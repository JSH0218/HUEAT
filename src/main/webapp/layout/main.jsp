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
  
  .title1 {
  text-align: center; /* 가로 가운데 정렬 */
  margin-top: 10vh; /* 화면 세로 중앙으로 이동 */
   }

  .subtitle {
  text-align: center; /* 가로 가운데 정렬 */
  color: gray;          
  }
  
   .title2 {
  text-align: center; /* 가로 가운데 정렬 */
  margin-top: 12vh; /* 화면 세로 중앙으로 이동 */
   }

  .subtitle1 {
  text-align: center; /* 가로 가운데 정렬 */
  color: gray;          
  }
  
  #total_main {
  padding-bottom: 50px;
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
 <div id="total_main" >
  <!-- 타이틀1 -->
   <div class="title1">
    <h2><b>고객소통</b></h2>
   </div>

   <div class="subtitle">
     <h5>항상 고객을 존중하며 고객의 눈높이에서 고객중심경영을 실현하기 위하여 최선을 다하겠습니다.</h5>
   </div>


  <!-- 공지사항 / 이벤트 -->
  <div style="margin-top: 4%;">
    <jsp:include page="../mainlayout/noticevent.jsp" />
  </div>
  
  <!-- 메뉴 카테고리 -->
  <div class="category">
  <jsp:include page="../mainlayout/menutag.jsp" />
  </div>

  <!-- 타이틀1 -->
   <div class="title2">
    <h2><b>이달의 소식</b></h2>
   </div>

   <div class="subtitle1">
     <h5>최고의 품질과 양으로 고객님들께 웃음을 드리도록 노력하겠습니다.</h5>
   </div>

  <!-- 이달의 휴게소 -->
  <div style="display: inline-block; margin-right: 20px; margin-top: 2%;">
  <jsp:include page="../mainlayout/hugesorank.jsp" />
  </div>
  
  
  <!-- 이달의 메뉴 -->
  <div style="display: inline-block; margin-left: -5%;">
  <jsp:include page="../mainlayout/foodrank.jsp" />
  </div>
  
  
  
 </div>
 
 </body>
</html>