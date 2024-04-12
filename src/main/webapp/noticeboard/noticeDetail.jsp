<%@page import="notice.model.NoticeDto"%>
<%@page import="notice.model.NoticeDao"%>
<%@page import="java.text.SimpleDateFormat"%>
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
  
  span.chu {
    
    font-size: 0.8em;
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
		  
		  var n_num = $(this).attr("n_num");
		  //alert(n_num);
		  var tag = $(this); 
		  
		  
		  $.ajax ({
			type : "get",
			dataType : "json",
			url : "noticeboard/noticeChu.jsp",
			data : {"n_num":n_num},
			success : function (data) {
				
				//alert(data.chu);
				tag.next().next().text(data.chu);
				//location.reload();
				
			}
			
			  
		  })
		  
	  })
		
	});

  //게시물 삭제
  function funcdel(n_num,currentPage){
	   
	   //alert(n_num+","+currentPage);
	   
	  var ans=confirm("삭제하려면 [확인]을 눌러주세요");
	   
	   if(ans){
		   location.href='noticeboard/noticeDelete.jsp?n_num='+n_num+"&currentPage="+currentPage;
	   } 
  }
 
 
 

  
</script>
</head>

  <%
  
    String n_num = request.getParameter("n_num");
    NoticeDao dao = new NoticeDao();
    
    NoticeDto dto = dao.getDataNotice(n_num);
    String currentPage=request.getParameter("currentPage");
    
    //조회수 가져오기
    dao.updateReadcount(n_num);
    
    //날짜
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
  
  %>
<body>

  <!-- 메뉴 타이틀 -->
  <input type="hidden" id="n_num" value="<%=n_num%>">
  <div style="margin-top: 70px; text-align: center;"><h4><b>공지사항</b></h4></div>
  

  <!-- 저장폼  -->
   <div style="margin: 100px 200px; width: 800px; margin-left: 28%;">
    <form id="frm">
     <table class="table">
      <caption align="top"><h5><b><%=dto.getN_subject() %></b></h5></caption>
      
      <tr>
        <td>
          <b style="position: absolute; margin-top: 3%;">작성자 : <%=dto.getN_subject() %></b><br>
          <span class="day"><%=sdf.format(dto.getN_writeday()) %></span><br>
          <span class="read">조회 : <%=dto.getN_readcount()%></span>
          <i class="icon1 bi bi-hand-thumbs-up" n_num=<%=dto.getN_num() %>></i>
          <span class="likes">추천 : </span>
    	  <span class="chu"><%=dto.getN_chu() %></span>
    	  
          
        </td>
      </tr>
      
      <tr height="300" align="center">
        <td>
           <img alt="" src="noticesave/<%=dto.getN_image()%>"><br><br><br>
           <%=dto.getN_content().replace("\n", "<br>") %><br><br>
        </td>
     </tr>
      
      
      <!-- 버튼 -->
       
      <tr>
       <td colspan="1" align="right">
         <button type="button" class="btn btn-success col" style="width: 80px; height: 40px;" 
         onclick="location.href='index.jsp?main=noticeboard/noticeForm.jsp'">글쓰기</button>
         <button type="button" class="btn btn-success col" style="width: 80px; height: 40px;" 
         onclick="location.href='index.jsp?main=noticeboard/noticeList.jsp'">목록</button>
         <button type="button" class="btn btn-success col" style="width: 80px; height: 40px;"
         onclick="location.href='index.jsp?main=noticeboard/noticeUpdateForm.jsp?n_num=<%=n_num%>&currentPage=<%=currentPage%>'">
         수정</button>
         <button type="button" class="btn btn-success col" style="width: 80px; height: 40px;" 
         onclick="funcdel(<%=n_num%>,<%=currentPage%>)">삭제</button>
      
       </td>
		</tr>		
			
		</table> 
	  </form>	
   </div>
</body>
</html>