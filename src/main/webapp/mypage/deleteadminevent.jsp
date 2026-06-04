<%@page import="event.model.EventDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Dongle&family=Nanum+Pen+Script&family=Noto+Sans+KR:wght@100..900&family=Single+Day&family=Stylish&display=swap" rel="stylesheet">
<script src="https://code.jquery.com/jquery-3.7.0.js"></script>
<title>Insert title here</title>
</head>
<body>
<%
	// 관리자만 이벤트 일괄 삭제 가능
	if(!util.SecurityUtil.isAdmin(session)){
		response.sendRedirect("../index.jsp"); return;
	}
	// CSRF 토큰 검증(위조 요청 차단)
	if(!util.SecurityUtil.checkCsrf(request)){ response.sendError(403); return; }
	//nums를 읽기
	String nums=request.getParameter("nums");
	//,로 분리해서 배열선언
	String [] num=nums.split(",");
	//배열의 갯수만큼 delete
	EventDao dao=new EventDao();
	for(String n:num)
	{
		dao.deleteEvent(n);
	}
	
	//목록으로 이동
	response.sendRedirect("../index.jsp?main=mypage/admineventlist.jsp");
%>
</body>
</html>