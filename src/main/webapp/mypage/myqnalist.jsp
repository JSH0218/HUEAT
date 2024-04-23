<%@page import="qa.model.QaDto"%>
<%@page import="qa.model.QaDao"%>
<%@page import="meminfo.model.MemInfoDao"%>
<%@page import="review.model.ReviewDto"%>
<%@page import="java.util.List"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="review.model.ReviewDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Nanum+Gothic:wght@400;700;800&display=swap" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Lato&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
<script src="https://code.jquery.com/jquery-3.7.0.js"></script>
<title>Insert title here</title>
<style type="text/css">
* {
	font-family: 'Nanum Gothic';
}

.line {
	border: 1px solid black;
	margin-top: 10px;
	margin-left: auto; /* 좌측 여백을 자동으로 설정 */
	margin-right: auto;
	width: 200px;
}

ul.tabs {
	margin: 0px;
	padding: 0px;
	list-style: none;
	display: flex;
	justify-content: center;
}

ul.tabs li {
	background: none;
	color: #222;
	display: inline-block;
	padding: 10px 18px;
	cursor: pointer;
}

ul.tabs li#next {
	border: 1px solid #ccc;
	margin-left: 20px;
	    border-radius: 100px;
	    text-align: center;
}
ul.tabs li#next:hover {
    background-color: #d3d3d3;
    transition: all 0.3s ease-in-out;
    border: 1px solid transparent;
      color: #fff;
}


#first {
	background-color: #d3d3d3;
	border-radius: 100px;
	text-align: center;
}

.tab-content {
	display: none;
	background: white;
	padding: 15px;
}

ul.tabs li span {
	font-weight: bold;
}

a:link {
	color: black;
	text-decoration: none;
}

a:visited {
	color: black;
	text-decoration: none;
}

a:hover {
	color: #0897B4;
}

a:active {
	color: black;
}

div.reviewlist {
	width: 100%;
	margin-top: 50px;
	margin-left: auto;
	margin-right: auto;
}

div.container {
	margin-left: auto;
	margin-right: auto;
	margin-bottom: 50px;
	margin-top: 128px;
}

#pagelayout {
	text-align: center;
	margin-left: auto;
	margin-right: auto;
	margin-top: 50px;
}

table.table {
	margin-bottom: 80px;
}

table.table th, table.table td {
	text-align: center; /* 가운데 정렬 */
	vertical-align: middle; /* 수직 정렬 */
	border: 2px solid lightgray;
	border-collapse: collapse;
}

table th:first-child, table td:first-child {
	border-left: 0;
	border-bottom: none;
}

table th:last-child, table td:last-child {
	border-right: 0;
	border-bottom: none;
}

.line1 {
	border: 3px solid darkgray;
	border-right: none;
	border-left: none;
}

tr:hover { /* <tr>의 첫번째,두번째 형제 요소 제외하고 나머지 영역에만 css 적용(헤더 제외) */
	background-color: lightgray;
}

.table th, .table td {
	padding: 8px; /* 셀의 안쪽 여백을 추가합니다 */
	text-align: center; /* 셀의 텍스트를 가운데 정렬합니다 */
}

