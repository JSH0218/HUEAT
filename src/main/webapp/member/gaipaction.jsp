<%@page import="util.SecurityUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Grandiflora+One&family=Gugi&family=Hahmlet:wght@100..900&family=Hi+Melody&family=Sunflower:wght@300&display=swap" rel="stylesheet">
<script src="https://code.jquery.com/jquery-3.7.0.js"></script>
<title>Insert title here</title>
</head>
<body>
<%
request.setCharacterEncoding("utf-8");

%>
<jsp:useBean id="dao" class="meminfo.model.MemInfoDao"/>
<jsp:useBean id="dto" class="meminfo.model.MemInfoDto"/>
<jsp:setProperty property="*" name="dto"/>
<%
// 1) 예약 아이디(admin 등) 가입 차단 — 권한 상승 방지
if (SecurityUtil.isReservedId(dto.getM_id())) {
%>
	<script type="text/javascript">
		alert("사용할 수 없는 아이디입니다.");
		history.back();
	</script>
<%
	return;
}

// 2) 아이디 중복 서버 측 재확인
if (dao.idcount(dto.getM_id()) > 0) {
%>
	<script type="text/javascript">
		alert("이미 사용 중인 아이디입니다.");
		history.back();
	</script>
<%
	return;
}

// 3) 비밀번호를 BCrypt 해시로 변환 후 저장
dto.setM_pass(SecurityUtil.hashPassword(dto.getM_pass()));

dao.insertMember(dto);
response.sendRedirect("../index.jsp");
%>
</body>
</html>