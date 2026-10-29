# AI 자동 개선 로그

- 베이스라인(자동화 시작 시점 main): `0468960`
- 판단 기준은 이 파일과 원격 저장소의 현재 상태다.

## 정적 분석 추이

| 날짜 | main 커밋 | Semgrep | SpotBugs(+FindSecBugs) | gitleaks |
|---|---|---|---|---|
| 2026-10-28 | 8101471 | 802 (no-scriptlets 799, httpservlet-path-traversal 2, unsafe-reflection 1) | 21 (EI_EXPOSE_REP 8, EI_EXPOSE_REP2 8, RV_RETURN_VALUE_IGNORED_BAD_PRACTICE 3, REC_CATCH_EXCEPTION 2) | 0 |
| 2026-10-28 | 59e53c2 | 802 (동일) | 21 (동일) | 0 |
| 2026-10-28 | 3012e6e | 802 (동일) | 21 (동일) | 0 |
| 2026-10-29 | cddaec1 | 802 (동일) | 21 (동일) | 0 |
| 2026-10-29 | d3334cf | 802 (동일) | 21 (동일) | 0 |

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
- PR: #114
- 실구동 확인 포인트: 아이디 저장 체크 후 로그인 화면의 아이디 칸, 마이페이지 비밀번호 변경 화면의 아이디 칸, 휴게소 상세에서 평점 등록, 관리자 공지·이벤트 목록의 작성자 표시.

### 2026-10-28 · 보안(입력 검증) · 가입 아이디 형식 서버 측 검증
- 영역: member(가입), util
- 근거: 직접 리뷰(위 XSS의 근본 원인, CLAUDE.md '규칙은 스스로 정한다' 위임의 첫 대상).
- 정한 규칙: 회원 ID는 영문 소문자로 시작하는 영문 소문자·숫자 4~20자(`[a-z][a-z0-9]{3,19}`). CLAUDE.md '보안 규칙'에 기록.
- 수정: `util/SecurityUtil.java`에 `isValidMemberId` 추가 / `member/gaipaction.jsp`(형식 위반 시 가입 거부, 기존 예약 ID 검사 블록에 합침) / `member/idcheck.jsp`(형식 위반 시 사용 불가 응답) / `member/gaipform.jsp`(중복확인·제출 시 같은 규칙으로 클라이언트 검사) / `CLAUDE.md`.
- 검증: `mvn -q compile` 통과 / `bash scripts/jspc-check.sh` PASS(122개, 오류 0) / jshell로 정규식 판정 10건 확인(`abcd`·20자 통과, `abc`·`1abc`·`Abcd`·`ab_cd`·21자·`"><script>`·null 거부) / 서브에이전트 독립 재검토: 막을 문제 없음(INSERT 경로는 `gaipaction.jsp` 하나, 로그인·시드 관리자 영향 없음).
- 경고 수 변화: Semgrep 802→802(처음엔 별도 스크립틀릿 블록으로 803이 되어 기존 블록에 합침), SpotBugs 21→21, gitleaks 0→0.
- PR: #116
- 실구동 확인 포인트: 가입 화면에서 `ab`·`Abcd`·`ab_cd` 입력 시 중복확인·제출 단계 안내, 정상 ID 가입, 형식 위반 ID를 직접 POST하면 "사용할 수 없는 아이디입니다." 응답.

### 2026-10-29 · 보안(입력 검증) · 장바구니 담기 수량 서버 측 검증
- 영역: foodcourt
- 근거: 직접 리뷰. `foodcourt/foodcartaddaction.jsp`가 `cart_cnt`를 범위 검사 없이 `Integer.parseInt`해 직접 POST로 0·음수·대량 수량을 넣을 수 있었고(`foodcartlist.jsp` 합계가 음수가 됨), 숫자가 아니면 처리되지 않은 예외(500)가 났다. 화면 입력란은 `min="1" max="10"`이었다.
- 정한 규칙: 장바구니 담기 요청 수량은 1~10 정수(화면 입력란과 동일). CLAUDE.md '보안 규칙'에 기록.
- 수정: `foodcourt/foodcartaddaction.jsp`(범위 밖·비숫자면 400) / `foodcourt/foodmenu.jsp`(AJAX 전 같은 규칙 검사) / `CLAUDE.md`.
- 검증: `mvn -q compile` 통과 / `bash scripts/jspc-check.sh` PASS(122개, 오류 0) / 서브에이전트 독립 재검토: 막을 문제 없음(호출처는 `foodmenu.jsp` 한 곳).
- 경고 수 변화: Semgrep 802→802, SpotBugs 21→21, gitleaks 0→0.
- PR: #117
- 실구동 확인 포인트: 메뉴 수량 0·11 입력 시 안내창, 1~10 정상 담기, 이미 담긴 메뉴 재담기(+1) 동작.

