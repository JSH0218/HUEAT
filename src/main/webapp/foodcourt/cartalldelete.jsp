<%@page import="foodcart.FoodCartDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
// 로그인 필수 + 소유자는 세션 사용자로 강제
if(!util.SecurityUtil.isLogin(session)){
	response.sendError(403); return;
}
// CSRF 토큰 검증(위조 요청 차단)
if(!util.SecurityUtil.checkCsrf(request)){ response.sendError(403); return; }
String m_num=new meminfo.model.MemInfoDao().getM_num(util.SecurityUtil.currentId(session));
FoodCartDao dao=new FoodCartDao();
dao.deleteAllCart(m_num);
%>