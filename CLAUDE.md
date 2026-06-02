# CLAUDE.md

이 파일은 Claude Code(claude.ai/code)가 이 저장소에서 작업할 때 참고하는 가이드입니다.

> **언어 정책:** 이 파일의 모든 내용은 한글로 작성한다. 앞으로 이 파일을 수정하거나 추가할 때도 반드시 한글로만 작성한다.

## 프로젝트 개요

HUEAT(휴EAT)는 고속도로 휴게소 정보 포털이다. 휴게소 검색, 음식 메뉴, 평점, 커뮤니티 게시판, 쇼핑 기능을 제공하며, Spring 없이 순수 Java Servlet/JSP로 구현된 전통적인 웹 애플리케이션으로 Apache Tomcat 9.0에서 동작한다.

## 빌드 및 실행

Maven 기반 프로젝트로 IntelliJ IDEA + Apache Tomcat v9.0에서 실행한다.

- **실행:** IntelliJ에서 `pom.xml`을 Maven 프로젝트로 열기 → Tomcat 9.0 Run Configuration 추가
- **접속 URL:** `http://localhost:8080/HuEatProject/`
- **웹 컨텐츠 루트:** `src/main/webapp/`
- **빌드:** `mvn clean package` (WAR 파일 생성)

## 환경 설정

실행 전 `src/main/java/mysql/db/DbConnect.java`의 하드코딩된 플레이스홀더를 실제 값으로 교체해야 한다:

```java
MYSQL_URL = "url";   // jdbc:mysql://host:port/dbname 형식으로 교체
// user ID = "id"    // 실제 DB 계정으로 교체
// password = "pass" // 실제 DB 비밀번호로 교체
```

- Java 17 필요
- MySQL 사용, `mysql-connector-j-8.3.0.jar` 드라이버는 `WEB-INF/lib/`에 포함되어 있음
- 의존 라이브러리: `cos.jar`(파일 업로드), `json_simple.jar`(JSON 파싱)

## 아키텍처

**패턴:** 프레임워크 없는 JSP 기반 MVC. 컨트롤러 역할을 서블릿이 아닌 JSP 액션 페이지가 담당한다.

**요청 흐름:**
1. 모든 페이지는 `src/main/webapp/index.jsp`를 통해 `?main=<page>` 쿼리 파라미터로 로드됨
2. 포함된 JSP 페이지가 서비스 레이어 없이 DAO를 직접 생성
3. DAO가 `mysql/db/DbConnect.getConnection()`으로 DB에 연결 후 PreparedStatement 실행
4. 결과를 DTO에 매핑하여 JSP에서 렌더링

**패키지 구조** (`src/main/java/`):
- `mysql/db/DbConnect.java` — JDBC 연결 관리 단일 진입점 (DB 인증 정보 집중 관리)
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
- 파일 업로드는 COS 라이브러리(`cos.jar`) 사용, 업로드 파일은 `src/main/webapp/image/` 하위에 저장.
- 세션 기반 인증: 로그인 상태는 `HttpSession`에 저장.
