<%@page import="notice.model.NoticeDao"%>
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
<title>공지 삭제</title>
</head>
<body>

  <%
  // 관리자만 공지 삭제 가능
  if(!util.SecurityUtil.isAdmin(session)){
    response.sendRedirect("../index.jsp?main=noticeboard/noticeList.jsp"); return;
  }
  // 상태변경은 POST + CSRF 토큰 검증(위조 요청 차단)
  if(!util.SecurityUtil.isPost(request) || !util.SecurityUtil.checkCsrf(request)){ response.sendError(403); return; }
  String n_num=request.getParameter("n_num");
  String currentPage=request.getParameter("currentPage");

  NoticeDao dao=new NoticeDao();
  dao.deleteNotice(n_num);
  
  response.sendRedirect("../index.jsp?main=noticeboard/noticeList.jsp?currentPage="+currentPage);
  
  
  %>

</body>
</html>