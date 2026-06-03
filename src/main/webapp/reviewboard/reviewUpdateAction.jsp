<%@page import="util.AppConfig"%>
<%@page import="util.SecurityUtil"%>
<%@page import="review.model.ReviewDto"%>
<%@page import="review.model.ReviewDao"%>
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
	String myid = (String) session.getAttribute("myid");
	if(myid==null){
		response.sendRedirect("../index.jsp?main=member/loginform.jsp");
		return;
	}

	String realPath = AppConfig.getUploadPath("review");

	int uploadSize = 1024 * 1024 * 5;

	MultipartRequest multi = null;
	try {
		multi = new MultipartRequest(request, realPath, uploadSize, "utf-8", new DefaultFileRenamePolicy());

		String r_num = multi.getParameter("r_num");
		String currentPage = multi.getParameter("currentPage");
		String r_content = multi.getParameter("r_content");
		String r_category = multi.getParameter("r_category");
		String r_image = multi.getFilesystemName("r_image");

		//업로드 파일 검증(허용 이미지 외에는 삭제 후 거부)
		if(!SecurityUtil.validateOrDelete(realPath, r_image)){
%>
		<script type="text/javascript">
			alert("이미지 파일(jpg, png, gif)만 업로드할 수 있습니다.");
			history.back();
		</script>
<%
			return;
		}

		//기존포토명 가져오기 -> 기존에 사진값을 가져오기 위해서 dao 먼저 선언
		ReviewDao dao = new ReviewDao();
		ReviewDto old = dao.getDataReview(r_num);
		String old_photoName = old.getR_image();

		//작성자 본인 또는 관리자만 수정 가능
		boolean isAdmin = "ADMIN".equals((String)session.getAttribute("role"));
		if(!isAdmin && !myid.equals(old.getR_myid())){
%>
		<script type="text/javascript">
			alert("수정 권한이 없습니다.");
			history.back();
		</script>
<%
			return;
		}

		//dto에 저장
		ReviewDto dto = new ReviewDto();

		dto.setR_num(r_num);
		dto.setR_myid(myid);
		dto.setR_category(r_category);
		dto.setR_content(r_content);

		//사진 선택을 안하면 기존의 사진으로 저장
		dto.setR_image(r_image == null ? old_photoName : r_image);

		//update
		dao.updateReview(dto);

		//방명록 목록으로 이동(수정했던 페이지로 이동)
		response.sendRedirect("../index.jsp?main=reviewboard/reviewList.jsp?currentPage=" + currentPage);

	} catch (Exception e) {
		e.printStackTrace();
	}
	%>

</body>
</html>