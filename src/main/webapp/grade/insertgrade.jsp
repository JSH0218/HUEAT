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
  // 작성자 위조 방어: 작성자 ID는 클라이언트 값이 아닌 세션 사용자로 강제
  dto.setG_myid(util.SecurityUtil.currentId(session));
  dao.insertGrade(dto);

%>	
