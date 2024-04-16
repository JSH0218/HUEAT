<%@page import="java.util.ArrayList"%>
<%@page import="brand.model.BrandDto"%>
<%@page import="brand.model.BrandDao"%>
<%@page import="java.util.List"%>
<%@page import="hugesoinfo.model.HugesoInfoDto"%>
<%@page import="hugesoinfo.model.HugesoInfoDao"%>
<%@page import="java.text.SimpleDateFormat"%>
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

.icon1 , .icon2{
	width: 30px;
    height: 30px;
}


.btn{
	background-color:white;
	border:white;
}

#contentarea{
	margin-bottom: 80px;
}

table.table{
	margin-bottom: 80px;
}

table.table th, table.table td{
    text-align: center; /* 가운데 정렬 */
    vertical-align: middle; /* 수직 정렬 */
    border : 2px solid lightgray;
    border-collapse: collapse;
}

tr:hover { /* <tr>의 첫번째,두번째 형제 요소 제외하고 나머지 영역에만 css 적용(헤더 제외) */
	 background-color: lightgray;
} 

table th:first-child,
table td:first-child {
	border-left: 0;
}
table th:last-child,
table td:last-child {
	border-right: 0;
}

.pyeonicon1{
	width: 2%;
	height: 2%;
}

.pyeonicon2{
	width: 14%;
	height: 14%;
	padding-right: 2%;
}

.line{
	border-top: 3px solid darkgray;
}

.line2{
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
	HugesoInfoDao hdao = new HugesoInfoDao();
	 
	//전체갯수
	int totalCount=hdao.getSearchTotalCount(h_name);
	int perPage=10; //한페이지당 보여질 글의 갯수
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
	List<HugesoInfoDto>list2=hdao.getSearchPagingList(h_name, startNum, perPage);

	
%>
<body>

<script>
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
		window.location.href="index.jsp?main=hugesoinfo/hugesolist.jsp?color=#65774F";
		}else{
			icon2.style.color="#65774F";
			icon1.style.color="lightgray";
			window.location.href="index.jsp?main=hugesoinfo/hugesolist2.jsp?color=#65774F";
		}
		
}

// 앨범형/목록형 색상변환
document.addEventListener("DOMContentLoaded", function() {
    const urlParams = new URLSearchParams(window.location.search);
    const color = urlParams.get('color');

        document.querySelector(".icon1").style.color = "#65774F";
        document.querySelector(".icon2").style.color = "lightgray";
   
});

//검색기능
function searchAction(h_name){
	if(h_name==""){
		alert("검색어를 입력해주세요");
	} else{
		location.href="index.jsp?main=hugesoinfo/hugesolistsearch.jsp?h_name="+h_name;
	}
}

</script>

<div style="margin: 100px 10% 40px; width:80%;">

<div id="titlearea">
			<h4>휴게소 목록</h4>
			<hr>
		</div>

<!-- 편의시설 아이콘  -->
<div style="width:100%; text-align:center;">
    <% 
    String[] pyeonIcons = {"수면실", "샤워실", "세탁실", "세차장", "경정비", "수유실", "쉼터", "ATM", "매점", "약국"};
    for (int i = 0; i < pyeonIcons.length; i++) { 
    %>
        <img src="image/pyeon/<%= pyeonIcons[i] %>.jpg" alt="<%= pyeonIcons[i] %>" class="pyeonicon1">
        <%= pyeonIcons[i] %>
    <% } %>
</div>


<!-- 리스트형 목록 -->
<button type="button" class="btn"
onclick="List(0)" style=" margin-left: 85%;">
<i class="bi bi-list icon1" style="font-size: 25px; font-weight: bold;"></i>
</button>

<!-- 앨범형 목록 -->
<button type="button" class="btn" 
onclick="List(1)" >
<i class="bi bi-grid-fill icon2" style="font-size: 25px; font-weight: bold;"> </i>
</button>


<div id="contentarea">
<table class="table">
<tr class="line">
<th rowspan="2" style="width: 250px; background-color: #DFE8E2;">휴게소</th>
<th rowspan="2" style="width: 420px; background-color: #DFE8E2;">이정</th>
<th rowspan="2" style="width: 230px; background-color: #DFE8E2;">전화번호</th>
<th colspan="2" style="width: 250px; background-color: #DFE8E2;">편의시설</th>
<th rowspan="2" style="width: 250px; background-color: #DFE8E2;">브랜드매장</th>
</tr>

<%

%>

