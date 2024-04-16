<%@page import="meminfo.model.MemInfoDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
String m_num=request.getParameter("m_num");
MemInfoDao dao=new MemInfoDao();
dao.deleteMember(m_num);
response.sendRedirect("../index.jsp?main=mypage/memberlist.jsp");
%>