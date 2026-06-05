<%@page import="foodcart.model.FoodCartDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
// 로그인 필수
if(!util.SecurityUtil.isLogin(session)){
	response.sendError(403); return;
}
// 상태변경은 POST + CSRF 토큰 검증(위조 요청 차단)
if(!util.SecurityUtil.isPost(request) || !util.SecurityUtil.checkCsrf(request)){ response.sendError(403); return; }
String cart_idx=request.getParameter("cart_idx");
// 소유자는 클라이언트 입력을 신뢰하지 않고 세션 사용자로부터 서버에서 도출(IDOR 방지)
String m_num=new meminfo.model.MemInfoDao().selectM_num(util.SecurityUtil.currentId(session));
FoodCartDao dao=new FoodCartDao();
dao.deleteCart(cart_idx, m_num);
%>