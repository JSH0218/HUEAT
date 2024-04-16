<%@page import="event.model.EventDto"%>
<%@page import="event.model.EventDao"%>
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
    //로그인상태확인
    String loginok=(String)session.getAttribute("loginok");
    String myid=(String)session.getAttribute("myid");   
   
    //이미지 업로드 경로
    String uploadPath = getServletContext().getRealPath("/eventsave");
    System.out.println(uploadPath);
    
    //업로드할 사이즈
    int uploadSize = 1024*1024*5;
    
    MultipartRequest multi = null;
    
    try {
    	
    	multi = new MultipartRequest(request, uploadPath, uploadSize, "utf-8", new DefaultFileRenamePolicy());
    	
    	
    	String e_subject = multi.getParameter("e_subject");
    	String e_content = multi.getParameter("e_content");
    	String e_image = multi.getFilesystemName("e_image");
    	
    	System.out.println(e_image);
    	
    	//dao 선언
    	EventDao dao = new EventDao();
    	
    	//dto 데이터담기
    	EventDto dto = new EventDto();
    	
    	dto.setE_myid(myid);
    	dto.setE_subject(e_subject);
    	dto.setE_content(e_content);
    	dto.setE_image(e_image);
    	
    	//db에 추가
    	dao.insertEvent(dto);
    	
    	//공지사항 목록으로 이동
    	response.sendRedirect("../index.jsp?main=eventboard/eventList.jsp");
    	
     } catch(Exception e) {
    	
    }
  
  %>

</body>
</html>