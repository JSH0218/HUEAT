# CLAUDE.md

이 파일은 Claude Code(claude.ai/code)가 이 저장소에서 작업할 때 참고하는 가이드입니다.

> **언어 정책:** 기본 언어는 한국어다. 다음 모든 항목을 한글로 작성한다.
> - 이 파일(CLAUDE.md)의 모든 내용 — 수정·추가 시에도 반드시 한글만 사용
> - 코드 주석
> - 커밋 메시지(커밋 코맨트)
> - 사용자에게 하는 설명·응답
>
> (단, 식별자·API명·로그 등 기술적으로 영문이 적절한 부분은 예외로 한다.)

## 프로젝트 개요

HUEAT(휴EAT)는 고속도로 휴게소 정보 포털이다. 휴게소 검색, 음식 메뉴, 평점, 커뮤니티 게시판, 쇼핑 기능을 제공하며, Spring 없이 순수 Java Servlet/JSP로 구현된 전통적인 웹 애플리케이션으로 Apache Tomcat 9.0에서 동작한다.

## 빌드 및 실행

Maven 기반 프로젝트로 IntelliJ IDEA + Apache Tomcat v9.0에서 실행한다.

- **실행:** IntelliJ에서 `pom.xml`을 Maven 프로젝트로 열기 → Tomcat 9.0 Run Configuration 추가
- **접속 URL:** `http://localhost:8080/HuEatProject/`
- **웹 컨텐츠 루트:** `src/main/webapp/`
- **빌드:** `mvn clean package` (WAR 파일 생성)

### 검증

자동화 테스트(`src/test`)는 없다. 변경 후에는 아래로 정적 검증한다.

- **Java(DAO/DTO/util) 컴파일:** `mvn -q compile` — `src/main/java`만 확인하며 JSP는 검사하지 않는다.
- **JSP 프리컴파일 게이트:** `powershell -ExecutionPolicy Bypass -File scripts/jspc-check.ps1` (Linux/macOS: `bash scripts/jspc-check.sh`)
  - Jasper(`JspC`)로 모든 JSP를 변환+컴파일한다. 스크립틀릿 문법 오류, `<%@ include %>` 변수 중복선언, **JSP가 호출하는 DAO 메서드 이름/시그니처 불일치**(`javac`로는 못 잡음)를 잡는다.
  - Tomcat 9 설치(`CATALINA_HOME`)와 Java 17 필요. 최초 실행 시 `ant.jar`를 내려받아 `.jspc/`에 캐시한다. (`.sh`는 Tomcat이 없으면 Jasper JAR를 Maven Central에서 내려받는다.)
  - 베이스라인은 전체 JSP 오류 0이므로, 실패하면 직전 변경이 원인이다. JSP를 수정했다면 커밋 전에 실행한다.
  - 런타임 동작(SQL 결과, redirect, AJAX URL, 세션 흐름)은 잡지 못하므로 아래 실행 스모크 테스트로 확인한다. 자세한 내용은 `scripts/README.md`.
- **정적 분석:** `bash scripts/static-analysis.sh` — Semgrep(공개 룰 + `scripts/semgrep/hueat-rules.yml`의 HUEAT 전용 룰), SpotBugs+FindSecBugs, gitleaks를 실행하고 도구별 경고 수를 요약한다.
  - HUEAT 전용 룰은 이 저장소에서 실제로 찾은 결함 유형(이스케이프 없는 출력, 액션 JSP의 CSRF 누락, 관리자 화면의 `isAdmin` 누락, 문자열 관리자 비교, 하드코딩 키, SQL 문자열 연결)을 잡는다.
  - 공개 룰 중 `no-scriptlets`는 스크립틀릿 JSP 구조 전체에 걸려 실제 결함을 가리므로 제외한다.
