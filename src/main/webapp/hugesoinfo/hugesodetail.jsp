<%@page import="grade.model.GradeDto"%>
<%@page import="grade.model.GradeDao"%>
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

table.gtable, table.gtable th, table.gtable td{
    text-align: center; /* 가운데 정렬 */
    vertical-align: middle; /* 수직 정렬 */
    border : 2px solid lightgray;
    border-collapse: collapse;
}

table.gtable td{
width:300px;
height: 50px;
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

.gradefrm{
	/* position: relative; */
    display: flex;
  /*   flex-wrap: wrap; */
   /*  align-items: stretch; */
   /*  width: 80%; */

}


/* 평점 css  */
.star-rating {
  display: flex;
  flex-direction: row-reverse;
  font-size: 2rem;
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

/* 휴게소 평균 평점 */
.star-ratings {
  color: #aaa9a9; 
  position: relative;
  unicode-bidi: bidi-override;
   width: max-content; 
  -webkit-text-fill-color: transparent; /* Will override color (regardless of order) */
  /* -webkit-text-stroke-width: 1.3px; */
 /* -webkit-text-stroke-color: #2b2a29; */ /* 별 테두리 */
}
 
.star-ratings-fill {
  color: #fff58c;
  padding: 0;
  position: absolute;
  z-index: 1;
  display: flex; 
  top: 0;
  left: 0;
  overflow: hidden;
  -webkit-text-fill-color: gold;
  font-size: 2.5rem;
}
 
.star-ratings-base {
  z-index: 0;
  padding: 0;
  font-size: 2.5rem;
  -webkit-text-fill-color: lightgray;
}

.red{
	color: #FFE400;
}


div.alist{margin-left: 20px;}

span.aday{
	font-size:0.8em;
	color:#bbb;
}


/* g_content css */
.form_radio_btn {
			height : 45px;
    		border: 1px solid #EAE7E7;
    		border-radius: 10px;
		}
		.form_radio_btn input[type=radio] {
			display: none;
		}
		.form_radio_btn label {
			display: block;
    		border-radius: 10px;
   			margin: 0 auto;
    		text-align: center;
    		height: -webkit-fill-available;
    		line-height: 45px;
		}
		 
		/* Checked */
		.form_radio_btn input[type=radio]:checked + label {
			background: #184DA0;
			color: #fff;
		}
		 
		/* Hover */
		.form_radio_btn label:hover {
			color: #666;
		}
		 
		/* Disabled */
		.form_radio_btn input[type=radio] + label {
			background: #F9FAFC;
			color: #666;
		}

@media (min-width: 1400px) {
  .food .container,
  .food .container-lg,
  .food .container-md,
  .food .container-sm,
  .food .container-xl,
  .food .container-xxl {
    max-width: 1700px;
  }
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
	
	SimpleDateFormat sdf=new SimpleDateFormat("yy.MM.dd");

	int fav=mdao.isFavorite(m_num, h_num);
	
	GradeDao gdao = new GradeDao();
	String avgGrade = gdao.avgGrade(h_num);

	//해당 휴게소에 평점을 등록한 사용자의 아이디 목록 가져오기
	List<String> getG_myid = gdao.getG_myid(h_num);
	
	//현재 로그인한 사용자의 아이디가 해당 목록에 포함되어 있는지 확인
	boolean G_myid = getG_myid.contains(m_id);
%>

<script type="text/javascript">
  
$(function(){
	list();
	
	var h_num=$("#h_num").val();
	var m_num=$("#m_num").val();
	//alert(m_num);


	var login = "<%=loginok%>";
	
	
 <%-- var avgGrade = "<%= avgGrade %>";
	if (avgGrade !== null) {
	    alert("평균 등급: " + avgGrade);
	} else {
	    alert("평균 등급을 가져오지 못했습니다.");
	} --%>
	
	/* 휴게소 평점 평균 */
	 function ratingToPercent(avgGrade) {
	    const score = avgGrade * 20;
	    return score + 1.5;
	  }

	// JSP에서 가져온 평균 등급 값을 JavaScript 변수에 할당
	var avgGrade = "<%= avgGrade %>"; 

	// HTML 요소에 평균 등급을 적용하는 함수 호출
	  applyStarRatings(parseFloat(avgGrade));

	  function applyStarRatings(avgGrade) {
	    const fillWidth = ratingToPercent(avgGrade) + '%';
	    document.querySelector('.star-ratings-fill').style.width = fillWidth;
	}

	
	

	 if(login=="null"){
		 $("#insertgrade").hide(); // 로그아웃 상태일 때 숨김
	        return;
	    }else {
	        $("#insertgrade").show(); // 로그인 상태일 때 표시
	    } 
	 
	 
	$("#btnasend").click(function(){
		    var g_grade = $("input[name='g_grade']:checked").val(); // 선택된 평점 값 가져오기
		    var g_content = $("input[name='g_content']:checked").val();// 사용자가 입력한 내용 가져오기
		    
		    if (!g_grade) { // 선택된 평점이 없을 경우
		        alert("평점을 선택해주세요");
		        return;
		    }
		    
		    $.ajax({
		        type: "get", 
		        url: "grade/insertgrade.jsp",
		        dataType: "html",
		        data: {"h_num": $("#h_num").val(),  
		        	   "m_num":$("#m_num").val(),  
		        	   "g_myid": $("#g_myid").val(),
		        	   "g_grade": g_grade, 
		        	   "g_content": g_content}, 
		        	   
		        success: function(){
		            $("#insertgrade").hide(); // 평점 등록 시 숨김
		            /* list();//평점 목록 다시 불러오기 */
		       
		            updateH_grade();
		         },
		        error: function(xhr, status, error) {
		            // 오류 발생 시 처리
		            console.error("AJAX Error: " + error);
		        }
		            
		    });
		    
		    });
	
			// 특정 휴게소의 평균 평점 및 평점 갯수
		    function updateH_grade() {
		    $.ajax({ 
	       		 
		        type:"post",
		        dataType:"html",
		        data: {"h_num":$("#h_num").val(), 
		        	"h_grade": avgGrade , 
		        	"h_gradecount":$("b.gradesu>span").text()},
		        url:"hugesoinfo/updateh_grade.jsp",
		        success:function(res){
		
		       
		        },
		        error: function(xhr, status, error) {
		            console.error("AJAX Error: " + error);
		        }
	
	            });
		    
		    
		    }
		    
	 
			  
		
		// 특정 휴게소의 평점 목록
		    function list(){
		    	
			  	  $.ajax({ 
			  		  type:"get",
			  		  url:"grade/gradelist.jsp",
			  		  dataType:"json",
			  		  data:{"h_num":$("#h_num").val()},
			  		  success:function(res){
			  			 
			  			  //평점갯수출력
			  			  $("b.gradesu>span").text(res.length);
			  			  
			  			  var s="";
			  			  $.each(res,function(idx,item){
			  				  
			  				  //평점에 따라 별표시 추가
			  				  var starsHTML = "";
			  				  for(var i=5;i>0;i--){
			  					  if(i<=item.g_grade){
			  						  starsHTML +="<span class='star' style='color:gold;'>★</span>";
			  					  }else{
			  						 starsHTML +="<span class='star-empty' style='color:lightgray;'>★</span>";
			  					  }
			  					  
			  				  }
			  				  s+="<div><hr>";
			  				  s+="<span class='star-rating'>"+ item.g_grade+ starsHTML +"</span>";
			  				  s+="<span class='aday'>"+ item.g_myid + " · "+ item.g_writeday+"</span>";
			  				  s+="<div>"+item.g_content+"</div>";
			  				  s+= "</div>";
			  			  });
			  			  $("div.alist").html(s);
			  			  
			  			  updateH_grade();
			  		  },
			  		  error: function(xhr, status, error) {
			  	            console.error("AJAX Error: " + error);
			  	        }
			  		  
			  	  });
			    } 
	
	
	
		    $('.writegrade').click(function() {
		        if(!G_myid) {
		            $('#insertgrade').show(); 
		        }
		    });
		   
		
		
		
	
	
	
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

	
	
// 유지))즐겨찾기
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
                location.href="index.jsp?main=mypage/favlist.jsp";
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
<input type="hidden" name="g_myid" value="<%=m_id%>" id="g_myid">

<div style="padding-top: 80px; position: relative; left:4%; display:flex;">
<!-- 휴게소 사진 -->
<div style="margin-top:50px;">
<img alt="" src="image/hugeso/<%=dto.getH_photo()%>" style="width:600px; height:400px;">
</div> 


<div style="padding-top: 60px; position: relative; left:4%; width: 600px;">


<!-- 휴게소 이름 출력 -->
<div style="font-size: 45px; font-weight:bold; margin-bottom: 20px; display:flex;">
<%=dto.getH_name()%> 
<!-- 즐겨찾기 버튼 -->
<button type="button" class ="favorite">
<!-- <i class="bi bi-bookmark" style="margin-left: 10px; font-size:200%;"></i> -->
<i class="bi bi-bookmarks-fill" style="margin-left: 30px;"></i>
</button>
</div>


<!-- 휴게소 평점 출력 -->

 <div><%=dto.getH_grade() %> </div>
<div class="star-ratings">
  <div 
    class="star-ratings-fill space-x-2 text-lg"
    :style="{ width: ratingToPercent() + '%' }"
  >
    <span>★</span><span>★</span><span>★</span><span>★</span><span>★</span>
   
  </div>
  <div class="star-ratings-base space-x-2 text-lg">
    <span>★</span><span>★</span><span>★</span><span>★</span><span>★</span>
  </div>
</div>
<div ><%=dto.getH_gradecount() %></div>


<!-- 휴게소 주소, 영업시간, 전화번호, 편의시설 출력 -->
<div style="font-size: 20px; margin-bottom: 20px;">
<i class="bi bi-geo-alt"></i>&nbsp;
<%=dto.getH_addr() %></div>
<div style="font-size: 20px; margin-bottom: 20px;">
<i class="bi bi-clock"></i>&nbsp;
24시
</div>
<div style="font-size: 20px; margin-bottom: 20px;" >
<i class="bi bi-telephone"></i>&nbsp;
<%=dto.getH_hp() %></div>
<div style="font-size: 20px; margin-bottom: 20px; display:flex;">
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

<div style=" float: right; margin-right:8%; margin-top:10%;">
<h5>주유소/충전소</h5>
<table class="gtable">
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
<div style="font-size:18px; font-weight:bold; color: gray;">본 정보는 특정 시점에 수집되어 실제 가격과 다를 수 있습니다.<br>
제공&nbsp;<span style="color:#0897B4;">한국도로공사</span></div>
</div>





</div>
</div>




<div style="position: relative; top:-50px;"> 
<div class="container mt-3 food">
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
  <span style="display: flex; flex-wrap: wrap;">
<% 
String brands = dto.getH_brand();
String[] brandArray = brands.split(",");
for(String brand : brandArray){%>
 <span style=" margin-right: 20px; text-align: center;">
 <img alt="<%= brand %>" src="image/brand/<%= brand %>.jpg" style="width: 200px; height:200px; margin-right:20px;">
  <div><% out.println(brand);%></div></span>
 <%}%><br>
    
  </span>
</div>
</div>
</div>

 <table style="width:50%; margin-left:8%;"> <!-- class="table table-bordered" -->
     <!-- 평점 -->
     <tr>
     
       <td>  
        <b class="gradesu" style="text-align:left;">평점&nbsp;<span>0</span>건  
        </b>
        
          <button class="writegrade"><i class="bi bi-pencil"></i>평점남기기</button>
      
          
         <div class="gradefrm" id="insertgrade">
          
          <%=m_id %>
          
    <div class="star-rating space-x-4 mx-auto" id="g_grade";>
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
    
   <div id="g_content">
   <div class="form_radio_btn">
    <input type="radio" name="g_content" id="clean_facility" value="시설이 깨끗해요" checked>
    <label for="clean_facility">시설이 깨끗해요</label>
    </div>
    <div class="form_radio_btn">
    <input type="radio" name="g_content" id="good_facility" value="휴게시설이 잘 되어 있어요">
    <label for="good_facility">휴게시설이 잘 되어 있어요</label>
    </div>
    <div class="form_radio_btn">
    <input type="radio" name="g_content" id="delicious_food" value="음식이 맛있어요">
    <label for="delicious_food">음식이 맛있어요</label>
    </div>
    <div class="form_radio_btn">
    <input type="radio" name="g_content" id="special_menu" value="특별한 메뉴가 있어요">
    <label for="special_menu">특별한 메뉴가 있어요</label>
    </div>
    <div class="form_radio_btn">
    <input type="radio" name="g_content" id="convenient_parking" value="주차하기 편해요">
    <label for="convenient_parking">주차하기 편해요</label>
    </div>
    </div>
	
   <button type="button" id="btnasend"
   class="btn btn-info btn-sm" style="margin-left: 10px;">등록</button>    
   
   </div>
 
       
   <div class="alist" id="alist" >평점 목록</div>
         
</td>
</tr>
</table>
</div>



</form>
</div>

<body>
 
</body>

</html>