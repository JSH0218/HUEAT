# 검증 결과 기준선 비교 (static-analysis.sh, runtime-smoke.sh가 source한다)
#
# 결과 파일을 "작업 트리 상태 키"별로 $T/results/<키>/ 에 저장하고, origin/main 트리의 결과와 항목 단위로 비교한다.
# 개수만 비교하면 "기존 1건이 사라지고 새 1건이 생긴" 경우를 놓치므로, 한 줄 = 항목 하나로 보고
# main보다 늘어난 항목(같은 항목이 여러 번이면 개수까지)을 새 항목으로 판정한다.
#
# 키는 커밋 여부와 상관없이 현재 작업 트리 내용(.gitignore 존중)으로 정해지므로,
# main에서 한 번(기준선), 수정 후에 한 번 실행하면 자동으로 둘을 비교한다. 비교 전에 `git fetch origin main`이 되어 있어야 한다.

# 키를 계산할 때 빼는 파일. 개선 로그는 검증 결과를 적는 문서라, 검증 뒤에 로그만 커밋해도 같은 트리로 본다
BASELINE_KEY_EXCLUDE="docs/ai-improvement-log.md"

# 현재 작업 트리(미커밋 변경·새 파일 포함, 개선 로그 제외)의 트리 해시
baseline_tree_key() {
    local idx
    idx="$(mktemp)"
    cp "$(git rev-parse --git-dir)/index" "$idx" 2>/dev/null || true
    GIT_INDEX_FILE="$idx" git add -A >/dev/null 2>&1
    GIT_INDEX_FILE="$idx" git update-index --force-remove -- "$BASELINE_KEY_EXCLUDE" >/dev/null 2>&1
    GIT_INDEX_FILE="$idx" git write-tree
    rm -f "$idx"
}

# 커밋(ref)의 트리 해시(개선 로그 제외). 키 계산 방식을 작업 트리와 맞춘다
baseline_ref_key() {
    local idx
    git rev-parse -q --verify "$1^{tree}" >/dev/null 2>&1 || return 0
    idx="$(mktemp)"
    GIT_INDEX_FILE="$idx" git read-tree "$1" 2>/dev/null
    GIT_INDEX_FILE="$idx" git update-index --force-remove -- "$BASELINE_KEY_EXCLUDE" >/dev/null 2>&1
    GIT_INDEX_FILE="$idx" git write-tree
    rm -f "$idx"
}

# 기준선 ref(기본 origin/main, 스크립트 자체를 시험할 때만 HUEAT_BASE_REF로 바꾼다)의 트리 키
baseline_main_key() {
    baseline_ref_key "${HUEAT_BASE_REF:-origin/main}"
}

# 이번 실행의 판정 기록을 먼저 지운다(중간에 실패하면 판정 기록이 없어 merge-gate.sh가 불합격으로 본다)
baseline_reset_verdict() {
    rm -f "$T/results/$2/$1.verdict"
}

# 수정한 트리에서 실행되면 origin/main의 scripts/를 꺼내 그 사본으로 다시 실행한다(exec, 돌아오지 않음).
# PR이 같은 PR 안에서 검증 스크립트·룰·시나리오를 느슨하게 바꿔도 그 PR의 판정에는 영향을 주지 못하게 하기 위함이다.
# 브랜치판으로 실행하려면(새 시나리오·룰 확인용) HUEAT_JUDGE=self 를 준다. main에 그 스크립트가 아직 없으면 브랜치판으로 실행한다.
# 사용: baseline_judge_with_main <scripts 기준 상대경로> "$@"   (전역 proj·key·T 필요)
baseline_judge_with_main() {
    local rel="$1" mkey ref dir
    shift
    [ -z "${HUEAT_JUDGE:-}" ] || return 0
    mkey="$(baseline_main_key)"
    [ -n "$mkey" ] && [ "$key" != "$mkey" ] || return 0
    ref="${HUEAT_BASE_REF:-origin/main}"
    dir="$T/judge/$mkey"
    if [ ! -f "$dir/scripts/$rel" ]; then
        rm -rf "$dir" && mkdir -p "$dir"
        git archive "$ref" scripts | tar -x -C "$dir" 2>/dev/null
    fi
    [ -f "$dir/scripts/$rel" ] || return 0
    echo "[judge] 판정은 $ref 의 검증 스크립트·룰·시나리오로 한다(브랜치판은 HUEAT_JUDGE=self)"
    HUEAT_JUDGE=main HUEAT_PROJ="$proj" exec bash "$dir/scripts/$rel" "$@"
}

# 사용: baseline_compare <태그> <결과 파일> <현재 키>
#   결과 파일을 $T/results/<현재 키>/<태그>.txt로 저장하고 origin/main 결과와 비교해 새 항목을 출력한다.
#   반환: 3 = 기준선(main)으로 저장함, 0 = 새 항목 없음, 1 = 새 항목 있음, 2 = 비교 불가(main 기준선 없음)
#   (기준선 저장을 0과 구분해, 수정 후 실행을 실수로 main 트리에서 해도 '통과'로 읽히지 않게 한다)
#   판정 기록 $T/results/<현재 키>/<태그>.verdict 에 "종료코드 판정방식(main|self) 기준main커밋"을 남긴다(merge-gate.sh가 읽는다).
baseline_compare() {
    local rc
    _baseline_compare "$@"
    rc=$?
    echo "$rc ${HUEAT_JUDGE:-self} $(git rev-parse "${HUEAT_BASE_REF:-origin/main}" 2>/dev/null)" >"$T/results/$3/$1.verdict"
    return $rc
}

_baseline_compare() {
    local tag="$1" file="$2" key="$3" mkey dir
    mkey="$(baseline_main_key)"
    dir="$T/results/$key"
    mkdir -p "$dir"
    sort "$file" >"$dir/$tag.txt"
    if [ -n "$mkey" ] && [ "$key" = "$mkey" ]; then
        echo "[$tag] 기준선: 이 결과를 origin/main 기준선으로 저장했다(종료코드 3, 합격 판정이 아님)"
        return 3
    fi
    if [ -z "$mkey" ] || [ ! -f "$T/results/$mkey/$tag.txt" ]; then
        echo "[$tag] 비교 불가: origin/main 기준선이 없다(먼저 최신 origin/main에서 실행한다)"
        return 2
    fi
    python3 - "$T/results/$mkey/$tag.txt" "$dir/$tag.txt" "$tag" <<'EOF'
import collections, sys
before = collections.Counter(l for l in open(sys.argv[1], encoding="utf-8").read().splitlines() if l)
after = collections.Counter(l for l in open(sys.argv[2], encoding="utf-8").read().splitlines() if l)
tag = sys.argv[3]
new = after - before
gone = before - after
for item, n in sorted(gone.items()):
    print(f"[{tag}] main 대비 사라짐: {item}" + (f" (x{n})" if n > 1 else ""))
for item, n in sorted(new.items()):
    print(f"[{tag}] main 대비 새로 생김: {item}" + (f" (x{n})" if n > 1 else ""))
print(f"[{tag}] main 대비 비교: 새로 생김 {sum(new.values())}건, 사라짐 {sum(gone.values())}건")
sys.exit(1 if new else 0)
EOF
}
