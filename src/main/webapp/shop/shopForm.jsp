<%@page import="hugesoinfo.model.HugesoInfoDto"%>
<%@page import="java.util.List"%>
<%@page import="hugesoinfo.model.HugesoInfoDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
    <link href="https://fonts.googleapis.com/css2?family=Nanum+Gothic&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <script src="https://code.jquery.com/jquery-3.7.0.js"></script>
<title>Insert title here</title>
<style type="text/css">

  button.col {
    background-color: #618E6E;
    right: 20%;
  }
  
  
</style>
</head>
<%
  HugesoInfoDao hdao = new HugesoInfoDao();
  List<HugesoInfoDto> hlist = hdao.getAllDatas();
  
%>
<body>
  

  <!-- 저장폼  -->
   <div style="margin: 100px 200px; width: 800px; margin-left: 28%;">
     <form action="shop/shopAction.jsp" method="post" enctype="multipart/form-data">
       <table class="table">
         <caption align="top"><h5><b>쇼핑몰 추가</b></h5></caption>
           <tr>
             <td>
               <select name="s_category" id="s_category" class="form-control" required="required" 
               style="width: 200px;">
                 <% for (HugesoInfoDto hugeso : hlist) { %>
                     <option value="<%= hugeso.getH_name() %>"><%= hugeso.getH_name() %></option>
                 <% } %>
               </select>
             </td>
            
            <tr> 
             <td>
               <input type="text" name="s_site" id="s_site" class="form-control" required="required"
               placeholder="사이트 주소를 입력하세요" style="width: 800px;">
             </td>
            <tr>  
           
           <tr>
             <td>
                <input type="file" name="s_image" class="form-control" style="width: 800px;">
             </td>
           </tr>
           
           <tr>
             <td colspan="1" align="right">
               <button type="submit" class="btn btn-success col" style="width: 80px; height: 40px;">등록</button>
               <button type="button" class="btn btn-success col" style="width: 80px; height: 40px;"
               onclick="location.href='index.jsp?main=shop/shopList.jsp'">목록</button>
             </td>
           </tr>
           
           
       </table> 
     </form>
   </div>

</body>
</html>