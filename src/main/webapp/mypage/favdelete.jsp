<%@page import="meminfo.model.MemInfoDao"%>
<%@page import="favorite.model.FavoriteDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
// 로그인 필수
if(!util.SecurityUtil.isLogin(session)){
	response.sendError(403); return;
}
// 상태변경은 POST + CSRF 토큰 검증(위조 요청 차단)
if(!util.SecurityUtil.isPost(request) || !util.SecurityUtil.checkCsrf(request)){ response.sendError(403); return; }
String f_num=util.SecurityUtil.digitsOnly(request.getParameter("f_num"));
MemInfoDao dao=new MemInfoDao();
// IDOR 방어: m_num을 세션 사용자로부터 도출해 본인 소유분만 삭제
String m_num=dao.selectM_num(util.SecurityUtil.currentId(session));
new FavoriteDao().deleteFavoriteByOwner(f_num, m_num);
%>