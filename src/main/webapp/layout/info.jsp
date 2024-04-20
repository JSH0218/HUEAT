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


  .gain {
  border: 0px solid cyan;
   display: flex; 
   width: 100%;
   justify-content: center;
  }
  
  .gain_title {
   margin-right: 75px;
   font-size: 0.8em;
   margin-top: 0.3%;
  }

  .info_addr {
   margin-left: 390px;
    margin-top: -1.5%;
    font-size: 0.6em;
    } 
    
   .info_call {
    line-height: 0%;
    text-align: right;
    margin-top: -4.3%;
    margin-right: 14%;
   }  
    
   .info_snsimg{
    /* position: relative; */
    cursor:pointer;
    width: 100%;
    margin: 1%;
    margin-left: 54%;
   } 
</style>
</head>
  <%
   //프로젝트 경로
   String root = request.getContextPath();  
  %>
<body>
   <div class="infolist" style="width: 100%">
      <div class="gain">
        <div class="gain_title">
        <a onclick="window.open('https://www.youtube.com/user/koreaexpressway', '_blank')">
        회사소개</a></div>
        <div class="gain_title">
        <a onclick="window.open('https://www.youtube.com/user/koreaexpressway', '_blank')">
        개인정보처리방침</a></div>
        <div class="gain_title">
        <a onclick="window.open('https://www.youtube.com/user/koreaexpressway', '_blank')">
        단체주문</a></div>
        <div class="gain_title">
        <a onclick="window.open('https://www.dpecoland.com/about.do', '_blank')">
        한국도로공사사이트</a></div>
      </div>
      <hr style="margin-top:0.5%;">

      <div class="info_img">  
       <img src="<%=root%>/image/mainbanner/logo1.png" style=" width: 100px; margin-left: 15%; margin-top: 15px;">
      </div> 
      
     <div class="info_addr"> 
       <div>우)39660 경상북도 김천시 혁신8로 77(율곡동,한국휴잇)</div>
       <div>COPYRIGHT ⓒ 2024 Korea Expressway Corporation. All Rights reserved.</div>  
     </div>
    
    
    <div class="info_call">
      <div style="color: #618E6E;"><h6><b>1588-0000</b></h6></div><br>
      <div style="font-size: 0.6em;">콜센터 _ AM 09:00~PM 18:00</div>
    </div>
    
    
    
    <div class="info_snsimg">
      <a onclick="window.open('https://www.youtube.com/user/koreaexpressway', '_blank')"
       style="margin-left: 22%;"><img alt="" src="<%=root%>/image/info/sns2.png" style="width: 35px;"></a>
      <a onclick="window.open('https://www.instagram.com/koreaexpressway/', '_blank')">
      <img alt="" src="<%=root%>/image/info/sns4.png" style="width: 35px;"></a>
      <a onclick="window.open('https://www.facebook.com/koreaexpressway', '_blank')">
      <img alt="" src="<%=root%>/image/info/sns6.png" style="width: 35px;"></a>
      <a onclick="window.open('https://blog.naver.com/exhappyway', '_blank')">
      <img alt="" src="<%=root%>/image/info/sns3.png" style="width: 35px;"></a>
      <a onclick="window.open('https://www.instagram.com/koreaexpressway/', '_blank')">
      <img alt="" src="<%=root%>/image/info/sns5.png" style="width: 35px;"></a>
      
    </div>
    
 
   </div>

</body>
</html>