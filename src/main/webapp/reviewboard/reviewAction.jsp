<%@page import="review.model.ReviewDao"%>
<%@page import="review.model.ReviewDto"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
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
    
	//로그인 세션얻기
	String loginok=(String)session.getAttribute("loginok");
	//아이디 얻기
	String myid=(String)session.getAttribute("myid");
  
    String uploadPath = getServletContext().getRealPath("/reviewsave");
    System.out.println(uploadPath);
    
    int uploadSize = 1024*1024*5;
    
    MultipartRequest multi = null;
    
    try{
    	
    	multi = new MultipartRequest(request,uploadPath,uploadSize,"utf-8",new DefaultFileRenamePolicy());
    	
    	String r_category = multi.getParameter("r_category");
    	String r_content = multi.getParameter("r_content");
    	String r_image = multi.getFilesystemName("r_image");
    	
    	System.out.println(r_image);
    	
    	//dao선언
    	ReviewDao dao = new ReviewDao();
    	
    	//dto저장
    	ReviewDto dto = new ReviewDto();
    	
    	dto.setR_myid(myid);
    	dto.setR_category(r_category);
    	dto.setR_content(r_content);
    	dto.setR_image(r_image);
    	
    	//db추가
    	dao.insertReview(dto);
    	
    	//방명록 목록으로 이동
    	response.sendRedirect("../index.jsp?main=reviewboard/reviewList.jsp");
    	
    } catch (Exception e) {
    	
    }
  %>

</body>
</html>