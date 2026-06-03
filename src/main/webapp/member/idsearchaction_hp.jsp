<%@page import="org.json.simple.JSONObject"%>
<%@page import="meminfo.model.MemInfoDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
String m_name=request.getParameter("m_name");
String m_hp2=request.getParameter("m_hp2");

MemInfoDao dao=new MemInfoDao();
String memid=dao.idsearch(m_name, m_hp2);
JSONObject ob=new JSONObject();
// 클라이언트에서 .html()로 삽입되므로 서버측 HTML 이스케이프(XSS 방지)
ob.put("memid", util.SecurityUtil.escapeHtml(memid));
%>
<%=ob.toString() %>
