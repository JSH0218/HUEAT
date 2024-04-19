<%@page import="food.model.FoodDto"%>
<%@page import="food.model.FoodDao"%>
<%@page import="brand.model.BrandDao"%>
<%@page import="brand.model.BrandDto"%>
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
<link rel="stylesheet" type="text/css" href="hugesoinfo/hugesodetail.css">
 <link href="https://fonts.googleapis.com/css2?family=Nanum+Gothic&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
   <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
   <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
	<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=5a77ce427996f7b3cb3de14e9a4e0444"></script>
<title>HUEAT</title>

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
	
    // HugesoInfoDao 객체 생성 & 휴게소 데이터 가져오기
    HugesoInfoDao dao = new HugesoInfoDao();
	HugesoInfoDto dto = dao.getData(h_num);
	
	SimpleDateFormat sdf=new SimpleDateFormat("yy.MM.dd");

	int fav=mdao.isFavorite(m_num, h_num);
	
	GradeDao gdao = new GradeDao();
	GradeDto gdto = gdao.bestContent(h_num);
	String avgGrade = gdao.avgGrade(h_num);

	//해당 휴게소에 평점을 등록한 사용자의 아이디 목록 가져오기
	List<String> getG_myid = gdao.getG_myid(h_num);
	
	//현재 로그인한 사용자의 아이디가 해당 목록에 포함되어 있는지 확인
	boolean G_myid = getG_myid.contains(m_id);
	
	//FoodDao 객체 생성 & 음식 데이터 가져오기
	FoodDao fdao = new FoodDao();
	List<FoodDto> foodlist = fdao.selectFood(h_num);
	
	//BrandDao 객체 생성 & 브랜드 데이터 가져오기
	BrandDao bdao = new BrandDao();
	List<BrandDto> brandList = bdao.selectBrand(h_num);
%>

<style type="text/css">
.toparea .shareArea .share > div {
    position: absolute;
    top: 50px;
    left: 0;
    display: none;
}

.toparea .shareArea .share > div a.kakao {
    background: url(path/to/kakao.png) no-repeat 50% 50%;
    /* Add fallback background color */
    background-color: #ffeb3b; /* Example color */
}

.toparea .shareArea .share > div a.naver {
    background: url(path/to/naver.png) no-repeat 50% 50%;
    /* Add fallback background color */
    background-color: #00c3ff; /* Example color */
}

.toparea .shareArea .share > div a.facebook {
    background: url(path/to/facebook.png) no-repeat 50% 50%;
    /* Add fallback background color */
    background-color: #3b5998; /* Example color */
}

.toparea .shareArea .share > div a.twitter {
    background: url(path/to/twitter.png) no-repeat 50% 50%;
    /* Add fallback background color */
    background-color: #1da1f2; /* Example color */
}

.form_radio_btn input[type=radio]:checked + label {
    background: #618E6E;
    color: #fff;
}

</style>

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
	
	 
	 /* $(".writegrade").click(function() {
		    if (login !== "null") {
		        $("#insertgrade").show();
		    } else {
		        $("#insertgrade").hide();
		    }
		}); */
	 
	 
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
		             list();
		       
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
		    
	 
			  
			
			
		        /* // 버튼 클릭 이벤트 설정
		        $('#sortByLatest').click(function(event) {
		            event.preventDefault(); // 버튼의 기본 동작인 폼 전송 방지
		            list("latest"); // '최신순'을 선택한 경우
		        });

		        $('#sortByHigh').click(function(event) {
		            event.preventDefault(); // 버튼의 기본 동작인 폼 전송 방지
		            list("high"); // '높은 순'을 선택한 경우
		        });

		        $('#sortByLow').click(function(event) {
		            event.preventDefault(); // 버튼의 기본 동작인 폼 전송 방지
		            list("low"); // '낮은 순'을 선택한 경우
		        }); */
		
			
		
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
	
	
	
	/* 	    $('.writegrade').click(function() {
		        if(!G_myid) {
		            $('#insertgrade').show(); 
		        }
		    });
		    */
		
		
		
	
	
	
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



$(document).ready(function() {
    $('.shareicon').click(function(event) {
        //event.preventDefault(); // 버튼의 기본 동작인 폼 전송 방지
        $('#hiddenButtons').slideToggle(); // 숨겨진 버튼들을 토글하여 나타나거나 사라지게 함
    });
});



