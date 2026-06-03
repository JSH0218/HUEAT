<%@page import="foodcart.FoodCartDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
// 로그인 필수
if(!util.SecurityUtil.isLogin(session)){
	response.sendError(403); return;
}
String cart_idx=request.getParameter("cart_idx");
FoodCartDao dao=new FoodCartDao();
dao.deleteCart(cart_idx);
%>