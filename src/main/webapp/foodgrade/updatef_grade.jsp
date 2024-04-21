<%@page import="food.model.FoodDao"%>
<%@page import="food.model.FoodDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
    request.setCharacterEncoding("utf-8");

    String f_grade = request.getParameter("f_grade");
    String h_num = request.getParameter("h_num"); 
    
    FoodDto dto = new FoodDto();
    dto.setF_grade(f_grade);
    dto.setH_num(h_num);
    
    FoodDao dao = new FoodDao();
    dao.updateF_grade(dto);

%>

