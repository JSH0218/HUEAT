<%@page import="foodgrade.model.FoodGradeDto"%>
<%@page import="foodgrade.model.FoodGradeDao"%>
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
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	
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
	String get_Content = gdao.get_Content(h_num);

	//해당 휴게소에 평점을 등록한 사용자의 아이디 목록 가져오기
	List<String> getG_myid = gdao.getG_myid(h_num);
	
	//현재 로그인한 사용자의 아이디가 해당 목록에 포함되어 있는지 확인
	boolean G_myid = getG_myid.contains(m_id);
	
	//FoodDao 객체 생성 & 음식 데이터 가져오기
	FoodDao fdao = new FoodDao();
	FoodDto ffdto = fdao.bestFood(h_num);
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

.nav-pills{
	justify-content:center;
	width:1150px;
}

.nav-item{
	width:50%;
	text-align:center;
	font-size:20px;
}

 .nav-link{
 	color:black ;
 }
 
 .nav-link.ative{
 	color:white ;
 }
 
 
 .progress-bar {
    width:500px;
    background-color: #f7f7f9 !important;
    /* border: 1px solid #ccc; */
    border-radius: 4px;
    margin-bottom: 10px;
  }
  .progress-bar-inner {
    height: 50px; /* 프로그래스 바의 기본 높이 */
    background-color: #dce5d2; /* 기본 프로그래스 바 색상 */
    border-radius: 4px;
    transition: width 0.3s; /* 애니메이션 효과 */
  }


.delete-button{
	border:none; 
	background-color:white;

}

.food-item.selected {
    cursor:pointer;
}

.food-item.selected {
    border:3px solid #618E6E;
    cursor:pointer;
}

.brand-item{
    cursor:pointer;
}


.writegrade{
	border:none;
	background-color:white;
}


#popup {
  display: flex;
  justify-content: center;
  align-items: center;
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(0, 0, 0, .7);
  z-index: 1;
}

#popup.hide {
  display: none;
}

#popup.has-filter {
  backdrop-filter: blur(4px);
  -webkit-backdrop-filter: blur(4px);
}

#popup .content {
  padding: 20px;
  background: #fff;
  border-radius: 5px;
  box-shadow: 1px 1px 3px rgba(0, 0, 0, .3);
}
</style>

<script type="text/javascript">
  
