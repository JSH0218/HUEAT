<%@page import="org.json.simple.JSONObject"%>
<%@page import="meminfo.model.MemInfoDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!-- 유지 작성함  -->
<%
String m_num=request.getParameter("m_num");
String h_num=request.getParameter("h_num");

MemInfoDao dao=new MemInfoDao();
int fav=dao.isFavorite(m_num, h_num);
JSONObject ob=new JSONObject();
ob.put("fav", fav);
out.print(ob.toString());
%>
<%=ob.toString()%>