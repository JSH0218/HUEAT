<%@page import="java.io.File"%>
<%@page import="review.model.ReviewDao"%>
<%@page import="review.model.ReviewDto"%>
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
<body>

  <%
  
    //db삭제뿐 아니라 업로드된 파일도 삭제하기
    String r_num = request.getParameter("r_num");
    String currentPage = request.getParameter("currentPage");

    // CSRF 토큰 검증(위조 요청 차단)
    if(!util.SecurityUtil.checkCsrf(request)){ response.sendError(403); return; }

    //db로 부터 저장된 이미지명 얻기
    ReviewDao dao = new ReviewDao();
    ReviewDto old = dao.getDataReview(r_num);

    // 로그인 + 작성자 본인(또는 관리자)만 삭제 가능
    if(!util.SecurityUtil.isLogin(session) || old==null
            || !util.SecurityUtil.isOwnerOrAdmin(session, old.getR_myid())){
%>
<script type="text/javascript">alert("삭제 권한이 없습니다."); history.back();</script>
<%
        return;
    }

    String r_image = old.getR_image();

    //db삭제
    dao.deleteReview(r_num);
    
    
    //파일삭제
    //프로젝트 실제경로구하기
    String realPath = getServletContext().getRealPath("/reviewsave");
    
    //파일 객체 생성
    File file = new File(realPath+"/"+r_image);
    
    //파일 삭제
    if(file.exists()) {
    	file.delete();
    	
    	//보던 페이지로 이동
    }
   	response.sendRedirect("../index.jsp?main=reviewboard/reviewList.jsp?currentPage="+currentPage);
  
  %>

</body>
</html>