$(function(){
	
	list();
	progressbar();
	
	var h_num=$("#h_num").val();
	var m_num=$("#m_num").val();

	var login = "<%=loginok%>";

    // 로그인 상태에 따라 평점 입력 폼을 보이거나 숨김
    if (login === "null") {
        $("#insertgrade").hide(); // 로그아웃 상태일 때 숨김
    } else {
        $("#insertgrade").show(); // 로그인 상태일 때 표시
    }
	
		function resetStarRating() {
		    // 모든 별점 input 요소를 초기화
		    document.querySelectorAll('.star-rating input').forEach(function(input) {
		        input.checked = false;
		    });

		    // 레이블 색상을 초기 상태로 변경
		    document.querySelectorAll('.star-rating label').forEach(function(label) {
		        label.style.color = 'transparent';
		    });
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
		        	
		        	resetStarRating();
		            //$("#insertgrade").hide(); // 평점 등록 시 숨김
		            updateH_grade();
		            progressbar();  
		            list();
		         },
		        error: function(xhr, status, error) {
		            // 오류 발생 시 처리
		            console.error("AJAX Error: " + error);
		        }
		            
		    });
		    
		    });
		    
 
				function ratingToPercent(avgGrade) {
				    const score = avgGrade * 20;
				    return score + 1.5;
				}

			// JSP에서 가져온 평균 등급 값을 JavaScript 변수에 할당
				var avgGrade = "<%= avgGrade %>"; 

				// HTML 요소에 평균 등급을 적용하는 함수 호출
				  applyStarRatings(parseFloat(avgGrade));
			   
			   
				// HTML 요소에 평균 등급을 적용하는 함수 호출
				function applyStarRatings(avgGrade) {
				    const fillWidth = ratingToPercent(avgGrade) + '%';
				    document.querySelector('.star-ratings-fill').style.width = fillWidth;
				}

				function updateH_grade() {
				    $.ajax({ 
				        type: "post",
				        dataType: "html",
				        data: {
				            "h_num": $("#h_num").val(), 
				            "h_grade": avgGrade , 
				            "h_gradecount": $("b.gradesu>span").text()
				        },
				        url: "hugesoinfo/updateh_grade.jsp",
				        success: function(res) {
				        	$(".avggrade3").text(avgGrade); 
				            
				        },
				        error: function(xhr, status, error) {
				            console.error("AJAX Error: " + error);
				        }
				    });
				} 



				$(document).ready(function () {
				    updateH_grade();
				});


 
		    /* 프로그래스바 업데이트를 위한 Ajax 요청 함수 */
		    function progressbar() {
    $.ajax({
        type: "post",
        dataType: "json", // 서버에서 JSON 형식으로 데이터를 반환한다고 가정합니다.
        data: {
            "h_num": $("#h_num").val(),
        },
        url: "hugesoinfo/contentprogressbar.jsp",
        success: function (data) {
            var progressContainer = document.getElementById('progress-container');

            // 기존의 프로그래스 바 제거
            progressContainer.innerHTML = '';

            // 새로운 프로그래스 바 생성 및 적용
            data.forEach((entry, index) => {
                var progressBarDiv = document.createElement('div');
                progressBarDiv.classList.add('progress-bar');
                
                var progressBarInnerDiv = document.createElement('div');
                progressBarInnerDiv.classList.add('progress-bar-inner');
                progressBarInnerDiv.style.width = (entry.value * 20) + '%'; // 데이터를 퍼센트로 변환하여 적용
                progressBarInnerDiv.innerHTML = '<div style="width: 500px; width:420px; display: flex; align-items: center; margin-left: 20px; margin-top:10px;">' +
                '<span style="font-size: 20px; font-weight: bold; text-align: center;">' + entry.label + '</span>' +
                '<span style="font-weight: bold; text-align: right; flex-grow: 1;">' + entry.value + '</span>' +
                '</div>';
                    // g_content값을 직접 프로그래스 바 내용으로 설정
                
                progressBarDiv.appendChild(progressBarInnerDiv);
                progressContainer.appendChild(progressBarDiv);
            });
        },
        error: function (xhr, status, error) {
            console.error("AJAX Error: " + error);
        }
    });
}


		    // 페이지 로드 후 프로그래스 바 업데이트 실행
		    $(document).ready(function () {
		        progressbar();
		    });



		        // 평점 삭제
		        $("div.alist").on("click", ".delete-button", function(event) {
		        	event.preventDefault(); // 버튼 기본 동작 중지
		        	var g_num = $(this).data("gnum"); // 평점의 g_num을 가져오기
		        	var g_myid = $(this).data("gmyid");// 평점의 g_myid을 가져오기
		        	
		        	 var confirmation = confirm(g_myid+"님의 평점을 삭제하시겠습니까?");
		        	 if (confirmation) {
		            $.ajax({
		                type: "post",
		                url: "grade/deletegrade.jsp",
		                dataType: "html",
		                data: {"g_num": g_num}, // g_num을 사용하여 데이터를 전송
		                success: function() {
		                    alert("정상적으로 삭제되었습니다.");
		                    updateH_grade();
		                    progressbar();
		                    list();
		                },
		                error: function(xhr, status, error) {
		                    console.error("AJAX Error: " + error);
		                }
		            });
		        } else {
		            // 취소 버튼을 누르면 아무런 작업을 하지 않습니다.
		            return;
		        }
		    });

			
		
		  var login = "<%=loginok%>";
		  var g_myid=$("#g_myid").val();
	      //alert(g_myid); 
		        
		// 특정 휴게소의 평점 목록
		    function list(sortType){
		    	if (!sortType) {
		            sortType = "latest";
		        }
		
			  	  $.ajax({ 
			  		  type:"get",
			  		  url:"grade/gradelist.jsp",
			  		  dataType:"json",
			  		  data:{"h_num":$("#h_num").val(),"sortType": sortType},
			  		  success:function(res){
			  			  //평점갯수출력
			  			  $("b.gradesu>span").text(res.length);
			  			  
			  			  var s="";
			  			  $.each(res,function(idx,item){
			  				  
			  				  //평점에 따라 별표시 추가
			  				  var starsHTML = "";
			  				  for(var i=5;i>0;i--){
			  					  if(i<=item.g_grade){
			  						  starsHTML +="<span class='star'id='g_grade' style='color:gold;'>★</span>";
			  					  }else{
			  						 starsHTML +="<span class='star-empty' id='g_grade' style='color:lightgray;'>★</span>";
			  					  }
			  					  
			  				  }
			  				s += "<hr>";
			  				  s += "<div style='display: flex; align-items: center; justify-content: space-between;'>";
			  				
			  				s += "<div>";
			  				s += "<span class='star-rating' id='g_grade' style= 'margin-left:40px;'>" + item.g_grade + starsHTML + "</span>";
			  				s += "<span class='aday' style= 'margin-left:25px; font-size:18px;'>" + item.g_myid + " · " + item.g_writeday + "</span>";
			  				s += "</div>";
			  				s += "<div class='gradecontent'style='margin-top: 10px; font-size:20px;'>" + item.g_content + "</div>";
			  				s += "<div class='delete-button-wrapper'>";
			  				s += "<button class='delete-button' data-gnum='" + item.g_num + "' data-gmyid='" + item.g_myid + "'><i class='bi bi-x-lg'></i></button>";
			  				s += "</div>";
			  				s += "</div>";

			                 
			  			});
			              $("div.alist").html(s);
			              
			              // 관리자가 아니거나 로그인 상태가 아닐 경우 삭제 버튼 숨기기
			              if (login == "null" || g_myid !== "admin") {
			                  $(".delete-button-wrapper").hide();
			                  //$(".delete-button-wrapper").append("<div><button></button></div>");
			              }
			              
			              updateH_grade();
			  		  },
			  		  error: function(xhr, status, error) {
			  	            console.error("AJAX Error: " + error);
			  	        }
			  		  
			  	  });
			    } 
	
		

	

		
	
	
	
  $(".brand").click(function() {
      $(this).toggleClass("active-color");
});

	
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
        event.preventDefault(); // 버튼의 기본 동작인 폼 전송 방지
        $('#hiddenButtons').slideToggle(); // 숨겨진 버튼들을 토글하여 나타나거나 사라지게 함
    });
});



