<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>

<%
  request.setCharacterEncoding("utf-8");
%>
<jsp:useBean id="dao" class="foodgrade.model.FoodGradeDao"/>
<jsp:useBean id="dto" class="foodgrade.model.FoodGradeDto"/>
<jsp:setProperty property="*" name="dto"/>
<%
  dao.insertFoodGrade(dto);

%>	