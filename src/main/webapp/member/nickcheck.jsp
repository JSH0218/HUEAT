<%@page import="org.json.simple.JSONObject"%>
<%@page import="meminfo.model.MemInfoDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
// 무인증 닉네임 중복확인 오라클: GET 프리패치·교차사이트 호출 차단(POST+CSRF 강제, 11차와 동일 하드닝)
if(!util.SecurityUtil.isPost(request) || !util.SecurityUtil.checkCsrf(request)){
    response.sendError(403); return;
}
String m_nick=request.getParameter("m_nick");
MemInfoDao dao=new MemInfoDao();
int nickcount=dao.nickcount(m_nick);

JSONObject ob=new JSONObject();
ob.put("nickcount", nickcount);

%>
<%=ob.toString() %>
