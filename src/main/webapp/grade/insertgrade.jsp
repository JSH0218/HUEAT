<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>

<%
  request.setCharacterEncoding("utf-8");
  // 로그인 사용자만 평점 등록 가능
  if(!util.SecurityUtil.isLogin(session)){
    response.sendError(403); return;
  }
%>
<jsp:useBean id="dao" class="grade.model.GradeDao"/>
<jsp:useBean id="dto" class="grade.model.GradeDto"/>
<jsp:setProperty property="*" name="dto"/>
<%
  dao.insertGrade(dto);

%>	
