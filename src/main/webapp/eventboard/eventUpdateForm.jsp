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
  
  #showing {
    width: 500px;
  }
  
  
</style>

<script type="text/javascript">
  
  function readURL(input) {
	
	if (input.files && input.files[0]) {
		var reader = new FileReader();
		
		reader.onload = function(e) {

	    $('#showing').attr('src', e.target.result);

     	}
			reader.readAsDataURL(input.files[0]);

		}
	}
</script>


</head>
  <%

   //num,currentPage
   String e_num = request.getParameter("e_num");
   String currentPage = request.getParameter("currentPage");
   
   EventDao dao = new EventDao();
   EventDto dto = dao.getDataEvent(e_num);
%>
<body>
  <!-- 메뉴 타이틀 -->
  <div style="margin-top: 70px; text-align: center;"><h4><b>이벤트</b></h4></div>
  

  <!-- 저장폼  -->
   <div style="margin: 100px 200px; width: 800px; margin-left: 28%;">
     <form action="eventboard/eventUpdateAction.jsp" method="post" enctype="multipart/form-data">
      <input type="hidden" name=e_num  value="<%=e_num%>">
      <input type="hidden" name="currentPage" value="<%=currentPage%>">
       <table class="table">
         <caption align="top"><h5><b>공지사항 수정</b></h5></caption>
           <tr>
             <td>
               <input type="text" name="e_subject" class="form-control" required="required"
               style="width: 800px;" value="<%=dto.getE_subject() %>">
             </td>
           </tr>
           
           <tr  align="center">
             <td>
               <img id="showing" src="<%=(dto.getE_image()==null?"":"noticesave/"+dto.getE_image())%>"><br><br>
               <textarea type="text" name="e_content" class="form-control" required="required"
               style="width: 800px; height: 300px; text-align: center;"><%=dto.getE_content() %></textarea>
             </td>
           </tr>
           
           <tr>
             <td>
                
                <input type="file" name="e_image" class="form-control" style="width: 800px;"
                 id="e_image" onchange="readURL(this)">
             </td>
           </tr>
           
           <tr>
             <td colspan="1" align="right">
               <button type="submit" class="btn btn-success col" style="width: 80px; height: 40px;">수정</button>
               <button type="button" class="btn btn-success col" style="width: 80px; height: 40px;"
               onclick="location.href='index.jsp?main=eventboard/eventList.jsp'">목록</button>
             </td>
           </tr>
           
           
       </table> 
     </form>
   </div>


</body>
</html>