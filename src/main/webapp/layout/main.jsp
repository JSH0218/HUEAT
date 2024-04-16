<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
    <link href="https://fonts.googleapis.com/css2?family=Nanum+Gothic&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <script src="https://code.jquery.com/jquery-3.7.0.js"></script>
<title>Insert title here</title>
<style type="text/css">
  body {
    font-family: '';
  }
  
  /* 정보도우미 */
  .main_1 {
    border: 0px solid yellow;
    max-width: 1200px;
    margin: 0 auto;
    padding: 20px;
    margin-top: 2%;
    margin-left: 
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
    align-items: center;
    margin-top: -5%;
    margin-left: 24%;
    padding-right: 20%;
   }
   
   .icon {
    text-align: center;
     padding-right: 10px;
     cursor: pointer;
   }
   
   .icon img {
    width: 50px; 
    height: 50px;
    margin-bottom: 10px;
    }
    
    .icon-font {
    font-size: 12px;
    color: #333;
    }
    
    
    /* 공지사항 및 이벤트 */
    .main2 {
    display: flex;
    max-width: 1200px;
    align-items: center;
    padding: 20px;
    margin-top: 3%;
    height: 100%;
   
    
    
    }
    
    .notice-section, .service-section {
    flex: 1;
    /* text-align: center; */
    }
    
    
    .notice-section {
    text-align: left;
/*  margin-right: auto
    padding: 10px; */
    }
    
    .notice-title {
    font-size: 24px;
    font-weight: bold;
    padding: 10px;
    margin-left: 5%;
    margin-top: -20%;
    }
    
    .notice-list {
    margin-left: 6%;
    }
    
    
    /*자주찾는 서비스*/
    .service-title {
    font-size: 24px;
    font-weight: bold;
    padding: 10px;
    margin-left: 7%;
    }
    
    .service-section {
    display: flex;
    flex-direction: column;
    align-items: stretch;
    padding-right: -5%;
   }
   
   .service-icons {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    margin-top: 10px;
    padding-right: 23%;
    margin-left: 4%;
   }
   
   .service-icon {
    text-align: center;
    cursor: pointer;
   }
   
   .service-icon img {
    width: 80px; 
    height: 80px;
    margin-bottom: 40%;
    }
    
    .service-font {
    font-size: 13px;
    margin-top: -38%;
    
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
      <div class="font_title">여행도우미</div>
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

    </section>
  </div>
  
  
  <!-- 공지사항 레이아웃-->
  <div class="main2 container">
    <div class="notice-section" style="margin-left: 10%;">
      <div class="notice-title">공지사항</div>
        <ul class="notice-list">
          <li>공지사항1</li>
          <li>공지사항2</li>
          <li>공지사항3</li>
          <li>공지사항4</li>
        </ul>
    </div>
    
    <!-- 자주찾는 서비스 레이아웃 -->
    <div class="service-section">
      <div class="service-title">자주찾는 서비스</div>
      <div class="service-icons">
        <div class="service-icon">
          <img src="<%=root%>/image/main/pic_01.png" alt="">
          <div class="service-font">이벤트</div>
        </div>
        
        <div class="service-icon">
          <img src="<%=root%>/image/main/pic_01.png" alt="">
          <div class="service-font">휴게소찾기</div>
        </div>
        
        <div class="service-icon">
          <img src="<%=root%>/image/main/pic_01.png" alt="">
          <div class="service-font">휴게소목록</div>
        </div>
      </div>
      
      <div class="service-icons" style="margin-top: 5%;"> 
        <div class="service-icon">
          <img src="<%=root%>/image/main/pic_01.png" alt="">
          <div class="service-font">푸드결제</div>
        </div>
        
        <div class="service-icon">
          <img src="<%=root%>/image/main/pic_01.png" alt="">
          <div class="service-font">회원문의</div>
        </div>
        
        <div class="service-icon">
          <img src="<%=root%>/image/main/pic_01.png" alt="">
          <div class="service-font">회원후기</div>
        </div>
        
    </div>
  </div>
  
  
  <!-- 메뉴 클릭 -->
  
  
    
    
   
</body>
</html>