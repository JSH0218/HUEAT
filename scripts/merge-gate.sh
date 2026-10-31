#!/usr/bin/env bash
# 자동 PR 머지 게이트: 자동 회차가 squash 머지하기 직전에 실행해, 머지 조건 중 기계적으로 확인할 수 있는 것을
# 스크립트가 판정한다(에이전트가 종료코드·보호 규칙을 스스로 읽고 해석하는 단계를 없앤다).
#
# 확인 항목
#   1) 작업 트리에 미커밋 변경이 없다(검증한 트리 = 머지할 커밋)
#   2) static-analysis.sh의 판정 기록이 "종료코드 0, main판 판정, 지금의 origin/main 기준"이다
#   3) 코드(src/·db/)를 바꿨다면 runtime-smoke.sh의 판정 기록도 같은 조건이다(종료코드 2·3은 불합격)
#   4) 코드(src/)를 바꿨다면 jspc-check.sh의 판정 기록이 종료코드 0, 지금의 origin/main 기준이다
#   5) 검증 기준 보호: 사람 확인이 필요한 파일·변경이 없다
#   6) HEAD가 지금의 origin/main을 포함하고(검증한 트리 = squash 머지 결과), 원격 브랜치에 push된 커밋과 같다
#   7) 판정에 영향을 주는 환경변수(HUEAT_JUDGE·HUEAT_BASE_REF·HUEAT_TOOLS·HUEAT_PROJ)를 바깥에서 주지 않았다
#
# 판정 기록은 scripts/lib/baseline.sh가 $HUEAT_TOOLS/results/<트리 키>/<태그>.verdict 에 남긴다.
# 트리 키는 개선 로그(docs/ai-improvement-log.md)를 빼고 계산하므로, 검증 뒤에 로그만 커밋해도 된다.
# 이 게이트도 다른 검증 스크립트처럼 origin/main판으로 다시 실행해 판정한다(PR이 게이트를 고쳐도 그 PR의 판정은 바뀌지 않음).
#
# 실행:  git fetch origin main 후, 머지할 PR 브랜치를 체크아웃한 상태에서  bash scripts/merge-gate.sh
# 통과하면 마지막 줄에 머지할 커밋 SHA를 출력한다. squash 머지 때 이 SHA를 expectedHeadSha로 넘겨 검증한 커밋만 머지되게 한다.
# 종료코드: 0 = 자동 머지 가능, 1 = 검증 불합격(새 경고·새 실패 등), 2 = 판정 불가(미커밋 변경, 판정 기록 없음·낡음 → 다시 검증),
#           4 = 사람 확인 필요(검증 기준 보호 대상 변경 → PR 제목에 [사람 확인 필요])
set -uo pipefail

S="$(cd "$(dirname "$0")" && pwd)"
proj="${HUEAT_PROJ:-$(cd "$S/.." && pwd)}"
T="${HUEAT_TOOLS:-/tmp/hueat-tools}"
# 바깥에서 준 판정 관련 환경변수 이름을 기록한다(main판 재실행 때는 이미 설정돼 있으므로 다시 계산하지 않는다)
: "${HUEAT_GATE_ENV=$(for v in HUEAT_JUDGE HUEAT_BASE_REF HUEAT_TOOLS HUEAT_PROJ; do [ -n "${!v+x}" ] && printf '%s ' "$v"; done)}"
export HUEAT_GATE_ENV
cd "$proj"
. "$S/lib/baseline.sh"
key="$(baseline_tree_key)"
baseline_judge_with_main merge-gate.sh "$@"

ref="${HUEAT_BASE_REF:-origin/main}"
main_sha="$(git rev-parse "$ref" 2>/dev/null)"
head_key="$(baseline_ref_key HEAD)"
dirty="$(git status --porcelain)"

