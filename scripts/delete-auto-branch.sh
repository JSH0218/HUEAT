#!/usr/bin/env bash
# 머지가 끝난 자동 개선 브랜치(원격 claude/auto-*)를 지운다.
#
# 자동 회차가 `git push origin --delete`를 직접 실행하면 세션 권한 확인에 막히므로, 이 스크립트 하나만
# 허용 규칙(.claude/settings.json)에 두고 이름 검사를 여기서 강제한다.
# PR이 머지됐는지와 원격 최신 커밋이 PR head와 같은지는 호출하는 쪽(자동 회차)이 GitHub에서 먼저 확인한다.
#
# 실행:  bash scripts/delete-auto-branch.sh <브랜치> [<브랜치> ...]
# 종료코드: 0 = 모두 삭제(또는 이미 없음), 1 = 하나 이상 실패, 2 = 이름이 claude/auto- 형식이 아님(아무것도 지우지 않음)
set -uo pipefail

[ $# -gt 0 ] || { echo "사용법: bash scripts/delete-auto-branch.sh <claude/auto-...> ..."; exit 2; }

# 하나라도 형식이 아니면 아무것도 지우지 않는다(main 등 다른 브랜치 삭제 방지)
for b in "$@"; do
    if ! [[ "$b" =~ ^claude/auto-[A-Za-z0-9._-]+$ ]]; then
        echo "[branch] ERROR: claude/auto-* 형식이 아닌 브랜치는 지우지 않는다: $b"
        exit 2
    fi
done

rc=0
for b in "$@"; do
    if [ -z "$(git ls-remote --heads origin "refs/heads/$b")" ]; then
        echo "[branch] 이미 없음: $b"
    elif git push -q origin --delete "$b"; then
        echo "[branch] 삭제: $b"
    else
        echo "[branch] 실패: $b"; rc=1
    fi
done
exit $rc
