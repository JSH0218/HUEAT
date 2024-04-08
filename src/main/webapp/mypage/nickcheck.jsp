<%@page import="org.json.simple.JSONObject"%>
<%@page import="meminfo.model.MemInfoDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
String m_nick=request.getParameter("m_nick");
String m_num=request.getParameter("m_num");
MemInfoDao dao=new MemInfoDao();
int count=dao.numPassCheck(m_num, m_nick);
int nickcount=dao.nickcount(m_nick);
String nickname=dao.getNick(m_num);


JSONObject ob=new JSONObject();
ob.put("count", count);
ob.put("nickcount", nickcount);
ob.put("nickname", nickname);

//System.out.println(nick);
//System.out.println(m_nick);
%>
<%=ob.toString() %>
