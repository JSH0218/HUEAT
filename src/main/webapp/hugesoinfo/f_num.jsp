<%@page import="org.json.simple.JSONObject"%>
<%@page import="meminfo.model.MemInfoDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
String m_num=request.getParameter("m_num");
String h_num=request.getParameter("h_num");

MemInfoDao dao=new MemInfoDao();
String f_num = dao.f_numData(m_num, h_num);// f_num 값을 가져옴

JSONObject ob=new JSONObject();
ob.put("f_num", f_num); // JSON 객체에 f_num 추가
out.print(ob.toString());
%>