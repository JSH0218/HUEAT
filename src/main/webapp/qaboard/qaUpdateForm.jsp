<%@page import="qa.model.QaDto"%>
<%@page import="qa.model.QaDao"%>
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
</head>

  <%

   //num,currentPage
   String q_num = request.getParameter("q_num");
   String currentPage = request.getParameter("currentPage");
   
   QaDao dao = new QaDao();
   QaDto dto = dao.getDataQa(q_num);
   %>
<body>

   <!-- 메뉴 타이틀 -->
  <div style="margin-top: 200px; text-align: center;"><h4><b>고객문의</b></h4></div>
  

  <!-- 저장폼  -->
   <div style="margin: 100px 200px; width: 800px; margin-left: 28%;">
     <form action="qaboard/qaUpdateAction.jsp" method="post">
      <input type="hidden" name="q_num"  value="<%=q_num%>">
      <input type="hidden" name="currentPage" value="<%=currentPage%>">
       <table class="table">
         <caption align="top"><h5><b>문의글 수정</b></h5></caption>
           <tr>
             <td>
               <select name="q_category" class="form-control" required="required" 
               style="width: 200px;">
                 <option value="회원가입 문의" <%= dto.getQ_category().equals("회원가입 문의") ? "selected" : "" %>>회원가입 문의</option>
                 <option value="홈페이지 문의" <%= dto.getQ_category().equals("홈페이지 문의") ? "selected" : "" %>>홈페이지 문의</option>
                 <option value="공지사항 문의" <%= dto.getQ_category().equals("공지사항 문의") ? "selected" : "" %>>공지사항 문의</option>
                 <option value="이벤트 문의" <%= dto.getQ_category().equals("이벤트 문의") ? "selected" : "" %>>이벤트 문의</option>
                 <option value="휴게소 문의" <%= dto.getQ_category().equals("휴게소 문의") ? "selected" : "" %>>휴게소 문의</option>
                 <option value="주유소 문의" <%= dto.getQ_category().equals("주유소 문의") ? "selected" : "" %>>주유소 문의</option>
               </select>
             </td>
           
             <td>
               <input type="text" name="q_subject"class="form-control" required="required"
               style="width: 590px; margin-left: -102.5%;" value="<%=dto.getQ_subject()%>">
             </td>
           </tr>
           
           <tr>
             <td>
               <textarea type="text" name="q_content" class="form-control" required="required"
               style="width: 800px; height: 300px; text-align: center;"><%=dto.getQ_content() %></textarea>
             </td>
           </tr>
         
           <tr>
             <td colspan="1" align="right">
               <button type="submit" class="btn btn-success col" style="width: 80px; height: 40px;">수정</button>
               <button type="button" class="btn btn-success col" style="width: 80px; height: 40px;"
               onclick="location.href='index.jsp?main=qaboard/qaList.jsp'">목록</button>
             </td>
           </tr>
           
           
       </table> 
     </form>
   </div>

</body>
</html>