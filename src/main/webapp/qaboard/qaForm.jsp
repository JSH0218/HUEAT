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
  table.table tr,table.table td{
  	border: none;
  }
  
</style>
</head>
<body>
  <!-- 메뉴 타이틀 -->
  <div style="margin-top: 70px; text-align: center;"><h4><b>고객문의</b></h4></div>
  

  <!-- 저장폼  -->
   <div style="margin: 100px 200px; width: 800px; margin-left: 28%;">
     <form action="qaboard/qaAction.jsp" method="post">
       <table class="table">
         <caption align="top"><h5><b>글쓰기</b></h5></caption>
           <tr>
             <td>
               <select name="q_category" id="q_category" class="form-control" required="required" 
               style="width: 200px;">
                 <option value="회원가입 문의">회원가입 문의</option>
                 <option value="홈페이지 문의">홈페이지 문의</option>
                 <option value="공지사항 문의">공지사항 문의</option>
                 <option value="이벤트 문의">이벤트 문의</option>
                 <option value="휴게소 문의">휴게소 문의</option>
                 <option value="주유소 문의">주유소 문의</option>
               </select>
             </td>
           
             <td>
               <input type="text" name="q_subject" id="q_subject" class="form-control" required="required"
               placeholder="제목을 입력하세요" style="width: 590px; margin-left: -102.5%;">
             </td>
           </tr>
           
           <tr>
             <td>
               <textarea type="text" name="q_content" id="q_content" class="form-control" required="required"
               placeholder="내용을 입력하세요" style="width: 800px; height: 300px;"></textarea>
             </td>

           </tr>
         
           <tr>
             <td colspan="1" align="right">
               <button type="submit" class="btn btn-success col" style="width: 80px; height: 40px;">등록</button>
               <button type="button" class="btn btn-success col" style="width: 80px; height: 40px;"
               onclick="location.href='index.jsp?main=qaboard/qaList.jsp'">목록</button>
             </td>
           </tr>
           
           
       </table> 
     </form>
   </div>

</body>
</html>