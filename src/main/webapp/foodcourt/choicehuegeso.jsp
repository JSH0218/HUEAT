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
	margin: 0 auto;
	height:700px;;
	width: 1000px;
	}

  #aa {
    position:fixed;
    top: 30%;
    left: 50%;
    transform: translateX(-50%);
    z-index: 1000;
  }

  #myList {
    max-height: 150px;
    overflow-y: auto;
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
  	outline: none;
  	
  }
  input::placeholder {
  color: white;
	}
</style>
<%
HugesoInfoDao dao=new HugesoInfoDao();
List<HugesoInfoDto> list=dao.getH_numH_name();
%>
</head>
<body>
<div id="all">
	<div id="aa">
	<div id="searchContainer">
    <input type="text" id="searchInput"  placeholder="검색하실 휴게소를 입력해주세요.">
  </div>
  
  <div>
  <ul id="myList">
  <%
  	for(int i=0;i<list.size();i++){
  		HugesoInfoDto dto=list.get(i);%>
  		 <li><a class="dropdown-item gomenu" h_num="<%=dto.getH_num() %>"><%=dto.getH_name() %></a></li>
  	<%}
  %>
  
  </ul>

  <script>
    $(document).ready(function(){
      $("#searchInput").on("keyup", function() {
        var value = $(this).val().toLowerCase();
        $("#myList li").filter(function() {
          $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1)
        });
      });
    });
    
    $(function(){
		$("a.gomenu").click(function(){
			var h_num=$(this).attr("h_num");
			//alert(h_num);
			
			//디테일 페이지로 이동
			location.href='index.jsp?main=foodcourt/foodmenu.jsp?h_num='+h_num;
			
		})
		
	})
    
  </script>
  </div>
  </div>
</div>
</body>
</html>