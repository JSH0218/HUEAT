<%@page import="java.io.File"%>
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
  
    //db삭제뿐 아니라 업로드된 파일도 삭제하기
    String s_num = request.getParameter("s_num");
    String currentPage = request.getParameter("currentPage");
    
    //db로 부터 저장된 이미지명 얻기
    ShopDao dao = new ShopDao();
    String r_image = dao.getDataShop(s_num).getS_image();
    
    //db삭제
    dao.deleteShop(s_num);
    
    
    //파일삭제
    //프로젝트 실제경로구하기
    String realPath = getServletContext().getRealPath("/shopsave");
    
    //파일 객체 생성
    File file = new File(realPath+"/"+r_image);
    
    //파일 삭제
    if(file.exists()) {
    	file.delete();
    	
    	//보던 페이지로 이동
    	response.sendRedirect("../index.jsp?main=shop/shopList.jsp?currentPage="+currentPage);
    }
  
  %>
</body>
</html>