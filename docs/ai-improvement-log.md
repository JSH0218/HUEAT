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
| 2026-10-29 | cab6173 | 802 (동일) | 21 (동일) | 0 |
| 2026-10-30 | ab650d4 | 802 (동일) | 21 (동일) | 0 |
| 2026-10-30 | cca8737 | 802 (동일) | 21 (동일) | 0 |
| 2026-10-30 | a25890c | 800 (no-scriptlets 797, httpservlet-path-traversal 2, unsafe-reflection 1) | 21 (동일) | 0 |
| 2026-10-30 | c5ca2af | 800 (동일) | 21 (동일) | 0 |
| 2026-10-30 | 53a9f29 | 전용 10 (admin-page-missing-isadmin 7, raw-string-getter-output 2, raw-request-session-output 1) / 공개 3 (no-scriptlets 제외) | 21 (동일) | 0 |
| 2026-10-30 | be020c0 | 전용 3 (raw-string-getter-output 2, raw-request-session-output 1) / 공개 3 | 21 (동일) | 0 |
| 2026-10-31 | 1ed7d65 | 전용 0 / 공개 3 (httpservlet-path-traversal 2, unsafe-reflection 1) | 21 (동일) | 0 |
| 2026-10-31 | dff4487 | 전용 0 / 공개 3 (동일) | 21 (동일) | 0 |
| 2026-10-31 | 033ae67 | 전용 0 / 공개 3 (동일) | 21 (동일) | 0 |

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

### 2026-10-29 · 보안(IDOR·정보 노출) · Q&A 비밀글 열람 권한 확인
- 영역: qaboard, qaanswer
- 근거: 직접 리뷰. Q&A는 모두 비밀글이라 `qaboard/qaList.jsp`가 작성자·관리자 외에는 "비밀글입니다"로 가리지만, `qaboard/qaDetail.jsp`·`qaboard/qaUpdateForm.jsp`(include 화면)와 `qaanswer/qaListAction.jsp`·`qaanswer/qaAnswerOneData.jsp`·`qaanswer/qaAnswerUpdateForm.jsp`(AJAX)는 권한 확인이 없어 비로그인 사용자도 `q_num`·`qa_num`을 바꿔 남의 질문과 답변을 읽을 수 있었다.
- 수정: 위 5개 파일에서 글을 읽은 직후 `SecurityUtil.isOwnerOrAdmin(session, 글 작성자)` 확인. include 화면은 안내창 후 목록으로 이동하고 `return`, AJAX는 403. 없는 글은 작성자가 null이라 관리자 외 거부.
- 검증: `mvn -q compile` 통과 / `bash scripts/jspc-check.sh` PASS(122개, 오류 0) / 서브에이전트 독립 재검토: 막을 문제 없음(작성자·관리자·마이페이지 링크·답변 AJAX 흐름 정상, 조회수는 권한 통과 시에만 증가). 리뷰가 찾은 같은 유형의 경로 2곳(`qaAnswerOneData.jsp`, `qaAnswerUpdateForm.jsp`)을 함께 막음.
- 경고 수 변화: Semgrep 802→802(기존 스크립틀릿 블록 안에서 처리), SpotBugs 21→21, gitleaks 0→0.
- PR: #119
- 실구동 확인 포인트: 비로그인·타인 계정으로 `index.jsp?main=qaboard/qaDetail.jsp?q_num=<남의 글>` 접근 시 안내창 후 목록 이동, 작성자 본인·관리자는 상세·답변 목록·관리자 답변 수정 정상.

