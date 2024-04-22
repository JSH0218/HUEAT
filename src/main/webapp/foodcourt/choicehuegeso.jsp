<%@page import="hugesoinfo.model.HugesoInfoDto"%>
<%@page import="java.util.List"%>
<%@page import="hugesoinfo.model.HugesoInfoDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Grandiflora+One&family=Gugi&family=Hahmlet:wght@100..900&family=Hi+Melody&family=Sunflower:wght@300&display=swap" rel="stylesheet">
<script src="https://code.jquery.com/jquery-3.7.0.js"></script>
<title>Insert title here</title>
<style>
	#all{
		margin:0 auto;
    top: 30%;
    left: 50%;
    text-align: center;
		margin-top:6%;
    border: 0px solid red;
	}


  #myList {
    max-height: 150px;
    overflow-y: hidden;
    width: 200px; /* 리스트의 너비를 조정 */
    margin: 0 auto;
  }

  #myList li {
    white-space: nowrap; /* 긴 텍스트가 줄 바꿈되지 않도록 설정 */
    overflow: hidden; /* 넘치는 부분을 숨김 */
    text-overflow: ellipsis; /* 넘치는 텍스트를 생략 부호로 표시 */
  }
  #searchInput,#myList{
  	width: 400px;
  	text-align: center;
  }
  #searchInput{
  	height: 40px; 
  	background-color:#618E6E; 
  	color: white;
  	border: 0px;
  	
  }
  input::placeholder {
  	color: white;
	}
	div.img-container{
    width: 100%; /* 이미지를 감싸는 부모 요소의 가로폭 */
    height: 250px; /* 원하는 높이로 설정 */
    overflow: hidden; /* 내용이 넘칠 경우를 대비하여 오버플로우를 숨김으로 설정 */
  	border: 0px solid black;
  	background-position: top;
  	text-align: center;
}
	
	div.img-container img {
		top: 0;
    width: 100%; /* 이미지가 부모 요소의 가로폭을 다 차지하도록 설정 */
    height: auto; /* 세로 비율을 유지하기 위해 자동으로 조정 */
    object-fit: cover; /* 이미지를 부모 요소에 맞게 잘라내어 배치 */
    
}
	div.span-container{
		width: 100%; /* 이미지를 감싸는 부모 요소의 가로폭 */
    height: 250px; /* 원하는 높이로 설정 */
    overflow: hidden; /* 내용이 넘칠 경우를 대비하여 오버플로우를 숨김으로 설정 */
  	background-position: top;
		margin-top:-14%;
  	text-align: center;
  	display: flex;
    justify-content: center; /* 수평 가운데 정렬 */
    align-items: center; /* 수직 가운데 정렬 */
	}

	div.span-container span{
		z-index: 9999;
		color: white;
		position: relative;

}
</style>
<%
HugesoInfoDao dao=new HugesoInfoDao();
List<HugesoInfoDto> list=dao.getH_numH_name();
%>
</head>
<body>
<%--여기서부터  --%>
<div class="img-container" style="border: 0px solid green; background-image: url('image/mainbanner/foodbanner01.png'); background-size: cover; background-position: center center;">
</div>
<div class="span-container" style="border:0px solid purple; font-size: 2.5em;" >
	<span>푸드코트<br><span>더 편리하고 빠르게 주문하세요.</span></span>
</div>
<%--여기까지 foodbanner영역 --%>

<div id="all">
	<div id="searchContainer">
		<span style="font-size: 1.2em;">검색하실 휴게소를 입력해주세요.</span><br><br><br>
    <input type="text" id="searchInput" placeholder="여기에 입력해주세요">
  </div>
  
  <div class="bb">
  <ul id="myList">
  <%
  	for(int i=0;i<list.size();i++){
  		HugesoInfoDto dto=list.get(i);%>
  		 <li><a class="dropdown-item gomenu" h_num="<%=dto.getH_num() %>"><%=dto.getH_name() %></a></li>
  	<%}
  %>
  
  </ul>
  </div>

</div>

  <script>
    $(document).ready(function(){
    			
			$(".bb").hide();
    	
    	$("#searchInput").on("focus", function() {
    		$(".bb").show();
    	      $("#myList").css("overflow-y", "auto"); // input을 클릭하면 스크롤바를 보이도록 변경합니다.
    	    });

    	    $("#searchInput").on("blur", function() {
    	      $("#myList").css("overflow-y", "hidden"); // input을 벗어나면 스크롤바를 숨깁니다.
    	    });
    	
    	
      $("#searchInput").on("keyup", function() {
        var value = $(this).val().toLowerCase();
        $("#myList li").filter(function() {
          $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1)
        });
      });
    });
    

    	$(document).on('click', 'a.gomenu', function(){
    		var h_num=$(this).attr("h_num");
			//alert(h_num);
			
			//디테일 페이지로 이동
			$(".bb").hide();
			location.href='index.jsp?main=foodcourt/foodmenu.jsp?h_num='+h_num;
    	})


    
  </script>
</body>
</html>