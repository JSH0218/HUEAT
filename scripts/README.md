# scripts — 개발/검증 보조 스크립트

## jspc-check.ps1 — JSP 프리컴파일 검증 게이트

Tomcat을 띄우지 않고도 **모든 JSP의 변환(translation) + Java 컴파일 오류**를 한 번에 잡는다.
Apache Jasper(`org.apache.jasper.JspC`)로 `src/main/webapp`의 모든 `*.jsp`를 서블릿 코드로
변환하고 컴파일(`-compile`)한다.

### 왜 필요한가
- 기존 정적 검증은 `javac`로 `src/main/java`(DAO/DTO/util)만 확인했다 → **JSP는 무검증**이었다.
- 그래서 Tomcat 런타임 검증이 불가한 환경에서는 구조적 JSP 작업(페이징 스크립틀릿 `include`
  추출, `hugesolist` 4종 통합, 공용 CSS/탭 분리)을 "동작 보존 위배 위험"으로 **보류**해 왔다.
- 이 게이트는 그 보류 작업의 **1순위 위험**을 런타임 없이 잡아 재개 가능하게 한다:
  - JSP 변환 오류: 스크립틀릿/EL 문법, `<%@ include %>` 변수 중복선언·스코프 충돌
  - JSP→DAO 호출 오류: JSP가 부르는 DAO 메서드 이름/시그니처 불일치(예: 메서드 이름 변경 후
    JSP 호출처 누락) — **`javac`로는 못 잡고 런타임 ClassNotFound/NoSuchMethod로 터지던 것**

### 한계 (이건 못 잡는다 → 여전히 실제 구동 필요)
런타임 동작: SQL 결과, redirect 대상, AJAX URL 정합, 세션/로그인 흐름, DB 데이터 의존 화면.
→ end-to-end는 IntelliJ + Tomcat(+MySQL 시드) 수동 스모크 또는 Docker 스택으로 별도 검증.

### 사전조건
- Java 17 (`javac`/`java` on PATH)
- Apache Tomcat 9 설치(Jasper 제공). `CATALINA_HOME` 환경변수 설정 권장.
  미설정 시 스크립트가 기본 경로(`C:\ApacheTomcat\apache-tomcat-9.0.118`)를 시도한다.
  다른 환경이면 `CATALINA_HOME`을 설정하거나 스크립트의 `$cands` 목록을 수정한다.
- 인터넷(최초 1회): `ant.jar` 자동 다운로드 → `.jspc/lib`에 캐시.
  ※ `JspC`가 `org.apache.tools.ant.Task`를 링크하므로 `ant.jar`가 classpath에 반드시 필요하다.

### 실행
```powershell
powershell -ExecutionPolicy Bypass -File scripts/jspc-check.ps1
```
- 종료코드 `0` = 전 JSP 통과(오류 0), 그 외 = 실패(오류 로그 출력).
- 임시 산출물은 `.jspc/`(gitignore). 안전하게 삭제 가능, 다음 실행 시 재생성.

### 권장 사용 시점
- JSP를 만지는 모든 PR(특히 구조 통합·`include` 추출) 직후, 커밋 전.
- 기존 베이스라인은 **오류 0(green)** 임이 확인됨(전체 122개 JSP 통과). 새로 깨지면 그 변경이 원인.
