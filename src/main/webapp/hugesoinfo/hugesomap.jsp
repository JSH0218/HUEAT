<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link href="https://fonts.googleapis.com/css2?family=Nanum+Brush+Script&family=Nanum+Pen+Script&family=Noto+Sans+KR:wght@100..900&family=Noto+Serif+KR&family=Stylish&display=swap" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
<link href="https: //fonts.googleapis.com/css2?family=Nanum+Gothic&display=swap" rel="stylesheet">
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
		
		div.infowindow{
			text-align: center;
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
		
		table tr:nth-child(1) th{
			background-color: #dfdfdf;
			text-align: center;
		}
		
		table tr td:nth-child(1){
			cursor: pointer;
		}
		
		table tr td{
			font-size: 14px;
		}

	</style>
	<script>
		$(function(){
			var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
		    mapOption = { 
		        center: new kakao.maps.LatLng(33.450701, 126.570667), // 지도의 중심좌표
		        level: 13 // 지도의 확대 레벨
		    };

			// 지도를 표시할 div와  지도 옵션으로  지도를 생성합니다
			var map = new kakao.maps.Map(mapContainer, mapOption);
			
			// HTML5의 geolocation으로 사용할 수 있는지 확인합니다 
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
			            position: locPosition
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
			
			$.ajax({
	        	type:"get",
	        	url:"hugesoinfo/mapaction.jsp",
	        	dataType:"json",
	        	success:function(res){
	        		
	        		var s="<table class='table table-bordered'>";
	        		s+="<tr><th>휴게소이름</th><th>주소</th><th>번호</th></tr>";
	        		
	        		$.each(res,function(i,elt){
	        			
	        			s+="<tr><td h_num="+elt.h_num+" onclick=\"location.href='index.jsp'\">"+elt.h_name+"</td><td>"+elt.h_addr+"</td><td>"+elt.h_hp+"</td></tr>";
	        			
	        			var locPosition = new kakao.maps.LatLng(elt.h_yvalue, elt.h_xvalue), // 마커가 표시될 위치를 geolocation으로 얻어온 좌표로 생성합니다
			            	message = '<div class="infowindow">'+elt.h_name+'</div>'; // 인포윈도우에 표시될 내용입니다
			            
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
				        	alert(elt.h_num);  
				        });
	        		});
	        		
	        		s+="</table>";
	        		
	        		$("#tablearea").html(s);
	        		
	        	}
	        });
		});
		
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
						var s="<table class='table table-bordered'>";
		        		s+="<tr><th>휴게소이름</th><th>주소</th><th>번호</th></tr>";
		        		
		        		$.each(res,function(i,elt){
		        			s+="<tr><td h_num="+elt.h_num+" onclick=\"location.href='index.jsp'\">"+elt.h_name+"</td><td>"+elt.h_addr+"</td><td>"+elt.h_hp+"</td></tr>";
		        		});
		        		
		        		s+="</table>";
					} else{
						var s="검색결과가 없습니다";
					}
	        		
	        		$("#tablearea").html(s);
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
	</div>
</body>
</html>