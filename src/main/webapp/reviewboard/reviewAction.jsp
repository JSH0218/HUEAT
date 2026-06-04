<%@page import="util.AppConfig"%>
<%@page import="util.SecurityUtil"%>
<%@page import="review.model.ReviewDao"%>
<%@page import="review.model.ReviewDto"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
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
    
	//로그인 세션얻기
	String loginok=(String)session.getAttribute("loginok");
	//아이디 얻기
	String myid=(String)session.getAttribute("myid");
  
    //로그인한 사용자만 작성 가능
    if(loginok==null || myid==null){
        response.sendRedirect("../index.jsp?main=member/loginform.jsp");
        return;
    }

    String uploadPath = AppConfig.getUploadPath("review");

    int uploadSize = 1024*1024*5;

    MultipartRequest multi = null;

    try{

    	multi = new MultipartRequest(request,uploadPath,uploadSize,"utf-8",new DefaultFileRenamePolicy());

    	//CSRF 토큰 검증(멀티파트라 multi에서 _csrf를 읽어 검증)
    	if(!SecurityUtil.isPost(request) || !SecurityUtil.checkCsrf(session, multi.getParameter("_csrf"))){
%>
    		<script type="text/javascript">
    			alert("요청이 유효하지 않습니다.");
    			history.back();
    		</script>
<%
    		return;
    	}

    	String r_category = multi.getParameter("r_category");
    	String r_content = multi.getParameter("r_content");
    	String r_image = multi.getFilesystemName("r_image");

    	//업로드 파일 검증(허용 이미지 외에는 삭제 후 거부)
    	if(!SecurityUtil.validateOrDelete(uploadPath, r_image)){
    %>
    		<script type="text/javascript">
    			alert("이미지 파일(jpg, png, gif)만 업로드할 수 있습니다.");
    			history.back();
    		</script>
    <%
    		return;
    	}

    	//dao선언
    	ReviewDao dao = new ReviewDao();

    	//dto저장
    	ReviewDto dto = new ReviewDto();

    	dto.setR_myid(myid);
    	dto.setR_category(r_category);
    	dto.setR_content(r_content);
    	dto.setR_image(r_image);

    	//db추가
    	dao.insertReview(dto);

    	//방명록 목록으로 이동
    	response.sendRedirect("../index.jsp?main=reviewboard/reviewList.jsp");

    } catch (Exception e) {
    	e.printStackTrace();
    }
  %>

</body>
</html>