input[type="checkbox"] {
	width: 10px;
	height: 10px;
	cursor: pointer;
}
td{
font-size: 14px;
}
td.day {
font-size: 12px;
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
<script type="text/javascript">
	$(function(){
		//메뉴탭기능 클릭하면 리뷰페이지로 이동
		$("#next").click(function(){
            location.href="index.jsp?main=mypage/myreviewlist.jsp";
        });
		
		
		 //전체체크 클릭시 체크값 얻어서 모든체크값 에 전달
		  $(".alldelcheck").click(function(){
			  
			  //전체 체크값 얻기
			  var chk=$(this).is(":checked");
			  console.log(chk);
			  
			  //전체체크값을 글앞에 체크에 일괄 전달하기
			  $(".alldel").prop("checked",chk);
		  });
		 
		  //삭제버튼 클릭시 삭제
		  $("#btndel").click(function(){
			  
			  var len=$(".alldel:checked").length;
			  //alert(len);
			  
			  if(len==0){
				  alert("최소 1개이상의 글을 선택해 주세요");
			  }else{
				  
				  var a=confirm(len+"개의 글을 삭제하려면 [확인]을 눌러주세요");
				  
				  if(a){
				  //체크된 곳의 value값(num)얻기
				  var n="";
				  $(".alldel:checked").each(function(idx){
					  n+=$(this).val()+",";
				  });
				  
				  //마지막 컴마 제거
				  n=n.substring(0,n.length-1);
				  //console.log(n);
				  
				  //삭제파일로 전송
				  location.href="mypage/deleteqna.jsp?nums="+n;
				  }
			  }
		  })
		
	
	});
</script>
</head>
<%
   
    //로그인 세션얻기
	String loginok=(String)session.getAttribute("loginok");
	String myid=(String)session.getAttribute("myid");

	QaDao dao=new QaDao();
	
	//전체갯수
	int totalCount=dao.getMyPageTotalCount(myid);
	int perPage=5; //한페이지당 보여질 글의 갯수
	int perBlock=10; //한블럭당 보여질 페이지 갯수
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
	
	//페이지에서 보여질 글만 가져오기
	List<QaDto> list = dao.getmypagelist(startNum, perPage, myid);
		
	//해당 페이지에 게시물이 없을 경우 이전 페이지로 돌아가기
	//마지막 페이지의 단 한개 남은 글을 삭제 시 빈페이지가 남는데 해결책으로 그 이전 페이지로 가는 로직 설정
		if(list.size()==0 && currentPage !=1) {%>
			<script type="text/javascript">
			  location.href="index.jsp?main=mypage/myqnalist.jsp?currentPage=<%=currentPage-1%>";
			</script>
		<%}
	
	//날짜변경
	SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");
	
	
	%>
<body>
<div class="img-container" style="border: 0px solid green; background-image: url('image/mainbanner/memberbanner01.jpg'); background-size: cover; background-position: center center;">
</div>
<div class="span-container" style="border:0px solid purple; font-size: 2.5em;">
	<span>나의 활동<br><span>Q&A</span></span>
</div>

<div class="container">
<%-- <div style="margin-top: 100px; text-align: center;" class="subject"><h4><b>나의활동</b></h4>
<hr class="line">
</div>--%>
<div class="reviewlist">
	<ul class="tabs">
			<li id="first"><span style="font-size: 14px;">Q&A</span></li>
			<li id="next"><span style="font-size: 14px;">REVIEW</span></li>
	</ul>
	<div id="tab2" class="tab2" style="margin-top: 40px;">
		<table class="table">
			<tr class="line1" style="height: 30px;">
				<th width="50" style="background-color: #DFE8E2;">번호</th>
				<th width="160" style="background-color: #DFE8E2;">카테고리</th>
				<th width="500" style="background-color: #DFE8E2;">제목</th>
				<th width="120" style="background-color: #DFE8E2;">닉네임</th>
				<th width="100" style="background-color: #DFE8E2;">작성일</th>
			</tr>
		<%
	      MemInfoDao mdao=new MemInfoDao();
		  String name=mdao.getId(myid);
		  
		 
	        
          //게시물이 없는 경우
          if(totalCount == 0) {%>
            <tr>
              <td colspan="5">
                <h6><b>등록된 게시글이 없습니다</b></h6>
              </td>
            </tr>
          
          <%}
          
          //내용 넣으면 각 주제별로 게시물 추출
          else {
		  
	      for(QaDto dto: list) {
		%>
		<tr>
			<td><input type="checkbox" class="alldel" value="<%=dto.getQ_num() %>">
			<%=no-- %>
			</td>
			<td>
		        <%=dto.getQ_category()%>
		    </td>
		    <td>
		    <a href="index.jsp?main=qaboard/qaDetail.jsp?currentPage=<%=currentPage %>&q_num=<%=dto.getQ_num() %>"><%=dto.getQ_subject()%></a>
		    </td>
		    <td>
				<%=name %>
			</td>
		    <td class="day">
		        <%=sdf.format(dto.getQ_writeday())%>
		    </td>		
		</tr>
    	<%}
    	%> 
    	<tr>
        	  <td colspan="5">
        	     <label style="float: left"><input type="checkbox" class="alldelcheck"> 전체선택</label>
        	     <span style="float: right;">
        	        <button type="button" class="btn btn-danger btn-sm" id="btndel">삭제</button>
        	        <button class="custom-btn btn-10">삭제</button>
        	     </span>
        	  </td>
        	</tr>
    	</table>  
    </div>
    
    
    
    
   <div id="pagelayout">

  <!-- 페이지 번호 출력 -->
  <ul class="pagination justify-content-center">
  <%
  //이전
  if(startPage>1)
  {%>
	  <li class="page-item ">
	   <a class="page-link" href="index.jsp?main=mypage/myqnalist.jsp?currentPage=<%=startPage-1%>" style="color: black;">이전</a>
	  </li>
  <%}
    for(int pp=startPage;pp<=endPage;pp++)
    {
    	if(pp==currentPage)
    	{%>
    		<li class="page-item active">
    		<a class="page-link" href="index.jsp?main=mypage/myqnalist.jsp?currentPage=<%=pp%>"><%=pp %></a>
    		</li>
    	<%}else
    	{%>
    		<li class="page-item">
    		<a class="page-link" href="index.jsp?main=mypage/myqnalist.jsp?currentPage=<%=pp%>"><%=pp %></a>
    		</li>
    	<%}
    }
    
    //다음
    if(endPage<totalPage)
    {%>
    	<li class="page-item">
    		<a  class="page-link" href="index.jsp?main=mypage/myqnalist.jsp?currentPage=<%=endPage+1%>"
    		style="color: black;">다음</a>
    	</li>
    <%}
          }
  %>
  
  </ul>
 
  
</div>
</div><!-- container -->
</div>
</body>
</html>