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
.line1 {
    border-bottom: 1px solid black; /* 가로 라인 스타일 지정 */
    width: 600px; /* 라인의 길이 설정 */
    margin: 100px 100px;
    
}

.line2 {
    border-bottom: 1px solid black; /* 가로 라인 스타일 지정 */
    width: 600px; /* 라인의 길이 설정 */
    margin: 100px 200px;
}

.line3 {
    border-bottom: 1px solid black; /* 가로 라인 스타일 지정 */
    width: 600px; /* 라인의 길이 설정 */
    margin: 200px 100px;
    
}

</style>
</head>
  <%
   //프로젝트 경로
   String root = request.getContextPath();  
  %>
<body>
  <div class="d-inline-flex" style="margin: 100px 100px;">
    
    <div class="line1">
      <b>+공지사항<b>
        
        <!-- 공지사항 목록 불러오는 코딩 넣을 예정 -->
    </div>
    
    <div class="line2">
      <b>+이벤트<b>
        <!-- 이벤트 목록 불러오는 코딩 넣을 예정 -->
    </div>
       
  </div>
  
  
  <div class="d-inline-flex" style="margin: 100px 100px;">
    
    <div class="line1">
      <b>+이달의 휴게소<b>
        <!-- 공지사항 목록 불러오는 코딩 넣을 예정 -->
    </div>
    
    <div class="line2">
      <b>+이달의 메뉴<b>
        <!-- 이벤트 목록 불러오는 코딩 넣을 예정 -->
    </div>
       
  </div>
  
  
    
    
   
</body>
</html>