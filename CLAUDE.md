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
2. 포함된 JSP 페이지가 서비스 레이어 없이 DAO를 직접 생성
3. DAO가 `mysql/db/DbConnect.getConnection()`으로 DB에 연결 후 PreparedStatement 실행
4. 결과를 DTO에 매핑하여 JSP에서 렌더링
5. 업로드 이미지는 웹루트 밖에 저장되므로 `<img src="fileview?type=<type>&name=<파일명>">` 형태로 `ImageServlet`을 통해 제공된다

**패키지 구조** (`src/main/java/`):
- `mysql/db/DbConnect.java` — JDBC 연결 관리 단일 진입점 (`AppConfig`로 접속 정보 획득)
- `util/` — 공용 인프라
  - `AppConfig.java` — 외부 설정 파일 로딩(DB 접속·`upload.dir`)
  - `SecurityUtil.java` — 보안 공용 유틸: XSS 이스케이프(`escapeHtml`/`nl2brEscaped`/`escapeJs`), 비밀번호 BCrypt(`hashPassword`/`checkPassword`), 예약 ID 차단(`isReservedId`), 업로드 검증(`validateOrDelete`/`validateAllUploads`), `urlEncode`
  - `ImageServlet.java` — `/fileview`로 매핑. 웹루트 외부 업로드 이미지를 type 화이트리스트 + 경로조작 차단으로 제공
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
- 관리자 액션 페이지는 `*save/` 디렉토리에 위치 (예: `hugesosave/`, `noticesave/`)

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
- **권한:** 관리자 판별은 `myid.equals("admin")` 문자열 비교가 아니라 세션 `role`로 한다 — `"ADMIN".equals(session.getAttribute("role"))`. 회원가입 시 예약 ID는 `SecurityUtil.isReservedId`로 차단.
- **파일 업로드:** 업로드 후 `SecurityUtil.validateOrDelete`/`validateAllUploads`로 확장자+MIME 검증(이미지만 허용). 저장 경로는 웹루트 외부(`upload.dir`)이며 직접 URL 접근이 아닌 `ImageServlet`으로만 제공.
- **DB 자격증명:** 소스에 하드코딩 금지. `AppConfig` 외부 설정 파일로만 관리.
