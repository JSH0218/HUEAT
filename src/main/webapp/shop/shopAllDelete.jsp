<%@page import="shop.ShopDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
    <link href="https://fonts.googleapis.com/css2?family=Nanum+Brush+Script&family=Nanum+Pen+Script&family=Noto+Sans+KR:wght@100..900&family=Noto+Serif+KR&family=Stylish&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <script src="https://code.jquery.com/jquery-3.7.0.js"></script>
<title>Insert title here</title>
</head>
<body>
<%
	//nums를 읽기
	String s_nums=request.getParameter("s_nums");
	//,로 분리해서 배열선언
	String [] num=s_nums.split(",");
	//배열의 갯수만큼 delete
	ShopDao dao=new ShopDao();
	for(String n:num)
	{
		dao.deleteShop(n);
	}
	
	//목록으로 이동
	response.sendRedirect("../index.jsp?main=shop/shopList.jsp");
%>

</body>
</html>