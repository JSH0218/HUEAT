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
  .img {
    position: relative;
    bottom: 0;
    left: 0;
    width: 100%;
   
}

  #subject {
    position: relative;
    bottom: 0;
    width: 100%;
    padding-top: 4.5%;
    font-size: 12px;
    color: #618E6E;
    }
    
  
  #addr {
    position: relative;
    bottom: 0;
    left: 0;
    width: 100%;
    font-size: 0.6em;
    padding-top: 4.6%;
    left: -16.5%;
    color: gray
    } 
    
   #call {
    position: relative;
    bottom: 0;
    width: 100%;
    left: 11%;
    padding-top: 2.6%;
    line-height: 0%;
    text-align: right;
   }  
    
   #snsimg{
    /* position: relative; */
    width: 100%;
    left: 4.5%;
    padding-top: 4.6%;
   } 
</style>
</head>
  <%
   //프로젝트 경로
   String root = request.getContextPath();  
  %>
<body>
   <div class="d-inline-flex img;" style="width: 100%">
     <img src="<%=root%>/image/mainbanner/logo1.png" style=" width: 85px; margin-left: 10%; margin-top: 50px; margin-bottom: 30px;">
     
     <div id="subject">
       <span><h4><b>HUEAT</b></h4></span>
     </div>
      
     <div id="addr"> 
       <span>우)39660 경상북도 김천시 혁신8로 77(율곡동,한국휴잇)</span><br>
       <span>COPYRIGHT ⓒ 2024 Korea Expressway Corporation. All Rights reserved.</span>  
     </div>
    
    
    <div id="call">
      <span style="color: #618E6E;"><h6><b>1588-0000</b></h6></span><br>
      <span style="font-size: 0.6em; color: gray;">콜센터 _ AM 09:00~PM 18:00</span>
    </div>
    
    
    
    <div id="snsimg">
      <a href="#" style="margin-left: 22%;"><img alt="" src="<%=root%>/image/info/sns2.png" style="width: 20px;"></a>
      <a href="#"><img alt="" src="<%=root%>/image/info/sns4.png" style="width: 20px;"></a>
      <a href="#"><img alt="" src="<%=root%>/image/info/sns6.png" style="width: 20px;"></a>
      <a href="#"><img alt="" src="<%=root%>/image/info/sns3.png" style="width: 20px;"></a>
      <a href="#"><img alt="" src="<%=root%>/image/info/sns5.png" style="width: 20px;"></a>
      
    </div>
    
 
   </div>

</body>
</html>