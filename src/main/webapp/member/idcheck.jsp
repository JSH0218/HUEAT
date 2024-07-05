<%@page import="org.json.simple.JSONObject"%>
<%@page import="meminfo.model.MemInfoDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
String id=request.getParameter("id");
MemInfoDao dao=new MemInfoDao();
int idcount=dao.idcount(id);

JSONObject ob=new JSONObject();
ob.put("idcount", idcount);

%>
<%=ob.toString()%>