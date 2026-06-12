<%@page import="java.util.TimeZone"%>
<%@page import="meminfo.model.MemInfoDao"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="event.model.EventDto"%>
<%@page import="java.util.List"%>
<%@page import="event.model.EventDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
    <link href="https://fonts.googleapis.com/css2?family=Nanum+Brush+Script&family=Nanum+Pen+Script&family=Noto+Sans+KR:wght@100..900&family=Noto+Serif+KR&family=Stylish&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <script src="https://code.jquery.com/jquery-3.7.0.js"></script>
<title>이벤트</title>

<link rel="stylesheet" type="text/css" href="layout/pagination-b.css">
<link rel="stylesheet" type="text/css" href="layout/banner.css">
 <style type="text/css">

  button.col {
    background-color: #618E6E;
    right: 20%;
  }
  
  #pagelayout {
    margin-left: 20%; 
    margin-bottom: 3%;
    margin-top: -4%;" 
  }
  
  a:link, a:visited {
    text-decoration: none;
    color: black;
  
  }
	div.span-container span{
		z-index: 9999;
		color: white;
		position: relative;
		font-size: 3em;
}

		div.alldiv{
		margin: 0 auto;
		width: 80%;
		border: 0px solid black;

	}
	
	div.tablediv{
		margin:0 auto;
		padding-top: 5%;
		border: 0px solid red;
		width: 70%;
		display: block;
	}
	
	#pagelayout{
		margin:0 auto;
		border: 0px solid yellow;
		padding-top: 4%;
		width: 70%;
		display: block;
	}



</style>

</head>

  <%
   //로그인상태확인
  String loginok=(String)session.getAttribute("loginok");
  String myid=(String)session.getAttribute("myid");

	EventDao dao=new EventDao();
	
	//전체갯수
	int totalCount=dao.selectTotalCount();
	int perPage=10; //한페이지당 보여질 글의 갯수
	int perBlock=10; //한블럭당 보여질 페이지 갯수
%>
<%@ include file="/layout/pagingCalc.jspf" %>
<%
	
	//페이지에서 보여질 글만 가져오기
	List<EventDto> list = dao.selectPagingList(startNum, perPage);
		
	//날짜변경
	SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");
	sdf.setTimeZone(TimeZone.getTimeZone("GMT"));
	
	//해당 페이지에 게시물이 없을 경우 이전 페이지로 돌아가기
    //마지막 페이지의 단 한개 남은 글을 삭제 시 빈페이지가 남는데 해결책으로 그 이전 페이지로 가는 로직 설정
    if(list.size()==0 && currentPage !=1) {%>
	  <script type="text/javascript">
	    location.href="index.jsp?main=eventboard/eventList.jsp?currentPage=<%=currentPage-1%>";
	  </script>
			<%}
	
	%>
<body>

<div class="img-container" style="border: 0px solid green; background-image: url('image/mainbanner/boardbanner01.jpg'); background-size: cover; background-position: center center;">
</div>
<div class="span-container" style="border:0px solid purple;">
	<span>이벤트<br><span style="display: block;font-size: 20px;">다양한 이벤트 소식을 전달합니다.</span></span>
</div>

  
 <div class="alldiv">
  <div class="tablediv">
    <table class="table table-bordered">
      <caption align="top" style="font-size: 1.2em;padding-left: 24px;"><b>목록</b></caption>
        <tr align="center" style="height: 30px;">
          <th width="120" style="background-color: #DFE8E2;">번호</th>
          <th width="450" style="background-color: #DFE8E2;">제목</th>
          <th width="200" style="background-color: #DFE8E2;">작성자</th>
          <th width="150" style="background-color: #DFE8E2;">조회수</th>
          <th width="150" style="background-color: #DFE8E2;">추천수</th>
          <th width="350" style="background-color: #DFE8E2;">등록일자</th>
        </tr>
        
        <%
        
          //게시물이 없는 경우
          if(totalCount == 0) {%>
            <tr>
              <td colspan="6">
                <h6 style="text-align: center;"><b>등록된 게시글이 없습니다</b></h6>
              </td>
            </tr>
          
          <%}
          
          //내용 넣으면 각 주제별로 게시물 추출
          else {
        	  
        	  MemInfoDao edao = new MemInfoDao();
        	  
        	  for(EventDto dto:list) {
        	  
        	   //아이디 얻기
        	   String name = edao.selectNickById(dto.getE_myid());
        		%>
        		
        		  <tr>
        		    <td align="center" valign="<%=dto.getE_num()%>"><%=no-- %></td>
        		    
        		    <!-- 제목 선택하면 디테일 페이지로 이동 -->
        		    <td><a href="index.jsp?main=eventboard/eventDetail.jsp?e_num=<%=dto.getE_num()%>
        		    &currentPage=<%=currentPage%>">
        		    <span style="text-overflow: ellipsis; white-space: nowrap; overflow: hidden;
        		    width: 250px; display: block;"><%=util.SecurityUtil.escapeHtml(dto.getE_subject()) %></span></a>
        		    
        		    </td>
        		    <td align="center"><%=util.SecurityUtil.escapeHtml(name) %></td>
        		    <td align="center"><%=dto.getE_readcount() %></td>
        		    <td align="center"><%=dto.getE_chu()%></td>
        		    <td align="center"><%=sdf.format(dto.getE_writeday())%></td>
        		    
        		  </tr>  
        	  <%}%>
        	  </table>
          <%}
      //로그인한 아이디와 글을 쓴 아이디가 같을경우에만
    	if (loginok!=null && "ADMIN".equals((String)session.getAttribute("role"))) {%>
        
     		<div style="float: right;">
          <button type="button" onclick="location.href='index.jsp?main=eventboard/eventForm.jsp'"
          class="btn btn-success col" style="width: 80px; height: 40px;">글쓰기</button>
				</div>
    
     <%}%>
    
  </div>
  
  <div style="width: 1000px; text-align: center;" id="pagelayout">
  
  
  <!-- 페이지 번호 출력 -->
  <% String pageUrl="eventboard/eventList.jsp"; String pageQuery=""; %>
<%@ include file="/layout/pagingNav.jspf" %>
 
  
</div>
</div><!-- 전체감싼 div -->
</body>
</html>