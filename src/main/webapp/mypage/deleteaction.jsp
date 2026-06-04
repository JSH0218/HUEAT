<%@page import="meminfo.model.MemInfoDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Dongle&family=Nanum+Pen+Script&family=Noto+Sans+KR:wght@100..900&family=Single+Day&family=Stylish&display=swap" rel="stylesheet">
<script src="https://code.jquery.com/jquery-3.7.0.js"></script>
<title>Insert title here</title>
</head>
<body>
<%
	request.setCharacterEncoding("utf-8");

	// 로그인 사용자 확인
	String loginok=(String)session.getAttribute("loginok");
	String myid=(String)session.getAttribute("myid");
	if(loginok==null || myid==null){
		response.sendRedirect("../index.jsp?main=member/loginform.jsp");
		return;
	}

	// 상태변경은 POST + CSRF 토큰 검증(폼의 _csrf vs 세션 토큰)
	if(!util.SecurityUtil.isPost(request) || !util.SecurityUtil.checkCsrf(request)){
		response.sendError(403);
		return;
	}

	String m_pass=request.getParameter("m_pass");

	MemInfoDao dao=new MemInfoDao();

	// 서버 측 비밀번호 검증(실패 시 탈퇴 거부)
	if(!dao.isIdPassMember(myid, m_pass)){
%>
	<script type="text/javascript">
		alert("비밀번호가 일치하지 않습니다.");
		history.back();
	</script>
<%
		return;
	}

	// 폼의 m_num을 신뢰하지 않고 로그인 사용자 본인 계정만 삭제
	String m_num=dao.getAlldatas(myid).getM_num();
	dao.deleteMember(m_num);

	// 세션 무효화 (로그아웃)
    session.invalidate();

	response.sendRedirect("../index.jsp");
%>
	
</body>
</html>