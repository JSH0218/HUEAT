<%@page import="java.util.List"%>
<%@page import="hugesoinfo.model.HugesoInfoDto"%>
<%@page import="hugesoinfo.model.HugesoInfoDao"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>


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

<title>HUEAT</title>

<link rel="stylesheet" type="text/css" href="layout/pagination.css">
<link rel="stylesheet" type="text/css" href="layout/banner.css">
<style type="text/css">
#titlearea{
			text-align: center;
			margin-bottom: 40px;
		}
		
		#titlearea hr{
			margin: 0 auto;
			width: 10%;
		}

#contentarea{
	margin-bottom: 80px;
}
		
.btn{
	background-color:white;
	border:white;
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

#searcharea{
	display: flex;
	justify-content: center;
	margin-bottom: 80px;
}

#searcharea input{
	margin-right: 5px;
}

#searcharea button{
	background-color: #618E6E;
}



	div.span-container span{
		z-index: 9999;
		color: white;
		font-size: 3em;
		position: relative;

}

</style>


</head>

<%	
	//로그인상태확인
	String loginok=(String)session.getAttribute("loginok");
	String myid=(String)session.getAttribute("myid");

    //UploadBoardDao 인스턴스 생성
	HugesoInfoDao dao = new HugesoInfoDao();
	 
	//전체갯수
	int totalCount=dao.selectTotalCount();
	int perPage=9; //한페이지당 보여질 글의 갯수
	int perBlock=5; //한블럭당 보여질 페이지 갯수
%>
<%@ include file="/layout/pagingCalc.jspf" %>
<%

	//페이지에서 보여질 글만 가져오기
	List<HugesoInfoDto>list2=dao.selectPagingList(startNum, perPage);
	
%>

<body>

<script type="text/javascript">
$(function(){
	//엔터 검색
	$("#searchbox").on("keyup", function(event) {
        // keyCode 13은 Enter 키를 나타냅니다.
        if (event.keyCode == 13) {
            // 검색 액션 실행
            searchAction($("#searchbox").val());
        }
    });
});

// 앨범형/목록형 변환
function List(type){
		const icon1 = document.querySelector(".icon1");
		const icon2 = document.querySelector(".icon2");
		
		if(type==0){
		icon1.style.color="#65774F";
		icon2.style.color="lightgray";
		window.location.href="index.jsp?main=hugesoinfo/hugesolist.jsp";
		}else{
			icon2.style.color="#65774F";
			icon1.style.color="lightgray";
			window.location.href="index.jsp?main=hugesoinfo/hugesolist2.jsp";
		}
		
}

// 앨범형/목록형 색상변환
document.addEventListener("DOMContentLoaded", function() {
    const urlParams = new URLSearchParams(window.location.search);
    const color = urlParams.get('color');

 
    	  document.querySelector(".icon1").style.color = "lightgray";
          document.querySelector(".icon2").style.color = "#65774F";
    
});

//검색기능
function searchAction(h_name){
	if(h_name==""){
		alert("검색어를 입력해주세요");
	} else{
		location.href="index.jsp?main=hugesoinfo/hugesolist2search.jsp?h_name="+encodeURIComponent(h_name);
	}
}

</script>

<div class="img-container" style="border: 0px solid green; background-image: url('image/mainbanner/huegesobanner01.jpg'); background-size: cover; background-position: center center;">
	
</div>
<div class="span-container" style="border:0px solid purple;">
	<span>휴게소 목록<br><span style="display: block;font-size: 20px;">휴게소 이름을 누르면 상세정보를 볼 수 있습니다.</span></span>
</div>


<div style="margin: 100px 10% 40px; width:80%;">


<!-- 리스트형 목록 -->
<button type="button" class="btn"
onclick="List(0)" style=" margin-left: 85%;">
<i class="bi bi-list icon1" style="font-size: 25px; font-weight: bold;"></i>
</button>

<!-- 앨범형 목록 -->
<button type="button" class="btn" 
onclick="List(1)" >
<i class="bi bi-grid-fill icon2" style="font-size: 25px; font-weight: bold;"></i>
</button>

<div id="contentarea">
<%
int count = 0; // 열의 카운터 변수
for (int i = 0; i < list2.size(); i++) {
    if (count % 3 == 0) {
%>
<div class="container" style="margin-bottom: 40px;">
    <div class="row" style="display: flex; justify-content: center;">
<% 
    }
%>
        <div class="col-md-3" style="text-align: center; margin-bottom: 20px;">
<%
	    // 각 게시물 정보를 가져오기
	    HugesoInfoDto dto = list2.get(i);
%>
	   
			<div style="width: 250px; height: 250px;  border: 1px solid lightgray; margin: 0 auto 20px auto;"><img alt="" src="fileview?type=hugeso&name=<%= util.SecurityUtil.urlEncode(dto.getH_photo()) %>" style="width: 250px; height: 250px; object-fit: cover;"></div>
          	<a href="index.jsp?main=hugesoinfo/hugesodetail.jsp?h_num=<%= dto.getH_num() %>" style="font-weight:bold;"><%=util.SecurityUtil.escapeHtml(dto.getH_name()) %></a>
            <p style="color: gray; font-size: 9pt; font-weight: bold; margin-bottom: 0px;"><%=util.SecurityUtil.escapeHtml(dto.getH_addr()) %></p>
            <p style="color: lightgray; font-size: 9pt; font-weight: bold;"><%=util.SecurityUtil.escapeHtml(dto.getH_hp()) %></p>
        </div>
<%
    count++;
    if (count % 3 == 0 || i == list2.size() - 1) {
%>
    </div>
</div>
<%
    }
}
	//로그인한 아이디와 글을 쓴 아이디가 같을경우에만
	if (loginok!=null && "ADMIN".equals((String)session.getAttribute("role"))){
		%>
		<div style="text-align: right; padding-right: 10%;">
			<button type="button" class="btn btn-primary" onclick="location.href='index.jsp?main=hugesoinfo/hugesoaddform.jsp'">추가</button>
		</div>
		<%
	}
%>
</div>

<!-- 페이지 번호 출력 -->
  <% String pageUrl="hugesoinfo/hugesolist2.jsp"; String pageQuery=""; %>
<%@ include file="/layout/pagingNav.jspf" %>
  

</div>
<div id="searcharea">
	<input type="text" id="searchbox">
	<button type="button" class="btn btn-success btn-sm" onclick="searchAction($('#searchbox').val())">검색</button>
</div>
</body>
</html>

