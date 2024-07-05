<%@page import="qa.model.QaDao"%>
<%@page import="qa.model.QaDto"%>
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
    request.setCharacterEncoding("utf-8");
  
    //로그인 세션얻기
	String loginok=(String)session.getAttribute("loginok");
	//아이디 얻기
	String myid=(String)session.getAttribute("myid");
  
    String q_category = request.getParameter("q_category");
    String q_subject = request.getParameter("q_subject");
    String q_content = request.getParameter("q_content");
    
    QaDto dto = new QaDto();
    
    dto.setQ_myid(myid);
    dto.setQ_category(q_category);
    dto.setQ_subject(q_subject);
    dto.setQ_content(q_content);
    
    QaDao dao = new QaDao();
    dao.insertQa(dto);
    
    //insert후 디테일 내용보기
    response.sendRedirect("../index.jsp?main=qaboard/qaList.jsp");
  %>
  
  
  

</body>
</html>