<%@page import="java.text.NumberFormat"%>
<%@page import="food.model.FoodDto"%>
<%@page import="food.model.FoodDao"%>
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
   
   .f_title {
    margin-left: 23.5%;
    font-size: 20px;
    font-weight: bold;
    margin-bottom: 1%;
    }
   
   .foodDetail {
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
      
	.swiper-button-next.menu::after,
	.swiper-button-prev.menu::after {
    color: #618E6E;
    font-size: 25pt;
    font-weight: bold;
    }
</style>
<script type="text/javascript">
  
   
    $(function () {
       
    
      
      //클릭시 휴게소 디테일 페이지로 이동
      $("a.foodDetail").click(function () {
         var f_num = $(this).attr("f_num");
         //alert(f_num);
         
         location.href = 'index.jsp?main=hugesoinfo/hugesodetail.jsp?f_num='+f_num;
      });
      

    });

      
     
</script>
</head>
<%
   //프로젝트 경로
   String root = request.getContextPath();  

   //휴게소
   FoodDao fdao = new FoodDao();
   List<FoodDto> hlist = fdao.getAllFood();

	NumberFormat nf=NumberFormat.getInstance();
%>
<body>
  <!-- 이달의 휴게소 -->
<div class="f_title">이달의 메뉴</div>
<div style="margin-left: 200px; ">
<div class="swiper-container menu">
    <div class="swiper-wrapper">
        <% 
            List<FoodDto> recentfood = fdao.getAllFood();
            int size = Math.min(recentfood.size(), 5);
            for (int f = 0; f < size; f++) { 
            	FoodDto dto = recentfood.get(f); 
            	int price=Integer.parseInt(dto.getF_price());
        %>
        <div class="swiper-slide">
            <div class="hugeso-content" style="text-align: center; width: 250px;">
                <a f_num="<%=dto.getF_num() %>" class="foodDetail"  style="cursor: pointer;
                display: inline-block;">
                    <img alt="" src="hugesosave/<%=dto.getF_photo() %>" class="f_image">
                    <div class="f_food">
                        <div class="f_name" style="font-size: 0.85em;"><%=dto.getF_name() %></div>
                        <div class="f_addr" style="font-size: 0.7em;"><%=nf.format(price) %>원</div>
                    </div>
                </a>
            </div>
        </div>
        <% } %>
    </div>
    <!-- Add Navigation -->
</div>
<div>
    <div class="swiper-button-next menu" style="position:absolute; top: 1365px; right: 142px"></div>
    <div class="swiper-button-prev menu" style="position:absolute; top: 1365px; left : 973px"></div>
</div>

</div>
<!-- Swiper JS -->
<script src="https://unpkg.com/swiper/swiper-bundle.min.js"></script>

<!-- Initialize Swiper -->
<script>
    var menu_swiper = new Swiper('.menu', {
        slidesPerView: 3, // 한 번에 보여질 슬라이드 개수
        loop : true,
        spaceBetween: 30, // 슬라이드 간의 간격
        navigation: {
            nextEl: '.swiper-button-next.menu',
            prevEl: '.swiper-button-prev.menu',
        },
    });
</script>
</body>
</html>