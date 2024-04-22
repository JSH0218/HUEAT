<%@page import="grade.model.GradeDao"%>
<%@page import="hugesoinfo.model.HugesoInfoDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%	
    String h_num=request.getParameter("h_num");
	String g_num=request.getParameter("g_num");
    GradeDao dao = new GradeDao();
    dao.deleteGrade(g_num);
%>