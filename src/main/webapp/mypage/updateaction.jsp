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

	String m_num=request.getParameter("m_num");
	String m_pass=request.getParameter("m_pass");
	String m_upass=request.getParameter("m_upass");
	String m_name=request.getParameter("m_name");
	String m_nick=request.getParameter("m_nick");
	String m_email=request.getParameter("m_email");
	String m_hp1=request.getParameter("m_hp1");
	String m_hp2=request.getParameter("m_hp2");
	String m_birth=request.getParameter("m_birth");

	MemInfoDto dto=new MemInfoDto();
	dto.setM_num(m_num);
	dto.setM_pass(m_upass);
	dto.setM_name(m_name);
	dto.setM_nick(m_nick);
	dto.setM_email(m_email);
	dto.setM_hp1(m_hp1);
	dto.setM_hp2(m_hp2);
	dto.setM_birth(m_birth);
	
	MemInfoDao dao=new MemInfoDao();
	dao.updateMember(dto);

	//마이페이지
	response.sendRedirect("../index.jsp?main=mypage/updatepassform.jsp#container");
%>
</body>
</html>