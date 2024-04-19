<%@page import="food.model.FoodDto"%>
<%@page import="brand.model.BrandDto"%>
<%@page import="java.util.List"%>
<%@page import="food.model.FoodDao"%>
<%@page import="brand.model.BrandDao"%>
<%@page import="hugesoinfo.model.HugesoInfoDto"%>
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
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=b71304786948cbe7995d40be3007bd8e&libraries=services"></script>
<title>Insert title here</title>
<%
	String h_num=request.getParameter("h_num");

	HugesoInfoDao hdao=new HugesoInfoDao();
	HugesoInfoDto hdto=hdao.getData(h_num);
	
	String hp = hdto.getH_hp();
	String[] hpArray = hp.split("-");
	
	String pyeons = hdto.getH_pyeon(); //dto에 있는 편의시설 문자열을 pyeons에 넣어줌
    String[] pyeonArray = pyeons.split(","); //콤마를 기준으로 편의시설 문자열을 분리하여 배열 pyeonArray에 넣어줌
    
    BrandDao bdao=new BrandDao();
    int btotal=bdao.getRegisteredTotal(h_num);
    List<BrandDto> blist=bdao.selectBrand(h_num);
    
    FoodDao fdao=new FoodDao();
    int ftotal=fdao.getRegisteredTotal(h_num);
    List<FoodDto> flist=fdao.getMenu(h_num);
%>
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
			
			searchHugeso("<%=hdto.getH_addr() %>", map);
			
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
				s+="<div>브랜드 로고: <input type='file' name='b_photo"+brandCount+"'></div>";
				s+="<div>브랜드 홈페이지 주소: <input type='text' name='b_addr"+brandCount+"' required='required'></div>";
				s+="<input type='hidden' name='b_num"+brandCount+"'>";
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
				s+="<div>음식 이미지: <input type='file' name='f_photo"+foodCount+"'></div>";
				s+="<div>음식 가격: <input type='text' name='f_price"+foodCount+"' required='required'></div>";
				s+="<input type='hidden' name='f_num"+foodCount+"'>";
				s+="</div>";

                // 가게 이름과 이미지 입력 필드를 추가
                $("#foodaddarea").append(s);
                
                $("#foodcount").val(foodCount);
			});
			
			var btotal=<%=btotal %>;
			for (var i = 0; i < btotal; i++) {
		        $("#addbrand").trigger("click");
		    }
			
			var ftotal=<%=ftotal %>;
			for (var i = 0; i < ftotal; i++) {
		        $("#addfood").trigger("click");
		    }
			
			<%
				for(int i=1;i<=blist.size();i++){
					BrandDto bdto=blist.get(i-1);
					%>
					$("#brandaddarea input[type='text'][name='b_name"+<%=i %>+"']").attr("value","<%=bdto.getB_name() %>");
					$("#brandaddarea input[type='text'][name='b_addr"+<%=i %>+"']").attr("value","<%=bdto.getB_addr() %>");
					$("#brandaddarea input[type='hidden'][name='b_num"+<%=i %>+"']").attr("value","<%=bdto.getB_num() %>");
					<%
				}
			
				for(int i=1;i<=flist.size();i++){
					FoodDto fdto=flist.get(i-1);
					%>
					$("#foodaddarea input[type='text'][name='f_name"+<%=i %>+"']").attr("value","<%=fdto.getF_name() %>");
					$("#foodaddarea input[type='text'][name='f_price"+<%=i %>+"']").attr("value","<%=fdto.getF_price() %>");
					$("#foodaddarea input[type='hidden'][name='f_num"+<%=i %>+"']").attr("value","<%=fdto.getF_num() %>");
					<%
				}
			%>
			
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
			<h4>휴게소 수정</h4>
			<hr>
		</div>
		<div id="contentarea">
			<form action="hugesoinfo/hugesoupdateaction.jsp" id="frm" method="post" enctype="multipart/form-data">
				<input type="hidden" name="h_num" value="<%=h_num %>">
				<div>휴게소 이름: <input type="text" name="h_name" required="required" value="<%=hdto.getH_name() %>"></div>
				<hr>
				<div>휴게소 사진: <input type="file" name="h_photo"></div>
				<hr>
				<div>휴게소 번호: <input type="text" name="h_hp1" maxlength="3" size="3" required="required" value="<%=hpArray[0] %>"> - <input type="text" name="h_hp2" maxlength="4" size="4" required="required" value="<%=hpArray[1] %>"> - <input type="text" name="h_hp3" maxlength="4" size="4" required="required" value="<%=hpArray[2] %>"></div>
				<hr>
				<div>휴게소 주소: <input type="text" name="h_addr" id="h_addr" required="required" value="<%=hdto.getH_addr() %>"></div>
				<input type="hidden" name="h_xvalue" id="h_xvalue" value="<%=hdto.getH_xvalue() %>">
				<input type="hidden" name="h_yvalue" id="h_yvalue" value="<%=hdto.getH_yvalue() %>">
				<hr>
				<div>
					편의시설: 
				    <% 
				        String[] facilities = {"수면실", "샤워실", "세탁실", "세차장", "경정비", "수유실", "쉼터", "ATM", "매점", "약국"};
				        for(String facility : facilities) {
				            boolean isChecked = false;
				            for(String pyeon : pyeonArray) {
				                if(pyeon.equals(facility)) {
				                    isChecked = true;
				                    break;
				                }
				            }
				            %>
				    		<input type="checkbox" name="h_pyeon" value="<%=facility%>" <% if(isChecked) out.print("checked"); %>> <%=facility%>
				    		<%
				    	}
				    %>
				</div>
				<hr>
				<div id="brandaddarea">
					<input type="hidden" name="brandcount" id="brandcount" value="0">
				</div>
				<div class="btnarea"><button type="button" id="addbrand" class="btn btn-warning btn-sm">가게추가</button></div>
				<hr>
				<div id="foodaddarea">
					<input type="hidden" name="foodcount" id="foodcount" value="0">
				</div>
				<div class="btnarea"><button type="button" id="addfood" class="btn btn-warning btn-sm">음식추가</button></div>
				<hr>
				<div>
					휘발유: <input type="text" name="h_gasolin" value="<%=hdto.getH_gasolin() %>" style="text-align: right;">원&nbsp;
					경유: <input type="text" name="h_disel" value="<%=hdto.getH_disel() %>" style="text-align: right;">원&nbsp;
					천연가스: <input type="text" name="h_lpg" value="<%=hdto.getH_lpg() %>" style="text-align: right;">원&nbsp;
				</div>
				<hr>
				<div class="btnarea">
					<button type="submit" class="btn btn-primary">업데이트</button>
					<button type="button" class="btn btn-danger" onclick="goBack()">취소</button>
				</div>
			</form>
			<div id="map"></div>
		</div>
	</div>
</body>
</html>