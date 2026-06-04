<%@page import="meminfo.model.MemInfoDao"%>
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
// 로그인 CSRF 차단: POST + 세션 CSRF 토큰 검증 후에만 인증 처리
if(!util.SecurityUtil.isPost(request) || !util.SecurityUtil.checkCsrf(request)){
	response.sendError(403); return;
}
String id=request.getParameter("m_id");
String pass=request.getParameter("m_pass");
String cbsave=request.getParameter("cbsave");

MemInfoDao dao=new MemInfoDao();

boolean b=dao.isIdPassMember(id, pass);

if(b){

	//세션 고정(Session Fixation) 공격 방지: 인증 성공 직후 세션 ID 재발급
	request.changeSessionId();

	//8시간유지
	session.setMaxInactiveInterval(60*60*8);

	session.setAttribute("loginok", "yes");
	session.setAttribute("myid", id);
	// 권한(USER/ADMIN)을 세션에 저장 — 관리자 판별은 이 값으로만 한다
	session.setAttribute("role", dao.getRole(id));
	session.setAttribute("saveok", cbsave==null?null:"yes" );
	response.sendRedirect("../index.jsp");
	
}else{%>
	<script type="text/javascript">
		alert("아이디와 비밀번호가 맞지않습니다.");
		history.back();
	</script>
<%}

%>
</body>
</html>