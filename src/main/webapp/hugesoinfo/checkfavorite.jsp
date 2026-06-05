<%@page import="org.json.simple.JSONObject"%>
<%@page import="meminfo.model.MemInfoDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!-- 유지 작성함  -->
<%
// 로그인 필수 + 조회 대상은 세션 사용자로 강제(타인 즐겨찾기 노출 방지)
if(!util.SecurityUtil.isLogin(session)){
	response.sendError(403); return;
}
MemInfoDao dao=new MemInfoDao();
String m_num=dao.selectM_num(util.SecurityUtil.currentId(session));
String h_num=request.getParameter("h_num");

int fav=dao.isFavorite(m_num, h_num);
JSONObject ob=new JSONObject();
ob.put("fav", fav);
out.print(ob.toString());
%>