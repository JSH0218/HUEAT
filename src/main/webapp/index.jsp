<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
	<link href="https://fonts.googleapis.com/css2?family=Nanum+Gothic&display=swap" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.7.0.js"></script>
    <link rel="icon" type="image/png" href="image/mainbanner/logo1.png" sizes="32x32">
<title>HUEAT</title>
<style type="text/css">
  div.title {
    border: 0px solid gray; 
    position: fixed;
     top: 0;
    left: 0;
    width: 100%;
    z-index: 1000;
    background-color: white;
  }
  
  div.banner {
    border: 1px solid yellow;
    margin-top: 100px;
    display: none;
  }
  
  div.main {
    border: 3px solid red;
  }
  
  div.info {
    border: 1px solid blue;
    background-color: #F2F2F2;
    
  }
  	@font-face {
    font-family: 'Orbit-Regular';
    src: url('https://cdn.jsdelivr.net/gh/projectnoonnu/noonfonts_2310@1.0/Orbit-Regular.woff2') format('woff2');
    font-weight: normal;
    font-style: normal;
}
</style>
</head>
<%
   //1. 기본페이지 main 페이지 지정
   String main = "layout/main.jsp"; //기본페이지
   
   //2. url을 통해서 main값을 읽어서 메인페이지에 출력
   if(request.getParameter("main") != null) {
	   main = request.getParameter("main");
   }else{
	   %>
	   <script type="text/javascript">
	   	$(function(){
	   		$("div.banner").show();
	   	});
	   </script>
	   <%
   }
%>
<body>

  <div class="layout title"><jsp:include page="layout/title.jsp"/></div>
  <div class="layout banner"><jsp:include page="layout/banner.jsp"/></div>
  <div class="layout main"><jsp:include page="<%=main %>"/></div>
  <div class="layout info"><jsp:include page="layout/info.jsp"/></div>
  
  

</body>
</html>