/* 음식평점 남기긱 */
$("#btnsendfood").click(function(){
    var g_grade = $("input[name='fg_grade']:checked").val(); // 선택된 평점 값 가져오기
    
    if (!fg_grade) { // 선택된 평점이 없을 경우
        alert("평점을 선택해주세요");
        return;
    }
    
    $.ajax({
        type: "get", 
        url: "foodgrade/insertfoodgrade.jsp",
        dataType: "html",
        data: {"fg_hugesonum": $("#h_num").val(),
        	   "fg_foodnum": $("#fg_myid").val(),
        	   "fg_myid": $("#fg_myid").val(),
        	   "fg_grade": fg_grade, 
        	   "g_content": g_content}, 
        	   
        success: function(){
            $("#insertfoodgrade").hide(); // 평점 등록 시 숨김
       
            updateH_grade();
         },
        error: function(xhr, status, error) {
            // 오류 발생 시 처리
            console.error("AJAX Error: " + error);
        }
            
    });
    
    });


var moreButton = document.getElementById("moreButton");
var foldButton = document.getElementById("foldButton");
var moreButton1 = document.getElementById("moreButton1");
var foldButton1 = document.getElementById("foldButton1");

if (document.querySelector('a[href="#home"]').classList.contains("active")) {
    moreButton.style.display = "block";
    foldButton.style.display = "none";
    moreButton1.style.display = "none";
    foldButton1.style.display = "none";
} else if (document.querySelector('a[href="#menu1"]').classList.contains("active")) {
    moreButton.style.display = "none";
    foldButton.style.display = "none";
    moreButton1.style.display = "block";
    foldButton1.style.display = "none";
}






})

</script>
</head>

<body>
<div class="h_body">

<form id="frm">
<input type="hidden" name="h_num" value="<%=h_num%>" id="h_num">
<input type="hidden" name="m_num" value="<%=m_num%>" id="m_num">
<input type="hidden" name="g_myid" value="<%=m_id%>" id="g_myid">

<div class="hugesodetail">
<div class="toparea">
<div class="location">
	<a href="#" class="home"><i class="bi bi-house-door-fill"></i></a>

<div class="one" style="display:flex;">
<a href="#" class="h_loc">휴게소정보 </a>
</div>
<div class="two">
<a href="#" class="h_loc">휴게소찾기</a>
</div>
<div class="three">휴게소상세
</div>
</div>

<!-- sns 공유하기 -->


<div class="sharearea">
    <div class="share">
        <button type="button" class="shareicon" onclick="toggleHiddenMenu()"
        style="border: none; background: none; cursor: pointer; width:40px; height:40px;">
            <i class="bi bi-share-fill" style="font-size:30px;"></i>
        </button>
        <div id="hiddenButtons" style="display: none;">
        <div style="display: flex; flex-direction: column;">
           <jsp:include page="sns_share.jsp" />
           </div>
        </div>
    </div>
    
    <div class="favicon">
<!-- 즐겨찾기 버튼 -->
<button type="button" class ="favorite">
<!-- <i class="bi bi-bookmark" style="margin-left: 10px; font-size:200%;"></i> -->
<i class="bi bi-bookmarks-fill" style="margin-left: 30px; font-size:30px;"></i>
</button>
</div>

</div>


<script>
    function toggleHiddenMenu() {
        var hiddenMenu = document.getElementById("hiddenButtons");
        if (hiddenMenu.style.display === "none") {
            hiddenMenu.style.display = "block";
        } else {
            hiddenMenu.style.display = "none";
        }
    }
</script>

</div>
</div>
<!-- 휴게소 이름 출력 -->
<h2 class="h_name"><%=dto.getH_name()%></h2> 
<p class="h_text">
<% if (gdto.getG_content() != null) { %>
    #<%= gdto.getG_content() %>
<% }%>
</p>
<div class="avggrade">
<!-- 휴게소 평점 출력 -->

<%--  <div><%=dto.getH_grade() %> </div> --%>
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
<%-- <div ><%=dto.getH_gradecount() %></div> --%>
</div>


<div class="huinfo">
<div class="imgarea">
<!-- 휴게소 사진 -->
<img alt="" src="image/hugeso/<%=dto.getH_photo()%>" style="width:700px; height:500px; margin-left:20px;">
</div>


