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
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
<script src="https://code.jquery.com/jquery-3.7.0.js"></script>
<title>Insert title here</title>
<style type="text/css">
	*{
			font-family: 'Nanum Gothic';
	}
		.line {
		  border: 1px solid #000;
		  margin-top: 30px;
		}
		#container {
		display: flex;
		margin-bottom: 100px;
		border: 1px solid red;
	}
		.container {
		width: 1000px;
		margin-top: 100px;
		margin-left: 50px;
		border: 1px solid red;
	}
		#sidebar {
		width: 300px;
		height: 300px;
		margin-top: 100px;
		margin-left: 200px;
		border: 1px solid red;
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

		ul.tabs li.current{
			background: white;
			color: #009900;
		}

		.tab-content{
			display: none;
			background: pink;
			padding: 15px;
		}

		.tab-content.current{
			display: inherit;
		}
	
		ul.tabs li span {
  		  font-weight: bold;
		}
		
</style>
<script type="text/javascript">
	$(document).ready(function(){
		
		$('ul.tabs li').click(function(){
			var tab_id = $(this).attr('data-tab');
	
			$('ul.tabs li').removeClass('current');
			$('.tab-content').removeClass('current');
	
			$(this).addClass('current');
			$("#"+tab_id).addClass('current');
		})
	
	})
</script>
</head>
<%
//로그인상태확인
//String loginok=(String)session.getAttribute("loginok");

	ReviewDao dao=new ReviewDao();
	
	//전체갯수
	int totalCount=dao.getTotalCount();
	int perPage=10; //한페이지당 보여질 글의 갯수
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
	List<ReviewDto> list = dao.getList(startNum, perPage);
	
	//날짜변경
	SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd HH:mm");
	
	
	%>

<body>
<div id="container">
<div id="sidebar">
			<b style="font-size: 30px; color: black;">마이휴잇</b>
			<table style="width: 300px; margin-top: 50px;">
				<tr height="60px;" style="border: 1px solid gray;">
					<td style="vertical-align: middle; padding-left: 20px;">회원정보수정</td>
					<td><i class="bi bi-chevron-right"></i></td>
				</tr>
				<tr height="60px;" style="border: 1px solid gray;">
					<td style="vertical-align: middle; padding-left: 20px;">나의활동</td>
					<td><i class="bi bi-chevron-right"></i></td>
				</tr>
				<tr height="60px;" style="border: 1px solid gray;">
					<td style="vertical-align: middle; padding-left: 20px;">즐겨찾기</td>
					<td><i class="bi bi-chevron-right"></i></td>
				</tr>
			</table>
		</div>
<div class="container">
	<b style="font-size: 25px; color: black;">나의활동</b>

	<hr class="line">
	<ul class="tabs">
		<li class="tab-link current" data-tab="tab-1"><span>내가 작성한 Q&A</span></li>
		<li class="tab-link" data-tab="tab-2"><span>내가 작성한 리뷰</span></li>
	</ul>

	<div id="tab-1" class="tab-content current">
		<table>
			<th>12123</th>
		</table>
		 <div style="width: 1000px; text-align: center;" id="pagelayout">
  
  
  <!-- 페이지 번호 출력 -->
  <ul class="pagination justify-content-center">
  <%
  //이전
  if(startPage>1)
  {%>
	  <li class="page-item ">
	   <a class="page-link" href="index.jsp?main=noticeboard/noticeList.jsp?currentPage=<%=startPage-1%>" style="color: black;">이전</a>
	  </li>
  <%}
    for(int pp=startPage;pp<=endPage;pp++)
    {
    	if(pp==currentPage)
    	{%>
    		<li class="page-item active">
    		<a class="page-link" href="index.jsp?main=noticeboard/noticeList.jsp?currentPage=<%=pp%>"><%=pp %></a>
    		</li>
    	<%}else
    	{%>
    		<li class="page-item">
    		<a class="page-link" href="index.jsp?main=noticeboard/noticeList.jsp?currentPage=<%=pp%>"><%=pp %></a>
    		</li>
    	<%}
    }
    
    //다음
    if(endPage<totalPage)
    {%>
    	<li class="page-item">
    		<a  class="page-link" href="index.jsp?main=noticeboard/noticeList.jsp?currentPage=<%=endPage+1%>"
    		style="color: black;">다음</a>
    	</li>
    <%}
  %>
  
  </ul>
 
  
</div>
	</div>
	<div id="tab-2" class="tab-content">
		 <table>
			<th>12123</th>
		</table>
	</div>

</div><!-- container -->
</div>
</body>
</html>