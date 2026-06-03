<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isErrorPage="true"%>
<%
    // 오류 상세(스택트레이스/내부 경로/예외 메시지)는 사용자에게 노출하지 않는다.
    // 상세 내용은 서버 로그로만 남긴다.
    Integer sc = (Integer) request.getAttribute("javax.servlet.error.status_code");
    int code = sc != null ? sc.intValue() : 500;
    response.setStatus(code);
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>오류</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<style>
  .err-wrap{max-width:520px;margin:120px auto;text-align:center;font-family:'Noto Sans KR',sans-serif;}
  .err-code{font-size:64px;font-weight:700;color:#618E6E;}
</style>
</head>
<body>
  <div class="err-wrap">
    <div class="err-code"><%= code %></div>
    <p class="mt-3">요청을 처리하는 중 문제가 발생했습니다.</p>
    <p class="text-muted">잠시 후 다시 시도해 주세요.</p>
    <a class="btn btn-success mt-3" href="<%= request.getContextPath() %>/index.jsp">홈으로</a>
  </div>
</body>
</html>
