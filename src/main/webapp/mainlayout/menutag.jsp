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
  /* 사이트도우미 */
  .main_1 {
    border: 0px solid yellow;
    max-width: 1200px;
    margin: 2% auto;
    padding: 20px;
    margin-top: 2%;
  }
  
  .font_title {
    font-size: 24px;
    font-weight: bold;
    margin-left: 3%;
  }
  
  .font_subtitle {
    font-size: 12px;
    color: #666;
    margin-left: 3%;
  }
  
  /* 픽토그램 섹션 스타일 */
  .icon_section {
    display: flex;
    justify-content: space-between;
    margin-top: 2%;
    margin-left: 38px;
   }
   
   .icon {
    text-align: center;
     padding-right: 10px;
     cursor: pointer;
   }
   
   .icon img {
    width: 70px; 
    height: 70px;
    margin-bottom: 10px;
    }
    
    .icon-font {
    font-size: 12px;
    color: #333;
    }

</style>
</head>
  <%

  //프로젝트 경로
  String root = request.getContextPath();  
  %>
<body>

  <!-- 정보제공 레이아웃 -->
  <div class="main_1 container">
    <section class="font_section">
      <div class="font_title">정보 도우미</div>
      <div class="font_subtitle">정보를 제공해드립니다</div>
    </section>
    
    
    <!-- 픽토그램 레이아웃 -->
    <section class="icon_section">
      <div class="icon" onclick="window.open('http://www.roadplus.co.kr/main/main.do', '_blank')">
        <img alt="" src="<%=root%>/image/main/pic_01.png">
        <div class="icon-font">교통정보</div>
      </div>
      
       <div class="icon" onclick="window.open('http://www.roadplus.co.kr/forecast/predict/selectPredictView.do', '_blank')">
        <img alt="" src="<%=root%>/image/main/pic-02.png">
        <div class="icon-font">교통예보</div>
      </div>
      
      <div class="icon" onclick="window.open('http://www.roadplus.co.kr/broadcast/viewtraffic/selectExtvList.do', '_blank')">
        <img alt="" src="<%=root%>/image/main/pic-03.png">
        <div class="icon-font">교통방송</div>
      </div>
      
      <div class="icon" onclick="window.open('https://www.ex.co.kr/site/com/pageProcess.do;jsessionid=gopBubVLtleCeOQfr6eZa3BhmTLdge6VybqFFi89IbzOfSkoztbCetH9xt5AuU6F.aexhomewas1_servlet_exhome', '_blank')">
        <img alt="" src="<%=root%>/image/main/pic-04.png">
        <div class="icon-font">교통안전</div>
      </div>
      
      <div class="icon" onclick="window.open('https://www.ex.co.kr/site/com/pageProcess.do', '_blank')">
        <img alt="" src="<%=root%>/image/main/pic-05.png">
        <div class="icon-font">전문시방서</div>
      </div>
      
      <div class="icon" onclick="#">
        <img alt="" src="<%=root%>/image/main/pic-05.png">
        <div class="icon-font">휴게소찾기</div>
      </div>
      
      <div class="icon" onclick="#">
        <img alt="" src="<%=root%>/image/main/pic-05.png">
        <div class="icon-font">푸드결제</div>
      </div>
      
      <div class="icon" onclick="#">
        <img alt="" src="<%=root%>/image/main/pic-05.png">
        <div class="icon-font">회원문의</div>
      </div>

    </section>
  </div>
</body>
</html>