<ul class="infoarea">


<!-- 휴게소 주소, 영업시간, 전화번호, 편의시설 출력 -->
<li class="op1">
<div class="tablecell">
<p class="txt1">주소</p>
<p class="txt2"><%=dto.getH_addr() %></p>
</div>
</li>
<li class="op2">
<div class="tablecell">
<p class="txt1">영업시간</p>
<p class="txt2">00:00 - 24:00</p>
</div>
</li>
<li class="op3">
<div class="tablecell">
<p class="txt1">전화번호</p>
<p class="txt2"><%=dto.getH_hp() %></p>
</div>
</li>
<li class="op4">
<div class="tablecell">
<p class="txt1">편의시설</p>
<p class="txt2">
 <% 
        String pyeons = dto.getH_pyeon(); //dto에 있는 편의시설 문자열을 pyeons에 넣어줌
        String[] pyeonArray = pyeons.split(","); //콤마를 기준으로 편의시설 문자열을 분리하여 배열 pyeonArray에 넣어줌
        for(String pyeon : pyeonArray){
        	 switch(pyeon){
        	 case "수면실":{
        		 %><img src="image/pyeon/수면실.jpg" alt="수면실" class="pyeonicon"><%
        	 break;
        	 }
        	 case "샤워실":{
        		 %><img src="image/pyeon/샤워실.jpg" alt="샤워실" class="pyeonicon" ><%
        				 break;
        	 }
        	 case "세탁실":{
        		 %><img src="image/pyeon/세탁실.jpg" alt="세탁실" class="pyeonicon"><%
        				 break;
        	 }
        	 case "세차장":{
        		 %><img src="image/pyeon/세차장.jpg" alt="세차장"  class="pyeonicon"><%
        				 break;
        	 }
        	 case "경정비":{
        		 %><img src="image/pyeon/경정비.jpg" alt="경정비"  class="pyeonicon"><%
        				 break;
        	 }
        	 case "수유실":{
        		 %><img src="image/pyeon/수유실.jpg" alt="수유실" class="pyeonicon"><%
        				 break;
        	 }
        	 case "쉼터":{
        		 %><img src="image/pyeon/쉼터.jpg" alt="쉼터"  class="pyeonicon"><%
        				 break;
        	 }
        	 case "ATM":{
        		 %><img src="image/pyeon/ATM.jpg" alt="ATM"  class="pyeonicon"><%
        				 break;
        	 }
        	 case "매점":{
        		 %><img src="image/pyeon/매점.jpg" alt="매점" class="pyeonicon"><%
        				 break;
        	 }
        	 case "약국":{
        		 %><img src="image/pyeon/약국.jpg" alt="약국"  class="pyeonicon"><%
        				 break;
        	 }
        	 default:{ /* 기타 */
        		 %><img src="image/pyeon/기타.jpg" alt="기타"  class="pyeonicon"><%
        		 break;
        	 }
        	 
        	 }
          /*   out.println(pyeon); */ // 각 편의시설 출력
        }
        %>
        </p>
        </div>
    </li>
</ul>
</div>


<div class="contain">

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
    <!-- 푸드코트 출력  -->
    <%
    int count = 0; // 이미지 개수를 세기 위한 변수
    for(FoodDto fdto : foodlist) {
        String f_photo = fdto.getF_photo();
        String f_name = fdto.getF_name();
        count++; // 이미지가 추가될 때마다 개수 증가

        // 이미지 출력
    %>
        <div class="food-item" style="display: <%= count <= 4 ? "inline-block" : "none" %>; text-align:center; font-weight:bold; margin-bottom: 20px;">
            <img alt="<%=f_name%>" src="image/food/<%=f_photo%>" style="width: 220px; height:200px; margin-right:20px; margin-bottom:15px;"><br>
            <%=f_name%>
        </div>
    <% if (count == 4) break; %> <%-- 이미지가 4개가 되면 반복문 중단 --%>
    <%}%>
        <div id="hiddenContent" style="display: none;">
            <!-- 추가 이미지들 -->
            <% 
            for (int i = 4; i < foodlist.size(); i++) {
                FoodDto fdto = foodlist.get(i);
                String f_photo = fdto.getF_photo();
                String f_name = fdto.getF_name();
            %>
                <div class="food-item" style="display: inline-block; text-align:center; font-weight:bold; margin-bottom: 20px;">
                    <img alt="<%=f_name%>" src="image/food/<%=f_photo%>" style="width: 220px; height:200px; margin-right:20px; margin-bottom:15px;"><br>
                    <%=f_name%>
                </div>
            <% } %>
        </div>
