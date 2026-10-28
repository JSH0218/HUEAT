# AI 자동 개선 로그

- 베이스라인(자동화 시작 시점 main): `0468960`
- 판단 기준은 이 파일과 원격 저장소의 현재 상태다.

## 정적 분석 추이

| 날짜 | main 커밋 | Semgrep | SpotBugs(+FindSecBugs) | gitleaks |
|---|---|---|---|---|
| 2026-10-28 | 8101471 | 802 (no-scriptlets 799, httpservlet-path-traversal 2, unsafe-reflection 1) | 21 (EI_EXPOSE_REP 8, EI_EXPOSE_REP2 8, RV_RETURN_VALUE_IGNORED_BAD_PRACTICE 3, REC_CATCH_EXCEPTION 2) | 0 |

## 처리 내역

### 2026-10-28 · 인프라 · Linux용 JSP 프리컴파일 게이트
- 근거: 직접 리뷰. 자동 회차 환경(Linux)에서는 `scripts/jspc-check.ps1`을 실행할 수 없어 JSP 검증이 불가능했다.
- 수정: `scripts/jspc-check.sh` 추가(동등 동작, Tomcat 미설치 시 Maven Central의 Jasper 9.0.118 JAR 사용, 429 재시도), `scripts/README.md`·`CLAUDE.md` 검증 안내에 한 줄 추가.
- 검증: `mvn -q compile` 통과 / `bash scripts/jspc-check.sh` → PASS(JSP 122개, 오류 0) / 존재하지 않는 DAO 호출을 넣은 임시 JSP로 FAIL(exit 1) 확인 후 삭제.
- 경고 수 변화: Java 소스 변경 없음(SpotBugs 21 → 21).
- PR: 이 로그 파일을 처음 추가한 PR(브랜치 `claude/auto-20261029-0102-jspc-linux`)
- 실구동 확인 포인트: 없음(런타임 코드 변경 없음).

## 후보
- Semgrep `httpservlet-path-traversal` 2건, `unsafe-reflection` 1건: 실제 경로 확인 필요(다음 회차 1순위 후보)
- SpotBugs `REC_CATCH_EXCEPTION` 2건, `RV_RETURN_VALUE_IGNORED_BAD_PRACTICE` 3건: 예외 처리·반환값 무시 확인
- Semgrep `no-scriptlets` 799건은 이 프로젝트 구조(스크립틀릿 JSP) 자체라 개선 대상 아님

## 오탐

## 보류

## 사람 확인 필요
