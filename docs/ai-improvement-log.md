# AI 자동 개선 로그

- 베이스라인(자동화 시작 시점 main): `0468960`
- 판단 기준은 이 파일과 원격 저장소의 현재 상태다.

## 정적 분석 추이

| 날짜 | main 커밋 | Semgrep | SpotBugs(+FindSecBugs) | gitleaks |
|---|---|---|---|---|
| 2026-10-28 | 8101471 | 미실행(권한 거부) | 21 (EI_EXPOSE_REP 8, EI_EXPOSE_REP2 8, RV_RETURN_VALUE_IGNORED_BAD_PRACTICE 3, REC_CATCH_EXCEPTION 2) | 미실행(권한 거부) |

## 처리 내역

### 2026-10-28 · 인프라 · Linux용 JSP 프리컴파일 게이트
- 근거: 직접 리뷰. 자동 회차 환경(Linux)에서는 `scripts/jspc-check.ps1`을 실행할 수 없어 JSP 검증이 불가능했다.
- 수정: `scripts/jspc-check.sh` 추가(동등 동작, Tomcat 미설치 시 Maven Central의 Jasper 9.0.118 JAR 사용, 429 재시도), `scripts/README.md`·`CLAUDE.md` 검증 안내에 한 줄 추가.
- 검증: `mvn -q compile` 통과 / `bash scripts/jspc-check.sh` → PASS(JSP 122개, 오류 0) / 존재하지 않는 DAO 호출을 넣은 임시 JSP로 FAIL(exit 1) 확인 후 삭제.
- 경고 수 변화: Java 소스 변경 없음(SpotBugs 21 → 21).
- PR: 미생성(아래 '보류' 참고).
- 실구동 확인 포인트: 없음(런타임 코드 변경 없음).

## 후보
- (다음 회차 정적 분석·직접 리뷰로 채운다)

## 오탐

## 보류
- 2026-10-28: Semgrep·gitleaks 실행이 세션 권한 분류기에 의해 거부됨(외부 코드 실행). 사용자가 권한 규칙을 허용해야 실행 가능.
- 2026-10-28: 이 회차는 사람 확인 없이 push·PR 생성·main 머지를 하지 않고 로컬 커밋까지만 진행함. 사용자가 이 세션에서 자동 push/머지를 명시적으로 허용하면 다음 회차부터 진행.

## 사람 확인 필요
