#!/usr/bin/env bash
# 실행 스모크 테스트: 실제 DB(MariaDB)와 Tomcat 9에 WAR를 띄우고 브라우저(Playwright)로 주요 화면과 권한 흐름을 확인한다.
#
# 정적 검증(컴파일·JSP 프리컴파일·정적 분석)이 잡지 못하는 런타임 동작(SQL 결과, redirect, 안내창, 세션 흐름)을 본다.
# 모두 무료 도구이며 컨테이너 안에서만 실행된다. 도구는 저장소 밖 $HUEAT_TOOLS(기본 /tmp/hueat-tools)에 캐시한다.
#   - MariaDB: 없으면 apt로 설치한다. 매 실행마다 스모크 전용 DB(hueat_smoke)를 새로 만들고 db/schema.sql + scripts/smoke/seed.sql을 적용한다.
#   - Tomcat 9: Maven Central의 배포본을 내려받아 포트 18080으로 쓴다.
#   - 시나리오: scripts/smoke/smoke.js
#
# 실행:  bash scripts/runtime-smoke.sh
# 결과는 scripts/lib/baseline.sh로 origin/main 결과와 시나리오 이름 단위로 비교한다.
# 종료코드:
#   3 = origin/main 트리에서 실행해 기준선으로 저장함(합격 판정 아님, main의 실패 시나리오는 출력만 한다)
#   0 = main 대비 새로 실패한 시나리오 없음, 1 = 새로 실패한 시나리오 있음
#   2 = 환경 문제(설치·다운로드·DB·Tomcat 실패, 시나리오 중단) 또는 실패가 있는데 main 기준선이 없어 비교 불가
# 수정한 트리에서 실행하면 origin/main판 스크립트·시나리오·시드로 다시 실행해 판정한다(lib/baseline.sh).
set -uo pipefail

S="$(cd "$(dirname "$0")" && pwd)"
proj="${HUEAT_PROJ:-$(cd "$S/.." && pwd)}"
T="${HUEAT_TOOLS:-/tmp/hueat-tools}"
TOMCAT_VER=9.0.118
PORT=18080
TC="$T/apache-tomcat-$TOMCAT_VER"
RUN="$T/smoke-run"
mkdir -p "$T"
cd "$proj"
. "$S/lib/baseline.sh"
key="$(baseline_tree_key)"
baseline_judge_with_main runtime-smoke.sh "$@"

log() { echo "[smoke] $*"; }

cleanup() {
    [ -x "$TC/bin/shutdown.sh" ] && CATALINA_PID="$RUN/tomcat.pid" "$TC/bin/shutdown.sh" 10 -force >/dev/null 2>&1
    mysqladmin -uroot shutdown >/dev/null 2>&1
}
trap cleanup EXIT

# --- 1) MariaDB ---
if ! command -v mariadbd >/dev/null 2>&1 && ! command -v mysqld >/dev/null 2>&1; then
    log "MariaDB 설치(apt)..."
    { apt-get update -q && DEBIAN_FRONTEND=noninteractive apt-get install -y -q --no-install-recommends mariadb-server; } >"$T/apt.log" 2>&1 \
        || { log "ERROR: MariaDB 설치 실패($T/apt.log)"; exit 2; }
fi
if ! mysqladmin -uroot ping >/dev/null 2>&1; then
    mkdir -p /run/mysqld
    (mysqld_safe --user=root >/dev/null 2>&1 &)
    for _ in $(seq 1 30); do mysqladmin -uroot ping >/dev/null 2>&1 && break; sleep 1; done
fi
mysqladmin -uroot ping >/dev/null 2>&1 || { log "ERROR: MariaDB 시작 실패"; exit 2; }

mysql -uroot -e "DROP DATABASE IF EXISTS hueat_smoke; CREATE DATABASE hueat_smoke DEFAULT CHARSET utf8mb4;
  CREATE USER IF NOT EXISTS 'hueat_smoke'@'localhost' IDENTIFIED BY 'smoke';
  GRANT ALL ON hueat_smoke.* TO 'hueat_smoke'@'localhost';" \
  && mysql -uroot hueat_smoke < db/schema.sql \
  && mysql -uroot --default-character-set=utf8mb4 hueat_smoke < "$S/smoke/seed.sql" \
  || { log "ERROR: DB 초기화 실패"; exit 2; }

# --- 2) 빌드와 Tomcat 배포 ---
log "WAR 빌드..."
mvn -B -q package -DskipTests >"$T/smoke-build.log" 2>&1 || { log "ERROR: mvn package 실패($T/smoke-build.log)"; exit 2; }
war="$(ls target/*.war | head -1)"

