<%@page import="foodcart.FoodCartDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
String m_num=request.getParameter("m_num");
FoodCartDao dao=new FoodCartDao();
dao.deleteAllCart(m_num);
%>