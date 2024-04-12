<%@page import="java.util.List"%>
<%@page import="java.util.HashMap"%>
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


.favorite{
	display: inline-block; 
	float:right;
	vertical-align: top;
	background-color:white;
	border:white;
}

.red{
	color: #FFE400;
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
	String f_num=mdao.f_numData(m_num, h_num);
	int fav=mdao.isFavorite(m_num, h_num);
%>

<script type="text/javascript">

$(function(){
	
$(".brand").click(function() {
    $(this).toggleClass("active-color");
});

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

<body>
<div style="margin: 100px 100px;">

<div id="titlearea">
			<h4>휴게소 상세정보</h4>
			<hr>
		</div>

<form id="frm">
<input type="hidden" name="h_num" value="<%=h_num%>" id="h_num">
<input type="hidden" name="m_num" value="<%=m_num%>" id="m_num">
<input type="hidden"  class="f_num"  f_num="<%=f_num %>">

<div style="float:left; margin-top:50px;">
<img alt="" src="image/hugeso/<%=dto.getH_photo()%>" style="width:600px; height:400px;">
</div>

<div style="padding-bottom: 200px; padding-top: 50px; margin-left:50%;">


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


<div style="float:left; width: 500px; height:600px;">



<!-- 브랜드 출력  -->
<% 
String brands = dto.getH_brand();
String[] brandArray = brands.split(",");
for(String brand : brandArray){%>
	<button type="button" class="btn btn-success brand" style="width:110px; height:50px;">
	<% out.println(brand); %>
	</button> 
 <%} %><br>
 
 
 
<%=dto.getH_sangphoto() %>

<!-- 상품이름 출력 -->
<%
String sangnames =  dto.getH_sangname();
String[] sangArray = sangnames.split(",");
for(String sangname : sangArray){%>
	<span style="margin-left:20px;"><% out.println(sangname); %></span>
<%}%><br>

<!-- 상품가격 출력 -->
<%
String prices =  dto.getH_sangprice();
prices = prices.replaceAll("\\{", "").replaceAll("\\}", ""); // {와 }를 제거하여 숫자만 남김
String[] priceArray = prices.split(","); // 쉼표를 기준으로 문자열 분할
for(String price : priceArray){
	 out.println(price+"원");
}%>

</div>

<div style="position:relative; margin-left:50%;">
<h5>주유소/충전소</h5>
<table class="table">
<tr>
<th >유종</th>
<th >가격</th>
</tr>
<tr>
<td >휘발유</td>
<td ><%=dto.getH_gasolin() %>원</td>
</tr>
<tr>
<td >경유</td>
<td ><%=dto.getH_disel() %>원</td>
</tr>
<tr>
<td >LPG</td>
<td><%=dto.getH_lpg() %>원</td>
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