<%@page import="org.json.simple.JSONObject"%>
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
    //num 읽기
    String e_num = request.getParameter("e_num");
    
    EventDao dao = new EventDao();
    dao.updateEventChu(e_num);
    
    //증가된 chu 값 json 형태로 보내기
    int chu = dao.getDataEvent(e_num).getE_chu();
    
    JSONObject ob = new JSONObject();
    ob.put("chu", chu);
    
    %>
    
    <%=ob.toString()%>

</body>
</html>