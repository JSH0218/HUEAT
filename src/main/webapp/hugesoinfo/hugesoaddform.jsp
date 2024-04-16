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
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=b71304786948cbe7995d40be3007bd8e&libraries=services"></script>
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
		
		#contentarea {
			display: flex;
			justify-content: center;
		}
		
		.btnarea{
			text-align: center;
		}
		
		#frm div{
			margin-bottom: 10px;
		}
		
		#map{
			width: 700px;
			height: 600px;
			margin-left: 10%;
		}
	</style>
	<script type="text/javascript">
		$(function(){
			var map=createMap();
			var foodCount=0;
			var brandCount=0;
			
			// 휴게소 주소 입력란의 내용이 변경될 때마다 searchHugeso 함수 실행
	        $("#h_addr").keyup(function(){
	            var h_addr = $(this).val(); // 변경된 주소 가져오기
	            searchHugeso(h_addr, map); // 휴게소 주소로 지도 검색 및 마커 추가
	        });
			
			$("#addbrand").click(function(){
				brandCount++; // 가게 카운트 증가
				
				var s="<div>";
				s+="<div style='display: flex; justify-content: space-between;'><div>브랜드 이름: " + brandCount + ": <input type='text' name='b_name'></div><i class='bi bi-x-lg' onclick='removeField(this)'></i></div>";
				s+="<div>브랜드 로고: " + brandCount + ": <input type='file' name='b_photo'></div>";
				s+="<div>브랜드 홈페이지 주소: " + brandCount + ": <input type='text' name='b_addr'></div>";

                // 입력 필드를 생성
                $("#brandaddarea").append(s);
			});
			
			$("#addfood").click(function(){
				foodCount++; // 가게 카운트 증가
				
				var s="<div>";
				s+="<div style='display: flex; justify-content: space-between;'><div>음식 이름: " + foodCount + ": <input type='text' name='f_name'></div><i class='bi bi-x-lg' onclick='removeField(this)'></i></div>";
				s+="<div>음식 이미지: " + foodCount + ": <input type='file' name='f_photo'></div>";
				s+="<div>음식 가격: " + foodCount + ": <input type='text' name='f_price'></div>";

                // 가게 이름과 이미지 입력 필드를 추가
                $("#foodaddarea").append(s);
			});
			
		});
		
		function removeField(element) {
            $(element).parent().parent().remove();
            brandCount--;
        }
		
		function goBack() {
			history.back();
		}
		
		function createMap(){
			var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
		    mapOption = { 
		        center: new kakao.maps.LatLng(33.450701, 126.570667), // 지도의 중심좌표
		        level: 13 // 지도의 확대 레벨
		    };

			// 지도를 표시할 div와  지도 옵션으로  지도를 생성합니다
			var map = new kakao.maps.Map(mapContainer, mapOption);
			
			// markers 배열을 초기화합니다
		    map.markers = [];
			
			return map;
		}
		
		function searchHugeso(h_addr, map){
			
			// 주소-좌표 변환 객체를 생성합니다
			var geocoder = new kakao.maps.services.Geocoder();
			
			// 이전에 생성된 마커가 있다면 제거합니다
		    if (map.markers.length > 0) {
		        for (var i = 0; i < map.markers.length; i++) {
		            map.markers[i].setMap(null);
		        }
		    }

			// 주소로 좌표를 검색합니다
			geocoder.addressSearch(h_addr, function(result, status) {

			    // 정상적으로 검색이 완료됐으면 
			     if (status === kakao.maps.services.Status.OK) {

			        var coords = new kakao.maps.LatLng(result[0].y, result[0].x);

			        // 결과값으로 받은 위치를 마커로 표시합니다
			        var marker = new kakao.maps.Marker({
			            map: map,
			            position: coords
			        });

			        // 지도의 중심을 결과값으로 받은 위치로 이동시킵니다
			        map.setCenter(coords);
			        
			     	// 생성된 마커를 markers 배열에 추가합니다
		            map.markers.push(marker);
			     	
			     	$("#h_xvalue").val(result[0].x);
			     	$("#h_yvalue").val(result[0].y);
			    } 
			});
		}
	</script>
</head>
<body>
	<div id="area">
		<div id="titlearea">
			<h4>휴게소 추가</h4>
			<hr>
		</div>
		<div id="contentarea">
			<form action="hugesoinfo/hugesoaddaction.jsp" id="frm" method="post" enctype="multipart/form-data">
				<div>휴게소 이름: <input type="text" name="h_name" required="required"></div>
				<hr>
				<div>휴게소 사진: <input type="file" name="h_photo" required="required"></div>
				<hr>
				<div>휴게소 번호: <input type="text" name="h_hp" required="required"></div>
				<hr>
				<div>휴게소 주소: <input type="text" name="h_addr" id="h_addr" required="required"></div>
				<input type="hidden" name="h_xvalue" id="h_xvalue">
				<input type="hidden" name="h_yvalue" id="h_yvalue">
				<hr>
				<div>
					편의시설: 
					<input type="checkbox" name="h_pyeon" value="수면실">수면실
					<input type="checkbox" name="h_pyeon" value="샤워실">샤워실
					<input type="checkbox" name="h_pyeon" value="세탁실">세탁실
					<input type="checkbox" name="h_pyeon" value="세차장">세차장
					<input type="checkbox" name="h_pyeon" value="경정비">경정비
					<input type="checkbox" name="h_pyeon" value="수유실">수유실
					<input type="checkbox" name="h_pyeon" value="쉼터">쉼터
					<input type="checkbox" name="h_pyeon" value="ATM">ATM
					<input type="checkbox" name="h_pyeon" value="매점">매점
					<input type="checkbox" name="h_pyeon" value="약국">약국
				</div>
				<hr>
				<div id="brandaddarea"></div>
				<div class="btnarea"><button type="button" id="addbrand">가게추가</button></div>
				<hr>
				<div id="foodaddarea"></div>
				<div class="btnarea"><button type="button" id="addfood">음식추가</button></div>
				<hr>
				<div>
					휘발유: <input type="text" name="h_gasolin">원&nbsp;
					경유: <input type="text" name="h_disel">원&nbsp;
					천연가스: <input type="text" name="h_lpg">원&nbsp;
				</div>
				<hr>
				<div class="btnarea">
					<button type="button" class="btn btn-success" onclick="goBack()">목록</button>
					<button type="submit" class="btn btn-primary">추가</button>
				</div>
			</form>
			<div id="map"></div>
		</div>
	</div>
</body>
</html>