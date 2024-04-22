<%@page import="foodgrade.model.FoodGradeDao"%>
<%@ page import="food.model.FoodDao" %>
<%@ page import="food.model.FoodDto" %>
<%@ page language="java" contentType="application/json; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
    request.setCharacterEncoding("UTF-8");
    String h_num = request.getParameter("h_num");
    String f_num = request.getParameter("f_num");
    String fg_foodnum = request.getParameter("f_num");

    // 음식 평점을 기반으로 음식 평균 평점 업데이트
    FoodGradeDao fgdao = new FoodGradeDao();
    String avgFoodGrade = fgdao.avgFoodGrade(fg_foodnum);

    // 해당 음식의 평점을 가져와 업데이트
    FoodDto dto = new FoodDto();
    dto.setH_num(h_num);
    dto.setF_num(f_num);
    dto.setF_grade(avgFoodGrade);
    
    FoodDao dao = new FoodDao();
    dao.updateF_grade(dto);

    // 응답 데이터를 JSON 형식으로 생성
    //out.print("{\"\": \"" + avgFoodGrade + "\"}");
%>