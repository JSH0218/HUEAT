<%@page import="hugesoinfo.model.HugesoInfoDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
	<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
	<link href="https://fonts.googleapis.com/css2?family=Nanum+Gothic&display=swap" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.7.0.js"></script>
	<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=b71304786948cbe7995d40be3007bd8e"></script>
<title>Insert title here</title>
	<style type="text/css">
		#area{
			margin-top: 20px;
			margin-bottom: 20px;
		}
		
		#titlearea{
			text-align: center;
			margin-top: 100px;
			margin-bottom: 40px;
		}
		
		#titlearea hr{
			margin: 0 auto;
			width: 10%;
		}
		
		#contentarea{
			padding-left: 25%;
			padding-right: 25%;
			margin-bottom: 80px;
		}
		
		#map{
        	max-width: 800px; /* 지도 최대 너비 설정 */
        	height: 640px;
        	margin: 0 auto 40px auto;
		}
		
		div.infowindow div{
			text-align: center;
			width: 210px;
		}
		
		div.infowindow div img{
			width: 210px;
		}
		
		#searcharea{
			margin-bottom: 20px;
			display: flex;
			align-items: center;
			justify-content: right;
		}
		
		#searcharea input{
			margin-right: 5px;
		}
		
		#searcharea button{
			background-color: #618E6E;
		}
		
		table.table th, table.table td{
		    text-align: center; /* 가운데 정렬 */
		    vertical-align: middle; /* 수직 정렬 */
		    border : 2px solid lightgray;
		    border-collapse: collapse;
		}
		
		table th:first-child,
		table td:first-child {
			border-left: 0;
		}
		table th:last-child,
		table td:last-child {
			border-right: 0;
		}
		
		.line{
			border-top: 3px solid darkgray;
			border-bottom: 3px solid darkgray;
		}
		
		a:link{
			color : black;
			text-decoration: none;
		}
		
		a:visited {
			color : black;
			text-decoration: none;
		}
		
		a:hover{
			color: #0897B4;
		}
		
		a:active{
			color: black;
		}
		
		ul{
			cursor: pointer;
		}

	</style>
	<script>
		$(function(){
			var map=createMap();
			
			showCurrentPosition(map);
			
			hugesoMarking(map);
			
			getPagingList(1);
		});
		
		// 지도생성
		function createMap(){
			var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
		    mapOption = { 
		        center: new kakao.maps.LatLng(33.450701, 126.570667), // 지도의 중심좌표
		        level: 13 // 지도의 확대 레벨
		    };

			// 지도를 표시할 div와  지도 옵션으로  지도를 생성합니다
			var map = new kakao.maps.Map(mapContainer, mapOption);
			
			return map;
		}
		
		//현재위치 표기
		function showCurrentPosition(map){
			// HTML5의 geolocation으로 사용할 수 있는지 확인합니다 (현재위치파악) 
			if (navigator.geolocation) {
			    
			    // GeoLocation을 이용해서 접속 위치를 얻어옵니다
			    navigator.geolocation.getCurrentPosition(function(position) {
			        
			        var lat = position.coords.latitude, // 위도
			            lon = position.coords.longitude; // 경도
			        
			        var locPosition = new kakao.maps.LatLng(lat, lon), // 마커가 표시될 위치를 geolocation으로 얻어온 좌표로 생성합니다
			            message = '<div>현재위치</div>'; // 인포윈도우에 표시될 내용입니다
			            
			     	// 마커를 생성합니다
			        var marker = new kakao.maps.Marker({  
			            map: map, 
			            position: locPosition,
			            zIndex: 9999
			        }); 
			        
			        var iwContent = message, // 인포윈도우에 표시할 내용
			            iwRemoveable = true;

			        // 인포윈도우를 생성합니다
			        var infowindow = new kakao.maps.InfoWindow({
			            content : iwContent,
			            removable : iwRemoveable
			        });
			        
			        // 인포윈도우를 마커위에 표시합니다 
			        infowindow.open(map, marker);
			        
			        // 지도 중심좌표를 접속위치로 변경합니다
			        map.setCenter(locPosition);
			            
			      });
			    
			}
		}
		
		// 지도에 휴게소 마킹
		function hugesoMarking(map){
			$.ajax({
	        	type:"get",
	        	url:"hugesoinfo/mapaction.jsp",
	        	dataType:"json",
	        	success:function(res){
	        		
	        		$.each(res,function(i,elt){
	        				        			
	        			var locPosition = new kakao.maps.LatLng(elt.h_yvalue, elt.h_xvalue),
			            	message = '<div class="infowindow"><div><img src=image/hugeso/'+elt.h_photo+'></div><div>'+elt.h_name+'</div></div>'; // 인포윈도우에 표시될 내용입니다
			            
			            var imageSrc = 'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/markerStar.png', // 마커이미지의 주소입니다    
			                imageSize = new kakao.maps.Size(24, 35); // 마커이미지의 크기입니다
			                
			            // 마커의 이미지정보를 가지고 있는 마커이미지를 생성합니다
			            var markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize)
			            
	        			// 마커를 생성합니다
				        var marker = new kakao.maps.Marker({  
				            map: map, 
				            position: locPosition,
				            image: markerImage // 마커이미지 설정 
				        });

				        // 인포윈도우를 생성합니다
				        var infowindow = new kakao.maps.InfoWindow({
				            content : message
				        });
				        
				        //마커에 마우스 호버에 따른 인포윈도우 표기
				        kakao.maps.event.addListener(marker, 'mouseover', makeOverListener(map, marker, infowindow));
				        kakao.maps.event.addListener(marker, 'mouseout', makeOutListener(infowindow));
				     	// 마커에 클릭이벤트를 등록합니다
				        kakao.maps.event.addListener(marker, 'click', function() {
				        	location.href="index.jsp?main=hugesoinfo/hugesodetail.jsp?h_num="+elt.h_num;
				        });
	        		});	        		
	        	}
	        });
		}
		
		// 인포윈도우를 표시하는 클로저를 만드는 함수입니다 
		function makeOverListener(map, marker, infowindow) {
		    return function() {
		        infowindow.open(map, marker);
		    };
		}

		// 인포윈도우를 닫는 클로저를 만드는 함수입니다 
		function makeOutListener(infowindow) {
		    return function() {
		        infowindow.close();
		    };
		}
		
		//검색기능
		function serachHugesoInfo(h_name){
			$.ajax({
				type:"get",
				url:"hugesoinfo/searchaction.jsp",
				dataType:"json",
				data:{"h_name":h_name},
				success:function(res){
					if(res.length){
						var s="<table class='table'>";
						s+="<thead>";
		        		s+="<tr class='line'><th style='width: 30%; background-color: #DFE8E2;'>휴게소이름</th><th style='width: 40%; background-color: #DFE8E2;'>주소</th><th style='width: 30%; background-color: #DFE8E2;'>번호</th></tr>";
		        		s+="</thead>";
		        		s+="<tbody>";
		        		
		        		$.each(res,function(i,elt){
		        			s+="<tr><td><a href='index.jsp?main=hugesoinfo/hugesodetail.jsp?h_num="+elt.h_num+"'>"+elt.h_name+"</a></td><td>"+elt.h_addr+"</td><td>"+elt.h_hp+"</td></tr>";
		        		});
		        		
		        		s+="</tbody>";
		        		s+="</table>";
					} else{
						var s="검색결과가 없습니다";
					}
	        		
	        		$("#tablearea").html(s);
	        		
	        		$("#pagenumarea").html("");
				}
			});
		}
		
		function getPagingList(currentPage){
			var currentPage=currentPage; //현재페이지번호
			$.ajax({
				type:"get",
				url:"hugesoinfo/hugesopaging.jsp",
				dataType:"json",
				data:{"currentPage":currentPage},
				success:function(res){
					var s="<table class='table'>";
					s+="<thead>";
	        		s+="<tr class='line'><th style='width: 30%; background-color: #DFE8E2;'>휴게소이름</th><th style='width: 40%; background-color: #DFE8E2;'>주소</th><th style='width: 30%; background-color: #DFE8E2;'>번호</th></tr>";
	        		s+="</thead>";
	        		s+="<tbody>";
	        		
					$.each(res,function(i,elt){
	        			
	        			s+="<tr><td><a href='index.jsp?main=hugesoinfo/hugesodetail.jsp?h_num="+elt.h_num+"'>"+elt.h_name+"</a></td><td>"+elt.h_addr+"</td><td>"+elt.h_hp+"</td></tr>";
	        		});
					
					s+="</tbody>";
					s+="</table>";
	        		
	        		$("#tablearea").html(s);
	        		
	        		<%
	        			HugesoInfoDao dao=new HugesoInfoDao();
	        		%>
	        		var totalCount=<%=dao.getTotalCount() %>; //전체데이터수
	        		var perPage=5; //한페이지당 보여질 글의 갯수
	        		var perBlock=5; //한블럭당 보여질 페이지 갯수
	        		var startNum; //db에서 가져올 글의 시작번호(mysql은 첫글이0번,오라클은 1번);
	        		var startPage; //각블럭당 보여질 시작페이지
	        		var endPage; //각블럭당 보여질 끝페이지
	        		var totalPage; //총페이지수
	        		var no; //각페이지당 출력할 시작번호
	        		
	        		//총페이지수 구한다
	        		//총글갯수/한페이지당보여질갯수로 나눔(7/5=1)
	        		//나머지가 1이라도 있으면 무조건 1페이지 추가(1+1=2페이지가 필요)
	        		totalPage=totalCount/perPage+(totalCount%perPage==0?0:1);

	        		//각블럭당 보여질 시작페이지
	        		//perBlock=5일경우 현재페이지가 1~5일경우 시작페이지가1,끝페이지가 5
	        		//현재가 13일경우 시작:11 끝:15
	        		var startPage=Math.floor((currentPage-1)/perBlock)*perBlock+1;
	        		endPage=startPage+perBlock-1;

	        		//총페이지가 23일경우 마지막블럭은 끝페이지가 25가 아니라 23
	        		if(endPage>totalPage)
	        			endPage=totalPage;

	        		//각페이지에서 보여질 시작번호
	        		//1페이지:0, 2페이지:5 3페이지: 10.....
	        		startNum=(currentPage-1)*perPage;

	        		//각페이지당 출력할 시작번호 구하기
	        		//총글개수가 23  , 1페이지:23 2페이지:18  3페이지:13
	        		no=totalCount-(currentPage-1)*perPage;

	        		//각페이지당 출력할 시작번호 구하기
	        		//총글개수가 23  , 1페이지:23 2페이지:18  3페이지:13
	        		no=totalCount-(currentPage-1)*perPage;
	        		
	        		//alert("startPage:"+startPage+"\n(currentPage-1)/perBlock:"+Math.floor((currentPage-1)/perBlock));
	        			        		
	        		var s="<ul class='pagination justify-content-center'>";
	        		
	        		//이전
	        		if(startPage>1){
	        			s+="<li class='page-item'>";
	        			s+="<a class='page-link' onclick='getPagingList("+(parseInt(startPage)-1)+")' style='color: black;'>이전</a>";
	        			s+="</li>";
	        		}
	        		
	        		//페이지번호
	        		for(var pp=startPage;pp<=endPage;pp++){
	        			if(pp==currentPage){
	        				s+="<li class='page-item active'>";
	        				s+="<a class='page-link' onclick='getPagingList("+pp+")'>"+pp+"</a>";
	        				s+="</li>";
	        			}else{
	        				s+="<li class='page-item'>";
	        				s+="<a class='page-link' onclick='getPagingList("+pp+")'>"+pp+"</a>";
	        				s+="</li>";
	        			}
	        		}
	        		
	        		//다음
	        		if(endPage<totalPage){
	        			s+="<li class='page-item'>";
	        			s+="<a  class='page-link' onclick='getPagingList("+(parseInt(endPage)+1)+")' style='color: black;'>다음</a>";
	        			s+="</li>";
	        		}
	        		
	        		s+="</ul>";
	        		
	        		$("#pagenumarea").html(s);
				}
			});
		}
	</script>
</head>
<body>
	<div id="area">
		<div id="titlearea">
			<h4>휴게소찾기</h4>
			<hr>
		</div>
		<div id="contentarea">
			<div id="map"></div>
			<div id="searcharea">
				<input type="text" id="searchH_name">
				<button type="button" class="btn btn-success btn-sm" onclick="serachHugesoInfo($('#searchH_name').val())">검색</button>
			</div>
			<div id="listarea">
				<div id="tablearea"></div>
			</div>
		</div>
		<div id="pagenumarea"></div>
	</div>
</body>
</html>