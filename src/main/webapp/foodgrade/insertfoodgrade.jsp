<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>

<%
  request.setCharacterEncoding("utf-8");
  // 로그인 사용자만 음식 평점 등록 가능
  if(!util.SecurityUtil.isLogin(session)){
    response.sendError(403); return;
  }
  // CSRF 토큰 검증(위조 요청 차단)
  if(!util.SecurityUtil.checkCsrf(request)){ response.sendError(403); return; }
%>
<jsp:useBean id="dao" class="foodgrade.model.FoodGradeDao"/>
<jsp:useBean id="dto" class="foodgrade.model.FoodGradeDto"/>
<jsp:setProperty property="*" name="dto"/>
<%
  // 작성자 위조 방어: 작성자 ID는 클라이언트 값이 아닌 세션 사용자로 강제
  dto.setFg_myid(util.SecurityUtil.currentId(session));
  dao.insertFoodGrade(dto);

%>	