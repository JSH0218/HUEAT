# AI 자동 개선 로그

- 베이스라인(자동화 시작 시점 main): `0468960`
- 판단 기준은 이 파일과 원격 저장소의 현재 상태다.

## 정적 분석 추이

| 날짜 | main 커밋 | Semgrep | SpotBugs(+FindSecBugs) | gitleaks |
|---|---|---|---|---|
| 2026-10-28 | 8101471 | 802 (no-scriptlets 799, httpservlet-path-traversal 2, unsafe-reflection 1) | 21 (EI_EXPOSE_REP 8, EI_EXPOSE_REP2 8, RV_RETURN_VALUE_IGNORED_BAD_PRACTICE 3, REC_CATCH_EXCEPTION 2) | 0 |
| 2026-10-28 | 59e53c2 | 802 (동일) | 21 (동일) | 0 |

## 처리 내역

### 2026-10-28 · 인프라 · Linux용 JSP 프리컴파일 게이트
- 근거: 직접 리뷰. 자동 회차 환경(Linux)에서는 `scripts/jspc-check.ps1`을 실행할 수 없어 JSP 검증이 불가능했다.
- 수정: `scripts/jspc-check.sh` 추가(동등 동작, Tomcat 미설치 시 Maven Central의 Jasper 9.0.118 JAR 사용, 429 재시도), `scripts/README.md`·`CLAUDE.md` 검증 안내에 한 줄 추가.
- 검증: `mvn -q compile` 통과 / `bash scripts/jspc-check.sh` → PASS(JSP 122개, 오류 0) / 존재하지 않는 DAO 호출을 넣은 임시 JSP로 FAIL(exit 1) 확인 후 삭제.
- 경고 수 변화: Java 소스 변경 없음(SpotBugs 21 → 21).
- PR: 이 로그 파일을 처음 추가한 PR(브랜치 `claude/auto-20261029-0102-jspc-linux`)
- 실구동 확인 포인트: 없음(런타임 코드 변경 없음).

### 2026-10-28 · 보안(XSS) · 회원 ID·닉네임의 이스케이프 없는 출력
- 영역: member, mypage, hugesoinfo(JSP 출력)
- 근거: 직접 리뷰. `member/gaipaction.jsp`에 서버 측 ID 형식 검증이 없어 `"><script>…` 같은 ID로 가입할 수 있고, 로그인 후 세션 `myid`가 `<%= %>`로 그대로 출력된다(`member/loginform.jsp`, `mypage/updatepassform.jsp`, `hugesoinfo/hugesodetail.jsp`). 관리자 목록(`mypage/adminnoticelist.jsp`, `mypage/admineventlist.jsp`)도 DB 닉네임을 그대로 출력한다.
- 수정: 위 5곳을 `util.SecurityUtil.escapeHtml(...)`로 감쌈(파일당 1줄).
- 검증: `mvn -q compile` 통과 / `bash scripts/jspc-check.sh` PASS(122개, 오류 0) / 서브에이전트 독립 재검토: 막을 문제 없음(`#g_myid`를 받는 서버 액션은 세션 ID를 쓰므로 비로그인 시 `"null"`→`""` 변화 영향 없음).
- 경고 수 변화: Semgrep 802→802, SpotBugs 21→21, gitleaks 0→0.
- 실구동 확인 포인트: 아이디 저장 체크 후 로그인 화면의 아이디 칸, 마이페이지 비밀번호 변경 화면의 아이디 칸, 휴게소 상세에서 평점 등록, 관리자 공지·이벤트 목록의 작성자 표시.

## 후보
- `member/gaipaction.jsp` 서버 측 ID 형식 검증 부재(위 XSS의 근본 원인). 가입 허용 범위가 바뀌는 동작 변경이라 규칙(허용 문자·길이)을 정해야 함
- `hugesoinfo/hugesodetail.jsp:720` `g_role` 세션 값 그대로 출력(서버가 정하는 USER/ADMIN이라 위험 낮음)
- `util/ImageServlet.java` 허용 확장자(jpg/jpeg/png/gif)와 `SecurityUtil` 업로드 허용 확장자(bmp/webp 포함) 불일치: bmp·webp 업로드는 저장되지만 표시되지 않음
- Semgrep `no-scriptlets` 799건은 이 프로젝트 구조(스크립틀릿 JSP) 자체라 개선 대상 아님

## 오탐
- 2026-10-28 · Semgrep `httpservlet-path-traversal` · `util/ImageServlet.java:64-65`: type 화이트리스트, 파일명 구분자·`..` 차단, 정규화 경로의 베이스 하위 재확인으로 이미 방어됨
- 2026-10-28 · Semgrep `unsafe-reflection` · `mysql/db/DbConnect.java:16`: `Class.forName` 인자는 서버 외부 설정 파일(`db.driver`) 값이며 사용자 입력이 아님
- 2026-10-28 · SpotBugs `REC_CATCH_EXCEPTION` · `util/SecurityUtil.java`(`isAllowedImage`, `hasImageMagicBytes`): 예외 시 false 반환(거부) — 의도된 fail-closed
- 2026-10-28 · SpotBugs `RV_RETURN_VALUE_IGNORED_BAD_PRACTICE` · `util/AppConfig.java:113`, `util/SecurityUtil.java:322,358`: `mkdirs`/`delete` 반환값 무시. 실패해도 웹루트 밖 파일이라 영향 낮아 수정 가치 낮음

## 보류

## 사람 확인 필요
