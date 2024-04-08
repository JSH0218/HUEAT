<%@page import="org.json.simple.JSONObject"%>
<%@page import="meminfo.model.MemInfoDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
String m_nick=request.getParameter("m_nick");
MemInfoDao dao=new MemInfoDao();
int nickcount=dao.nickcount(m_nick);

JSONObject ob=new JSONObject();
ob.put("nickcount", nickcount);

%>
<%=ob.toString() %>
