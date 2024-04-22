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
<title>Insert title here</title>

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
  
  
</style>

</head>

  <%
   //로그인상태확인
  String loginok=(String)session.getAttribute("loginok");
  String myid=(String)session.getAttribute("myid");

	EventDao dao=new EventDao();
	
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
	List<EventDto> list = dao.getList(startNum, perPage);
		
	//날짜변경
	SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd HH:mm");
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
  <!-- 메뉴 타이틀 -->
  <div style="margin-top: 70px; text-align: center;"><h4><b>이벤트</b></h4></div>
  
  
  <div style="margin: 100px 200px; width: 1000px; margin-left: 18%;">
    <table class="table table-bordered">
      <caption align="top"><h5><b>목록</b></h5></caption>
        <tr class="table-" align="center" style="height: 30px;">
          <th width="120">번호</th>
          <th width="450">제목</th>
          <th width="200">작성자</th>
          <th width="150">조회수</th>
          <th width="150">추천수</th>
          <th width="350">등록일자</th>
        </tr>
        
        <%
        
          //게시물이 없는 경우
          if(totalCount == 0) {%>
            <tr>
              <td colspan="6">
                <h6><b>등록된 게시글이 없습니다</b></h6>
              </td>
            </tr>
          
          <%}
          
          //내용 넣으면 각 주제별로 게시물 추출
          else {
        	  
        	  MemInfoDao edao = new MemInfoDao();
        	  
        	  for(EventDto dto:list) {
        	  
        	   //아이디 얻기
        	   String name = edao.getId(dto.getE_myid());
        		%>
        		
        		  <tr>
        		    <td align="center" valign="<%=dto.getE_num()%>"><%=no-- %></td>
        		    
        		    <!-- 제목 선택하면 디테일 페이지로 이동 -->
        		    <td><a href="index.jsp?main=eventboard/eventDetail.jsp?e_num=<%=dto.getE_num()%>
        		    &currentPage=<%=currentPage%>">
        		    <span style="text-overflow: ellipsis; white-space: nowrap; overflow: hidden;
        		    width: 250px; display: block;"><%=dto.getE_subject() %></a></span>
        		    
        		    </td>
        		    <td align="center"><%=name %></td>
        		    <td align="center"><%=dto.getE_readcount() %></td>
        		    <td align="center"><%=dto.getE_chu()%></td>
        		    <td align="center"><%=sdf.format(dto.getE_writeday())%></td>
        		    
        		  </tr>  
        	  <%}
          }
      //로그인한 아이디와 글을 쓴 아이디가 같을경우에만
    	if (loginok!=null && myid.equals("admin")) {%>
        
      <tr>
        <td colspan="6" align="right">
          <button type="button" onclick="location.href='index.jsp?main=eventboard/eventForm.jsp'"
          class="btn btn-success col" style="width: 80px; height: 40px;">글쓰기</button>
        </td>
    </tr>
    
     <%}%>
    </table>
  </div>
  
  <div style="width: 1000px; text-align: center;" id="pagelayout">
  
  
  <!-- 페이지 번호 출력 -->
  <ul class="pagination justify-content-center">
  <%
  //이전
  if(startPage>1)
  {%>
	  <li class="page-item ">
	   <a class="page-link" href="index.jsp?main=eventboard/eventList.jsp?currentPage=<%=startPage-1%>" style="color: black;">이전</a>
	  </li>
  <%}
    for(int pp=startPage;pp<=endPage;pp++)
    {
    	if(pp==currentPage)
    	{%>
    		<li class="page-item active">
    		<a class="page-link" href="index.jsp?main=eventboard/eventList.jsp?currentPage=<%=pp%>"><%=pp %></a>
    		</li>
    	<%}else
    	{%>
    		<li class="page-item">
    		<a class="page-link" href="index.jsp?main=eventboard/eventList.jsp?currentPage=<%=pp%>"><%=pp %></a>
    		</li>
    	<%}
    }
    
    //다음
    if(endPage<totalPage)
    {%>
    	<li class="page-item">
    		<a  class="page-link" href="index.jsp?main=eventboard/eventList.jsp?currentPage=<%=endPage+1%>"
    		style="color: black;">다음</a>
    	</li>
    <%}
  %>
  
  </ul>
 
  
</div>

</body>
</html>