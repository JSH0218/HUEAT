<%@page import="grade.model.GradeDto"%>
<%@page import="java.util.List"%>
<%@page import="favorite.model.FavoriteDto"%>
<%@page import="meminfo.model.MemInfoDao"%>
<%@page import="meminfo.model.MemInfoDto"%>
<%@page import="hugesoinfo.model.HugesoInfoDto"%>
<%@page import="hugesoinfo.model.HugesoInfoDao"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">

 <link href="https: //fonts.googleapis.com/css2?family=Nanum+Gothic&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
   <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
   <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<title>HUEAT</title>
<style type="text/css">


#titlearea{
			text-align: center;
			margin-bottom: 20px;
		}
		
		#titlearea hr{
			margin: 0 auto;
			width: 10%;
		}

table.table, table.table th, table.table td{
    text-align: center; /* 가운데 정렬 */
    vertical-align: middle; /* 수직 정렬 */
    border : 2px solid lightgray;
    border-collapse: collapse;
}

table.table td{
width:200px;
}

button.brand{
 background-color: white;
 color: #618E6E;
 font-weight: bold;
 
   /* background-color: #618E6E;  */
	
}


.favorite{
	display: inline-block; 
	float:right;
	vertical-align: top;
	background-color:white;
	border:white;
}

.nav-pills .nav-link.active{
	background-color:#618E6E;
}


/* 평점 css  */
.star-rating {
  display: flex;
  flex-direction: row-reverse;
  font-size: 2.25rem;
  line-height: 2.5rem;
  justify-content: space-around;
  padding: 0 0.2em;
  text-align: center;
  width: 5em;
}
 
.star-rating input {
  display: none;
}
 
.star-rating label {
  -webkit-text-fill-color: transparent; /* Will override color (regardless of order) */
  -webkit-text-stroke-width: 2.3px;
  -webkit-text-stroke-color: #2b2a29;
  cursor: pointer;
}
 
.star-rating :checked ~ label {
  -webkit-text-fill-color: gold;
}
 
.star-rating label:hover,
.star-rating label:hover ~ label {
  -webkit-text-fill-color: #fff58c;
}


.star-ratings {
  color: #aaa9a9; 
  position: relative;
  unicode-bidi: bidi-override;
  width: max-content;
  -webkit-text-fill-color: transparent; /* Will override color (regardless of order) */
  -webkit-text-stroke-width: 1.3px;
  -webkit-text-stroke-color: #2b2a29;
}
 
.star-ratings-fill {
  color: #fff58c;
  padding: 0;
 /*  position: absolute;
  z-index: 1;
  display: flex; */
  top: 0;
  left: 0;
  overflow: hidden;
  -webkit-text-fill-color: gold;
}
 
.star-ratings-base {
  z-index: 0;
  padding: 0;
}

.red{
	color: #FFE400;
}


div.alist{margin-left: 20px;}

span.aday{
	float:right;
	font-size:0.8em;
	color:#bbb;
}
</style>
<%
    //요청 파라미터로부터 휴게소 번호(h_num) 가져옴
	String h_num = request.getParameter("h_num");
    //세션에서 현재 로그인된 member의 아이디를 가져옴
	String m_id = (String)session.getAttribute("myid");
	
	String loginok=(String)session.getAttribute("loginok");
	
	// MemInfoDao 인스턴스 생성
	MemInfoDao mdao = new MemInfoDao();
	// 현재 로그인된 member의 아이디를 통해 해당 member의 m_num 조회
	String m_num = mdao.getM_num(m_id);
	
  // HugesoInfoDao 객체 생성
  HugesoInfoDao dao = new HugesoInfoDao();
	// 휴게소 데이터 가져옴
	HugesoInfoDto dto = dao.getData(h_num);
	
	GradeDto gdto = new GradeDto();
	
	SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd HH:mm");

	String f_num=mdao.f_numData(m_num, h_num);
	int fav=mdao.isFavorite(m_num, h_num);
%>

<script type="text/javascript">
  
