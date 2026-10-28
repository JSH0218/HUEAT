#!/usr/bin/env bash
# JSP 프리컴파일 검증 게이트 (Linux/macOS용, scripts/jspc-check.ps1과 동등)
#
# Apache Jasper(org.apache.jasper.JspC)로 src/main/webapp의 모든 *.jsp를 변환+컴파일해
# 스크립틀릿 문법 오류, <%@ include %> 변수 중복선언, JSP->DAO 메서드 불일치를 잡는다.
# 런타임 동작(SQL 결과, redirect, AJAX URL, 세션 흐름)은 잡지 못한다. 자세한 내용은 scripts/README.md.
#
# Tomcat 설치가 없어도 된다: CATALINA_HOME에 Tomcat 9가 있으면 그 lib를 쓰고,
# 없으면 Maven Central에서 Jasper 관련 JAR를 내려받아 .jspc/lib에 캐시한다(최초 1회).
#
# 실행:  bash scripts/jspc-check.sh
# 종료코드: 0 = 전 JSP 통과, 그 외 = 실패
#
# 참고: JspC는 JSP 컴파일이 실패해도 종료코드 0을 반환하므로, 생성 결과물
# (모든 .java에 대응하는 .class가 있는지)로 통과 여부를 판정한다.
set -uo pipefail

proj="$(cd "$(dirname "$0")/.." && pwd)"
webapp="$proj/src/main/webapp"
weblib_dir="$webapp/WEB-INF/lib"
work="$proj/.jspc"
classes="$work/classes"
gen="$work/gen"
lib_cache="$work/lib"      # 내려받은 JAR 캐시(재사용하므로 지우지 않음)

TOMCAT_VER=9.0.118
ECJ_VER=3.26.0
ANT_VER=1.10.14
MAVEN=https://repo1.maven.org/maven2

rm -rf "$classes" "$gen"
mkdir -p "$classes" "$gen" "$lib_cache"

# Maven Central 다운로드(429 등 일시 오류는 재시도)
fetch() {
    local url="$1" out="$2" i
    [ -s "$out" ] && return 0
    for i in 1 2 3 4; do
        if curl -fsSL --max-time 120 -o "$out.tmp" "$url"; then
            mv "$out.tmp" "$out"; return 0
        fi
        sleep $((i * 2))
    done
    rm -f "$out.tmp"
    echo "[jspc] ERROR: 다운로드 실패: $url"
    return 1
}

# --- Jasper 클래스패스 구성 ---
if [ -n "${CATALINA_HOME:-}" ] && [ -f "$CATALINA_HOME/lib/jasper.jar" ]; then
    echo "[jspc] Tomcat: $CATALINA_HOME"
    servlet_api="$CATALINA_HOME/lib/servlet-api.jar"
    tomcp="$(printf '%s:' "$CATALINA_HOME"/lib/*.jar)$CATALINA_HOME/bin/tomcat-juli.jar"
else
    echo "[jspc] Tomcat 미설치 - Maven Central의 Jasper $TOMCAT_VER 사용"
    tomcp=""
    for a in tomcat-jasper tomcat-jasper-el tomcat-el-api tomcat-jsp-api tomcat-servlet-api \
             tomcat-juli tomcat-api tomcat-util tomcat-util-scan; do
        jar="$lib_cache/$a-$TOMCAT_VER.jar"
        fetch "$MAVEN/org/apache/tomcat/$a/$TOMCAT_VER/$a-$TOMCAT_VER.jar" "$jar" || exit 3
        tomcp="$tomcp$jar:"
    done
    jar="$lib_cache/ecj-$ECJ_VER.jar"
    fetch "$MAVEN/org/eclipse/jdt/ecj/$ECJ_VER/ecj-$ECJ_VER.jar" "$jar" || exit 3
    tomcp="$tomcp$jar"
    servlet_api="$lib_cache/tomcat-servlet-api-$TOMCAT_VER.jar"
fi

# JspC가 org.apache.tools.ant.Task를 링크하므로 ant.jar가 필요하다
ant_jar="$lib_cache/ant-$ANT_VER.jar"
fetch "$MAVEN/org/apache/ant/ant/$ANT_VER/ant-$ANT_VER.jar" "$ant_jar" || exit 3
tomcp="$tomcp:$ant_jar"

# --- 1) 프로젝트 Java 컴파일(JSP->DAO 호출 타입검사용) ---
weblib="$(printf '%s:' "$weblib_dir"/*.jar)"
echo "[jspc] 프로젝트 Java 컴파일..."
find "$proj/src/main/java" -name '*.java' > "$work/sources.txt"
if ! javac -encoding UTF-8 -nowarn -cp "$servlet_api:$weblib" -d "$classes" @"$work/sources.txt"; then
    echo "[jspc] ERROR: javac 실패"
    exit 1
fi

# --- 2) JspC 실행(전체 webapp 변환+컴파일) ---
log="$work/jspc.err"
echo "[jspc] JspC 실행(변환+컴파일)..."
java -Duser.language=en -cp "$tomcp" org.apache.jasper.JspC \
    -webapp "$webapp" -d "$gen" -javaEncoding UTF-8 -compile \
    -classpath "$classes:$weblib" 2>"$log" 1>/dev/null

# --- 3) 결과물로 판정(.jspf 조각은 JspC가 단독 변환하지 않으므로 제외) ---
jsp_count=$(find "$webapp" -type f -name '*.jsp' | wc -l)
java_count=$(find "$gen" -type f -name '*.java' | wc -l)
missing=()
while IFS= read -r f; do
    [ -f "${f%.java}.class" ] || missing+=("$f")
done < <(find "$gen" -type f -name '*.java')
translation_fail=$((jsp_count - java_count))

if [ ${#missing[@]} -eq 0 ] && [ "$translation_fail" -le 0 ]; then
    echo "[jspc] PASS - JSP ${jsp_count}개 변환+컴파일, 오류 0"
    exit 0
fi

echo "[jspc] FAIL - 변환 실패: $translation_fail, 컴파일 실패: ${#missing[@]}"
for f in "${missing[@]}"; do echo "  - $(basename "$f")"; done
echo "[jspc] 오류 로그(주요 줄):"
grep -E '\.java:|ERROR|cannot|undefined|method|symbol|Unable' "$log" | head -40
echo "[jspc] 전체 로그: $log"
exit 1
