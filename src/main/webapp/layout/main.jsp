<%@page import="hugesoinfo.model.HugesoInfoDto"%>
<%@page import="hugesoinfo.model.HugesoInfoDao"%>
<%@page import="event.model.EventDto"%>
<%@page import="event.model.EventDao"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="notice.model.NoticeDto"%>
<%@page import="java.util.List"%>
<%@page import="notice.model.NoticeDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
    <link href="https://fonts.googleapis.com/css2?family=Nanum+Gothic&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <script src="https://code.jquery.com/jquery-3.7.0.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<title>Insert title here</title>
<style type="text/css">
  .category {
    margin-top: -13.2%;
    margin-left: 42%;
    
  }

</style>
</head>
  <%
   //프로젝트 경로
   String root = request.getContextPath();  
   
  
   //notice
   NoticeDao ndao = new NoticeDao();
   List<NoticeDto> list = ndao.getAllNotice();
   
   //event
   EventDao edao = new EventDao();
   List<EventDto> elist = edao.getAllEvent();
   
   //휴게소
   HugesoInfoDao hdao = new HugesoInfoDao();
   List<HugesoInfoDto> hlist = hdao.getAllGrade();
   
   
  %>
<body>
  <!-- 공지사항 / 이벤트 -->
  <div style="margin-top: 4%;">
    <jsp:include page="../mainlayout/noticevent.jsp" />
  </div>
  
  <!-- 메뉴 카테고리 -->
  <div class="category">
  <jsp:include page="../mainlayout/menutag.jsp" />
  </div>

  <div style="margin-top: 100px;"></div>

  <!-- 이달의 휴게소 -->
  <div style="display: inline-block; margin-right: 20px;">
  <jsp:include page="../mainlayout/hugesorank.jsp" />
  </div>
  
  
  <!-- 이달의 메뉴 -->
  <div style="display: inline-block;">
  <jsp:include page="../mainlayout/foodrank.jsp" />
  </div>
 </body>
</html>