- **실행 스모크 테스트:** `bash scripts/runtime-smoke.sh` — MariaDB(없으면 apt 설치)에 스모크 전용 DB(`hueat_smoke`)를 새로 만들어 `db/schema.sql`과 `scripts/smoke/seed.sql`을 적용하고, WAR를 Tomcat 9(포트 18080)에 배포한 뒤 Playwright로 `scripts/smoke/smoke.js`의 시나리오(공개 화면, 가입·로그인, 관리자 화면·비밀글 권한)를 실행한다. 종료코드 0이면 전 시나리오 통과다.
  - 정적 검증이 못 잡는 런타임 동작(SQL 결과, 안내창·이동, 세션 흐름, 같은 출처 5xx)을 확인한다. 외부 CDN 로딩 실패는 판정에 쓰지 않는다.
  - 권한 차단 판정은 "데이터가 노출되지 않음"을 기준으로 한다(include 화면의 `sendRedirect`는 무시되기 때문, 아래 '요청 흐름' 참고).

## 환경 설정

DB 접속 정보와 업로드 경로는 **웹루트 외부 설정 파일**에서 읽는다(소스코드에 하드코딩하지 않음).
`db.properties.example`를 복사해 실제 설정 파일을 만든 뒤 아래 위치 중 하나에 둔다:

1. 환경변수 `HUEAT_CONFIG`가 가리키는 절대경로
2. 시스템 프로퍼티 `-Dhueat.config=...`가 가리키는 경로
3. (기본) `${user.home}/.hueat/db.properties`

설정 키:

```properties
db.url=jdbc:mysql://host:port/hueat?useSSL=false&serverTimezone=Asia/Seoul&characterEncoding=UTF-8
db.user=<DB 계정>
db.password=<DB 비밀번호>
db.driver=com.mysql.cj.jdbc.Driver
upload.dir=C:/Project/Web/.appdata/hueat   # 업로드 파일 저장 베이스(웹루트·repo 외부)
```

설정 로딩은 `util/AppConfig.java`가 담당하며, `DbConnect`는 이를 통해 접속한다.
실제 설정 파일에는 비밀번호가 들어가므로 Git에 커밋하지 않는다(`.gitignore`에 `db.properties` 등록됨).

**권장 폴더 컨벤션(여러 프로젝트 공유):** 비밀 설정과 업로드 파일은 모두 repo 바깥에 둔다.
- 비밀 설정: `C:/Project/Web/.secrets/<프로젝트>.properties` (프로젝트당 파일 1개) → 각 프로젝트의 Run Configuration VM 옵션 `-Dhueat.config=...`로 지정
- 업로드/파일: `C:/Project/Web/.appdata/<프로젝트>/` (프로젝트당 하위 폴더 1개) → 해당 경로를 `upload.dir`로 지정

### DB 초기화 (최초 1회 필수)

`db/schema.sql`을 적용한다(전체 테이블 DDL을 한 파일에 모아둠: `mysql -u <user> -p <DB> < db/schema.sql`). 보안 변경으로 `meminfo` 테이블이 다음을 만족해야 한다:
- `m_pass VARCHAR(60)` — BCrypt 해시(60자) 저장
- `m_role VARCHAR(10) DEFAULT 'USER'` — 권한 구분. `getRole()`이 조회하고 회원가입은 DEFAULT에 의존하므로 컬럼이 반드시 존재해야 함
- **관리자 계정**: 관리자 판별이 role 기반이므로 `m_role='ADMIN'` 행이 없으면 관리자 기능을 아무도 못 쓴다. 스키마의 예시 INSERT로 생성한다.
- 기존 DB에 **평문 비밀번호**가 있으면 BCrypt 검증이 실패하므로 재해싱 또는 초기화가 필요하다.

- Java 17 필요
- MySQL 사용, `mysql-connector-j-8.3.0.jar` 드라이버는 `WEB-INF/lib/`에 포함되어 있음
- 의존 라이브러리: `cos.jar`(파일 업로드), `json_simple.jar`(JSON 파싱), `jbcrypt-0.4.jar`(비밀번호 해싱)
- 라이브러리는 `pom.xml`에 `system` 스코프로 `WEB-INF/lib`의 JAR를 직접 참조한다

