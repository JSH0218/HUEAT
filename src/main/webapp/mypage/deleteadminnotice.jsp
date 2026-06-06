<%@page import="notice.model.NoticeDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공지 삭제</title>
</head>
<body>
<%
	// 관리자만 공지 일괄 삭제 가능
	if(!util.SecurityUtil.isAdmin(session)){
		response.sendRedirect("../index.jsp"); return;
	}
	// 상태변경은 POST + CSRF 토큰 검증(위조 요청 차단)
	if(!util.SecurityUtil.isPost(request) || !util.SecurityUtil.checkCsrf(request)){ response.sendError(403); return; }
	//nums를 읽기
	String nums=request.getParameter("nums");
	//,로 분리해서 배열선언
	String [] num=nums.split(",");
	//배열의 갯수만큼 delete
	NoticeDao dao=new NoticeDao();
	for(String n:num)
	{
		dao.deleteNotice(n);
	}
	
	//목록으로 이동
	response.sendRedirect("../index.jsp?main=mypage/adminnoticelist.jsp");
%>
</body>
</html>