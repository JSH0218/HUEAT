<%@page import="org.json.simple.JSONObject"%>
<%@page import="meminfo.model.MemInfoDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
String m_name=request.getParameter("m_name");
String m_id=request.getParameter("m_id");
String m_hp2=request.getParameter("m_hp2");

MemInfoDao dao=new MemInfoDao();
String mempass=dao.passSearch(m_name, m_id, m_hp2);
JSONObject ob=new JSONObject();
ob.put("mempass", mempass);
%>
<%=ob.toString()%>