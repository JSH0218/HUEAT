#!/usr/bin/env bash
# 정적 분석 일괄 실행 (무료 오픈소스: Semgrep, SpotBugs+FindSecBugs, gitleaks)
#
# 도구와 결과물은 저장소 밖 임시 디렉토리(기본 /tmp/hueat-tools)에 둔다. 이미 설치돼 있으면 재사용한다.
# semgrep.dev 레지스트리는 차단될 수 있으므로 GitHub의 semgrep-rules 저장소를 로컬 룰로 쓴다.
# gitleaks는 --redact로 실행하므로 비밀값 원문은 출력·저장되지 않는다.
#
# 실행:  bash scripts/static-analysis.sh
# 출력:  도구별 경고 수 요약(마지막 줄들). 상세 결과는 $T/semgrep.json, target/spotbugsXml.xml, $T/gitleaks.json
set -uo pipefail

proj="$(cd "$(dirname "$0")/.." && pwd)"
T="${HUEAT_TOOLS:-/tmp/hueat-tools}"
GITLEAKS_VER=8.21.2
mkdir -p "$T"
cd "$proj"

# --- 설치 ---
command -v semgrep >/dev/null 2>&1 || pip install -q semgrep >/dev/null 2>&1 || echo "[sa] WARN: semgrep 설치 실패"
[ -d "$T/sgr" ] || git clone -q --depth 1 https://github.com/semgrep/semgrep-rules.git "$T/sgr" || echo "[sa] WARN: semgrep-rules clone 실패"
if [ ! -x "$T/gitleaks" ]; then
    curl -fsSL -o "$T/gl.tgz" "https://github.com/gitleaks/gitleaks/releases/download/v$GITLEAKS_VER/gitleaks_${GITLEAKS_VER}_linux_x64.tar.gz" \
        && tar xzf "$T/gl.tgz" -C "$T" gitleaks || echo "[sa] WARN: gitleaks 설치 실패"
fi

# --- 실행 ---
if command -v semgrep >/dev/null 2>&1 && [ -d "$T/sgr" ]; then
    semgrep scan --metrics=off --disable-version-check --config "$T/sgr/java" --config "$T/sgr/generic" \
        --json -o "$T/semgrep.json" src/main >/dev/null 2>"$T/semgrep.log" || true
fi
mvn -B -q compile >/dev/null 2>&1 \
    && mvn -B -q com.github.spotbugs:spotbugs-maven-plugin:4.8.6.4:spotbugs \
        -Dspotbugs.plugins=com.h3xstream.findsecbugs:findsecbugs-plugin:1.13.0 >/dev/null 2>&1 \
    || echo "[sa] WARN: SpotBugs 실행 실패"
[ -x "$T/gitleaks" ] && "$T/gitleaks" dir src --no-banner --redact -f json -r "$T/gitleaks.json" >/dev/null 2>&1

# --- 요약 ---
python3 - "$T" <<'EOF'
import collections, json, os, sys
import xml.etree.ElementTree as ET
t = sys.argv[1]
def summary(name, counter):
    if counter is None:
        print(f"[sa] {name}: 실행 안 됨")
    else:
        print(f"[sa] {name}: {sum(counter.values())} {dict(counter.most_common())}")
p = os.path.join(t, "semgrep.json")
summary("Semgrep", collections.Counter(r["check_id"].split(".")[-1] for r in json.load(open(p))["results"]) if os.path.exists(p) else None)
p = "target/spotbugsXml.xml"
summary("SpotBugs", collections.Counter(b.get("type") for b in ET.parse(p).getroot().iter("BugInstance")) if os.path.exists(p) else None)
p = os.path.join(t, "gitleaks.json")
summary("gitleaks", collections.Counter(x["RuleID"] for x in json.load(open(p))) if os.path.exists(p) else None)
EOF