$(function(){
	list();
	
	var h_num=$("#h_num").val();
	//alert(h_num);
	
	var login = "<%=loginok%>";
	 if(login=="null"){
		 $("#insertgrade").hide(); // 로그아웃 상태일 때 숨김
	        return;
	    }else {
	        $("#insertgrade").show(); // 로그인 상태일 때 표시
	    } 
	
	$("#btnasend").click(function(){
		
		    /* var m_num = $("#m_num").val().trim(); */
		    var g_grade = $("input[name='g_grade']:checked").val(); // 선택된 별점 값 가져오기
		    
		/*   if(m_num === ''){
		    	alert("회원번호를 입력해주세요");
		    	return;
		    }  */
		    
		    if (!g_grade) { // 선택된 별점이 없을 경우
		        alert("별점을 선택해주세요");
		        return;
		    }

		    $.ajax({
		        type: "GET", // HTTP 요청 메서드 설정 (GET, POST 등)
		        url: "grade/insertgrade.jsp",
		        dataType: "html",
		        data: {"h_num": $("#h_num").val(), /* "m_num":m_num, */ "g_grade": g_grade}, // rating 변수를 사용하여 데이터 전송
		        success: function(){
		            // 기존 입력값 지우기
		           /*  $("#m_num").val(''); */
		            $("input[name='g_grade']").prop('checked',false);
		            
		            //댓글 목록 다시 불러오기
		            list();
		        },
		        error: function(xhr, status, error) {
		            // 오류 발생 시 처리
		            console.error("AJAX Error: " + error);
		        }
		    });
		});


			  
		
		
	    function list()
	    {
	  	  //console.log("list h_num="+$("#h_num").val());
	  	  
	  	  $.ajax({
	  		  
	  		  type:"get",
	  		  url:"grade/gradelist.jsp",
	  		  dataType:"json",
	  		  data:{"h_num":$("#h_num").val()},
	  		  success:function(res){
	  			 
	  			  //댓글갯수출력
	  			  $("b.acount>span").text(res.length);
	  			  
	  			  var s="";
	  			  $.each(res,function(idx,item){
	  				  s+="<div>"+item.m_num+": ";
	  				  
	  				  //별점에 따라 별표시 추가
	  				  var starsHTML = "";
	  				  for(var i=5;i>0;i--){
	  					  if(i<=item.g_grade){
	  						  starsHTML +="<span class='star' style='color:gold;'>★</span>";
	  					  }else{
	  						 starsHTML +="<span class='star-empty'>☆</span>";
	  					  }
	  					  
	  				  }
	  				  s+="<div class='star-rating'>" + starsHTML +"</div>";
	  				 
	  				  s+="<span class='aday'>"+item.writeday+"</span>";
	  				  s+= "</div>";
	  			  });
	  			  $("div.alist").html(s);
	  			  
	  		  },
	  		  error: function(xhr, status, error) {
	  	            console.error("AJAX Error: " + error);
	  	        }
	  		  
	  	  });
	    } 
	
	
	
	
	
	
  $(".brand").click(function() {
      $(this).toggleClass("active-color");
});

	//변수 선언
	var gasolin = parseInt(<%=dto.getH_gasolin()%>); // 휘발유 가격 데이터
	var diesel = parseInt(<%=dto.getH_disel()%>); // 경유 가격 데이터
	var lpg = parseInt(<%=dto.getH_lpg()%>); // LPG 가격 데이터

    // 숫자에 천 단위 콤마 추가하는 함수
    function insertCommas(x) {
        return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
    }

	
	
	
	
	
	
	/* 휴게소 전체 평점 */
	 function ratingToPercent() {
      const score = +this.restaurant.averageScore * 20;
      return score + 1.5;
     }
	

  

var login = "<%=loginok%>";
var data=$("#frm").serialize()
var f_num=$(".f_num").attr("f_num");
var icon = $(".favorite i");


if(login=="null"){
	icon.css("background-color","white");
}
else if(<%=fav%>==1){
	icon.addClass("red");
	}

$(".favorite i").click(function(){

if(login=="null"){
	alert("로그인이 필요한 서비스입니다.");
	return;
}else{
	if(icon.hasClass("red")){
		  $.ajax({
              type:"post",
              url:"hugesoinfo/deletefavorite.jsp",
              dataType:"html",
              data:data,
              success:function(){
                  alert("즐겨찾기 삭제완료");
                  icon.removeClass("red");
                              
              }
          })
	}else{
		  $.ajax({
        type:"post",
        dataType:"html",
        data: data,
        url:"hugesoinfo/insertfavorite.jsp",
        success:function(){
            icon.addClass("red");
            var a=confirm("즐겨찾기에 저장하였습니다\n즐겨찾기로 이동하려면 [확인]을 눌러주세요");
            
            if(a){
                location.href="index.jsp?main=/.jsp";
            }
            
        }
    })
	};
		
}
});

})
</script>
</head>


<div style="margin: 100px 100px;">

<div id="titlearea">
			<h4>휴게소 상세정보</h4>
			<hr>
		</div>