## 아키텍처

**패턴:** 프레임워크 없는 JSP 기반 MVC. 컨트롤러 역할을 서블릿이 아닌 JSP 액션 페이지가 담당한다.

**요청 흐름:**
1. 모든 페이지는 `src/main/webapp/index.jsp`를 통해 `?main=<page>` 쿼리 파라미터로 로드됨
   - `main` 값은 `SecurityUtil.isAllowedMainPage`의 화이트리스트(`ALLOWED_MAIN_PAGES`, 대소문자 무시)에 있어야 include되며, 없으면 조용히 `layout/main.jsp`로 폴백한다. **`index.jsp?main=`으로 여는 새 화면을 추가하면 반드시 이 목록에도 등록한다.**
   - 폼/목록 화면은 `index.jsp`에 include되고, 상태변경 액션 JSP(`*action.jsp`, `*Delete.jsp` 등)는 단독으로 호출된 뒤 `response.sendRedirect("../index.jsp?main=...")`로 돌아간다.
   - include된 화면 안에서는 응답이 이미 시작되어 `response.sendRedirect`가 무시된다(빈 화면이 됨). include 화면에서 차단·이동하려면 `<script>alert(...);location.href=...</script>`를 출력하고 `return`한다.
2. 포함된 JSP 페이지가 서비스 레이어 없이 DAO를 직접 생성
3. DAO가 `mysql/db/DbConnect.getConnection()`으로 DB에 연결 후 PreparedStatement 실행
4. 결과를 DTO에 매핑하여 JSP에서 렌더링
5. 업로드 이미지는 웹루트 밖에 저장되므로 `<img src="fileview?type=<type>&name=<파일명>">` 형태로 `ImageServlet`을 통해 제공된다

**패키지 구조** (`src/main/java/`):
- `mysql/db/DbConnect.java` — JDBC 연결 관리 단일 진입점 (`AppConfig`로 접속 정보 획득)
- `util/` — 공용 인프라
  - `AppConfig.java` — 외부 설정 파일 로딩(DB 접속·`upload.dir`)
  - `SecurityUtil.java` — 보안 공용 유틸: XSS 이스케이프(`escapeHtml`/`nl2brEscaped`/`escapeJs`), 비밀번호 BCrypt(`hashPassword`/`checkPassword`), 예약 ID 차단(`isReservedId`), 업로드 검증(`validateOrDelete`/`validateAllUploads`), 세션 권한(`isLogin`/`isAdmin`/`isOwnerOrAdmin`/`currentId`), CSRF(`csrfToken`/`isPost`/`checkCsrf`), `index.jsp` include 화이트리스트(`isAllowedMainPage`), `urlEncode`/`safeUrl`/`digitsOnly`
  - `ImageServlet.java` — `/fileview`로 매핑. 웹루트 외부 업로드 이미지를 type 화이트리스트(`notice`, `event`, `review`, `shop`, `hugeso`) + 경로조작 차단으로 제공. 새 업로드 type을 만들면 `ALLOWED_TYPES`에 추가해야 한다
- 각 도메인은 `<domain>/model/<Entity>Dto.java` + `<domain>/model/<Entity>Dao.java` 구조를 따름

**비즈니스 도메인별 패키지:**
| 도메인 | 패키지 경로 | 설명 |
|---|---|---|
| 회원 / 인증 | `meminfo/model/` | 로그인, 회원가입, 프로필 |
| 휴게소 정보 | `hugesoinfo/model/` | 검색, 페이징, 유가 정보 |
| 즐겨찾기 | `favorite/model/` | 사용자별 북마크 휴게소 |
| 휴게소 평점 | `grade/model/` | 별점 평가 |
| 음식 메뉴 | `food/model/`, `brand/model/` | 메뉴 항목, 브랜드 정보 |
| 음식 평점 | `foodgrade/model/` | 메뉴별 평점 |
| 푸드코트 장바구니 | `foodcart/model/` | 구매 항목 |
| 게시판 | `notice/`, `event/`, `qa/`, `qaanswer/`, `review/` | 커뮤니티 콘텐츠 |
| 쇼핑 | `shop/model/` | 쇼핑몰 상품 |