<tr class="line2">
<th style="width: 250px; background-color: #DFE8E2;">휴게소</th>
<th style="width: 250px; background-color: #DFE8E2;">주유소</th>
</tr>
<% 
if(list2.isEmpty()){
	%>
	<tr>
		<td colspan="6">검색결과가 없습니다</td>
	</tr>
	<%
}else{
	for(int i=0;i<list2.size();i++){
	    //1번열에 출력할 번호
	    int num = list2.size()-i;
	    
	    //i번째 dto얻기
	    HugesoInfoDto hdto = list2.get(i);
	    %>
	    <tr>
	    <td>
	    <a href="index.jsp?main=hugesoinfo/hugesodetail.jsp?h_num=<%=hdto.getH_num() %>">
	    <%=hdto.getH_name() %></a></td>
	    <td><%=hdto.getH_addr() %> </td>
	    <td><%=hdto.getH_hp() %> </td>
	    <td>
	 <% 
	        String pyeons = hdto.getH_pyeon(); //dto에 있는 편의시설 문자열을 pyeons에 넣어줌
	        String[] pyeonArray = pyeons.split(","); //콤마를 기준으로 편의시설 문자열을 분리하여 배열 pyeonArray에 넣어줌
	        for(String pyeon : pyeonArray){
	        	 switch(pyeon){
	        	 case "수면실":{
	        		 %><img src="image/pyeon/수면실.jpg" alt="수면실" class="pyeonicon2"><%
	        	 break;
	        	 }
	        	 case "샤워실":{
	        		 %><img src="image/pyeon/샤워실.jpg" alt="샤워실" class="pyeonicon2"><%
	        				 break;
	        	 }
	        	 case "세탁실":{
	        		 %><img src="image/pyeon/세탁실.jpg" alt="세탁실" class="pyeonicon2"><%
	        				 break;
	        	 }
	        	 case "세차장":{
	        		 %><img src="image/pyeon/세차장.jpg" alt="세차장" class="pyeonicon2"><%
	        				 break;
	        	 }
	        	 case "경정비":{
	        		 %><img src="image/pyeon/경정비.jpg" alt="경정비" class="pyeonicon2"><%
	        				 break;
	        	 }
	        	 case "수유실":{
	        		 %><img src="image/pyeon/수유실.jpg" alt="수유실" class="pyeonicon2"><%
	        				 break;
	        	 }
	        	 case "쉼터":{
	        		 %><img src="image/pyeon/쉼터.jpg" alt="쉼터" class="pyeonicon2"><%
	        				 break;
	        	 }
	        	 case "ATM":{
	        		 %><img src="image/pyeon/ATM.jpg" alt="ATM" class="pyeonicon2"><%
	        				 break;
	        	 }
	        	 case "매점":{
	        		 %><img src="image/pyeon/매점.jpg" alt="매점" class="pyeonicon2"><%
	        				 break;
	        	 }
	        	 case "약국":{
	        		 %><img src="image/pyeon/약국.jpg" alt="약국" class="pyeonicon2"><%
	        				 break;
	        	 }
	        	 default:{ /* 기타 */
	        		 break;
	        	 }
	        	 
	        	 }
	          /*   out.println(pyeon); */ // 각 편의시설 출력
	        }
	        %>
	        
	    </td>
	    <td>휘발유<%=hdto.getH_gasolin().equals("없음")?"X":"O" %> 경유<%=hdto.getH_disel().equals("없음")?"X":"O" %> 천연가스<%=hdto.getH_lpg().equals("없음")?"X":"O" %></td>
	    <td>
	    <%
		  BrandDao bdao=new BrandDao();
		  List<BrandDto> blist=bdao.selectBrand(hdto.getH_num());
		  List<String> brandList=new ArrayList<String>();
		  
		  if(brandList.size()>0){
		  	for(int j=0;j<blist.size();j++){
		      	BrandDto bdto=blist.get(j);
		       	brandList.add(bdto.getB_name());
		       }
		    } else{
		    	brandList.add("없음");
		    }
		     
		     if(brandList.size()==1){%>
		    	 <%=brandList.get(0) %>
		     <%}else{
		    	 int brandCount=brandList.size()-1;
		    	 out.println(brandList.get(0)+" 외 "+brandCount);
		     }
		 %>
	     </td>
	    </tr>
	<%}
}
%>

</table>
</div>
  <!-- 페이지 번호 출력 -->
  <ul class="pagination justify-content-center">
  <%
  //이전
  if(startPage>1)
  {%>
	  <li class="page-item ">
	   <a class="page-link" href="index.jsp?main=hugesoinfo/hugesolistsearch.jsp?currentPage=<%=startPage-1%>&h_name=<%=h_name %>" style="color: black;">이전</a>
	  </li>
  <%}
    for(int pp=startPage;pp<=endPage;pp++)
    {
    	if(pp==currentPage)
    	{%>
    		<li class="page-item active">
    		<a class="page-link" href="index.jsp?main=hugesoinfo/hugesolistsearch.jsp?currentPage=<%=pp%>&h_name=<%=h_name %>"><%=pp %></a>
    		</li>
    	<%}else
    	{%>
    		<li class="page-item">
    		<a class="page-link" href="index.jsp?main=hugesoinfo/hugesolistsearch.jsp?currentPage=<%=pp%>&h_name=<%=h_name %>"><%=pp %></a>
    		</li>
    	<%}
    }
    
    //다음
    if(endPage<totalPage)
    {%>
    	<li class="page-item">
    		<a  class="page-link" href="index.jsp?main=hugesoinfo/hugesolistsearch.jsp?currentPage=<%=endPage+1%>&h_name=<%=h_name %>"
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