if [ ! -x "$TC/bin/startup.sh" ]; then
    curl -fsSL --retry 4 --retry-delay 2 -o "$T/tomcat.tgz" \
        "https://repo1.maven.org/maven2/org/apache/tomcat/tomcat/$TOMCAT_VER/tomcat-$TOMCAT_VER.tar.gz" \
        && tar xzf "$T/tomcat.tgz" -C "$T" || { log "ERROR: Tomcat 다운로드 실패"; exit 2; }
    sed -i "s/port=\"8080\"/port=\"$PORT\"/; s/port=\"8005\"/port=\"-1\"/" "$TC/conf/server.xml"
fi

# 이전 실행이 남긴 Tomcat이 떠 있으면 옛 WAR로 응답해 잘못 통과할 수 있으므로 먼저 내리고, 포트가 비었는지 확인한다
[ -f "$RUN/tomcat.pid" ] && CATALINA_PID="$RUN/tomcat.pid" "$TC/bin/shutdown.sh" 10 -force >/dev/null 2>&1
if curl -s -o /dev/null --max-time 3 "http://localhost:$PORT/"; then
    log "ERROR: 포트 $PORT를 이미 다른 프로세스가 쓰고 있다(이전 Tomcat이 남아 있는지 확인)"; exit 2
fi
rm -rf "$RUN" && mkdir -p "$RUN/upload"
cat >"$RUN/db.properties" <<EOF
db.url=jdbc:mysql://localhost:3306/hueat_smoke?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=Asia/Seoul&characterEncoding=UTF-8
db.user=hueat_smoke
db.password=smoke
db.driver=com.mysql.cj.jdbc.Driver
upload.dir=$RUN/upload
EOF
rm -rf "$TC/webapps/HuEatProject" "$TC/webapps/HuEatProject.war" "$TC/work/Catalina"
cp "$war" "$TC/webapps/HuEatProject.war"
: >"$TC/logs/catalina.out"

log "Tomcat 시작(포트 $PORT)..."
CATALINA_PID="$RUN/tomcat.pid" CATALINA_OPTS="-Dhueat.config=$RUN/db.properties" "$TC/bin/startup.sh" >/dev/null 2>&1
ready=""
for _ in $(seq 1 60); do
    code="$(curl -s -o /dev/null -w '%{http_code}' "http://localhost:$PORT/HuEatProject/index.jsp")"
    [ "$code" = "200" ] && { ready=1; break; }
    sleep 1
done
[ -n "$ready" ] || { log "ERROR: Tomcat 응답 없음($TC/logs/catalina.out)"; exit 2; }

# --- 3) 시나리오 ---
failed_out="$RUN/failed.txt"
rm -f "$failed_out"
SMOKE_BASE="http://localhost:$PORT/HuEatProject/" SMOKE_FAILED_OUT="$failed_out" node "$S/smoke/smoke.js"
rc=$?
if grep -qE "SEVERE|Exception" "$TC/logs/catalina.out"; then
    log "참고: Tomcat 로그에 SEVERE/Exception이 있다($TC/logs/catalina.out)"
    grep -E "SEVERE|Exception" "$TC/logs/catalina.out" | head -5
fi
# 시나리오가 끝까지 돌지 못했으면(결과 파일 없음) 환경 문제로 본다
[ -f "$failed_out" ] || { log "ERROR: 시나리오 실행이 중간에 끝났다(종료코드 $rc)"; exit 2; }
# 기준선(main) 실행이면 저장하고 3(main에서 실패한 시나리오는 위에 FAIL로 출력됨)
if [ "$key" = "$(baseline_main_key)" ]; then
    baseline_compare smoke "$failed_out" "$key"
    exit 3
fi
# 실패가 없으면 기준선 유무와 상관없이 통과다(결과는 저장만 한다)
if [ ! -s "$failed_out" ]; then
    baseline_compare smoke "$failed_out" "$key" >/dev/null
    exit 0
fi
baseline_compare smoke "$failed_out" "$key"
cmp=$?
# main에서도 실패하던 시나리오는 이번 변경의 영향을 판정할 수 없으므로 따로 알린다
mfile="$T/results/$(baseline_main_key)/smoke.txt"
if [ -f "$mfile" ]; then
    grep -Fxf "$mfile" "$failed_out" | sed 's/^/[smoke] main에서도 실패(이번 변경 판정 불가): /'
fi
exit $cmp