**뷰 구조** (`src/main/webapp/`):
- `layout/` — 공통 헤더(`title.jsp`), 배너, 푸터(`info.jsp`, `main.jsp`)
- 기능 디렉토리는 Java 패키지명과 일치 (`member/`, `hugesoinfo/`, `foodcourt/` 등)
- `*save/` 디렉토리(`hugesosave/`, `noticesave/` 등)는 옛 방식의 이미지 폴더로, 기존 데이터가 참조하는 이미지가 들어 있다. 관리자 액션 JSP는 각 기능 디렉토리에 있다.

## 주요 컨벤션

- DTO는 getter/setter만 있는 순수 Java 빈이며 비즈니스 로직 없음.
- DAO는 ORM 없이 `PreparedStatement`로 raw JDBC 사용.
- 모든 JSP 페이지는 `pageEncoding="UTF-8"` 선언.
- 파일 업로드는 COS 라이브러리(`cos.jar`) 사용. 저장 위치는 `AppConfig.getUploadPath(type)`(= `upload.dir/<type>`, 웹루트 외부)이며 `ImageServlet`(`/fileview`)으로 제공한다. (옛 `src/main/webapp/image/`·`*save/` 직접 저장 방식은 더 이상 사용하지 않음)
- 세션 기반 인증: 로그인 상태는 `HttpSession`에 저장(`loginok`, `myid`, `role`).

## 보안 규칙 (반드시 준수)

이 코드베이스는 프레임워크가 없으므로 보안 처리를 수동으로 적용한다. 새 코드 작성 시 아래를 지킨다.

- **XSS 출력 인코딩:** DB/사용자 입력을 JSP로 출력할 때 절대 raw `<%= %>`로 내보내지 않는다.
  - HTML 본문/속성: `util.SecurityUtil.escapeHtml(...)`
  - 개행 포함 본문(기존 `replace("\n","<br>")` 대체): `util.SecurityUtil.nl2brEscaped(...)`
  - 인라인 JS 문자열: `util.SecurityUtil.escapeJs(...)`
  - JSON 응답이 클라이언트에서 `.html()`로 삽입되는 경우(DOM XSS), **서버 측 JSON 생성 시** `escapeHtml`로 이스케이프한다(예: `grade/gradelist.jsp`, `qaanswer/qaListAction.jsp`, `mypage/membersearch.jsp`).
