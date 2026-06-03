<%@page import="org.json.simple.JSONObject"%>
<%@page import="meminfo.model.MemInfoDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
request.setCharacterEncoding("utf-8");
String m_name=request.getParameter("m_name");
String m_id=request.getParameter("m_id");
String m_hp2=request.getParameter("m_hp2");

MemInfoDao dao=new MemInfoDao();
// 평문 비밀번호를 반환하지 않는다. 신원 일치 여부(boolean)만 반환한다.
boolean exists=dao.verifyMember(m_name, m_id, m_hp2);
JSONObject ob=new JSONObject();
ob.put("exists", exists);
%>
<%=ob.toString()%>