python3 - "$T" "$ref" "$main_sha" "$head_key" "$dirty" "$HUEAT_GATE_ENV" <<'PY'
import re, subprocess, sys
T, ref, main_sha, head_key, dirty, gate_env = sys.argv[1:7]

def git(*a):
    return subprocess.run(["git", *a], capture_output=True, text=True).stdout

fails, unknown, human = [], [], []
ok = lambda m: print(f"[gate] 통과: {m}")

# 7) 판정에 영향을 주는 환경변수
if gate_env.strip():
    unknown.append(f"판정에 영향을 주는 환경변수가 설정돼 있다({gate_env.strip()}). 자동 회차는 이 변수 없이 검증·게이트를 실행한다")
else:
    ok("판정 관련 환경변수 없음")

# 6) 검증한 트리 = 머지 결과, 원격과 같은 커밋
head_sha = git("rev-parse", "HEAD").strip()
if subprocess.run(["git", "merge-base", "--is-ancestor", ref, "HEAD"]).returncode != 0:
    unknown.append(f"HEAD가 지금의 {ref}({main_sha[:7]})를 포함하지 않는다(squash 머지 결과가 검증한 트리와 다름). "
                   f"`git merge {ref}` 후 검증을 다시 실행한다")
else:
    ok(f"HEAD가 {ref}({main_sha[:7]})를 포함")
branch = git("symbolic-ref", "-q", "--short", "HEAD").strip()
remote = git("ls-remote", "origin", f"refs/heads/{branch}").split("\t")[0].strip() if branch else ""
if not remote:
    unknown.append(f"원격 브랜치 origin/{branch or '(브랜치 아님)'}를 확인하지 못했다(push했는지 확인)")
elif remote != head_sha:
    unknown.append(f"원격 브랜치({remote[:7]})와 HEAD({head_sha[:7]})가 다르다(push하거나 원격 커밋을 받아 다시 검증)")
else:
    ok(f"원격 브랜치와 HEAD가 같음({head_sha[:7]})")

# 1) 미커밋 변경
if dirty.strip():
    unknown.append("미커밋 변경이 있다(검증한 트리와 머지할 커밋이 다를 수 있음). 커밋한 뒤 다시 검증한다")
else:
    ok("미커밋 변경 없음")

changes = [l.split("\t") for l in git("diff", "--name-status", f"{ref}...HEAD").splitlines() if l]
paths = [c[-1] for c in changes]
if not paths:
    unknown.append(f"{ref} 대비 변경이 없다")

# 2)·3) 판정 기록
def verdict(tag, need, need_main=True):
    if not need:
        return
    try:
        code, mode, sha = open(f"{T}/results/{head_key}/{tag}.verdict").read().split()
    except (OSError, ValueError):
        unknown.append(f"{tag}: 이 커밋 트리의 판정 기록이 없다(수정 후 검증을 다시 실행한다)")
        return
    if sha != main_sha:
        unknown.append(f"{tag}: 판정 기준 main({sha[:7]})이 지금의 {ref}({main_sha[:7]})와 다르다(최신 main 기준으로 다시 검증한다)")
    elif need_main and mode != "main":
        unknown.append(f"{tag}: 브랜치판(HUEAT_JUDGE={mode}) 판정이다. main판 판정이어야 한다")
    elif code != "0":
        fails.append(f"{tag}: 판정 종료코드 {code}(0만 합격)")
    else:
        ok(f"{tag}: 종료코드 0" + (", main판 판정" if need_main else "") + f", 기준 {main_sha[:7]}")

verdict("sa", True)
code_changed = any(p.startswith(("src/", "db/")) for p in paths)
verdict("smoke", code_changed)
if not code_changed:
    ok("smoke: 코드(src/·db/) 변경이 없어 생략")
# JSP 프리컴파일은 판정 기준이 "전체 JSP 오류 0"이라 main판 재실행이 없다(jspc-check.sh 변경은 아래 보호 규칙이 막는다)
src_changed = any(p.startswith("src/") for p in paths)
verdict("jspc", src_changed, need_main=False)
if not src_changed:
    ok("jspc: src/ 변경이 없어 생략")

