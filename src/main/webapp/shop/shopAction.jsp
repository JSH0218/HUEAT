<%@page import="util.AppConfig"%>
<%@page import="util.SecurityUtil"%>
<%@page import="shop.ShopDto"%>
<%@page import="shop.ShopDao"%>
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
   //로그인상태확인
    String loginok=(String)session.getAttribute("loginok");
    String myid=(String)session.getAttribute("myid");
    //관리자만 상품 등록 가능
    if(!util.SecurityUtil.isAdmin(session)){
        response.sendRedirect("../index.jsp?main=shop/shopList.jsp");
        return;
    }

    //이미지 업로드 경로(웹루트 외부)
    String uploadPath = AppConfig.getUploadPath("shop");

    //업로드할 사이즈
    int uploadSize = 1024*1024*5;

    MultipartRequest multi = null;

    try {

    	multi = new MultipartRequest(request, uploadPath, uploadSize, "utf-8", new DefaultFileRenamePolicy());

    	//CSRF 토큰 검증(멀티파트라 multi에서 _csrf를 읽어 검증)
    	if(!SecurityUtil.checkCsrf(session, multi.getParameter("_csrf"))){
%>
    		<script type="text/javascript">
    			alert("요청이 유효하지 않습니다.");
    			history.back();
    		</script>
<%
    		return;
    	}

    	String s_category = multi.getParameter("s_category");
    	String s_site = multi.getParameter("s_site");
    	String s_image = multi.getFilesystemName("s_image");

    	//업로드 파일 검증(허용 이미지 외에는 삭제 후 거부)
    	if(!SecurityUtil.validateOrDelete(uploadPath, s_image)){
%>
    		<script type="text/javascript">
    			alert("이미지 파일(jpg, png, gif)만 업로드할 수 있습니다.");
    			history.back();
    		</script>
<%
    		return;
    	}

    	//dao 선언
    	ShopDao dao= new ShopDao();
    	
    	//dto 데이터담기
    	ShopDto dto= new ShopDto();
    	

    	dto.setS_category(s_category);
    	dto.setS_site(s_site);
    	dto.setS_image(s_image);
    	
    	//db에 추가
    	dao.insertShop(dto);
    	
    	//공지사항 목록으로 이동
    	response.sendRedirect("../index.jsp?main=shop/shopList.jsp");

     } catch(Exception e) {
    	e.printStackTrace();
    }
  
  %>
</body>
</html>