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
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
<script src="https://code.jquery.com/jquery-3.7.0.js"></script>
<title>Insert title here</title>
<style type="text/css">
	*{
			font-family: 'Nanum Gothic';
	}
		.line {
		  border: 1px solid black;
		  margin-top: 10px;
		  margin-left: auto; /* 좌측 여백을 자동으로 설정 */
		  margin-right: auto; 
		  width: 200px;
		}
		ul.tabs{
			margin: 0px;
			padding: 0px;
			list-style: none;
		}
		ul.tabs li{
			background: none;
			color: #222;
			display: inline-block;
			padding: 10px 15px;
			cursor: pointer;
		}
		ul.tabs li:hover {
		    color: green;
		}
		#next{
		  background-color: #d3d3d3;
		  padding: 3px;
		  border-radius: 100px;
		}
		.tab-content{
			display: none;
			background: white;
			padding: 15px;
		}

		ul.tabs li span {
  		  font-weight: bold;
		} 
		  a:link, a:visited {
		    text-decoration: none;
		    color: black;
		  
		  }
		  div.reviewlist {
			width: 100%;
			height: 500px;
			margin-top: 50px;
			border: 1px solid red;
			margin-left: auto;
   			margin-right: auto;
		}
		div.container{
			border: 1px solid green;
			margin-left: auto;
   			margin-right: auto;
		}
		div.subject{
			border: 1px solid cyan;
		}
		#pagelayout{
			text-align: center;
			border: 1px solid green;
			margin-left: auto;
   			margin-right: auto;
			margin-top: 50px;
		}
		.table {
		    border-collapse: collapse; /* 테이블 셀의 경계를 합칩니다 */
		    width: 100%;
		}
		
		.table, .table th, .table td {
		    border: 1px solid gray; /* 모든 테이블 요소에 1px 두께의 회색 실선 테두리를 추가합니다 */
		}
		.table td {
		    border-left: 1px solid gray;
		    border-right: 1px solid gray;
		}
		
		.table th, .table td {
		    padding: 8px; /* 셀의 안쪽 여백을 추가합니다 */
		    text-align: center; /* 셀의 텍스트를 가운데 정렬합니다 */
		}

</style>
</head>
<%
   
    //로그인 세션얻기
	String loginok=(String)session.getAttribute("loginok");
	String myid=(String)session.getAttribute("myid");

	ReviewDao dao=new ReviewDao();
	
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
	List<ReviewDto> list = dao.getmypagelist(startNum, perPage, myid);
		
	//해당 페이지에 게시물이 없을 경우 이전 페이지로 돌아가기
	//마지막 페이지의 단 한개 남은 글을 삭제 시 빈페이지가 남는데 해결책으로 그 이전 페이지로 가는 로직 설정
		if(list.size()==0 && currentPage !=1) {%>
			<script type="text/javascript">
			  location.href="index.jsp?main=mypage/reviewList.jsp?currentPage=<%=currentPage-1%>";
			</script>
		<%}
	
	//날짜변경
	SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");
	
	
	%>
<body>
<div class="container">
<div style="margin-top: 100px; text-align: center;" class="subject"><h4><b>나의활동</b></h4>
<hr class="line">
</div>
<div class="reviewlist">
	<ul class="tabs">
		<li><span style="font-size: 15px;">내가 작성한 Q&A</span></li>
		<li id="next"><span style="font-size: 15px;">내가 작성한 리뷰(<%=totalCount %>)</span></li>
	</ul>
	<div id="tab2" class="tab2">
		<table class="table">
			<tr class="table-success" style="height: 30px;">
				<th width="120">번호</th>
				<th width="200">닉네임</th>
				<th width="400">리뷰</th>
				<th width="150">추천</th>
				<th width="200">작성일</th>
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
		  
	      for(ReviewDto dto:list) {
		%>
		<tr>
			<td><input type="checkbox" class="alldel">
			<%=no-- %>
			</td>
			<td>
				<%=name %>
			</td>
			<td>
		        <%=dto.getR_content()%>
		    </td>
		    <td>
		        <%=dto.getR_chu()%>
		    </td>
		    <td>
		        <%=sdf.format(dto.getR_writeday())%>
		    </td>		
		</tr>
    	<%}
    	%> 
    	<tr>
        	  <td colspan="5">
        	     <label style="float: left"><input type="checkbox" class="alldelcheck"> 전체선택</label>
        	     <span style="float: right;">
        	        <button type="button" class="btn btn-danger btn-sm" id="btndel"><i class="bi bi-x-circle"></i>삭제</button>&nbsp;
        	        <button type="button" class="btn btn-info btn-sm" onclick="#"><i class="bi bi-pencil-fill"></i>글쓰기</button>
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
	   <a class="page-link" href="index.jsp?main=mypage/myreviewlist.jsp?currentPage=<%=startPage-1%>" style="color: black;">이전</a>
	  </li>
  <%}
    for(int pp=startPage;pp<=endPage;pp++)
    {
    	if(pp==currentPage)
    	{%>
    		<li class="page-item active">
    		<a class="page-link" href="index.jsp?main=mypage/myreviewlist.jsp?currentPage=<%=pp%>"><%=pp %></a>
    		</li>
    	<%}else
    	{%>
    		<li class="page-item">
    		<a class="page-link" href="index.jsp?main=mypage/myreviewlist.jsp?currentPage=<%=pp%>"><%=pp %></a>
    		</li>
    	<%}
    }
    
    //다음
    if(endPage<totalPage)
    {%>
    	<li class="page-item">
    		<a  class="page-link" href="index.jsp?main=mypage/myreviewlist.jsp?currentPage=<%=endPage+1%>"
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