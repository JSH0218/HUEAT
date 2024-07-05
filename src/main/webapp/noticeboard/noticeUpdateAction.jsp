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
  //String myid=(String)session.getAttribute("myid");

  String realPath=getServletContext().getRealPath("/noticesave");
  System.out.println(realPath);
  
  int uploadSize=1024*1024*5;
  
  MultipartRequest multi=null;
  try{
  multi=new MultipartRequest(request,realPath,uploadSize,"utf-8",new DefaultFileRenamePolicy());
  
       String n_num = multi.getParameter("n_num");
       String currentPage = multi.getParameter("currentPage");
       String n_subject = multi.getParameter("n_subject");
       String n_content=multi.getParameter("n_content");
       String n_image=multi.getFilesystemName("n_image"); 
       
       //기존포토명 가져오기 -> 기존에 사진값을 가져오기 위해서 dao 먼저 선언
       NoticeDao dao = new NoticeDao();
       String old_photoName = dao.getDataNotice(n_num).getN_image();
       
       //dto에 저장
       NoticeDto dto=new NoticeDto();
       
       
       //추후 아이디불러오기 dto.setMyid(myid);
       dto.setN_num(n_num);
       dto.setN_subject(n_subject);
       dto.setN_content(n_content);
       
       
       //사진 선택을 안하면 기존의 사진으로 저장
       dto.setN_image(n_image==null?old_photoName:n_image);
       
       //update
       dao.updateNotice(dto);
       
       //방명록 목록으로 이동(수정했던 페이지로 이동)
       response.sendRedirect("../index.jsp?main=noticeboard/noticeList.jsp?currentPage="+currentPage);
  
  }catch(Exception e){
	  
  }
%>

</body>
</html>