- **비밀번호:** 평문 저장/비교 금지. 저장은 `SecurityUtil.hashPassword`, 검증은 `SecurityUtil.checkPassword`(BCrypt). 비밀번호 찾기는 평문 반환 대신 재설정(`member/passResetaction.jsp`) 방식.
- **권한:** 관리자 판별은 `myid.equals("admin")` 문자열 비교가 아니라 세션 `role`로 한다 — `SecurityUtil.isAdmin(session)`(내부적으로 `"ADMIN".equals(session.getAttribute("role"))`). 작성자 본인/관리자 확인은 `isOwnerOrAdmin(session, ownerId)`. 회원가입 시 예약 ID는 `SecurityUtil.isReservedId`로 차단.
- **입력 형식:** 회원 ID는 영문 소문자로 시작하는 영문 소문자·숫자 4~20자(`SecurityUtil.isValidMemberId`, 서버 `member/gaipaction.jsp`·`member/idcheck.jsp`와 클라이언트 `member/gaipform.jsp`가 같은 규칙).
- **입력 형식(장바구니):** 푸드코트 장바구니 담기 요청 수량은 1~10 정수(서버 `foodcourt/foodcartaddaction.jsp`, 클라이언트 `foodcourt/foodmenu.jsp` 입력란·검사가 같은 규칙).
- **입력 형식(평점):** 휴게소·음식 평점은 1~5 정수(`SecurityUtil.isValidGrade`, 서버 `grade/insertgrade.jsp`·`foodgrade/insertfoodgrade.jsp`, 클라이언트는 `hugesoinfo/hugesodetail.jsp`의 별점 라디오 1~5).
- **CSRF:** 상태변경 액션 JSP는 맨 앞에서 권한 확인 후 `if(!SecurityUtil.isPost(request) || !SecurityUtil.checkCsrf(request)){ response.sendError(403); return; }`로 POST+토큰을 검증한다.
  - HTML 폼: `<input type="hidden" name="_csrf" value="<%=util.SecurityUtil.csrfToken(session)%>">`
  - jQuery AJAX: `index.jsp` 하단의 `ajaxPrefilter`가 `_csrf`를 자동 첨부한다(동일출처 한정).
  - 링크형 삭제 등: GET 링크 대신 `index.jsp`가 제공하는 `postNav(url, params)`로 POST 전송한다.
  - 세션 쿠키는 `web.xml`(HttpOnly)과 `META-INF/context.xml`(`SameSite=lax`)에서 설정한다. 오류는 `web.xml`이 `error.jsp`로 포워딩해 스택트레이스를 노출하지 않는다.
- **파일 업로드:** 업로드 후 `SecurityUtil.validateOrDelete`/`validateAllUploads`로 확장자+MIME 검증(이미지만 허용). 저장 경로는 웹루트 외부(`upload.dir`)이며 직접 URL 접근이 아닌 `ImageServlet`으로만 제공.
- **DB 자격증명:** 소스에 하드코딩 금지. `AppConfig` 외부 설정 파일로만 관리.
- **민감값 치환:** 소스에서 API 키·앱키·가맹점 코드·토큰·비밀번호 등 민감값으로 추정되는 문자열을 발견하면 값만 `[secret]`으로 치환한다(예: `sdk.js?appkey=[secret]`, `Kakao.init("[secret]")`, `IMP.init('[secret]')`). 이 저장소에 남아 있던 카카오·결제 키는 계정 삭제로 이미 무효화된 값이라 치환으로 해당 기능이 동작하지 않아도 된다. 커밋 이력은 재작성(force-push)하지 않으며, 로그·PR·커밋 메시지에도 원래 값을 적지 않는다.

## 작업 원칙

