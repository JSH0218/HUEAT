<%@page import="org.json.simple.JSONObject"%>
<%@page import="meminfo.model.MemInfoDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
// 로그인 필수(타인 닉네임 무인증 조회 차단) + POST+CSRF 강제(11차와 동일 하드닝)
if(!util.SecurityUtil.isLogin(session)){ response.sendError(403); return; }
if(!util.SecurityUtil.isPost(request) || !util.SecurityUtil.checkCsrf(request)){
    response.sendError(403); return;
}
String m_nick=request.getParameter("m_nick");
MemInfoDao dao=new MemInfoDao();
// m_num은 클라이언트 입력 대신 세션 사용자로 고정(임의 m_num으로 타인 닉네임 조회하는 IDOR 차단)
String m_num=dao.selectM_num(util.SecurityUtil.currentId(session));
int count=dao.numPassCheck(m_num, m_nick);
int nickcount=dao.nickcount(m_nick);
String nickname=dao.selectNickByNum(m_num);


JSONObject ob=new JSONObject();
ob.put("count", count);
ob.put("nickcount", nickcount);
ob.put("nickname", nickname);

//System.out.println(nick);
//System.out.println(m_nick);
%>
<%=ob.toString() %>
