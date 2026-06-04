<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>

<%
  request.setCharacterEncoding("utf-8");
  // 로그인 사용자만 평점 등록 가능
  if(!util.SecurityUtil.isLogin(session)){
    response.sendError(403); return;
  }
  // 상태변경은 POST + CSRF 토큰 검증(위조 요청 차단)
  if(!util.SecurityUtil.isPost(request) || !util.SecurityUtil.checkCsrf(request)){ response.sendError(403); return; }
%>
<jsp:useBean id="dao" class="grade.model.GradeDao"/>
<jsp:useBean id="dto" class="grade.model.GradeDto"/>
<jsp:setProperty property="*" name="dto"/>
<%
  // 저장형 XSS 방어: g_content는 상세페이지 라디오 5종만 허용한다(UI 우회로 임의 문자열 저장 차단).
  // 이 값은 hugesodetail.jsp의 프로그래스바에 삽입되므로 자유입력을 허용하면 안 된다.
  java.util.List<String> allowedContent = java.util.Arrays.asList(
      "시설이 깨끗해요", "휴게시설이 잘 되어 있어요", "음식이 맛있어요", "특별한 메뉴가 있어요", "주차하기 편해요");
  if(!allowedContent.contains(dto.getG_content())){
    response.sendError(400); return;
  }
  // 숫자 파라미터 정규화(h_num/g_grade)
  String h_num = util.SecurityUtil.digitsOnly(dto.getH_num());
  String g_grade = util.SecurityUtil.digitsOnly(dto.getG_grade());
  if(h_num.isEmpty() || g_grade.isEmpty()){
    response.sendError(400); return;
  }
  dto.setH_num(h_num);
  dto.setG_grade(g_grade);

  // 작성자 위조 방어: 작성자 ID는 클라이언트 값이 아닌 세션 사용자로 강제
  dto.setG_myid(util.SecurityUtil.currentId(session));
  dao.insertGrade(dto);

%>
