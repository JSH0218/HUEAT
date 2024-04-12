<%@page import="review.model.ReviewDto"%>
<%@page import="review.model.ReviewDao"%>
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
    margin-left: -118%;
    margin-top: 347%;
    
  }
  
    #showing {
    width: 300px;
    display: block;
        margin: auto;
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
   String r_num = request.getParameter("r_num");
   String currentPage = request.getParameter("currentPage");
   
   ReviewDao dao = new ReviewDao();
   ReviewDto dto = dao.getDataReview(r_num);
%>
<body>
  
   <!-- 메뉴 타이틀 -->
  <div style="margin-top: 70px; text-align: center;"><h4><b>고객후기</b></h4></div>
  
  <!-- 저장폼  -->
   <div style="margin: 100px 200px; width: 800px; margin-left: 25%;">
     <form action="reviewboard/reviewUpdateAction.jsp" method="post" enctype="multipart/form-data">
      <input type="hidden" name=r_num  value="<%=r_num%>">
      <input type="hidden" name="currentPage" value="<%=currentPage%>">
       <table class="table">
         <caption align="top"><h5><b>후기 수정</b></h5></caption>
         
         <tr>
           <td>
             <img id="showing" src="<%=(dto.getR_image()==null?"":"reviewsave/"+dto.getR_image())%>"><br><br>
             <textarea type="text" name="r_content" class="form-control" required="required"
               style="width: 690px; height: 100px;" ><%=dto.getR_content() %></textarea>
           </td>
           
           <td>
             <button type="submit" class="btn btn-success col" 
             style="width: 100px; height: 100px;">수정</button>
           </td>
         </tr>
         
         <tr>
             <td>
                <input type="file" name="r_image" class="form-control" style="width: 800px;"
                id="r_image" onchange="readURL(this)">
             </td>
         </tr>
       </table>
     </form>
    </div>

</body>
</html>