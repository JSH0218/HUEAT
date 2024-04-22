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
<style type="text/css">

 #footer {
   position: relative;
 }
 
 /*상부*/
 .top {
 background: #474747;
 }
 
 .inner {
 width: 100%;
 height: 40px;
 margin: 0 auto;
 
 }
 
 .info_site {
 cursor: pointer;
 color: #bfbfbf;
 text-decoration: none;
 }
 
 .inner > ul {
 list-style: none;
 float: left;
 padding-left: 11rem;
 }
 
  .inner > ul li{
 float: left;
 padding-left: 40px;
 }
 
  .inner > ul li a{
  font-size: 13px;
  font-weight: 500;
  line-height: 40px;
  color: #bfbfbf;
 }
 
 /*하부*/
 .bottom {
 background: #595959;
 }
 
 .b_inner {
 width: 100%;
 height: 160px;
 padding-top: 25px;
 margin: 0 auto;
 }
 
 .b_left {
 float: left;
 margin-left: 11%;
 width: 1000px;
 }
 
 .logo {
 max-width: 100%;
 border: 0;
 vertical-align: top;
 user-select: none;
 height: 60px;
 }
 
 .b_font {

 font-size: 13px;
 font-weight: 500;
 color: #a8a8a8;
 margin-bottom: 0%;
 }
 
 .b1_font {
 font-size: 12px;
 color: #a8a8a8;
 }
 
  .b_right {
 float: right;
 margin-right: 11%;
 }
 
 .b2_font {

 font-size: 20px;
 font-weight: 500;
 color: #a8a8a8;
 margin-bottom: 0%;
 text-align: right;
 }
 
 .b3_font {
 font-size: 12px;
 color: #a8a8a8;
 text-align: right;
 }
 
 .s_img {
 height: 35px;
 list-style: none;
 }
 
 
</style>
</head>
  <%
   //프로젝트 경로
   String root = request.getContextPath();  
  %>
<body>
  <div id="footer">
    <div class="top">
      <div class="inner">
        <ul class="info_site">
          <li><a href="index.jsp?main=intro/intro.jsp">회사소개</a></li>
          <li><a onclick="window.open('https://www.ex.co.kr/site/com/pageProcess.do;jsessionid=haJ9zrsokV1l4DbNvDcbE5SSCUzDqM3txQv1Fs7M5rLxXLvoz3K6T9eebQ92HCFr.aexhomewas2_servlet_exhome2')">
          개인정보처리방침</a></li>
          <li><a href="index.jsp?main=foodcourt/choicehuegeso.jsp">단체주문</a></li>
          <li><a onclick="window.open('https://www.ex.co.kr/', '_blank')">한국도로공사공식사이트</a></li>
        </ul>
      </div>
    </div>
    
    
    <div class="bottom">
      <div class="b_inner">
        <div class="b_left">
          <h1 style="font-size: 3.6rem;">
          <a href=""><img src="<%=root%>/image/mainbanner/logo-02.png" class="logo"></a></h1>
          <p class="b_font">
          우)39660 경상북도 김천시 혁신8로 77(율곡동,한국휴잇)</p>
          <p class="b1_font">
          COPYRIGHT ⓒ 2024 Korea Expressway Corporation. All Rights reserved.</p>
        </div>
        
        <div class="b_right">
          <div>
            <p class="b2_font">1588-0000</p>
            <p class="b3_font" >콜센터 _ AM 09:00~PM 18:00</p>
          </div>
          
          <div>
            <ul>
              <a onclick="window.open('https://www.youtube.com/user/koreaexpressway', '_blank')">
              <img alt="" src="<%=root%>/image/info/sns2.png" class="s_img"></a>
              <a onclick="window.open('https://www.instagram.com/koreaexpressway/', '_blank')">
              <img alt="" src="<%=root%>/image/info/sns4.png" class="s_img"></a>
              <a onclick="window.open('https://www.facebook.com/koreaexpressway', '_blank')">
              <img alt="" src="<%=root%>/image/info/sns6.png" class="s_img"></a>
              <a onclick="window.open('https://blog.naver.com/exhappyway', '_blank')">
              <img alt="" src="<%=root%>/image/info/sns3.png" class="s_img"></a>
            </ul>
          </div>  
        </div>
      </div>
    </div>
  </div>
   
</body>
</html>