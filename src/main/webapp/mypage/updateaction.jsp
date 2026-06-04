<%@page import="util.SecurityUtil"%>
<%@page import="meminfo.model.MemInfoDao"%>
<%@page import="meminfo.model.MemInfoDto"%>
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

	// 상태변경은 POST + CSRF 토큰 검증(위조 요청 차단)
	if(!SecurityUtil.isPost(request) || !SecurityUtil.checkCsrf(request)){
%>
	<script type="text/javascript">
		alert("요청이 유효하지 않습니다.");
		history.back();
	</script>
<%
		return;
	}

	// 로그인 사용자 확인
	String loginok=(String)session.getAttribute("loginok");
	String myid=(String)session.getAttribute("myid");
	if(loginok==null || myid==null){
		response.sendRedirect("../index.jsp?main=member/loginform.jsp");
		return;
	}

	// m_num은 클라이언트 입력을 신뢰하지 않고 세션 사용자로부터 서버에서 도출(IDOR 방지)
	String m_pass=request.getParameter("m_pass");   // 현재 비밀번호(평문)
	String m_upass=request.getParameter("m_upass");  // 새 비밀번호(평문, 비어있으면 변경 안 함)
	String m_name=request.getParameter("m_name");
	String m_nick=request.getParameter("m_nick");
	String m_email=request.getParameter("m_email");
	String m_hp1=request.getParameter("m_hp1");
	String m_hp2=request.getParameter("m_hp2");
	String m_birth=request.getParameter("m_birth");

	MemInfoDao dao=new MemInfoDao();

	// 서버 측 현재 비밀번호 검증(클라이언트 비교 제거)
	if(!dao.isIdPassMember(myid, m_pass)){
%>
	<script type="text/javascript">
		alert("현재 비밀번호가 일치하지 않습니다.");
		history.back();
	</script>
<%
		return;
	}

	// 기존 회원 정보(저장된 해시 포함) 조회
	MemInfoDto current=dao.getAlldatas(myid);

	// 새 비밀번호가 비어 있으면 기존 해시 유지, 입력되면 새로 해시
	String finalPass;
	if(m_upass==null || m_upass.trim().isEmpty()){
		finalPass=current.getM_pass();
	}else{
		finalPass=SecurityUtil.hashPassword(m_upass);
	}

	MemInfoDto dto=new MemInfoDto();
	dto.setM_num(current.getM_num());
	dto.setM_pass(finalPass);
	dto.setM_name(m_name);
	dto.setM_nick(m_nick);
	dto.setM_email(m_email);
	dto.setM_hp1(m_hp1);
	dto.setM_hp2(m_hp2);
	dto.setM_birth(m_birth);

	dao.updateMember(dto);

	//마이페이지
	response.sendRedirect("../index.jsp?main=mypage/updatepassform.jsp");
%>
</body>
</html>