<form id="frm">
<input type="hidden" name="h_num" value="<%=h_num%>" id="h_num">
<input type="hidden" name="m_num" value="<%=m_num%>" id="m_num">
<input type="hidden"  class="f_num"  f_num="<%=f_num %>">

<!-- 휴게소 사진 -->
<div style="float:left; margin-top:50px;">
<img alt="" src="image/hugeso/<%=dto.getH_photo()%>" style="width:600px; height:400px;">
</div>


<div style="padding-bottom: 150px; padding-top: 80px; position: relative; left:4%;">

<!-- 휴게소 이름 출력 -->
<div style="font-size: 45px; font-weight:bold; margin-bottom: 20px; display: inline-block;" class="d-inline-flex">
<%=dto.getH_name()%> 

<!-- 즐겨찾기 버튼 -->
<button type="button" class ="favorite">
<!-- <i class="bi bi-bookmark" style="margin-left: 10px; font-size:200%;"></i> -->
<i class="bi bi-bookmarks-fill" style="margin-left: 30px;"></i>
</button>

</div>

<!-- 휴게소 평점 출력 -->
 <div class="star-ratings">
	<div 
    class="star-ratings-fill space-x-2 text-lg"
    style="{ width: ratingToPercent + '%' }"
	>
		<span>★</span><span>★</span><span>★</span><span>★</span><span>★</span>
	</div>
	<div class="star-ratings-base space-x-2 text-lg">
		<span>★</span><span>★</span><span>★</span><span>★</span><span>★</span>
	</div>
</div> 

<!-- 휴게소 주소, 영업시간, 전화번호, 편의시설 출력 -->
<div style="font-size: 20px; margin-bottom: 20px; ">
<i class="bi bi-geo-alt"></i>&nbsp;
<%=dto.getH_addr() %></div>
<div style="font-size: 20px; margin-bottom: 20px;">
<i class="bi bi-clock"></i>&nbsp;
</div>
<div style="font-size: 20px; margin-bottom: 20px;">
<i class="bi bi-telephone"></i>&nbsp;
<%=dto.getH_hp() %></div>
<div style="font-size: 20px; margin-bottom: 20px;">
<i class="bi bi-info-circle"></i>&nbsp;
편의시설&nbsp;
 <% 
        String pyeons = dto.getH_pyeon(); //dto에 있는 편의시설 문자열을 pyeons에 넣어줌
        String[] pyeonArray = pyeons.split(","); //콤마를 기준으로 편의시설 문자열을 분리하여 배열 pyeonArray에 넣어줌
        for(String pyeon : pyeonArray){
        	 switch(pyeon){
        	 case "수면실":{
        		 %><img src="image/pyeon/수면실.jpg" alt="수면실" width="5%" height="5%"><%
        	 break;
        	 }
        	 case "샤워실":{
        		 %><img src="image/pyeon/샤워실.jpg" alt="샤워실"  width="5%" height="5%"><%
        				 break;
        	 }
        	 case "세탁실":{
        		 %><img src="image/pyeon/세탁실.jpg" alt="세탁실"  width="5%" height="5%"><%
        				 break;
        	 }
        	 case "세차장":{
        		 %><img src="image/pyeon/세차장.jpg" alt="세차장"  width="5%" height="5%"><%
        				 break;
        	 }
        	 case "경정비":{
        		 %><img src="image/pyeon/경정비.jpg" alt="경정비"  width="5%" height="5%"><%
        				 break;
        	 }
        	 case "수유실":{
        		 %><img src="image/pyeon/수유실.jpg" alt="수유실"  width="5%" height="5%"><%
        				 break;
        	 }
        	 case "쉼터":{
        		 %><img src="image/pyeon/쉼터.jpg" alt="쉼터"  width="5%" height="5%"><%
        				 break;
        	 }
        	 case "ATM":{
        		 %><img src="image/pyeon/ATM.jpg" alt="ATM"  width="5%" height="5%"><%
        				 break;
        	 }
        	 case "매점":{
        		 %><img src="image/pyeon/매점.jpg" alt="매점"  width="5%" height="5%"><%
        				 break;
        	 }
        	 case "약국":{
        		 %><img src="image/pyeon/약국.jpg" alt="약국"  width="5%" height="5%"><%
        				 break;
        	 }
        	 default:{ /* 기타 */
        		 %><img src="image/pyeon/기타.jpg" alt="기타"  width="5%" height="5%"><%
        		 break;
        	 }
        	 
        	 }
          /*   out.println(pyeon); */ // 각 편의시설 출력
        }
        %>
        </div>
