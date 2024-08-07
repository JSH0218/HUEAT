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
		
		#addbrand,#addfood{
			border: 2px solid #618E6E;
			background-color: white;
			height: 35px;
			border-radius:5px;
			width: 150px;
		}
		
		button.btnreset{
			background-color:white;
       border:2px solid red;
       border-radius:5px;
       width: 60px;
      height: 35px;
      font-size: 15px;

		}
		
		.btnadd{
			background-color:white;
		 border:2px solid #618E6E;
       border-radius:5px;
       width: 60px;
      height: 35px;
      font-size: 15px;
		}
		.bi-x-lg{
		cursor: pointer;
		}
	</style>
	<script type="text/javascript">
		$(function(){
			var map=createMap();
			
			// 휴게소 주소 입력란의 내용이 변경될 때마다 searchHugeso 함수 실행
	        $("#h_addr").keyup(function(){
	            var h_addr = $(this).val(); // 변경된 주소 가져오기
	            searchHugeso(h_addr, map); // 휴게소 주소로 지도 검색 및 마커 추가
	        });
			
			$("#addbrand").click(function(){
				var brandCount=$("#brandcount").val();
				brandCount++;
				
				var s="<div>";
				s+="<div style='display: flex; justify-content: space-between;'><div>브랜드 이름: <input type='text' name='b_name"+brandCount+"' required='required'></div><i class='bi bi-x-lg' onclick='removeBrandField(this)'></i></div>";
				s+="<div>브랜드 로고: <input type='file' name='b_photo"+brandCount+"' required='required'></div>";
				s+="<div>브랜드 홈페이지 주소: <input type='text' name='b_addr"+brandCount+"' required='required'></div>";
				s+="</div>";

                // 입력 필드를 생성
                $("#brandaddarea").append(s);
                
                $("#brandcount").val(brandCount);
			});
			
			$("#addfood").click(function(){
				var foodCount=$("#foodcount").val();
				foodCount++;
				
				var s="<div>";
				s+="<div style='display: flex; justify-content: space-between;'><div>음식 이름: <input type='text' name='f_name"+foodCount+"' required='required'></div><i class='bi bi-x-lg' onclick='removeFoodField(this)'></i></div>";
				s+="<div>음식 이미지: <input type='file' name='f_photo"+foodCount+"' required='required'></div>";
				s+="<div>음식 가격: <input type='text' name='f_price"+foodCount+"' required='required'></div>";
				s+="</div>";

                // 가게 이름과 이미지 입력 필드를 추가
                $("#foodaddarea").append(s);
                
                $("#foodcount").val(foodCount);
			});
			
		});
		
		function removeBrandField(element) {
		    $(element).parent().parent().remove();
		    var count = $("#brandcount").val();
		    count--;
		    $("#brandcount").val(count);
		    // 제거된 필드보다 큰 번호를 가진 필드의 이름을 수정
		    $("#brandaddarea input[type='text'][name^='b_name']").each(function(index) {
		        $(this).attr("name", "b_name" + (index + 1));
		    });
		    $("#brandaddarea input[type='file'][name^='b_photo']").each(function(index) {
		        $(this).attr("name", "b_photo" + (index + 1));
		    });
		    $("#brandaddarea input[type='text'][name^='b_addr']").each(function(index) {
		        $(this).attr("name", "b_addr" + (index + 1));
		    });
		}

		function removeFoodField(element) {
		    $(element).parent().parent().remove();
		    var count = $("#foodcount").val();
		    count--;
		    $("#foodcount").val(count);
		    // 제거된 필드보다 큰 번호를 가진 필드의 이름을 수정
		    $("#foodaddarea input[type='text'][name^='f_name']").each(function(index) {
		        $(this).attr("name", "f_name" + (index + 1));
		    });
		    $("#foodaddarea input[type='file'][name^='f_photo']").each(function(index) {
		        $(this).attr("name", "f_photo" + (index + 1));
		    });
		    $("#foodaddarea input[type='text'][name^='f_price']").each(function(index) {
		        $(this).attr("name", "f_price" + (index + 1));
		    });
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
				<div >휴게소 사진: <input type="file" name="h_photo" required="required" ></div>
				<hr>
				<div>휴게소 번호: <input type="text" name="h_hp1" maxlength="3" size="3" required="required"> - <input type="text" name="h_hp2" maxlength="4" size="4" required="required"> - <input type="text" name="h_hp3" maxlength="4" size="4" required="required"></div>
				<hr>
				<div>휴게소 주소: <input type="text" name="h_addr" id="h_addr" required="required"></div>
				<input type="hidden" name="h_xvalue" id="h_xvalue">
				<input type="hidden" name="h_yvalue" id="h_yvalue">
				<hr>
				<div>
					편의시설:&nbsp;
					<input type="checkbox" name="h_pyeon" value="수면실">수면실&nbsp;
					<input type="checkbox" name="h_pyeon" value="샤워실">샤워실&nbsp;
					<input type="checkbox" name="h_pyeon" value="세탁실">세탁실&nbsp;
					<input type="checkbox" name="h_pyeon" value="세차장">세차장&nbsp;
					<input type="checkbox" name="h_pyeon" value="경정비">경정비&nbsp;
					<input type="checkbox" name="h_pyeon" value="수유실">수유실&nbsp;
					<input type="checkbox" name="h_pyeon" value="쉼터">쉼터&nbsp;
					<input type="checkbox" name="h_pyeon" value="ATM">ATM&nbsp;
					<input type="checkbox" name="h_pyeon" value="매점">매점&nbsp;
					<input type="checkbox" name="h_pyeon" value="약국">약국
				</div>
				<hr>
				<div id="brandaddarea">
					<input type="hidden" name="brandcount" id="brandcount" value="0">
				</div>
				<div class="btnarea"><button type="button" id="addbrand" class="btn-sm">가맹점 추가</button></div>
				<hr>
				<div id="foodaddarea">
					<input type="hidden" name="foodcount" id="foodcount" value="0">
				</div>
				<div class="btnarea"><button type="button" id="addfood" class="btn-sm">메뉴 추가</button></div>
				<hr>
				<div>
					휘발유: <input type="text" name="h_gasolin" style="text-align: right;">원&nbsp;/
					경유: <input type="text" name="h_disel" style="text-align: right;">원&nbsp;/
					천연가스: <input type="text" name="h_lpg" style="text-align: right;">원&nbsp;
				</div>
				<hr>
				<div class="btnarea">
					<button type="submit" class="btnadd" style="margin-right: 10px;">추가</button>
					<button type="button" class="btnreset"  onclick="goBack()">취소</button>
				</div>
			</form>
			<div id="map"></div>
		</div>
	</div>
</body>
</html>