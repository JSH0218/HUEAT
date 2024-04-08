<%@page import="notice.model.NoticeDto"%>
<%@page import="notice.model.NoticeDao"%>
<%@page import="java.text.SimpleDateFormat"%>
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

  <%
  
    String n_num = request.getParameter("n_num");
    NoticeDao dao = new NoticeDao();
    
    NoticeDto dto = dao.getDataNotice(n_num);
    String currentPage=request.getParameter("currentPage");
    
    //조회수 가져오기
    dao.updateReadcount(n_num);
    
    //날짜
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
  
  %>
<body>

  <!-- 메뉴 타이틀 -->
  <div style="margin-top: 70px; text-align: center;"><h4><b>공지사항</b></h4></div>
  <input type="hidden" id="n_num" value="<%=n_num%>">

  <!-- 저장폼  -->
   <div style="margin: 100px 200px; width: 800px; margin-left: 25%;">
     <table class="table">
      <caption align="top"><h5><b><%=dto.getN_subject() %></b></h5></caption>
         
				
			
		</table> 
   </div>
</body>
</html>