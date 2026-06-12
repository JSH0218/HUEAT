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
<title>휴게소 선택</title>
<link rel="stylesheet" type="text/css" href="layout/banner.css">
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
	div.span-container span{
		z-index: 999;
		color: white;
		position: relative;

}

	#myList li{
		cursor: pointer;
	}
</style>
<%
HugesoInfoDao dao=new HugesoInfoDao();
List<HugesoInfoDto> list=dao.selectH_numH_name();
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
  		 <li><a class="dropdown-item gomenu" h_num="<%=dto.getH_num() %>"><%=util.SecurityUtil.escapeHtml(dto.getH_name()) %></a></li>
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
    	
    	    /*$("#searchInput").on("blur", function() {
    	    	$(".bb").hide();
    	      $("#myList").css("overflow-y", "hidden"); // input을 벗어나면 스크롤바를 숨깁니다.
    	    });*/
    	    
    	    $(document).on("click", function(event) {
    	        var target = $(event.target);

    	        // 만약 클릭된 요소가 검색 입력창이나 메뉴 목록에 속하지 않으면
    	        // 메뉴를 숨깁니다.
    	        if (!target.is("#searchInput") && !target.closest("#myList").length) {
    	            $(".bb").hide();
    	            $("#myList").css("overflow-y", "hidden");
    	        }
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