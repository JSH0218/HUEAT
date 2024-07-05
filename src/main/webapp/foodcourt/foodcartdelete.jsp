<%@page import="foodcart.FoodCartDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
String cart_idx=request.getParameter("cart_idx");
FoodCartDao dao=new FoodCartDao();
dao.deleteCart(cart_idx);
%>