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

	String realPath = getServletContext().getRealPath("/reviewsave");
	System.out.println(realPath);

	int uploadSize = 1024 * 1024 * 5;

	MultipartRequest multi = null;
	try {
		multi = new MultipartRequest(request, realPath, uploadSize, "utf-8", new DefaultFileRenamePolicy());

		String r_num = multi.getParameter("r_num");
		String currentPage = multi.getParameter("currentPage");
		String r_content = multi.getParameter("r_content");
		String r_image = multi.getFilesystemName("r_image");

		//기존포토명 가져오기 -> 기존에 사진값을 가져오기 위해서 dao 먼저 선언
		ReviewDao dao = new ReviewDao();
		String old_photoName = dao.getDataReview(r_num).getR_image();

		//dto에 저장
		ReviewDto dto = new ReviewDto();

		dto.setR_num(r_num);
		dto.setR_myid(myid);
		dto.setR_content(r_content);

		//사진 선택을 안하면 기존의 사진으로 저장
		dto.setR_image(r_image == null ? old_photoName : r_image);

		//update
		dao.updateReview(dto);

		//방명록 목록으로 이동(수정했던 페이지로 이동)
		response.sendRedirect("../index.jsp?main=reviewboard/reviewList.jsp?currentPage=" + currentPage);

	} catch (Exception e) {

	}
	%>

</body>
</html>