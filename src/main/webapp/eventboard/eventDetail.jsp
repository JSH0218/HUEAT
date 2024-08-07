<%@page import="meminfo.model.MemInfoDao"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="event.model.EventDto"%>
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
  
  span.day {
    float: right;
    font-size: 0.8em;
    color: gray;
  }
  
   span.read {
    float: right;
    font-size: 0.8em;
    color: gray;
  }
  
  span.likes {
  
    font-size: 0.8em;
    color: gray;
  }
  
  div.chu,span.chu {
  	float: left;
  	font-size: 0.9em;
  	color: gray;
  }
  
  i.icon1 {
    cursor: pointer;
    font-size: 0.8em;
    margin-left: 82%;
  }
  
</style>
<script type="text/javascript">

  $(function () {
	 //누르면 추천 올라가기
	  $("i.icon1").click(function () {
		  
		  var e_num = $(this).attr("e_num");
		  //alert(e_num);
		  var tag = $(this); 
		  
		  
		  $.ajax ({
			type : "get",
			dataType : "json",
			url : "eventboard/eventChu.jsp",
			data : {"e_num":e_num},
			success : function (data) {
				
				//alert(data.chu);
				tag.next().next().text(data.chu);
				//location.reload();
				
			}
			
			  
		  })
		  
	  })
		
	});

  //게시물 삭제
  function funcdel(e_num,currentPage){
	   
	   //alert(e_num+","+currentPage);
	   
	  var ans=confirm("삭제하려면 [확인]을 눌러주세요");
	   
	   if(ans){
		   location.href='eventboard/eventDelete.jsp?e_num='+e_num+"&currentPage="+currentPage;
	   } 
  }
 
 
 

  
</script>
</head>

  <%
    String loginok=(String)session.getAttribute("loginok");
    String myid=(String)session.getAttribute("myid");
  
    String e_num = request.getParameter("e_num");
    EventDao dao = new EventDao();
    
    EventDto dto = dao.getDataEvent(e_num);
    String currentPage=request.getParameter("currentPage");
    
    //조회수 가져오기
    dao.updateReadcount(e_num);
    
    //날짜
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
  
  %>
<body>

  <!-- 메뉴 타이틀 -->
  <input type="hidden" id="e_num" value="<%=e_num%>">
  <div style="margin-top: 70px; text-align: center;"><h4><b>이벤트</b></h4></div>
  

  <!-- 저장폼  -->
   <div style="margin: 0 auto; width: 900px; margin-left: 28%;margin-top: 4%; margin-bottom: 10%;">
    <form id="frm">
     <table class="table table-bordered">
      <%-- <caption align="top"><h5><b><%=dto.getE_subject() %></b></h5></caption>--%>
        <%
        MemInfoDao rdao = new MemInfoDao();
      
    	  
    	   //아이디 얻기
    	    String name = rdao.getId(dto.getE_myid());

    	  %>
      
      <tr>
        <td style="background-color: #ebeae7; font-size: 1.3em; text-align: center; height: 80px; vertical-align: middle;">
          <span style="float: left; font-size: 1.3em;"><%=dto.getE_subject() %></span>
          <span class="day"><%=name %> | <%=sdf.format(dto.getE_writeday()) %></span>
      
        </td>
      </tr>
      
      <tr height="300" align="center">
        <td>
           <img alt="" src="eventsave/<%=dto.getE_image()%>" style="height: 200px;"><br><br><br>
           <%=dto.getE_content().replace("\n", "<br>") %><br><br>
        </td>
     </tr>
      
      
      <!-- 버튼 -->
      <% 
       //버튼
      //로그인한 아이디와 글을 쓴 아이디가 같을경우에만
    	if (loginok!=null && myid.equals("admin")) {%>
    	 
      <tr>
       <td colspan="1" align="right">
       
       <span class="chu">조회 : <%=dto.getE_readcount()%></span>
       		<div class="chu">
    				<span style="display: inline-block;">
        		<i class="icon1 bi bi-hand-thumbs-up" e_num=<%=dto.getE_num() %>></i>
    				</span>&nbsp;&nbsp;
    				<span>추천 : <%=dto.getE_chu() %></span>
					</div>
       
         <button type="button" class="btn btn-success col" style="width: 80px; height: 40px;" 
         onclick="location.href='index.jsp?main=eventboard/eventForm.jsp'">글쓰기</button>
         <button type="button" class="btn btn-success col" style="width: 80px; height: 40px;"
         onclick="location.href='index.jsp?main=eventboard/eventUpdateForm.jsp?e_num=<%=e_num%>&currentPage=<%=currentPage%>'">
         수정</button>
         <button type="button" class="btn btn-success col" style="width: 80px; height: 40px;" 
         onclick="funcdel(<%=e_num%>,<%=currentPage%>)">삭제</button>
         <button type="button" class="btn btn-success col" style="width: 80px; height: 40px;" 
         onclick="location.href='index.jsp?main=eventboard/eventList.jsp'">목록</button>
      
       </td>
		</tr>	
      <%}	
      
    	else {%>
  	      <tr>
            <td colspan="1" align="right" style="background-color: #ebeae7;">
            <span class="chu">조회 : <%=dto.getE_readcount()%></span>
       		<div class="chu">
    				<span style="display: inline-block;">
        		<i class="icon1 bi bi-hand-thumbs-up" e_num=<%=dto.getE_num() %>></i>
    				</span>&nbsp;&nbsp;
    				<span>추천 : <%=dto.getE_chu() %></span>
					</div>
            
  		      <button type="button" class="btn btn-success col" style="width: 80px; height: 40px;" 
              onclick="location.href='index.jsp?main=eventboard/eventList.jsp'">목록</button>
           
            </td>
          </tr>   
        <%}
      
         %>   
			
		</table> 
	  </form>	
   </div>
</body>
</html>