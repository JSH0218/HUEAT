<%@page import="util.SecurityUtil"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="meminfo.model.MemInfoDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
// 무인증 아이디 중복확인 오라클: GET 프리패치·교차사이트 호출 차단(POST+CSRF 강제, 11차와 동일 하드닝)
if(!util.SecurityUtil.isPost(request) || !util.SecurityUtil.checkCsrf(request)){
    response.sendError(403); return;
}
String id=request.getParameter("id");
MemInfoDao dao=new MemInfoDao();
// 예약 아이디(admin 등)는 사용 불가 처리(이미 존재하는 것과 동일하게 1 반환)
int idcount = SecurityUtil.isReservedId(id) ? 1 : dao.idcount(id);

JSONObject ob=new JSONObject();
ob.put("idcount", idcount);

%>
<%=ob.toString()%>