$(".writegrade").click(function(){
//document.querySelector('.food-item').addEventListener('click', function() {
    // 버튼을 클릭했을 때 실행될 코드
    document.querySelectorAll('.food-item').forEach(image => {
    	 image.addEventListener('click', function() {
    		 showPopup(image, image.getAttribute('data-fnum')); // 클로저를 사용하여 image와 f_num 값을 전달
    });
});
});

function showPopup(image, fg_foodnum) {
    // 이미지를 검정 사각형으로 변하도록 클래스를 추가
    image.classList.toggle('selected');

    
    if (fg_foodnum) {
    	//alert(fg_foodnum);
        // 해당 음식번호가 존재하면 팝업 표시
        showPopup2();
    } else {
        console.error('해당 음식번호가 존재하지 않습니다.');
    }
}


   
function showPopup2() {
    const popup = document.querySelector('#popup');
    popup.classList.remove('has-filter');
    popup.classList.remove('hide');
}



 function updateF_grade(fg_foodnum) {
	    //console.log("fg_foodnum:", fg_foodnum);
	    $.ajax({ 
	        type: "post",
	        dataType: "html",
	        data: {
	            "h_num": $("#h_num").val(),
	            "f_num": fg_foodnum
	        },
	        url: "foodgrade/updatef_grade.jsp",
	        success: function(res) {
	            // 서버에서 응답으로 받은 평균 평점을 사용하여 업데이트
	            //$(".avggrade2").text(res); // 평균 평점을 페이지에 업데이트
	        	location.reload();
	        },
	        error: function(xhr, status, error) {
	            console.error("AJAX Error: " + error);
	        }
	    });
	}



/* 등록 버튼 클릭 시 음식평점 남기기 */
$("#btnsendfood").click(function(){
    var fg_grade = $("input[name='fg_grade']:checked").val(); // 선택된 평점 값 가져오기
    const fg_foodnum = $(".food-item.selected").attr("data-fnum"); // 선택된 음식 번호 가져오기
    if (!fg_grade) { // 선택된 평점이 없을 경우
        alert("평점을 선택해주세요");
        return;
    }
    
    $.ajax({
        type: "post", 
        dataType: "html",
        data: {"fg_hugesonum": $("#h_num").val(),
        	   "fg_foodnum": fg_foodnum,
        	   "fg_myid": $("#g_myid").val(),
        	   "fg_grade": fg_grade}, 
        url: "foodgrade/insertfoodgrade.jsp",	   
        success: function(){
            //$("#insertfoodgrade").hide(); // 평점 등록 시 숨김
       
            //updateH_grade();
            
            //alert("평점등록 완료!!!");
           
           resetStarRating();
            $("#popup").hide(); 
            //location.reload();
            updateF_grade(fg_foodnum);
            //closePopup();
            
         },
        error: function(xhr, status, error) {
            // 오류 발생 시 처리
            console.error("AJAX Error: " + error);
        }
            
    });
    
    });

  window.onload = function() {
    // 모든 .food-item 요소를 선택
    var foodItems = document.querySelectorAll('.food-item');

    // 각 요소에 대해 반복
    foodItems.forEach(function(item) {
        // 해당 요소의 f_grade 값을 가져옴
        var grade = parseFloat(item.querySelector('.avggrade2').textContent);
        
        // 만약 f_grade가 0.0이라면
        if (grade === 0.0) {
            // 해당 요소의 .starrating div를 숨김
            item.querySelector('.starrating').style.display = 'none';
        }
    });
};


