<%@page import="notice.model.NoticeDto"%>
<%@page import="notice.model.NoticeDao"%>
<%@page import="notice.model.NoticeDto"%>
<%@page import="notice.model.NoticeDao"%>
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
    //이미지 업로드 경로
    String uploadPath = getServletContext().getRealPath("/noticesave");
    System.out.println(uploadPath);
    
    //업로드할 사이즈
    int uploadSize = 1024*1024*5;
    
    MultipartRequest multi = null;
    
    try {
    	
    	multi = new MultipartRequest(request, uploadPath, uploadSize, "utf-8", new DefaultFileRenamePolicy());
    	
    	
    	String n_subject = multi.getParameter("n_subject");
    	String n_content = multi.getParameter("n_content");
    	String n_image = multi.getFilesystemName("n_image");
    	
    	System.out.println(n_image);
    	
    	//dao 선언
    	NoticeDao dao = new NoticeDao();
    	
    	//dto 데이터담기
    	NoticeDto dto = new NoticeDto();
    	
    	dto.setN_subject(n_subject);
    	dto.setN_content(n_content);
    	dto.setN_image(n_image);
    	
    	//db에 추가
    	dao.insertNotice(dto);
    	
    	//공지사항 목록으로 이동
    	response.sendRedirect("../index.jsp?main=noticeboard/noticeForm.jsp");
    	
     } catch(Exception e) {
    	
    }
  
  %>

</body>
</html>