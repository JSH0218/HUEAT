<%@page import="review.model.ReviewDto"%>
<%@page import="review.model.ReviewDao"%>
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
   <script src="https://code.jquery.com/jquery-3.7.0.js"></script>
   <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<title>HUEAT</title>
<style type="text/css">

body{
font-family: 'Nanum Gothic';
}

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


#favorite{
	display: inline-block; 
	float:right;
	vertical-align: top;
	background-color:white;
	border:white;
}

.nav-pills .nav-link.active{
	background-color:#618E6E;
}
</style>
</head>
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
	
	FavoriteDto fdto = new FavoriteDto();
	
	ReviewDao rdao = new ReviewDao();
	
    
%>


<script type="text/javascript">

$(document).ready(function() {
	

$(".brand").click(function() {
    $(this).toggleClass("active-color");
});



//초기 즐겨찾기 상태 가져오기
$(document).ready(function() {
    checkFavoriteStatus();
});

// 즐겨찾기 상태를 가져오고 버튼 색상을 업데이트하는 함수
function checkFavoriteStatus() {
    $.ajax({
        type: "get",
        url: "hugesoinfo/checkfavorite.jsp", // 해당 URL은 실제로 구현되어야 합니다.
        dataType: "json", // 즐겨찾기 상태를 JSON 형식으로 반환하는 것을 가정합니다.
        success: function(response) {
            // 즐겨찾기 상태에 따라 버튼 색상 업데이트
            isFavorite = response.isFavorite;
            updateButtonColor();
        },
        error: function(xhr, status, error) {
            // 오류 처리
            console.error("오류 발생: " + error);
        }
    });
}

// 버튼 클릭 시 즐겨찾기 추가 또는 삭제 요청 보내기
$("#favorite").click(function(){
    var login = "<%=loginok%>";
    
    if(login === "null"){
        alert("로그인이 필요한 서비스입니다.");
        return;
    }

    if (isFavorite) {
        del(<%=fdto.getF_num()%>);
    } else {
        toggleFavorite();
    }
});

// 즐겨찾기 추가 요청을 보내는 함수
function toggleFavorite() {
    var f_data=$("#frm").serialize();
  
    $.ajax({
        type: "post",
        dataType: "html",
        data: f_data,
        url: "hugesoinfo/insertfavorite.jsp",
        success: function(response) {
            // 성공 시 즐겨찾기 상태 업데이트 및 버튼 색상 변경
            isFavorite = true;
            updateButtonColor();
        },
        error: function(xhr, status, error) {
            // 오류 처리
            console.error("오류 발생: " + error);
        }
    });
}

// 즐겨찾기 삭제 요청을 보내는 함수
function del(f_num) {
    $.ajax({
        type: "get",
        url: "hugesoinfo/deletefavorite.jsp",
        dataType: "html",
        data: {"f_num": f_num},
        success: function(response) {
            // 성공 시 즐겨찾기 상태 업데이트 및 버튼 색상 변경
            isFavorite = false;
            updateButtonColor();
        },
        error: function(xhr, status, error) {
            // 오류 처리
            console.error("오류 발생: " + error);
        }
    });
}

// 버튼 색상을 업데이트하는 함수
function updateButtonColor() {
    var icon = $("#favorite i");
    if (isFavorite) {
        icon.css("background-color", "yellow");
    } else {
        icon.css("background-color", "white");
    }
}






	//변수 선언
	var gasolin = parseInt(<%=dto.getH_gasolin()%>); // 휘발유 가격 데이터
	var diesel = parseInt(<%=dto.getH_disel()%>); // 경유 가격 데이터
	var lpg = parseInt(<%=dto.getH_lpg()%>); // LPG 가격 데이터

    // 숫자에 천 단위 콤마 추가하는 함수
    function insertCommas(x) {
        return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
    }

</script>



<body>
<div style="margin: 100px 100px;">

<div id="titlearea">
			<h4>휴게소 상세정보</h4>
			<hr>
		</div>

<form id="frm">
<input type="hidden" name="h_num" value="<%=h_num%>">
<input type="hidden" name="m_num" value="<%=m_num%>">

<!-- 휴게소 사진 -->
<div style="float:left; margin-top:50px;">
<img alt="" src="image/hugeso/<%=dto.getH_photo()%>" style="width:600px; height:400px;">
</div>


<div style="padding-bottom: 150px; padding-top: 80px; position: relative; left:4%;">

<!-- 휴게소 이름 출력 -->
<div style="font-size: 45px; font-weight:bold; margin-bottom: 20px; display: inline-block;">
<%=dto.getH_name()%> 
</div>


<!-- 즐겨찾기 버튼 -->
<button type="button" id="favorite" style="position:relative; left:-200px; top:-50px;">
<i class="bi bi-bookmark" style=" font-size:200%;"></i>
</button>

<!-- 휴게소 평점 출력 -->
<div style="font-size: 20px; margin-bottom: 20px; ">
3.8 <%=dto.getH_grade() %>

<% 
int i=0;
for(i=0;i<5;i++){%>
   <i class="bi bi-star"></i>
<%} %>

(<%=dto.getH_gradecount() %>)
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
        		 %><img src="../image/pyeon/1.jpg" alt="수면실" width="5%" height="5%"><%
        	 break;
        	 }
        	 case "샤워실":{
        		 %><img src="../image/pyeon/2.jpg" alt="샤워실"  width="5%" height="5%"><%
        				 break;
        	 }
        	 case "세탁실":{
        		 %><img src="../image/pyeon/3.jpg" alt="세탁실"  width="5%" height="5%"><%
        				 break;
        	 }
        	 case "세차장":{
        		 %><img src="../image/pyeon/4.jpg" alt="세차장"  width="5%" height="5%"><%
        				 break;
        	 }
        	 case "경정비":{
        		 %><img src="../image/pyeon/5.jpg" alt="경정비"  width="5%" height="5%"><%
        				 break;
        	 }
        	 case "수유실":{
        		 %><img src="../image/pyeon/6.jpg" alt="수유실"  width="5%" height="5%"><%
        				 break;
        	 }
        	 case "쉼터":{
        		 %><img src="../image/pyeon/7.jpg" alt="쉼터"  width="5%" height="5%"><%
        				 break;
        	 }
        	 case "ATM":{
        		 %><img src="../image/pyeon/8.jpg" alt="ATM"  width="5%" height="5%"><%
        				 break;
        	 }
        	 case "매점":{
        		 %><img src="../image/pyeon/9.jpg" alt="매점"  width="5%" height="5%"><%
        				 break;
        	 }
        	 case "약국":{
        		 %><img src="../image/pyeon/10.jpg" alt="약국"  width="5%" height="5%"><%
        				 break;
        	 }
        	 default:{ /* 기타 */
        		 %><img src="../image/pyeon/11.jpg" alt="기타"  width="5%" height="5%"><%
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




<!-- <b style="color:gray; font-size">조회</b> -->

</form>
</div>

 
</body>
</html>