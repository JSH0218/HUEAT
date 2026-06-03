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
	// 로그인 필수
	if(!util.SecurityUtil.isLogin(session)){
		response.sendRedirect("../index.jsp?main=member/loginform.jsp"); return;
	}
	//nums를 읽기
	String nums=request.getParameter("nums");
	//,로 분리해서 배열선언
	String [] num=nums.split(",");
	//배열의 갯수만큼 delete (작성자 본인 또는 관리자 글만)
	ReviewDao dao=new ReviewDao();
	for(String n:num)
	{
		review.model.ReviewDto r=dao.getDataReview(n);
		if(r!=null && util.SecurityUtil.isOwnerOrAdmin(session, r.getR_myid())){
			dao.deleteReview(n);
		}
	}
	
	//목록으로 이동
	response.sendRedirect("../index.jsp?main=mypage/myreviewlist.jsp");
%>
</body>
</html>