# 4) 검증 기준 보호
any_change = re.compile(r"^(scripts/[^/]+\.sh|scripts/lib/.*|\.claude/.*|\.github/.*|pom\.xml|db/schema\.sql"
                        r"|src/main/webapp/WEB-INF/web\.xml|src/main/webapp/META-INF/context\.xml)$")
ignore_files = {".semgrepignore", ".gitleaksignore", ".gitleaks.toml"}
for p in paths:
    if any_change.match(p):
        human.append(f"보호 파일 변경(추가 포함 사람 확인): {p}")
    if p.rsplit("/", 1)[-1] in ignore_files:
        human.append(f"검사 제외 설정 파일 변경: {p}")

numstat = {}
for l in git("diff", "--numstat", f"{ref}...HEAD").splitlines():
    a, d, p = l.split("\t", 2)
    numstat[p] = (a, d)
for p, (a, d) in numstat.items():
    if (p.startswith(("scripts/semgrep/", "scripts/smoke/")) or p == "CLAUDE.md") and d not in ("0", "-"):
        human.append(f"기존 줄 삭제·변경({d}줄): {p}")

def added_lines(path):
    out, new_no = [], 0
    for l in git("diff", "-U0", f"{ref}...HEAD", "--", path).splitlines():
        m = re.match(r"^@@ -\d+(?:,\d+)? \+(\d+)(?:,\d+)? @@", l)
        if m:
            new_no = int(m.group(1))
            continue
        if l.startswith("+") and not l.startswith("+++"):
            out.append((new_no, l[1:]))
            new_no += 1
    return out

for p in paths:
    if p.startswith("scripts/semgrep/"):
        for _, t in added_lines(p):
            if re.search(r"\bexclude\b|pattern-not|paths\s*:", t):
                human.append(f"룰 판정을 좁히는 줄 추가: {p}: {t.strip()[:80]}")
    if p.startswith("src/"):
        for _, t in added_lines(p):
            if re.search(r"nosemgrep|gitleaks:allow", t):
                human.append(f"검사 억제 주석 추가: {p}: {t.strip()[:80]}")

if "CLAUDE.md" in paths:
    lines = git("show", "HEAD:CLAUDE.md").splitlines()
    start = next((i + 1 for i, l in enumerate(lines) if l.startswith("## 보안 규칙")), None)
    end = next((i + 1 for i, l in enumerate(lines) if start and i + 1 > start and l.startswith("## ")), len(lines) + 1)
    for no, t in added_lines("CLAUDE.md"):
        if not (start and start < no < end and t.startswith("- **")):
            human.append(f"CLAUDE.md '보안 규칙' 섹션 밖의 추가 또는 규칙 형식(- **…) 아님: {no}행: {t.strip()[:60]}")

if not human:
    ok("검증 기준 보호 대상 변경 없음")

for m in unknown:
    print(f"[gate] 판정 불가: {m}")
for m in fails:
    print(f"[gate] 불합격: {m}")
for m in human:
    print(f"[gate] 사람 확인 필요: {m}")

if human:
    print("[gate] 결과: 사람 확인 필요(종료코드 4) — 자동 머지하지 않고 PR 제목에 [사람 확인 필요]를 붙인다")
    sys.exit(4)
if unknown:
    print("[gate] 결과: 판정 불가(종료코드 2) — 다시 검증한 뒤 게이트를 다시 실행한다")
    sys.exit(2)
if fails:
    print("[gate] 결과: 불합격(종료코드 1)")
    sys.exit(1)
print("[gate] 결과: 자동 머지 가능(종료코드 0)")
print(f"[gate] 머지할 커밋: {head_sha} (squash 머지 때 expectedHeadSha로 넘긴다)")
PY
