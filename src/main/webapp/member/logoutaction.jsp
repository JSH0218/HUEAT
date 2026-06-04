<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Grandiflora+One&family=Gugi&family=Hahmlet:wght@100..900&family=Hi+Melody&family=Sunflower:wght@300&display=swap" rel="stylesheet">
<script src="https://code.jquery.com/jquery-3.7.0.js"></script>
<title>Insert title here</title>
</head>
<body>
<%
// 로그아웃 CSRF 차단: POST + CSRF 토큰 검증을 통과해야만 세션을 무효화한다.
if(!util.SecurityUtil.isPost(request) || !util.SecurityUtil.checkCsrf(request)){
	response.sendError(403); return;
}
//세션 전체 무효화(loginok뿐 아니라 myid/role/saveok/CSRF 토큰까지 제거)
session.invalidate();
response.sendRedirect("../index.jsp");
%>
</body>
</html>