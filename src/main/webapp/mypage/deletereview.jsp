<%@page import="review.model.ReviewDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<%
	//nums를 읽기
	String nums=request.getParameter("nums");
	//,로 분리해서 배열선언
	String [] num=nums.split(",");
	//배열의 갯수만큼 delete
	ReviewDao dao=new ReviewDao();
	for(String n:num)
	{
		dao.deleteReview(n);
	}
	
	//목록으로 이동
	response.sendRedirect("../index.jsp?main=mypage/myreviewlist.jsp");
%>
</body>
</html>