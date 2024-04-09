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
  //String myid=(String)session.getAttribute("myid");

  String realPath=getServletContext().getRealPath("/eventsave");
  System.out.println(realPath);
  
  int uploadSize=1024*1024*5;
  
  MultipartRequest multi=null;
  try{
  multi=new MultipartRequest(request,realPath,uploadSize,"utf-8",new DefaultFileRenamePolicy());
  
       String e_num = multi.getParameter("e_num");
       String currentPage = multi.getParameter("currentPage");
       String e_subject = multi.getParameter("e_subject");
       String e_content=multi.getParameter("e_content");
       String e_image=multi.getFilesystemName("e_image"); 
       
       //기존포토명 가져오기 -> 기존에 사진값을 가져오기 위해서 dao 먼저 선언
       EventDao dao = new EventDao();
       String old_photoName = dao.getDataEvent(e_num).getE_image();
       
       //dto에 저장
       EventDto dto=new EventDto();
       
       
       //추후 아이디불러오기 dto.setMyid(myid);
       dto.setE_num(e_num);
       dto.setE_subject(e_subject);
       dto.setE_content(e_content);
       
       
       //사진 선택을 안하면 기존의 사진으로 저장
       dto.setE_image(e_image==null?old_photoName:e_image);
       
       //update
       dao.updateEvent(dto);
       
       //방명록 목록으로 이동(수정했던 페이지로 이동)
       response.sendRedirect("../index.jsp?main=eventboard/eventList.jsp?currentPage="+currentPage);
  
  }catch(Exception e){
	  
  }
%>

</body>
</html>