</div>

  <div id="menu1" class="container tab-pane fade"><br>
    <!-- 브랜드 출력  -->
   <div style="display: flex; flex-wrap: wrap;">
        <% 
        int count1 = 0; // 브랜드 개수를 세기 위한 변수
        for(BrandDto bdto : brandList) {
            String b_photo = bdto.getB_photo();
            String b_name = bdto.getB_name();
            String b_addr = bdto.getB_addr();
            count1++; // 브랜드가 추가될 때마다 개수 증가

            // 브랜드 출력
        %>
            <div class="brand-item" style="display: <%= count1 <= 4 ? "inline-block" : "none" %>; text-align:center; font-weight:bold; margin-bottom: 20px;">
                <img alt="<%=b_name %>" src="image/brand/<%=b_photo %>" style="width: 220px; height:200px; margin-right:20px; margin-bottom:15px;">
                <div><%=b_name %></div>
            </div>
        <% if (count1 == 4) break; %> <%-- 브랜드가 4개가 되면 반복문 중단 --%>
        <%}%>
            <div id="hiddenContent1" style="display: none;">
                <!-- 추가 브랜드들 -->
                <% 
                for (int i = 4; i < brandList.size(); i++) {
                    BrandDto bdto = brandList.get(i);
                    String b_photo = bdto.getB_photo();
                    String b_name = bdto.getB_name();
                    String b_addr = bdto.getB_addr();
                %>
                    <div class="brand-item" style="display: none;">
                        <img alt="<%=b_name %>" src="image/brand/<%=b_photo %>" style="width: 220px; height:200px; margin-right:20px; margin-bottom:15px;">
                        <div><%=b_name %></div>
                    </div>
                <% } %>
            </div>
    </div>
</div>
</div>

<div style="text-align: center; margin-top: 30px;">
  <button id="moreButton" style="border: none; background: none; cursor: pointer;">
        <i class="bi bi-chevron-down" style="font-size:30px;"></i>
    </button>
    <button id="foldButton" style="display: none; border: none; background: none; cursor: pointer;">
        <i class="bi bi-chevron-up" style="font-size:30px;"></i>
    </button>
</div> 
</div>
</div>

<!-- <div style="text-align: center; margin-top: 30px;">
    <button id="moreButton1" style="border: none; background: none; cursor: pointer;">
        <i class="bi bi-chevron-down" style="font-size:30px;"></i>
    </button>
    <button id="foldButton1" style="display: none; border: none; background: none; cursor: pointer;">
        <i class="bi bi-chevron-up" style="font-size:30px;"></i>
    </button>
</div>  -->

<script>
function toggleContent(hiddenContentId, moreButtonId, foldButtonId, className, maxVisibleItems) {
    var hiddenContent = document.getElementById(hiddenContentId);
    if (!hiddenContent) return;

    var hiddenItems = hiddenContent.querySelectorAll("." + className);
    hiddenItems.forEach(function(item, index) {
        item.style.display = index < maxVisibleItems ? "inline-block" : "inline-block";
    });

    var moreButton = document.getElementById(moreButtonId);
    var foldButton = document.getElementById(foldButtonId);

    moreButton.addEventListener("click", function(event) {
        event.preventDefault();
        hiddenContent.style.display = "block";
        moreButton.style.display = "none";
        foldButton.style.display = "inline";
    });

    foldButton.addEventListener("click", function(event) {
        event.preventDefault();
        hiddenContent.style.display = "none";
        foldButton.style.display = "none";
        moreButton.style.display = "inline";
    });
}

// 각 섹션의 토글 버튼 기능을 할당
toggleContent("hiddenContent", "moreButton", "foldButton", "food-item", document.querySelectorAll(".food-item").length);
toggleContent("hiddenContent1", "moreButton1", "foldButton1", "brand-item", document.querySelectorAll(".brand-item").length);

</script>





<div class="contain">