// 휴게소 평점 정렬
$(document).ready(function() {
    $('#sortByLatest').click(function(event) {
        list('latest');
    });

    $('#sortByHigh').click(function(event) {
        list('high');
    });

    $('#sortByLow').click(function(event) {
        list('low');
    });
});



//휴게소 평점 정렬
$(document).ready(function() {
    $('#foodLatest').click(function(event) {
    	sortFood('latest');
    });

    $('#foodHigh').click(function(event) {
        sortFood('high');
    });

    $('#foodLow').click(function(event) {
        sortFood('low');
    });
});


function updateFoodSort(html) {
    // 푸드코트를 비우고, 서버에서 받은 HTML로 채웁니다.
    $("#home .food-item").remove(); // 기존 음식 아이템 삭제
    $("#home").append(html); // 정렬된 음식 목록 추가
}


function sortFood(sortType) {
    $.ajax({
    	type:"get",
		  url:"foodgrade/foodgradesort.jsp",
		  dataType:"html",
		  data:{"h_num":$("#h_num").val(),"sortType": sortType},
		  success:function(html){
			  updateFoodSort(html);
        },
        error: function(xhr, status, error) {
            // 요청 실패 시의 처리
            console.error("Error:", status, error);
        }
    });
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
	<a href="index.jsp?main" class="home"><!-- <i class="bi bi-house-door-fill"> --></i></a>

<div class="one" style="display:flex;">
<a href="#" class="h_loc"></a>
</div>
<div class="two">
<a href="#" class="h_loc"></a>
</div>
<div class="three">
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
<% }%>&nbsp;
<% if (ffdto.getF_name() != null) { %>
    #<%= ffdto.getF_name() %>
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



<button type="button" id="foodLatest">최신순</button>
<button type="button" id="foodHigh">평점높은순</button>
<button type="button" id="foodLow">평점낮은순</button>


<button type="button" class="writegrade"><i class="bi bi-pencil"></i>평점남기기</button>

  <div id="popup" class="hide">
  <div class="content">
  

  <div class="gradecontent2">
    <p>
      <div class="star-rating space-x-4 mx-auto" id="fg_grade">
    <input type="radio" id="fg_5-stars" name="fg_grade" value="5" v-model="fg_ratings" />
    <label for="fg_5-stars" class="star pr-4">★</label>
    <input type="radio" id="fg_4-stars" name="fg_grade" value="4" v-model="fg_ratings" />
    <label for="fg_4-stars" class="star">★</label>
    <input type="radio" id="fg_3-stars" name="fg_grade" value="3" v-model="fg_ratings" />
    <label for="fg_3-stars" class="star">★</label>
    <input type="radio" id="fg_2-stars" name="fg_grade" value="2" v-model="fg_ratings" />
    <label for="fg_2-stars" class="star">★</label>
    <input type="radio" id="fg_1-star" name="fg_grade" value="1" v-model="fg_ratings" />
    <label for="fg_1-star" class="star">★</label>
</div>

    </p>
    <button type="button" id="btnsendfood" class="prebtn">등록</button>
  </div>
  </div>
</div>


<div class="container mt-3 food">
  <!-- Nav pills -->
  <ul class="nav nav-pills" role="tablist">
    <li class="nav-item">
      <a class="nav-link active" data-bs-toggle="pill" href="#home" >푸드코트</a>
    </li>
    <li class="nav-item">
      <a class="nav-link" data-bs-toggle="pill" href="#menu1" >브랜드</a>
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
        String f_num = fdto.getF_num();
        String f_grade = fdto.getF_grade();
        count++; // 이미지가 추가될 때마다 개수 증가

        // 이미지 출력
    %>
        <div class="food-item" style="display: <%= count <= 4 ? "inline-block" : "none" %>; 
        text-align:center; font-weight:bold; margin-bottom: 20px;margin-right:20px; cursor:pointer;" data-fnum="<%=f_num%>">
            <img alt="<%=f_name%>" src="image/food/<%=f_photo%>"  
            style="width: 220px; height:200px;  margin-bottom:15px;" data-fnum="<%=f_num%>"><br>
     <div style="display: inline-block;" class="starrating">
    <label style="-webkit-text-fill-color: gold; font-size: 15px;">★</label>
    <p class="avggrade2" style="font-weight:bold; font-size:15px; display: inline-block;">
    <%=f_grade %></p></div> <%=f_name%>
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
                String f_num = fdto.getF_num();
                String f_grade = fdto.getF_grade();
            %>
                <div class="food-item"  style="display: inline-block;
                text-align:center; font-weight:bold; margin-bottom: 20px;margin-right:20px; cursor:pointer;" data-fnum="<%=f_num%>">
                    <img alt="<%=f_name%>" src="image/food/<%=f_photo%>"  
                    style="width: 220px; height:200px;  margin-bottom:15px;" data-fnum="<%=f_num%>"><br>
                    <div style="display: inline-block;" class="starrating">
    <label style="-webkit-text-fill-color: gold; font-size: 15px;">★</label>
    <p class="avggrade2" style="font-weight:bold; font-size:15px; display: inline-block;">
    <%=f_grade %></p></div><%=f_name%>
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
            <div class="brand-item" style="display: <%= count1 <= 4 ? "inline-block" : "none" %>; text-align:center; font-weight:bold; margin-bottom: 20px; margin-right:20px;">
                <a href="<%=b_addr %>">
                <img alt="<%=b_name %>" src="image/brand/<%=b_photo %>" 
                style="width: 220px; height:200px;  margin-bottom:15px; cursor:pointer;"></a>
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
                    <div class="brand-item" style="display: none; margin-right:20px;">
                     <a href="<%=b_addr %>">
                        <img alt="<%=b_name %>" src="image/brand/<%=b_photo %>" 
                        style="width: 220px; height:200px;  margin-bottom:15px; cursor:pointer;" ></a>
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

<div style="text-align: center; margin-top: 30px;">
    <button id="moreButton1" style="border: none; background: none; cursor: pointer;">
        <i class="bi bi-chevron-down" style="font-size:30px;"></i>
    </button>
    <button id="foldButton1" style="display: none; border: none; background: none; cursor: pointer;">
        <i class="bi bi-chevron-up" style="font-size:30px;"></i>
    </button>
</div>

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
    <td>휘발유</td>
    <td><%= "없음".equals(dto.getH_gasolin()) ? "-" : dto.getH_gasolin() %>원</td>
</tr>
<tr>
    <td>경유</td>
    <td><%= "없음".equals(dto.getH_disel()) ? "-" : dto.getH_disel() %>원</td>
</tr>
<tr>
    <td>LPG</td>
    <td><%= "없음".equals(dto.getH_lpg()) ? "-" : dto.getH_lpg() %>원</td>
</tr>

</table>
<div style="font-size:16px; font-weight:bold; color: gray; text-align:center; margin-bottom:100px;">본 정보는 특정 시점에 수집되어 실제 가격과 다를 수 있습니다.
[제공&nbsp;<span style="color:#0897B4;">한국도로공사]</span></div>
</div>


<div class="contain">

<p class="subtitle">평점</p>

<button type="button" id="sortByLatest">최신순</button>
<button type="button" id="sortByHigh">평점높은순</button>
<button type="button" id="sortByLow">평점낮은순</button>
<div class="gradearea2"style="display: flex; justify-content: center; margin-left:10%;">
<div style="display: inline-block;" class="starrating">
    <label style="-webkit-text-fill-color: gold; font-size: 5rem;">★</label>
    <p class="avggrade3" style="font-weight:bold; font-size:50px; display: inline-block; margin-top: -30px;">
        <%-- <%=dto.getH_grade() %> --%>
    </p>
</div> 


<!-- 프로그래스 바 -->
<div id="progress-container" style="flex-grow: 1;margin-left: 300px;"></div>
</div>


 <table style="width:80%; margin-left:75px;">
     <!-- 평점 -->
     <tr>
       <td>  
        
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
   <div id="g_content" style="display: inline-flex; width:1000px;">
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
  <b class="gradesu" style="text-align:left;">평점&nbsp;<span>0</span>건  </b>
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
<button type="button" onclick="location.href='index.jsp?main=hugesoinfo/hugesoupdateform.jsp?h_num=<%=h_num %>'" >수정</button> 
<button type="button" onclick="location.href='hugesoinfo/hugesodeleteaction.jsp?h_num=<%=h_num %>'">삭제</button> 
</div>

</div>



</div>
</div>
</form> 
</body>
</html>