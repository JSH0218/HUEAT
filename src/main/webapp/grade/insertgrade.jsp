<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>

<%
  request.setCharacterEncoding("utf-8");
%>
<jsp:useBean id="dao" class="grade.model.GradeDao"/>
<jsp:useBean id="dto" class="grade.model.GradeDto"/>
<jsp:setProperty property="*" name="dto"/>
<%
  dao.insertGrade(dto);

%>	
