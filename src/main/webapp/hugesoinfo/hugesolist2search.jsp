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

</style>


</head>

<%	
	//검색어 받기
	request.setCharacterEncoding("utf-8");
	String h_name=request.getParameter("h_name");
    //UploadBoardDao 인스턴스 생성
	HugesoInfoDao dao = new HugesoInfoDao();
    //모든 게시글 데이터 가져오기
	List<HugesoInfoDto> list = dao.getAllDatas();
	 
	//전체갯수
	int totalCount=dao.getSearchTotalCount(h_name);
	int perPage=9; //한페이지당 보여질 글의 갯수
	int perBlock=5; //한블럭당 보여질 페이지 갯수
	int startNum; //db에서 가져올 글의 시작번호(mysql은 첫글이0번,오라클은 1번);
	int startPage; //각블럭당 보여질 시작페이지
	int endPage; //각블럭당 보여질 끝페이지
	int currentPage;  //현재페이지
	int totalPage; //총페이지수
	int no; //각페이지당 출력할 시작번호

	//현재페이지 읽는데 단 null일경우는 1페이지로 준다
	if(request.getParameter("currentPage")==null)
		currentPage=1;
	else
		currentPage=Integer.parseInt(request.getParameter("currentPage"));

	//총페이지수 구한다
	//총글갯수/한페이지당보여질갯수로 나눔(7/5=1)
	//나머지가 1이라도 있으면 무조건 1페이지 추가(1+1=2페이지가 필요)
	totalPage=totalCount/perPage+(totalCount%perPage==0?0:1);

	//각블럭당 보여질 시작페이지
	//perBlock=5일경우 현재페이지가 1~5일경우 시작페이지가1,끝페이지가 5
	//현재가 13일경우 시작:11 끝:15
	startPage=(currentPage-1)/perBlock*perBlock+1;
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

	//페이지에서 보여질 글만 가져오기
	List<HugesoInfoDto>list2=dao.getSearchPagingList(h_name, startNum, perPage);

	
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
		location.href="index.jsp?main=hugesoinfo/hugesolist2search.jsp?h_name="+h_name;
	}
}

</script>




<div style="margin: 100px 10% 40px; width:80%;">


		<div id="titlearea">
			<h4>휴게소 목록</h4>
			<hr>
		</div>

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
if(list2.isEmpty()){
	%>
	<div style="text-align: center;">검색결과가 없습니다</div>
	<%
}else{
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
		   
				<div style="width: 250px; height: 250px;  border: 1px solid lightgray; margin: 0 auto 20px auto;"><img alt="" src="image/hugeso/<%= dto.getH_photo() %>" style="width: 250px; height: 250px;"></div>
	          	<a href="index.jsp?main=hugesoinfo/hugesodetail.jsp?h_num=<%= dto.getH_num() %>" style="font-weight:bold;"><%=dto.getH_name() %></a>
	            <p style="color: gray; font-size: 9pt; font-weight: bold; margin-bottom: 0px;"><%=dto.getH_addr() %></p>
	            <p style="color: lightgray; font-size: 9pt; font-weight: bold;"><%=dto.getH_hp() %></p>
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
}
%>
</div>

<!-- 페이지 번호 출력 -->
  <ul class="pagination justify-content-center">
  <%
  //이전
  if(startPage>1)
  {%>
	  <li class="page-item ">
	   <a class="page-link" href="index.jsp?main=hugesoinfo/hugesolist2search.jsp?currentPage=<%=startPage-1%>&h_name=<%=h_name %>" style="color: black;">이전</a>
	  </li>
  <%}
    for(int pp=startPage;pp<=endPage;pp++)
    {
    	if(pp==currentPage)
    	{%>
    		<li class="page-item active">
    		<a class="page-link" href="index.jsp?main=hugesoinfo/hugesolist2search.jsp?currentPage=<%=pp%>&h_name=<%=h_name %>"><%=pp %></a>
    		</li>
    	<%}else
    	{%>
    		<li class="page-item">
    		<a class="page-link" href="index.jsp?main=hugesoinfo/hugesolist2search.jsp?currentPage=<%=pp%>&h_name=<%=h_name %>"><%=pp %></a>
    		</li>
    	<%}
    }
    
    //다음
    if(endPage<totalPage)
    {%>
    	<li class="page-item">
    		<a  class="page-link" href="index.jsp?main=hugesoinfo/hugesolist2search.jsp?currentPage=<%=endPage+1%>&h_name=<%=h_name %>"
    		style="color: black;">다음</a>
    	</li>
    <%}
  %>
  
  </ul>
  

</div>
<div id="searcharea">
	<input type="text" id="searchbox">
	<button type="button" class="btn btn-success btn-sm" onclick="searchAction($('#searchbox').val())">검색</button>
</div>
</body>
</html>