### 2026-10-29 · 보안(입력 검증) · 휴게소·음식 평점 값 범위 서버 측 검증
- 영역: grade, foodgrade, util
- 근거: 직접 리뷰. `grade/insertgrade.jsp`는 `g_grade`에서 숫자만 남기고 범위를 검사하지 않아 `9999` 같은 값이 저장됐고, `foodgrade/insertfoodgrade.jsp`는 `fg_grade`를 전혀 검증하지 않았다. 평균은 이 테이블에서 재계산(`hugesoinfo/updateh_grade.jsp`, `foodgrade/updatef_grade.jsp`)되어 메인 "이달의 휴게소" 등 순위에 반영되므로, 로그인 사용자의 직접 POST 몇 번으로 순위를 조작할 수 있었다.
- 정한 규칙: 휴게소·음식 평점은 1~5 정수(화면 별점 라디오, 스키마 주석 `-- 1~5`와 동일). CLAUDE.md '보안 규칙'에 기록.
- 수정: `util/SecurityUtil.java`(`isValidGrade` 추가) / `grade/insertgrade.jsp`·`foodgrade/insertfoodgrade.jsp`(위반 시 400) / `CLAUDE.md`.
- 검증: `mvn -q compile` 통과 / `bash scripts/jspc-check.sh` PASS(122개, 오류 0) / 서브에이전트 독립 재검토: 막을 문제 없음(평점 INSERT 경로는 두 액션뿐, UPDATE 경로 없음, 평균 재계산은 서버 측).
- 경고 수 변화: Semgrep 802→802, SpotBugs 21→21, gitleaks 0→0.
- PR: #118
- 실구동 확인 포인트: 휴게소 상세에서 휴게소 평점·음식 평점 등록 후 평균·개수 갱신, 메인 "이달의 휴게소" 표시.

## 후보
- 같은 사용자의 평점 중복 등록 제한 없음(1~5 범위여도 반복 등록으로 평균·순위가 기울어짐). 사용자당 1회 규칙이면 UNIQUE 제약 등 스키마 변경이 필요할 수 있음
- `foodgrade/insertfoodgrade.jsp`: `fg_foodnum`·`fg_hugesonum` 숫자 정규화·빈 값 검사 없음(`insertgrade.jsp`의 `h_num` 처리와 비대칭)
- `reviewboard/reviewUpdateAction.jsp`: 권한 없음·CSRF 실패 시 이미 저장된 업로드 파일을 지우지 않음, 없는 `r_num`이면 NPE를 `catch(Exception)`이 삼켜 빈 화면
- `foodcart/model/FoodCartDao.java` `updateCnt`: 이미 담긴 메뉴는 요청 수량을 무시하고 +1만 하며 누적 상한이 없음(반복 담기로 10 초과 가능). 누적 상한 규칙 검토
- `foodcourt/foodmenu.jsp`: 담기 AJAX에 `error` 콜백이 없어 서버 400 응답이 화면에 표시되지 않음
- `foodcourt/foodcartaddaction.jsp`: `f_num`·`h_num` 존재·숫자 여부 미검증(바인딩 파라미터라 SQLi는 아님)
- `member/gaipform.jsp`: 중복확인 AJAX 결과를 기다리지 않고 `isIdChecked = true`로 설정되고, 확인 뒤 ID를 바꿔도 초기화되지 않음(서버의 중복 재확인·UNIQUE 제약으로 데이터는 보호됨)
- `member/gaipform.jsp`: 중복 시 입력란을 비우는 셀렉터가 `#id`로 잘못됨(실제는 `#m_id`)
- `hugesoinfo/hugesodetail.jsp:720` `g_role` 세션 값 그대로 출력(서버가 정하는 USER/ADMIN이라 위험 낮음)
- Semgrep `no-scriptlets` 799건은 이 프로젝트 구조(스크립틀릿 JSP) 자체라 개선 대상 아님

## 오탐
- 2026-10-28 · Semgrep `httpservlet-path-traversal` · `util/ImageServlet.java:64-65`: type 화이트리스트, 파일명 구분자·`..` 차단, 정규화 경로의 베이스 하위 재확인으로 이미 방어됨
- 2026-10-28 · Semgrep `unsafe-reflection` · `mysql/db/DbConnect.java:16`: `Class.forName` 인자는 서버 외부 설정 파일(`db.driver`) 값이며 사용자 입력이 아님
- 2026-10-28 · SpotBugs `REC_CATCH_EXCEPTION` · `util/SecurityUtil.java`(`isAllowedImage`, `hasImageMagicBytes`): 예외 시 false 반환(거부) — 의도된 fail-closed
- 2026-10-28 · SpotBugs `RV_RETURN_VALUE_IGNORED_BAD_PRACTICE` · `util/AppConfig.java:113`, `util/SecurityUtil.java:322,358`: `mkdirs`/`delete` 반환값 무시. 실패해도 웹루트 밖 파일이라 영향 낮아 수정 가치 낮음

## 보류

## 사람 확인 필요