### 2026-10-30 · 보안(권한 누락·정보 노출) · 마이페이지 관리자 목록 화면의 관리자 확인
- 영역: mypage(관리자 목록)
- 근거: 직접 리뷰. `mypage/adminqnalist.jsp`·`adminnoticelist.jsp`·`admineventlist.jsp`는 화이트리스트에 있는 관리자 전용 화면인데 권한 확인이 없어, 비로그인 사용자도 `index.jsp?main=mypage/adminqnalist.jsp`로 모든 Q&A 답변 내용과 질문 제목(비밀글)을 볼 수 있었다(#119로 막은 비밀글이 이 화면으로 노출).
- 수정: 세 파일의 기존 스크립틀릿 안, DAO 접근 전에 `SecurityUtil.isAdmin(session)` 확인. 아니면 안내창 후 메인으로 이동하고 `return`.
- 검증: `mvn -q compile` 통과 / `bash scripts/jspc-check.sh` PASS(122개, 오류 0) / 서브에이전트 독립 재검토: 막을 문제 없음(가드 앞 출력은 정적 CSS·JS뿐, 진입 링크·삭제 액션·페이징 정상).
- 경고 수 변화: Semgrep 802→802, SpotBugs 21→21, gitleaks 0→0.
- PR: #120
- 실구동 확인 포인트: 비로그인·일반 계정으로 세 화면 접근 시 안내창 후 메인 이동, 관리자는 목록·페이징·선택 삭제 정상.

### 2026-10-30 · 보안(LFI·정보 노출) · 검증 없는 include를 하던 죽은 화면 `mypage/mypageindex.jsp` 삭제
- 영역: mypage
- 근거: 직접 리뷰(지난 회차 서브에이전트 발견, 이번 회차에 코드 재확인). `mypagemain` 파라미터를 검증 없이 `<jsp:include page=...>`에 넣어, 직접 호출(`/mypage/mypageindex.jsp?mypagemain=../WEB-INF/web.xml`)로 `WEB-INF` 보호를 우회해 웹앱 내부 파일을 읽거나 `index.jsp` 화이트리스트를 우회해 임의 JSP를 include할 수 있었다.
- 수정: 저장소 어디에서도 참조·링크되지 않는 죽은 화면이라 파일을 삭제(화이트리스트를 새로 만드는 것보다 단순). 남은 동적 include는 화이트리스트로 막힌 `index.jsp` 하나뿐임을 확인.
- 검증: `mvn -q compile` 통과 / `bash scripts/jspc-check.sh` PASS(121개, 오류 0) / 서브에이전트 독립 재검토: 막을 문제 없음(코드·링크·설정 참조 없음, `RequestDispatcher`·`jsp:forward`·`pageContext.include` 사용처 없음).
- 경고 수 변화: Semgrep 802→800(`no-scriptlets` 799→797), SpotBugs 21→21, gitleaks 0→0.
- PR: #121
- 실구동 확인 포인트: 마이페이지 메뉴(회원정보 수정·내 글·즐겨찾기) 정상, `/mypage/mypageindex.jsp` 접근 시 404.

### 2026-10-30 · 버그(데이터 손실) · Q&A 관리자 답변 수정 폼에 기존 내용이 채워지지 않던 문제
- 영역: qaboard(상세 화면 스크립트)
- 근거: 직접 리뷰(로그 후보, 이번 회차에 코드 재확인). `qaboard/qaDetail.jsp`의 수정 아이콘 처리에서 `qaanswer/qaAnswerOneData.jsp` 응답 키(`qa_content`)가 아닌 `res.uqa_content`를 읽어 수정란이 비었고, 그대로 "수정"을 누르면 `qaAnswerUpdateAction.jsp`가 빈 값을 저장해 답변이 지워졌다. 서버는 값을 `escapeHtml`해 보내므로 키만 고치면 엔티티가 보이고 저장 시 이중 이스케이프된다.
- 수정: `qaboard/qaDetail.jsp` 한 줄. `res.qa_content`를 분리된 textarea로 엔티티 디코드해 `.val()`로 넣음(서버 이스케이프는 유지, 응답이 `text/html`이라 원문 반환보다 안전).
- 검증: `mvn -q compile` 통과 / `bash scripts/jspc-check.sh` PASS(121개, 오류 0) / Chromium(Playwright)에서 디코드 방식 확인: 엔티티 복원, `<img onerror>` 실행 안 됨 / 서브에이전트 독립 재검토: 막을 문제 없음(대상은 `<input type="text">`, 이후 목록은 서버 이스케이프 후 `.html()`).
- 경고 수 변화: Semgrep 800→800, SpotBugs 21→21, gitleaks 0→0.
- PR: #122
- 실구동 확인 포인트: 관리자로 Q&A 상세에서 답변 수정 아이콘 클릭 시 기존 내용(특수문자 `<`, `&` 포함)이 그대로 채워지는지, 수정 후 목록 표시.

### 2026-10-30 · 보안(권한 누락) · 관리자 글쓰기·수정 폼 7개의 관리자 확인
- 영역: noticeboard, eventboard, shop, hugesoinfo(관리자 폼)
- 근거: HUEAT 전용 Semgrep 룰 `hueat-admin-page-missing-isadmin` 7건(로그 후보와 동일). `noticeForm`·`noticeUpdateForm`·`eventForm`·`eventUpdateForm`·`shopForm`·`hugesoaddform`·`hugesoupdateform`이 비로그인 사용자에게도 관리자 폼과 수정용 기존 데이터를 보여 줬다(제출 액션은 이미 `isAdmin`으로 막힘).
- 수정: 7개 파일의 `<!DOCTYPE>` 바로 앞에 `SecurityUtil.isAdmin(session)` 확인 추가(아니면 안내창 후 메인 이동, `return`). `scripts/smoke/smoke.js`에 비로그인·일반 사용자 차단과 관리자 접근 시나리오 21개 추가.
- 검증: `mvn -q compile` 통과 / `bash scripts/jspc-check.sh` PASS(121개, 오류 0) / 실행 스모크: 변경 전 main 30/30 → 새 시나리오를 수정 전 코드에 돌리면 차단 14건 실패(37/51) → 수정 후 51/51 / 서브에이전트 독립 재검토: 막을 문제 없음(가드 앞 DAO·출력 없음, 정상 진입 링크는 모두 관리자 조건 안).
- 경고 수 변화: Semgrep 전용 10→3, 공개 3→3, SpotBugs 21→21, gitleaks 0→0.
- PR: #128
- 실구동 확인 포인트: 스모크 시나리오로 확인됨(비로그인·일반 사용자 안내창 후 이동, 관리자 정상 열람).

### 2026-10-30 · 보안(저장형 XSS) · 회원 생년월일·휴대폰 출력 이스케이프 누락
- 영역: mypage(회원 목록·검색·정보 수정), hugesoinfo(상세 1줄)
- 근거: HUEAT 전용 룰 `hueat-raw-string-getter-output` 2건·`hueat-raw-request-session-output` 1건 + 직접 리뷰(`mypage/membersearch.jsp`). `meminfo.m_birth`는 `VARCHAR(20)`이고 서버 형식 검증이 없어 가입·정보 수정 시 `<svg onload=alert()>`(20자)를 넣으면, 관리자 회원 목록(`memberlist.jsp`)에서 그대로 출력되어 관리자 브라우저에서 스크립트가 실행됐다. 관리자 회원 검색 JSON(`membersearch.jsp`)도 원문을 돌려줘 `memberlist.jsp`의 `.html()`로 DOM XSS가 됐다.
- 수정: `memberlist.jsp`(m_birth), `membersearch.jsp`(JSON m_birth), `updateform.jsp`(m_hp2·m_birth value), `hugesodetail.jsp`(세션 role)을 `escapeHtml`로 감쌈. `scripts/smoke/seed.sql`에 악성 생년월일 회원 추가, `scripts/smoke/smoke.js`에 시나리오 2개(회원 목록 스크립트 미실행, 검색 응답 이스케이프) 추가.
- 검증: `mvn -q compile` 통과 / `bash scripts/jspc-check.sh` PASS(121개, 오류 0) / 실행 스모크: 수정 전 코드 50/53(목록에서 스크립트 실행 확인, 검색 응답에 원문 `<svg onload=alert()>` 확인) → 수정 후 53/53 / 서브에이전트 독립 재검토: 막을 문제 없음(정상 값 불변, 이중 이스케이프 없음, 남은 raw 출력 없음).
- 경고 수 변화: Semgrep 전용 3→0, 공개 3→3, SpotBugs 21→21, gitleaks 0→0.
- PR: #130
- 실구동 확인 포인트: 스모크 시나리오로 확인됨.

### 2026-10-31 · 버그(계정 복구 불가)·입력 검증 · 가입·정보 수정의 휴대폰·생년월일 서버 측 형식 검증
- 영역: member(가입), mypage(정보 수정), util
- 근거: 로그 후보 + 오탐 확인 에이전트 판정 '실제 문제(낮음)'. 서버가 `m_hp2`·`m_birth` 형식을 검사하지 않았고 가입 화면은 `010.1234.5678`·12자 이상 번호를 허용했다. 아이디 찾기·비밀번호 재설정(`idsearchform.jsp`·`passSearchform.jsp`)은 정확히 11자만 받아 `m_hp2=?` 완전 일치로 비교하므로 이런 회원은 계정을 영구히 복구할 수 없었다. 생년월일에는 임의 문자열(스크립트 포함)이 저장됐다.
- 정한 규칙: 휴대폰은 숫자 11자, 생년월일은 실제 날짜인 `yyyy-MM-dd`. CLAUDE.md '보안 규칙'에 기록.
- 수정: `util/SecurityUtil.java`(`isValidPhone`·`isValidBirth`) / `member/gaipaction.jsp`·`mypage/updateaction.jsp`(위반 시 안내 후 되돌아감) / `member/gaipform.jsp`(휴대폰 숫자만·최대 11자, 제출 시 검사) / `mypage/updateform.jsp`(제출 시 검사) / `scripts/smoke/smoke.js`(형식 위반 휴대폰·생년월일 가입 거부 시나리오 2개 추가) / `CLAUDE.md`.
- 검증: `mvn -q compile` 통과 / `bash scripts/jspc-check.sh` PASS(121개, 오류 0) / jshell 판정 확인(휴대폰 11자만 통과, 생년월일 2024-02-29 통과·2023-02-29·1990-13-01·19900101·스크립트 거부) / 실행 스모크: 깨끗한 origin/main 기준선 53/53(종료코드 3) → 브랜치판으로 새 시나리오를 수정 전 코드에 돌리면 2건 실패(53/55), 수정 후 55/55 → main판 판정 종료코드 0 / 정적 분석 main판 판정 종료코드 0(새 경고 0건) / 서브에이전트 독립 재검토: 막을 문제 없음(관리자 시드 값은 새 규칙 통과, 형식 위반 기존 값도 수정 화면에서 고칠 수 있음).
- 경고 수 변화: Semgrep 전용 0→0, 공개 3→3, SpotBugs 21→21, gitleaks 0→0.
- PR: #137
- 실구동 확인 포인트: 스모크 시나리오(형식 위반 가입 거부, 정상 가입·로그인)로 확인.

### 2026-10-31 · 버그(빈 답변 저장)·입력 검증 · Q&A 답변 내용 서버 측 검증
- 영역: qaanswer, qaboard(상세 화면 스크립트)
- 근거: 로그 후보 + 오탐 확인 에이전트 판정 '실제 문제(낮음)'. 답변 등록·수정 액션이 `qa_content`를 검사하지 않았고 수정 화면(`#btnupdate`)에는 빈 값 검사가 없어, 관리자가 수정창을 비우고 저장하면 빈 답변이 저장되어 질문 목록에 '답변 1'로 집계됐다(`qaList.jsp`의 `qa_cnt`는 행 수). 1000자 초과는 DAO가 예외를 삼켜 실패해도 성공처럼 보였다.
- 정한 규칙: 답변 내용은 앞뒤 공백을 뺀 1~1000자. CLAUDE.md '보안 규칙'에 기록.
- 수정: `qaanswer/qaAnswerInsertAction.jsp`·`qaAnswerUpdateAction.jsp`(위반 시 400) / `qaboard/qaDetail.jsp`(수정 시 빈 값 검사, 등록·수정 입력란 `maxlength="1000"`) / `scripts/smoke/smoke.js`(정상 답변 등록, 공백 답변 등록 거부, 빈 값 수정 거부 시나리오 3개 추가) / `CLAUDE.md`.
- 검증: `mvn -q compile` 통과 / `bash scripts/jspc-check.sh` PASS(121개, 오류 0) / 실행 스모크: 깨끗한 origin/main 기준선 61/61(종료코드 3) → 브랜치판으로 새 시나리오를 수정 전 코드에 돌리면 2건 실패(62/64, 빈 답변 저장 재현) → 수정 후 64/64 → main판 판정 종료코드 0 / 정적 분석 main판 판정 종료코드 0(새 경고 0건).
- 독립 리뷰(2단계): 높음 0 / 중간 0 / 낮음 3. 1단계(diff만)는 호출처(`qaDetail.jsp`의 두 AJAX)·CSRF 첨부(`ajaxPrefilter`)·검사 순서·길이 상한·smoke 경로를 확인했다. 2단계(설명 추가)는 문제가 실제로 있었고 두 경로가 모두 막혔으며, `qaanswerboard`에 쓰는 다른 경로가 없음을 확인했다. 낮음 지적은 다음 세 가지로 모두 고치지 않았다. ① 길이 검사가 원문 기준(규칙 의도인 빈 답변·저장 실패는 막힘) ② 400 응답 시 화면 안내 없음 ③ 거부 시나리오가 상태코드를 보지 않음(②③은 후보로 기록).
- PR: #141
- 실구동 확인 포인트: 스모크 시나리오로 확인.

### 2026-10-31 · 버그(가입 흐름) · 가입 폼 아이디 중복확인 흐름 수정
- 영역: member(가입 화면 스크립트)
- 근거: 로그 후보. 오탐 확인 에이전트를 3번 돌렸고, 1·2순위(리뷰 수정 액션, 지도 페이징)는 오탐, 3순위인 이 항목이 '실제 문제(낮음)'로 판정됐다. `member/gaipform.jsp`는 중복확인 AJAX 직후 결과와 상관없이 `isIdChecked = true`로 설정했고, 사용 불가 시 입력란을 비우는 셀렉터가 `#id`(존재하지 않음)였으며, 확인 뒤 아이디를 바꿔도 초기화되지 않았다. 그래서 사용 불가 아이디로 제출하면 "회원가입 완료" 안내가 먼저 뜨고 서버가 거부했다. 독립 리뷰 1단계에서 추가로 '높음' 문제가 확인됐다. 단독으로 연 가입 폼에는 `ajaxPrefilter`가 없어서 `idcheck.jsp`·`nickcheck.jsp`(POST+CSRF 강제)가 원래부터 항상 403이었고, 첫 수정 후에는 회원가입이 아예 불가능해졌다.
- 수정: `member/gaipform.jsp`
  - 중복확인 결과가 '사용 가능'이고 응답 사이 입력값이 그대로일 때만 확인 처리한다.
  - 셀렉터를 `#m_id`로 고치고, 아이디 입력이 바뀌면 확인 상태를 초기화한다.
  - 중복확인·닉네임 확인 AJAX에 폼의 hidden `_csrf`를 직접 보낸다.
  - `scripts/smoke/smoke.js`: 사용 불가 결과 표시·입력란 비움, 사용 가능 결과 표시(단독 화면 CSRF 전달), 확인 뒤 아이디 변경 시 재확인 요구 시나리오 3개를 추가했다.
- 검증: `mvn -q compile` 통과 / `bash scripts/jspc-check.sh` PASS(121개, 오류 0) / 실행 스모크: 깨끗한 origin/main 기준선 79/79(종료코드 3) → 브랜치판으로 새 시나리오를 수정 전 코드에 돌리면 3건 실패(79/82) → 수정 후 82/82 → main판 판정 종료코드 0 / 정적 분석 main판 판정 종료코드 0(새 경고 0건).
- 독립 리뷰: 첫 리뷰 1단계 높음 1(단독 가입 폼 AJAX의 CSRF 토큰 누락으로 가입 불가)·중간 1(시나리오가 403 때문에 통과)·낮음 1 → 모두 수정. 새 리뷰 에이전트로 다시 리뷰: 1단계 높음 0·중간 0·낮음 3, 2단계 높음 0·중간 0·낮음 1(include 경로로 연 가입 폼의 상대경로 404, 회귀 아님, 후보로 기록). 확인 항목: idcheck/nickcheck/gaipaction 호출처, 단독·include 진입 경로(banner.jsp, loginform.jsp), 다른 단독 화면(idsearchform·passSearchform·updateform)의 CSRF 토큰 전달
- PR: (생성 후 기입)
- 실구동 확인 포인트: 스모크 시나리오(단독 가입 화면의 중복확인 결과 표시, 재확인 요구)로 확인.

## 후보
- [유지보수·낮음·2026-10-31] 업로드 액션 9개(`reviewAction`·`reviewUpdateAction`·`noticeAction`·`noticeUpdateAction`·`eventAction`·`eventUpdateAction`·`shopAction`·`hugesoaddaction`·`hugesoupdateaction`): CSRF·권한 거부 경로에서 이미 저장된 업로드 파일을 지우지 않고, 이미지 교체 시 기존 파일도 지우지 않음(공통 정리 과제)
- [유지보수·낮음·2026-10-31] `layout/pagingCalc.jspf`(13개 화면)·`hugesoinfo/hugesopaging.jsp`: `currentPage`가 비숫자·0 이하일 때 기본값 1로 정리하지 않음(현재 영향은 오류 화면·빈 목록뿐)
- [버그·낮음·2026-10-31] `index.jsp?main=member/gaipform.jsp`(`layout/banner.jsp:133`)로 include하면 상대경로 `idcheck.jsp`·`nickcheck.jsp`·`gaipaction.jsp`가 웹 루트 기준으로 풀려 404(단독 화면은 정상)
- [버그·낮음·2026-10-31] `member/gaipform.jsp`: 닉네임 중복 결과가 제출을 막지 않음, `onsubmit="return check(this)"`의 `check` 함수가 정의돼 있지 않음, 중복확인 AJAX에 `error` 처리 없음
- `qaboard/qaDetail.jsp`: 답변 등록·수정 AJAX에 `error` 콜백이 없어 서버 400 응답이 화면에 표시되지 않음
- `scripts/smoke/smoke.js`: Q&A 답변 거부 시나리오가 DB 불변만 보고 응답 상태코드(400)는 확인하지 않음(다른 이유의 실패로도 통과 가능)
- `qaboard/qaAction.jsp`·`qaUpdateAction.jsp`: 질문 제목·내용 빈 값 서버 측 검사 여부 미확인
- `hugesoinfo/hugesodetail.jsp:1270-1271`: 휴게소 수정·삭제 버튼이 권한 조건 없이 모든 사용자에게 보임(서버·폼 단계에서는 막힘, 화면 표시만 정리 필요)
- `shop/shopDelete.jsp`: 호출처가 없는 죽은 액션(화면은 `shopAllDelete.jsp`만 사용). redirect가 `if(file.exists())` 안에만 있어 직접 호출 시 빈 화면. 죽은 코드 정리 후보
- `shop/shopAllDelete.jsp`: 상품 일괄 삭제 시 이미지 파일을 지우지 않음(`shopDelete.jsp`와 불일치)
- `mypage/updateform.jsp`·`deleteform.jsp`·`favlist.jsp`·`myqnalist.jsp`·`myreviewlist.jsp`: 로그인 확인 없음(세션 myid로만 조회해 타인 데이터 노출은 없으나 비로그인 시 NPE 가능)
- `qaanswer/qaAnswerUpdateForm.jsp`: 호출처가 없는 파일로 보이며 `qa_content`를 이스케이프 없이 JSON으로 출력(죽은 코드 정리 후보)
- 같은 사용자의 평점 중복 등록 제한 없음(1~5 범위여도 반복 등록으로 평균·순위가 기울어짐). 사용자당 1회 규칙이면 UNIQUE 제약 등 스키마 변경이 필요할 수 있음
- `foodgrade/insertfoodgrade.jsp`: `fg_foodnum`·`fg_hugesonum` 숫자 정규화·빈 값 검사 없음(`insertgrade.jsp`의 `h_num` 처리와 비대칭)
- `foodcart/model/FoodCartDao.java` `updateCnt`: 이미 담긴 메뉴는 요청 수량을 무시하고 +1만 하며 누적 상한이 없음(반복 담기로 10 초과 가능). 누적 상한 규칙 검토
- `foodcourt/foodmenu.jsp`: 담기 AJAX에 `error` 콜백이 없어 서버 400 응답이 화면에 표시되지 않음
- `foodcourt/foodcartaddaction.jsp`: `f_num`·`h_num` 존재·숫자 여부 미검증(바인딩 파라미터라 SQLi는 아님)
- Semgrep `no-scriptlets` 799건은 이 프로젝트 구조(스크립틀릿 JSP) 자체라 개선 대상 아님

## 오탐
- 2026-10-31 · 직접 리뷰 · `reviewboard/reviewUpdateAction.jsp`(오탐 확인 에이전트 판정): 없는 `r_num`은 DAO가 빈 DTO를 돌려줘 NPE가 나지 않고 권한 없음으로 정상 차단됨. 거부 경로의 고아 업로드 파일은 업로드 액션 9개 공통 구조이며 새 공격 능력이 없음(로그인 사용자는 원래 업로드 가능, 웹루트 밖 저장)
- 2026-10-31 · 직접 리뷰 · `hugesoinfo/hugesopaging.jsp`(오탐 확인 에이전트 판정): 유일한 호출처 `hugesomap.jsp`는 1 이상의 정수만 보냄. 비정상 값은 `error.jsp`(스택트레이스 비노출) 또는 빈 목록으로 끝나 노출·우회 없음. `layout/pagingCalc.jspf`(13개 화면)도 같은 방식이라 이 파일만 고치면 일관성이 깨짐
- 2026-10-28 · Semgrep `httpservlet-path-traversal` · `util/ImageServlet.java:64-65`: type 화이트리스트, 파일명 구분자·`..` 차단, 정규화 경로의 베이스 하위 재확인으로 이미 방어됨
- 2026-10-28 · Semgrep `unsafe-reflection` · `mysql/db/DbConnect.java:16`: `Class.forName` 인자는 서버 외부 설정 파일(`db.driver`) 값이며 사용자 입력이 아님
- 2026-10-28 · SpotBugs `REC_CATCH_EXCEPTION` · `util/SecurityUtil.java`(`isAllowedImage`, `hasImageMagicBytes`): 예외 시 false 반환(거부) — 의도된 fail-closed
- 2026-10-28 · SpotBugs `RV_RETURN_VALUE_IGNORED_BAD_PRACTICE` · `util/AppConfig.java:113`, `util/SecurityUtil.java:322,358`: `mkdirs`/`delete` 반환값 무시. 실패해도 웹루트 밖 파일이라 영향 낮아 수정 가치 낮음

## 보류
- (해결) 2026-10-30 · 머지된 `claude/auto-*` 원격 브랜치 정리: 세션에서는 삭제가 막혀(권한 분류기·git 프록시 403) 저장소 설정 "Automatically delete head branches"로 대체했고, 남은 브랜치는 소유자가 정리했다. 이후 회차는 브랜치 삭제를 시도하거나 기록하지 않는다(CLAUDE.md).
- 2026-10-30 · 업로드 파일 삭제 경로 불일치: `reviewboard/reviewDelete.jsp`·`shop/shopDelete.jsp`·`hugesoinfo/hugesodeleteaction.jsp`가 첨부 이미지를 옛 웹루트 경로(`getRealPath("/reviewsave")` 등)에서 지워, 실제 업로드 파일(`AppConfig.getUploadPath(type)`)은 남는다. 경로만 바꾸면 여러 행이 같은 파일명(예: `hugesosave/없음.jpg` 같은 자리표시 이미지)을 참조할 때 화면에 쓰이는 공유 이미지를 지워 다른 글의 이미지가 깨질 수 있어 보류. 해결하려면 삭제 전 같은 파일명을 참조하는 다른 행이 없는지 확인하는 로직이 먼저 필요하다. (서브에이전트 검토도 보류 판단에 동의)
- 2026-10-30 · 이번 회차는 위 항목 검토 중 `shop/shopDelete.jsp` redirect 수정을 시도했으나, 서브에이전트 검토로 호출처가 없는 죽은 액션임이 확인되어(화면 재현 경로 없음) 변경을 되돌리고 기록만 남김.

## 사람 확인 필요
