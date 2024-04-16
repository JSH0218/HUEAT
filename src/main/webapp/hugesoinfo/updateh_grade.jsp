<%@page import="hugesoinfo.model.HugesoInfoDao"%>
<%@page import="hugesoinfo.model.HugesoInfoDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
	request.setCharacterEncoding("utf-8");

	String h_num=request.getParameter("h_num");
	String h_grade=request.getParameter("h_grade");
	String h_gradecount=request.getParameter("h_gradecount");

	HugesoInfoDto dto=new HugesoInfoDto();
	dto.setH_num(h_num);
	dto.setH_grade(h_grade);
	dto.setH_gradecount(h_gradecount);
	
	HugesoInfoDao dao = new HugesoInfoDao();
	dao.updateH_grade(dto);

%>
