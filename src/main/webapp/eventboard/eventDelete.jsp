<%@page import="event.model.EventDao"%>
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
  // 관리자만 이벤트 삭제 가능
  if(!util.SecurityUtil.isAdmin(session)){
    response.sendRedirect("../index.jsp?main=eventboard/eventList.jsp"); return;
  }
  // CSRF 토큰 검증(위조 요청 차단)
  if(!util.SecurityUtil.checkCsrf(request)){ response.sendError(403); return; }
  String e_num=request.getParameter("e_num");
  String currentPage=request.getParameter("currentPage");

  EventDao dao=new EventDao();
  dao.deleteEvent(e_num);
  
  response.sendRedirect("../index.jsp?main=eventboard/eventList.jsp?currentPage="+currentPage);
  
  
  %>

</body>
</html>