<p class="subtitle">주유소/충전소</p>
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
<div style="font-size:16px; font-weight:bold; color: gray; text-align:center; margin-bottom:100px;">본 정보는 특정 시점에 수집되어 실제 가격과 다를 수 있습니다.
[제공&nbsp;<span style="color:#0897B4;">한국도로공사]</span></div>
</div>







<div class="contain">

<p class="subtitle">평점</p>

<!-- <button id="sortByLatest">최신순</button>
<button id="sortByHigh">평점높은순</button>
<button id="sortByLow">평점낮은순</button> -->

<div style="display: inline-block;">
    <label style="-webkit-text-fill-color: gold; font-size: 5rem;">★</label>
    <p style="font-weight:bold; font-size:50px; display: inline-block;">
        <%=dto.getH_grade() %>
    </p>
</div>



 <table style="width:50%; margin-left:auto;">
     <!-- 평점 -->
     <tr>
     
       <td>  
        <b class="gradesu" style="text-align:left;">평점&nbsp;<span>0</span>건  
        </b>
        
      <!-- <button class="writegrade"><i class="bi bi-pencil"></i>평점남기기</button>  -->
      
  <% if(!G_myid) {%>
         <div class="gradefrm" id="insertgrade">
          <div style="display: inline-block;">
          <p style="margin-top:80px; font-size 20px; font-weight:bold;"><%=m_id %></p>


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
    <br>
    </div>
    
    
    <div><span style="font-weight:bold; font-size:20px;"><%=dto.getH_name()%></span>는 이런 점이 좋아요!(1개 선택)</div><br>
   <div id="g_content" style="display: flex; width:1000px;">
   <div class="form_radio_btn" style="width:200px;">
    <input type="radio" name="g_content" id="clean_facility" value="시설이 깨끗해요" checked>
    <label for="clean_facility">시설이 깨끗해요</label>
    </div>
    <div class="form_radio_btn" style="width:200px;">
    <input type="radio" name="g_content" id="good_facility" value="휴게시설이 잘 되어 있어요">
    <label for="good_facility">휴게시설이 잘 되어 있어요</label>
    </div>
    <div class="form_radio_btn" style="width:200px;">
    <input type="radio" name="g_content" id="delicious_food" value="음식이 맛있어요">
    <label for="delicious_food">음식이 맛있어요</label>
    </div>
    <div class="form_radio_btn" style="width:200px;">
    <input type="radio" name="g_content" id="special_menu" value="특별한 메뉴가 있어요">
    <label for="special_menu">특별한 메뉴가 있어요</label>
    </div>
    <div class="form_radio_btn" style="width:200px;">
    <input type="radio" name="g_content" id="convenient_parking" value="주차하기 편해요">
    <label for="convenient_parking">주차하기 편해요</label>
    </div>
    </div>
	<br>
	<div class="btnArea hulist">
   <button type="button" id="btnasend" class="prebtn" >등록</button>    
   </div>
   </div>
 <%}%>
 
   <div class="alist" id="alist">평점 목록</div>

</td>
</tr>
</table>

</div>



<div class="contain2">
<p class="subtitle">위치정보</p>

<div id="map" style="width: 70%;height:500px; margin:auto;"></div>
<script>
var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
    mapOption = { 
        center: new kakao.maps.LatLng(<%=dto.getH_yvalue()%>,<%=dto.getH_xvalue()%>), // 지도의 중심좌표
        level: 3 // 지도의 확대 레벨
    };

var map = new kakao.maps.Map(mapContainer, mapOption); // 지도를 생성합니다

// 마커가 표시될 위치입니다 
var markerPosition  = new kakao.maps.LatLng(<%=dto.getH_yvalue()%>,<%=dto.getH_xvalue()%>); 

// 마커를 생성합니다
var marker = new kakao.maps.Marker({
    position: markerPosition
});

// 마커가 지도 위에 표시되도록 설정합니다
marker.setMap(map);
  
</script>





<div class="btnArea hulist">
<button type="button" id="prebtn"
   class="prebtn" >목록</button> 
</div>

<script>
    $(document).ready(function() {
        $("#prebtn").click(function() {
            history.back(); // 이전 페이지로 이동
        });
    });
</script>



</div>
<button type="button" >수정</button> 
<button type="button" style="background-color:">삭제</button> 
</div>

</div>



</div>
</form>
</div>
</body>

</html>