LLM이 흔히 저지르는 실수(과한 변경, 근거 없는 가정, 불필요한 추상화)를 줄이기 위한 행동 지침이다. [andrej-karpathy-skills](https://github.com/multica-ai/andrej-karpathy-skills)의 CLAUDE.md를 이 저장소에 맞게 옮겼다. 사람 확인 없이 PR을 머지하는 자동 작업 회차에도 그대로 적용된다.

### 1. 코딩 전에 생각한다
- 가정을 명시한다. 해석이 여러 개면 조용히 하나를 고르지 않는다.
- 더 단순한 방법이 있으면 그 방법을 택하거나 제안한다.
- 불확실하면 대화형 작업에서는 질문한다. **자동 작업 회차(답할 사람이 없음)에서는 그 항목을 건너뛰고 `docs/ai-improvement-log.md`의 '보류'에 이유를 남긴다.** 확신 없는 수정을 머지하지 않는다.

### 2. 단순함이 우선이다
- 문제를 해결하는 최소한의 코드만 쓴다. 요청·주제에 없는 기능, 한 번만 쓰는 추상화, 요청받지 않은 설정 가능성은 넣지 않는다.
- 일어날 수 없는 상황을 위한 예외 처리는 넣지 않는다.
- 200줄로 썼는데 50줄로 가능하면 다시 쓴다.

### 3. 필요한 곳만 고친다
- 작업 범위는 요청(자동 회차에서는 그 회차에 고른 **주제 1개**)이다. 바뀐 모든 줄은 그 주제로 설명될 수 있어야 한다.
- 주제 범위 밖의 코드·주석·포맷은 "개선"하지 않는다. 눈에 띈 문제는 고치지 말고 기록한다(자동 회차는 로그의 '후보'에 추가).
- 주제가 리팩터링·죽은 코드 정리라면 그 주제 범위 안에서는 정리해도 된다. 범위 밖으로 번지지 않는다.
- 기존 스타일(명명, 스크립틀릿 패턴, 주석 밀도)을 따른다. 내 변경 때문에 안 쓰이게 된 import·변수·함수는 지운다.

### 4. 검증 가능한 목표로 실행한다
- 작업 전에 성공 기준을 정하고, 통과할 때까지 반복한다. 이 저장소에는 자동화 테스트가 없으므로 기준은 다음을 쓴다.
  - `mvn -q compile` 통과
  - JSP를 고쳤다면 JSP 프리컴파일 검증 통과
  - 정적 분석(Semgrep·SpotBugs) 경고 수가 변경 전보다 늘지 않음
  - 런타임 동작을 바꿨다면 실행 스모크 테스트(`scripts/runtime-smoke.sh`)의 실패 시나리오가 늘지 않음
  - 수정 전 문제의 재현 경로(어떤 입력이 어디로 흘러 어떻게 터지는지)를 설명할 수 있고, 수정 후 그 경로가 막혔음을 코드로 보일 수 있음
- 여러 단계 작업은 "단계 → 확인 방법" 형태로 짧게 계획을 세운다.

## 자동 작업 회차 규칙

예약 작업으로 같은 세션에서 반복 실행되는 자동 개선 회차(브랜치 `claude/auto-*`)에 적용한다. 이 세션은 대화 기록이 계속 쌓이므로 이전 판단에 끌려가는 편향(앵커링, 자기 작업 옹호, 시야 축소)을 막는 것이 목적이다. 예약 작업 지시문과 다르면 **이 섹션을 따른다**(지시문보다 나중에 추가되었다).

### 시작과 정리
- **최신 main에서 시작한다:** 회차마다 `git fetch origin main` 후 최신 `origin/main`에서 작업 브랜치를 만든다.
- **머지된 브랜치를 지운다:** 자동 PR을 머지했으면 그 head 브랜치(원격 `claude/auto-*`)를 `git push origin --delete <브랜치>`로 지운다. 회차 시작 시 이전 회차에서 남은 브랜치도 같은 기준으로 정리한다. 아래를 모두 만족할 때만 지운다.
  - 브랜치 이름이 `claude/auto-`로 시작한다(그 외 브랜치는 건드리지 않는다).
  - 그 브랜치를 head로 하는 PR이 **머지됨(merged)** 상태다(열린 PR, 머지 없이 닫힌 PR의 브랜치는 지우지 않는다).
  - 원격 브랜치의 최신 커밋이 머지된 PR의 head 커밋과 같다(다르면 지우지 않고 로그 '보류'에 남긴다).

### 항목 선정
- **판단은 매번 새로 한다:** 이전 회차의 대화 기억은 참고만 한다. 항목을 고를 때와 수정할 때는 해당 코드를 그 회차에 다시 읽고 처음부터 판단한다.
- **판정 재검증:** 로그의 '오탐'·'보류' 항목은 등록 후 14일이 지나면 다시 검증 대상에 넣는다(판정이 맞으면 날짜만 갱신).
- **영역 순환:** 같은 영역(패키지/웹 디렉토리)을 3회 연속 다루지 않는다. 로그에 영역을 기록하고, 아직 다루지 않은 영역을 우선한다.
- **HUEAT 전용 룰 경고도 후보다:** `scripts/semgrep/hueat-rules.yml`의 경고는 '후보'와 같은 개선 대상이며 우선순위 판단에 쓴다.
- **규칙은 스스로 정한다(소유자 위임):** 이 프로젝트는 실사용 서비스가 아니고 쌓인 운영 데이터도 없으며 규칙을 정해 줄 사람도 없다. 그래서 입력 검증 규칙(허용 문자·길이·형식 등)처럼 "규칙을 정해야 해서" 보류하던 동작 변경은 자동 회차가 통용되는 합리적인 기본값을 직접 정해 적용하고 자동 머지해도 된다(지시문의 "화면·URL 동작을 바꾸지 않는다"보다 우선한다).
  - 서버 측 검증을 기준으로 하고, 클라이언트 측 검증이 있으면 같은 규칙으로 맞춘다.
  - 정한 규칙은 이 파일의 '보안 규칙'에 한 줄로 남긴다.
  - 기존 데이터 호환은 고려하지 않는다. 단, DB 스키마 변경이 필요한 항목은 사람이 DB에 적용해야 하므로 '사람 확인 필요'로 남기고 고르지 않는다.
- **주간 재검토 회차:** 매주 일요일 01시 회차는 새 개선을 하지 않는다. 지난 7일간 자동 머지된 PR들을 서브에이전트로 처음 보는 리뷰어처럼 다시 검토하고, 결함이 있으면 수정 PR을 올린다. 결과는 로그 '재검토'에 기록한다.

### 검증과 머지
- **실행 검증:** 코드(JSP·Java·SQL)를 바꾸는 회차는 변경 전 main과 변경 후에 각각 `bash scripts/runtime-smoke.sh`를 실행해 실패한 시나리오를 비교한다. 변경 전부터 실패하던 시나리오는 원인을 로그에 남긴다.
- **시나리오를 늘린다:** 기능을 고치거나 동작을 바꾸면 그 동작을 확인하는 시나리오를 `scripts/smoke/smoke.js`에 추가한다(필요한 데이터는 `scripts/smoke/seed.sql`에). 추가한 시나리오는 수정 전 코드에서 실패하고 수정 후 통과하는지 확인한다.
- **결함 유형은 룰로 남긴다:** 직접 리뷰로 새 유형의 결함을 고쳤다면 같은 실수를 잡는 룰을 `scripts/semgrep/hueat-rules.yml`에 추가하는 것을 고려한다(정규식이 오탐 없이 표현 가능할 때만). 룰을 추가·수정하면 잡혀야 할 예시와 잡히면 안 되는 예시로 확인하고, 의도적으로 허용하는 파일은 `paths.exclude`에 이유와 함께 적는다.
- **독립 리뷰(서브에이전트):** 머지 전 diff 재검토는 Agent 도구로 띄운 서브에이전트에 맡긴다(이 섹션이 서브에이전트 사용을 명시적으로 지시한다). 서브에이전트에는 diff와 '문제와 재현 경로' 설명만 주고 "회귀·보안 결함·범위 이탈을 찾아라"라고 요청한다.
- **머지 조건(모두 충족해야 squash 머지):**
  1. `mvn -q compile` 통과, JSP를 고쳤다면 `bash scripts/jspc-check.sh` 통과
  2. `bash scripts/static-analysis.sh`의 Semgrep(전용·공개)·SpotBugs 경고가 새로 생기지 않음
  3. 코드를 바꿨다면 실행 스모크 테스트의 실패 시나리오가 변경 전보다 늘지 않음. 환경 문제(종료코드 2 이상)로 실행하지 못했다면 그 사실을 PR과 로그에 적고, 변경이 런타임 동작(권한·redirect·SQL·세션)을 바꾸는 경우에는 머지하지 않음
  4. 독립 리뷰가 지적한 문제를 모두 해소함
  5. PR이 mergeable이고 DB 스키마(`db/schema.sql`)·권한 설정(`.claude/settings.json`) 변경이 없음
- 하나라도 못 맞추면 머지하지 않고 PR에 사유를 코멘트한 뒤 로그에 기록한다.
