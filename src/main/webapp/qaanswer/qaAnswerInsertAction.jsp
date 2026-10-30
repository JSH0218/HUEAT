<%@page import="qaanswer.model.QaanswerDao"%>
<%@page import="qaanswer.model.QaanswerDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

    <%
    request.setCharacterEncoding("utf-8");

    // 관리자만 답변 등록 가능
    if(!util.SecurityUtil.isAdmin(session)){
        response.sendError(403); return;
    }
    // 상태변경은 POST + CSRF 토큰 검증(위조 요청 차단)
    if(!util.SecurityUtil.isPost(request) || !util.SecurityUtil.checkCsrf(request)){ response.sendError(403); return; }
    //로그인 세션얻기
	String loginok=(String)session.getAttribute("loginok");
	//아이디 얻기
	String myid=(String)session.getAttribute("myid");

	String q_num = request.getParameter("q_num");
	String qa_num = request.getParameter("qa_num");
    String qa_content = request.getParameter("qa_content");
    // 답변 내용은 앞뒤 공백을 뺀 1~1000자(qaanswerboard.qa_content VARCHAR(1000), 빈 답변·저장 실패 차단)
    if(qa_content==null || qa_content.trim().isEmpty() || qa_content.length()>1000){
        response.sendError(400); return;
    }
   
    
    QaanswerDto dto = new QaanswerDto();
    
    dto.setQ_num(q_num);
    dto.setQa_myid(myid);
    dto.setQa_content(qa_content);
    
    QaanswerDao dao = new QaanswerDao();
    dao.insertQaAnswer(dto);
    
    %>