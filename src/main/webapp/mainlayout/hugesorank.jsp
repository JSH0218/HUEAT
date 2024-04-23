<%@page import="hugesoinfo.model.HugesoInfoDto"%>
<%@page import="java.util.List"%>
<%@page import="hugesoinfo.model.HugesoInfoDao"%>
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
   /*이달의 휴게소*/
   .h_title {
    margin-left: 23.5%;
    font-size: 20px;
    font-weight: bold;
    margin-bottom: 1%;
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


    .swiper-button-next {
    
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
      
       div.swiper-backface-hidden{
      margin-right: 0px;
   }
   
  .swiper-button-next.hugeso::after,
	.swiper-button-prev.hugeso::after {
    color: #618E6E;
    font-size: 25pt;
    font-weight: bold;
    }
   
</style>
<script type="text/javascript">
  
   
    $(function () {
       
    
      
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

   //휴게소
   HugesoInfoDao hdao = new HugesoInfoDao();
   List<HugesoInfoDto> hlist = hdao.getAllGrade();


%>
<body>
  <!-- 이달의 휴게소 -->
<div class="h_title">이달의 휴게소</div>
<div style="margin-left: 200px;">
<div class="swiper-container hugeso">
    <div class="swiper-wrapper">
        <% 
            List<HugesoInfoDto> recenthugeso = hdao.getAllGrade();
            int size = Math.min(recenthugeso.size(), 5);
            for (int h = 0; h < size; h++) { 
                HugesoInfoDto dto = recenthugeso.get(h); 
        %>
        <div class="swiper-slide">
            <div class="hugeso-content" style="text-align: center; width: 250px;">
                <a h_num="<%=dto.getH_num() %>" class="hugesoDetail"  style="cursor: pointer;
                display: inline-block;">
                    <img alt="" src="hugesosave/<%=dto.getH_photo() %>" class="h_image">
                    <div class="h_hugeso">
                        <div class="h_name" style="font-size: 0.85em;"><%=dto.getH_name() %></div>
                        <div class="h_addr" style="font-size: 0.7em;"><%=dto.getH_addr() %></div>
                    </div>
                </a>
            </div>
        </div>
        <% } %>
    </div>
    <!-- Add Navigation -->
</div>
<div>
    <div class="swiper-button-next hugeso" style="position:absolute; top: 1365px; right: 970px"></div>
    <div class="swiper-button-prev hugeso" style="position:absolute; top: 1365px; left : 149px"></div>
</div>

</div>
<!-- Swiper JS -->
<script src="https://unpkg.com/swiper/swiper-bundle.min.js"></script>

<!-- Initialize Swiper -->
<script>
    var hugeso_swiper = new Swiper('.hugeso', {
        slidesPerView: 3, // 한 번에 보여질 슬라이드 개수
        loop : true,
        spaceBetween: 30, // 슬라이드 간의 간격
        navigation: {
            nextEl: '.swiper-button-next.hugeso',
            prevEl: '.swiper-button-prev.hugeso',
        },
    });
</script>
</body>
</html>