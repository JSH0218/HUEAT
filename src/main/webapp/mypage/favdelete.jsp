<%@page import="meminfo.model.MemInfoDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
String f_num=request.getParameter("f_num");
MemInfoDao dao=new MemInfoDao();
dao.favDelete(f_num);
%>