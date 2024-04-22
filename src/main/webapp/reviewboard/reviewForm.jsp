<%@page import="hugesoinfo.model.HugesoInfoDto"%>
<%@page import="java.util.List"%>
<%@page import="hugesoinfo.model.HugesoInfoDao"%>
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
    
  }
  
  
</style>
</head>
<%
  HugesoInfoDao hdao = new HugesoInfoDao();
  List<HugesoInfoDto> hlist = hdao.getAllDatas();
  
%>
<body>
  
   <!-- 메뉴 타이틀 -->
  <div style="margin-top: 70px; text-align: center;"><h4><b>고객후기</b></h4></div>
  
  <!-- 저장폼  -->
   <div style="margin: 100px 200px; width: 800px; margin-left: 25%;">
     <form action="reviewboard/reviewAction.jsp" method="post" enctype="multipart/form-data">
       <table class="table">
         <caption align="top"><h5><b>후기등록</b></h5></caption>
             <td>
               <select name="r_category" id="r_category" class="form-control" required="required" 
               style="width: 200px;">
                 <% for (HugesoInfoDto hugeso : hlist) { %>
                     <option value="<%= hugeso.getH_name() %>"><%= hugeso.getH_name() %></option>
                 <% } %>
               </select>
             </td>
         
         <tr>
           <td>
             <textarea type="text" name="r_content" class="form-control" required="required"
               placeholder="후기를 작성해주세요" style="width: 690px; height: 100px;"></textarea>
           </td>
           
           <td>
             <button type="submit" class="btn btn-success col" 
             style="width: 100px; height: 100px;">등록</button>
           </td>
         </tr>
         
         <tr>
             <td>
                <input type="file" name="r_image" class="form-control" style="width: 800px;">
             </td>
         </tr>
       </table>
     </form>
    </div>

</body>
</html>