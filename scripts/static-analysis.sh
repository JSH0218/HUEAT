#!/usr/bin/env bash
# 정적 분석 일괄 실행 (무료 오픈소스: Semgrep, SpotBugs+FindSecBugs, gitleaks)
#
# 도구와 결과물은 저장소 밖 임시 디렉토리(기본 /tmp/hueat-tools)에 둔다. 이미 설치돼 있으면 재사용한다.
# semgrep.dev 레지스트리는 차단될 수 있으므로 GitHub의 semgrep-rules 저장소를 로컬 룰로 쓴다.
# gitleaks는 --redact로 실행하므로 비밀값 원문은 출력·저장되지 않는다.
#
# 실행:  bash scripts/static-analysis.sh
# 출력:  도구별 경고 수 요약과, origin/main 결과 대비 새로 생기거나 사라진 경고 목록(scripts/lib/baseline.sh).
#        상세 결과는 $T/semgrep.json, target/spotbugsXml.xml, $T/gitleaks.json
# 종료코드: 3 = origin/main 트리에서 실행해 기준선으로 저장함(합격 판정 아님), 0 = main 대비 새 경고 없음,
#           1 = main 대비 새 경고 있음, 2 = 도구가 하나라도 실행되지 않았거나 main 기준선이 없어 비교할 수 없음
# 경고 항목은 "도구|룰|파일(SpotBugs는 클래스)"로 비교한다(줄 번호는 수정하면 바뀌므로 쓰지 않는다).
# Semgrep이 파싱하지 못한 파일도 "semgrep-error|파일" 항목으로 넣어, 파싱 실패로 경고가 '사라지는' 것을 새 항목으로 잡는다.
# 수정한 트리에서 실행하면 origin/main판 스크립트·룰로 다시 실행해 판정한다(lib/baseline.sh의 baseline_judge_with_main).
set -uo pipefail

S="$(cd "$(dirname "$0")" && pwd)"
proj="${HUEAT_PROJ:-$(cd "$S/.." && pwd)}"
T="${HUEAT_TOOLS:-/tmp/hueat-tools}"
GITLEAKS_VER=8.21.2
mkdir -p "$T"
cd "$proj"
. "$S/lib/baseline.sh"
key="$(baseline_tree_key)"
baseline_judge_with_main static-analysis.sh "$@"
# 이전 회차 결과가 남아 있으면 도구 실패 시 지난 수치가 요약에 나오므로 먼저 지운다
rm -f "$T/semgrep.json" "$T/gitleaks.json" target/spotbugsXml.xml

# --- 설치 ---
command -v semgrep >/dev/null 2>&1 || pip install -q semgrep >/dev/null 2>&1 || echo "[sa] WARN: semgrep 설치 실패"
[ -d "$T/sgr" ] || git clone -q --depth 1 https://github.com/semgrep/semgrep-rules.git "$T/sgr" || echo "[sa] WARN: semgrep-rules clone 실패"
# no-scriptlets는 "JSP에 스크립틀릿을 쓰지 말라"는 룰로, 스크립틀릿 JSP인 이 프로젝트 전체가 걸려(약 800건)
# 실제 결함을 가리므로 뺀다
rm -f "$T/sgr/java/lang/security/audit/xss/jsp/no-scriptlets.yaml"
if [ ! -x "$T/gitleaks" ]; then
    curl -fsSL -o "$T/gl.tgz" "https://github.com/gitleaks/gitleaks/releases/download/v$GITLEAKS_VER/gitleaks_${GITLEAKS_VER}_linux_x64.tar.gz" \
        && tar xzf "$T/gl.tgz" -C "$T" gitleaks || echo "[sa] WARN: gitleaks 설치 실패"
fi

# --- 실행 ---
if command -v semgrep >/dev/null 2>&1 && [ -d "$T/sgr" ]; then
    # --disable-nosem: 소스의 nosemgrep 주석으로 경고를 숨기지 못하게 한다
    semgrep scan --metrics=off --disable-version-check --disable-nosem --config "$T/sgr/java" --config "$T/sgr/generic" \
        --config "$S/semgrep" \
        --json -o "$T/semgrep.json" src/main >/dev/null 2>"$T/semgrep.log" || true
fi
mvn -B -q compile >/dev/null 2>&1 \
    && mvn -B -q com.github.spotbugs:spotbugs-maven-plugin:4.8.6.4:spotbugs \
        -Dspotbugs.plugins=com.h3xstream.findsecbugs:findsecbugs-plugin:1.13.0 >/dev/null 2>&1 \
    || echo "[sa] WARN: SpotBugs 실행 실패"
[ -x "$T/gitleaks" ] && "$T/gitleaks" dir src --no-banner --redact -f json -r "$T/gitleaks.json" >/dev/null 2>&1

# --- 요약과 비교용 항목 목록 ---
python3 - "$T" "$T/findings.txt" <<'PY'
import collections, json, os, sys
import xml.etree.ElementTree as ET
t, out = sys.argv[1], sys.argv[2]
def summary(name, counter):
    if counter is None:
        print(f"[sa] {name}: 실행 안 됨")
    else:
        print(f"[sa] {name}: {sum(counter.values())} {dict(counter.most_common())}")
p = os.path.join(t, "semgrep.json")
results = json.load(open(p))["results"] if os.path.exists(p) else None
def semgrep_counter(own):
    if results is None:
        return None
    return collections.Counter(r["check_id"].split(".")[-1] for r in results
                               if r["check_id"].split(".")[-1].startswith("hueat-") == own)
# HUEAT 전용 룰(scripts/semgrep)과 공개 룰을 나눠 보여준다
summary("Semgrep(HUEAT 전용 룰)", semgrep_counter(True))
summary("Semgrep(공개 룰)", semgrep_counter(False))
p = "target/spotbugsXml.xml"
bugs = list(ET.parse(p).getroot().iter("BugInstance")) if os.path.exists(p) else None
summary("SpotBugs", collections.Counter(b.get("type") for b in bugs) if bugs is not None else None)
p = os.path.join(t, "gitleaks.json")
leaks = json.load(open(p)) if os.path.exists(p) else None
summary("gitleaks", collections.Counter(x["RuleID"] for x in leaks) if leaks is not None else None)

# 한 줄 = 경고 하나
items = [f"semgrep|{r['check_id'].split('.')[-1]}|{r['path']}" for r in results or []]
if results is not None:
    for e in json.load(open(os.path.join(t, "semgrep.json"))).get("errors", []):
        items.append(f"semgrep-error|{e.get('path') or e.get('type') or 'unknown'}")
for b in bugs or []:
    c = b.find("Class")
    items.append(f"spotbugs|{b.get('type')}|{c.get('classname') if c is not None else ''}")
items += [f"gitleaks|{x['RuleID']}|{x['File']}" for x in leaks or []]
open(out, "w", encoding="utf-8").write("".join(i + "\n" for i in items))

missing = [n for n, v in (("Semgrep", results), ("SpotBugs", bugs), ("gitleaks", leaks)) if v is None]
if missing:
    print(f"[sa] ERROR: 실행되지 않은 도구가 있어 비교할 수 없다: {', '.join(missing)}")
    sys.exit(2)
PY
[ $? -eq 0 ] || exit 2

baseline_compare sa "$T/findings.txt" "$key"
exit $?