</div>


<div style="float:left; position: relative; top:-50px;"> 


<div class="container mt-3">

  <!-- Nav pills -->
  <ul class="nav nav-pills" role="tablist">
    <li class="nav-item">
      <a class="nav-link active" data-bs-toggle="pill" href="#home">푸드코트</a>
    </li>
    <li class="nav-item">
      <a class="nav-link" data-bs-toggle="pill" href="#menu1">브랜드</a>
    </li>
  </ul>

  <!-- Tab panes -->
  <div class="tab-content">
    <div id="home" class="container tab-pane active"><br>
   
      
     <!-- 상품 사진 출력  --> 
      <%
String sangphotos = dto.getH_sangphoto();
String[] sangPhotoArray = sangphotos.split(",");
  for(String sangphoto : sangPhotoArray){%>
	<img alt="" src="image/food/<%=sangphoto%>" style="width: 200px; height:200px; margin-right:20px;">
 
 <%}%><br>
 
<!-- 상품이름 출력 -->
<%
String sangnames =  dto.getH_sangname();
String[] sangArray = sangnames.split(",");
for(String sangname : sangArray){%>
	<div style="display: inline-block; text-align: center; margin-right: 20px; width: 200px;"><% out.println(sangname); %></div>
<%}%><br>


 <!-- 상품가격 출력 -->
<%
String prices =  dto.getH_sangprice();
prices = prices.replaceAll("\\{", "").replaceAll("\\}", ""); // {와 }를 제거하여 숫자만 남김
String[] priceArray = prices.split(","); // 쉼표를 기준으로 문자열 분할
for(String price : priceArray){%>
	 <div style="display: inline-block; text-align: center; margin-right: 20px; width: 200px;">
	 <% out.println(price+"원");%></div>
<%}%>  
      
    </div>
    
    
    <div id="menu1" class="container tab-pane fade"><br>

 <!-- 브랜드 출력  -->
<% 
String brands = dto.getH_brand();
String[] brandArray = brands.split(",");
for(String brand : brandArray){%>
 <img alt="<%= brand %>" src="image/brand/<%= brand %>.jpg" style="width: 120px; height: 120px;">
  <% out.println(brand);%>
 <%}%><br>

    </div>
  </div>
</div>
</div>

<div style="position:relative; margin-left:60%; ">
<h5>주유소/충전소</h5>
<table class="table">
<tr>
<th >유종</th>
<th >가격</th>
</tr>
<tr>
<td >휘발유</td>
<td ><%=dto.getH_gasolin()%>원</td>
</tr>
<tr>
<td >경유</td>
<td ><%= dto.getH_disel() %>원</td>
</tr>
<tr>
<td >LPG</td>
<td><%= dto.getH_lpg() %>원</td>
</tr>
</table>
<div style="font-size:14px; font-weight:bold; color: gray;">본 정보는 특정 시점에 수집되어 실제 가격과 다를 수 있습니다.<br>
제공&nbsp;<span style="color:#0897B4;">한국도로공사</span></div>
</div>



 <table class="table table-bordered"> 
     <!-- 평점 -->
     <tr>
       <td>
         <b class="acount">평점<span>0</span></b>
         <div class="aform input-group" id="insertgrade" >
          <!-- <input type="text" id="m_num" class="form-control"
          style="width:10px;" placeholder="회원번호"> --><%=m_id %>
          
    <div class="star-rating space-x-4 mx-auto" id="g_grade">
	<input type="radio" id="5-stars" name="g_grade" value="5" v-model="ratings" />
	<label for="5-stars" class="star pr-4">★</label>
	<input type="radio" id="4-stars" name="g_grade" value="4" v-model="ratings" />
	<label for="4-stars" class="star">★</label>
	<input type="radio" id="3-stars" name="g_grade" value="3" v-model="ratings" />
	<label for="3-stars" class="star">★</label>
	<input type="radio" id="2-stars" name="g_grade" value="2" v-model="ratings" />
	<label for="2-stars" class="star">★</label>
	<input type="radio" id="1-star" name="g_grade" value="1" v-model="ratings" />
	<label for="1-star" class="star">★</label>
    </div>

   <button type="button" id="btnasend"
   class="btn btn-info btn-sm" style="margin-left: 10px;">등록</button>    
   
   </div>
   
   <div class="alist" id="alist" >평점 목록</div>
         
</td>
</tr>
</table>



</form>
</div>

<body>
 
</body>

</html>