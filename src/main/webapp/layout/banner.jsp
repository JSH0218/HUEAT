<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Grandiflora+One&family=Gugi&family=Hahmlet:wght@100..900&family=Hi+Melody&family=Sunflower:wght@300&display=swap" rel="stylesheet">
<script src="https://code.jquery.com/jquery-3.7.0.js"></script>
<script src="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.js"></script>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css" />
<title>Insert title here</title>
</head>

<style>
    html,body {
      position: relative;
      height: 100%;
    }

    body {
      background: #eee;
      font-size: 14px;
      color: #000;
      margin: 0;
      padding: 0;
    }

    .swiper {
      width: 100%;
      height: 100%;
    }

    .swiper-slide {
      text-align: center;
      font-size: 18px;
      background: #fff;
      display: flex;
      justify-content: center;
      align-items: center;
      cursor: pointer;
    }
    
   .swiper-slide img {
    margin: 0px !important;
}


    
    .autoplay-progress {
      position: absolute;
      right: 16px;
      bottom: 16px;
      z-index: 10;
      width: 48px;
      height: 48px;
      display: flex;
      align-items: center;
      justify-content: center;
      font-weight: bold;
      color: var(--swiper-theme-color);
    }

    .autoplay-progress svg {
      --progress: 0;
      position: absolute;
      left: 0;
      top: 0px;
      z-index: 10;
      width: 100%;
      height: 100%;
      stroke-width: 4px;
      stroke: var(--swiper-theme-color);
      fill: none;
      stroke-dashoffset: calc(125.6px * (1 - var(--progress)));
      stroke-dasharray: 125.6;
      transform: rotate(-90deg);
    }
    
      .swiper-button-next, .swiper-button-prev{
       /*color: white;*/
       border-radius: 30px;
       width: 60px;
       height: 60px;
       /*background-color: rgba(33, 33, 33, 0.5);*/
       
    }
  </style>
</head>
<%
    //1.íë¡ì í¸ ì ë ê²½ë¡ ì¤ì 
    String root = request.getContextPath();
    
%>

<body style="overflow-x: hidden;">
  <!-- Swiper -->
  <div class="swiper mySwiper">
    <div class="swiper-wrapper">
      <div class="swiper-slide"><img style="width: 100%; height: 450px; display: block;" src="<%=root%>/image/mainbanner/main_대지 1.jpg"
      onclick="location.href='index.jsp?main=foodcourt/choicehuegeso.jsp'"></div>
      <div class="swiper-slide"><img style="width: 100%; height: 450px; display: block;" src="<%=root%>/image/mainbanner/main-02.jpg"
      onclick="location.href='index.jsp?main=member/gaipform.jsp'"></div>
      <div class="swiper-slide"><img style="width: 100%; height: 450px; display: block;" src="<%=root%>/image/mainbanner/main-03.jpg"
      onclick="location.href='index.jsp?main=hugesoinfo/hugesodetail.jsp?h_num=1"></div>
      <div class="swiper-slide"><img style="width: 100%; height: 450px; display: block;" src="<%=root%>/image/mainbanner/main-04.jpg"
      onclick="location.href='index.jsp?main=hugesoinfo/hugesodetail.jsp?h_num=127'"></div>
      <div class="swiper-slide"><img style="width: 100%; height: 450px; display: block;" src="<%=root%>/image/mainbanner/main-05.jpg"
      onclick="location.href='index.jsp?main=hugesoinfo/hugesodetail.jsp?h_num=86'"></div>
      <div class="swiper-slide"><img style="width: 100%; height: 450px; display: block;" src="<%=root%>/image/mainbanner/main-06.jpg"
      onclick="location.href='index.jsp?main=hugesoinfo/hugesodetail.jsp?h_num=106'"></div>
  

    </div> 
    <div class="swiper-button-next"></div>
    <div class="swiper-button-prev"></div>
    <div class="swiper-pagination"></div>
    <div class="autoplay-progress">
      <svg viewBox="0 0 48 48">
        <circle cx="24" cy="24" r="20"></circle>
      </svg>
      <span></span>
    </div>
  </div>
    <!-- Initialize Swiper -->
  <script>
    const progressCircle = document.querySelector(".autoplay-progress svg");
    const progressContent = document.querySelector(".autoplay-progress span");
    var swiper = new Swiper(".mySwiper", {
      loop: true,
      spaceBetween: 30,
      centeredSlides: true,
      autoplay: {
        delay: 2500,
        disableOnInteraction: false
      },
      pagination: {
        el: ".swiper-pagination",
        clickable: true
      },
      navigation: {
        nextEl: ".swiper-button-next",
        prevEl: ".swiper-button-prev"
      },
      on: {
        autoplayTimeLeft(s, time, progress) {
          progressCircle.style.setProperty("--progress", 1 - progress);
          
        }
      }
    });
  </script>
</body>
</html>