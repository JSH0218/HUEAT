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
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <script src="https://code.jquery.com/jquery-3.7.0.js"></script>

<title>Insert title here</title>
<style type="text/css">
  body {
    font-family: '';
  }
  
  /* 사이트도우미 */
  .main_1 {
    border: 0px solid yellow;
    max-width: 1200px;
    margin: 0 auto;
    padding: 20px;
    margin-top: 2%;
    margin-left: 20%;
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
    

    /*공지사항 */
    .noticeDetail {
    text-decoration: none;
    color: black;

    }
    
     img.n_image{
     width: 150px;
     height: 200px;
     border: 1px solid gray;

   }
   
   .n_subject {
    width: 150px;
    flex: 1;
    margin-top: 5%;
    word-wrap: break-word; /* 글자가 요소의 경계를 넘어갈 때 자동으로 줄바꿈 */
    overflow-wrap: break-word;
    }
   
   .n_writeday {
 
   font-size: 0.8em;
   }
   
   .n_notice {
     flex: 1;
     margin-right: 10px;
     position: relative;
   }
   
   
     /*이벤트 */
    .eventDetail {
    text-decoration: none;
    color: black;
    
    }
    
     img.e_image{
     width: 150px;
     height: 200px;
     border: 1px solid gray;
   }
   
   .e_subject {
    width: 150px;
    flex: 1;
    margin-top: 5%;
    word-wrap: break-word; /* 글자가 요소의 경계를 넘어갈 때 자동으로 줄바꿈 */
    overflow-wrap: break-word;
    }
   
   .e_writeday {
  
   font-size: 0.8em;
   }
   
   .e_event {
     flex: 1;
     margin-right: 10px;
     position: relative;
   }
   
   
   /*이달의 휴게소*/
   .h_title {
    margin-left: 10.5%;
    font-size: 20px;
    font-weight: bold;
    }
   
   .hugesoDetail {
    text-decoration: none;
    color: black;
    
    }


    
    .swiper-slide img {
    width: 200px;
    height: 120px;
    object-fit: cover;
    margin: 10px;
    }
    
   .swiper-container {
    position: relative;
    height: 100%;
    width: 680px;
    overflow: hidden;
    margin-right: auto;
    }


      @media (max-width: 760px) {
        .swiper-button-next {
          right: 20px;
          transform: rotate(90deg);
        }

        .swiper-button-prev {
          left: 20px;
          transform: rotate(90deg);
        }
      }

  /*다양한 즐길거리*/
   .food {
    margin-top: 20%;
    border: 1px solid blue;
    width: 1350px; /* 원하는 너비로 설정합니다. */
    margin-left: 100px; /* 원하는 여백으로 설정합니다. */
    border: 1px solid blue;
    display: flex;
    justify-content: center;
    align-items: center;
    flex-direction: column;
   }
   
   .food_title {
   text-align: center;
   }
   
   .food_images {
   display: flex;
   margin-top: 15%;
   margin: 10 30px;
   }
   
   .food_images img {
    width: 100px;
    height: 300px;
    cursor: pointer;
   }
   div.swiper-backface-hidden{
   	margin-right: 0px;
   }
   

   
</style>

<script type="text/javascript">
  
   
    $(function () {
       
       //클릭시 공지사항 디테일 페이지로 이동
       $("a.noticeDetail").click(function () {
         var n_num = $(this).attr("n_num");
         //alert(n_num);
         
         location.href = 'index.jsp?main=noticeboard/noticeDetail.jsp?n_num='+n_num;
      });
       
      
      //클릭시 이벤트 디테일 페이지로 이동
      $("a.eventDetail").click(function () {
         var e_num = $(this).attr("e_num");
         //alert(e_num);
         
         location.href = 'index.jsp?main=eventboard/eventDetail.jsp?e_num='+e_num;
      });
      
      //클릭시 휴게소 디테일 페이지로 이동
      $("a.hugesoDetail").click(function () {
         var h_num = $(this).attr("h_num");
         //alert(h_num);
         
         location.href = 'index.jsp?main=hugesoinfo/hugesodetail.jsp?h_num='+h_num;
      });
      

    });
    
    
      
     
</script>
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
   
   
   SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
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
  
  
  <!-- 공지사항 레이아웃-->
  <div class="container mt-3"  style="width: 650px; margin-left: 10%; padding-top: 4%;">
 
    <!-- Nav tabs -->
    <ul class="nav nav-tabs" role="tablist">
      <li class="nav-item">
        <a class="nav-link active" data-bs-toggle="tab" href="#tabs-notice">공지사항</a>
      </li>
    
      <li class="nav-item">
        <a class="nav-link" data-bs-toggle="tab" href="#tabs-event">이벤트</a>
      </li>    
    </ul>
    
    
      <!-- 공지사항 list불러오기 -->
    <div class="tab-content">
      <div id="tabs-notice" class="container tab-pane active"><br>
        <table class="noticetable table">
          <tr>
            <% 
              int i = 0;
               
              List<NoticeDto> recentNotices = ndao.getAllNotice().subList(0, Math.min(list.size(), 3));
            
              for(NoticeDto dto:recentNotices) {%>
               
                <td>
                  <a n_num="<%=dto.getN_num() %>" style="cursor: pointer;" class="noticeDetail">
                    <img alt="" src="noticesave/<%=dto.getN_image() %>" class="n_image">
                    <div class="n_notice">
                      <div class="n_subject"><%=dto.getN_subject() %></div>
                      <div class="n_writeday">
                        <%=sdf.format(dto.getN_writeday()) %>
                      </div> 
                    </div>   
                  </a>
                </td>      
              <%}
              
            %>
            
          </tr>
        </table>
      </div> 
      
      
         <!-- 이벤트 list불러오기 -->
   
      <div id="tabs-event" class="container tab-pane fade"><br>
        <table class="eventtable table">
          <tr>
            <% 
              int e = 0;
               
              List<EventDto> recentEvent = edao.getAllEvent().subList(0, Math.min(elist.size(), 3));
            
              for(EventDto dto:recentEvent) {%>
               
                <td>
                  <a e_num="<%=dto.getE_num() %>" style="cursor: pointer;" class="eventDetail">
                    <img alt="" src="eventsave/<%=dto.getE_image() %>" class="e_image">
                    <div class="e_event">
                      <div class="e_subject"><%=dto.getE_subject() %></div>
                      <div class="e_writeday">
                        <%=sdf.format(dto.getE_writeday()) %>
                      </div> 
                    </div>   
                  </a>
                </td>      
              <%}%>
          </tr>
        </table>
      </div> 
    </div>
  </div>  

  <div style="margin-top: 100px;"></div>

<!-- 이달의 휴게소 -->
<div class="h_title">이달의 휴게소</div>
<div style="margin-left: 200px;">
<div class="swiper-container" style="border: 1px solid cyan;">
    <div class="swiper-wrapper" style="border: 1px solid pink;">
        <% 
            List<HugesoInfoDto> recenthugeso = hdao.getAllGrade();
            int size = Math.min(recenthugeso.size(), 5);
            for (int h = 0; h < size; h++) { 
                HugesoInfoDto dto = recenthugeso.get(h); 
        %>
        <div class="swiper-slide" style="border: 1px solid red;" >
            <div class="hugeso-content" style="text-align: center; border: 1px solid green; width: 250px;">
                <a h_num="<%=dto.getH_num() %>" class="hugesoDetail"  style="cursor: pointer;
                display: inline-block;">
                    <img alt="" src="image/hugeso/<%=dto.getH_photo() %>" class="h_image">
                    <div class="h_hugeso">
                        <div class="h_name" style="font-size: 0.85em;"><%=dto.getH_name() %></div>
                        <div class="h_addr" style="font-size: 0.6em;"><%=dto.getH_addr() %></div>
                    </div>
                </a>
            </div>
        </div>
        <% } %>
    </div>
    <!-- Add Navigation -->
    <div class="swiper-button-next"></div>
    <div class="swiper-button-prev"></div>
</div>
</div>
<!-- Swiper JS -->
<script src="https://unpkg.com/swiper/swiper-bundle.min.js"></script>

<!-- Initialize Swiper -->
<script>
    var swiper = new Swiper('.swiper-container', {
        slidesPerView: 3, // 한 번에 보여질 슬라이드 개수
        spaceBetween: 30, // 슬라이드 간의 간격
        navigation: {
            nextEl: '.swiper-button-next',
            prevEl: '.swiper-button-prev',
        },
    });
</script>

 </body>
</html>