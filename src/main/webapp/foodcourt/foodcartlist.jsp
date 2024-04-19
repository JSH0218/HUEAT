<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%@page import="foodcart.FoodCartDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
String m_num=request.getParameter("m_num");
String h_num=request.getParameter("h_num");

FoodCartDao dao=new FoodCartDao();
List<HashMap<String,String>> list=dao.getCartMenu(m_num, h_num);


%>

