<%@page import="qa.model.QaDao"%>
<%@page import="qa.model.QaDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
    <link href="https://fonts.googleapis.com/css2?family=Nanum+Brush+Script&family=Nanum+Pen+Script&family=Noto+Sans+KR:wght@100..900&family=Noto+Serif+KR&family=Stylish&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <script src="https://code.jquery.com/jquery-3.7.0.js"></script>
<title>QnA 수정 처리</title>
</head>
<body>
  <%
    request.setCharacterEncoding("utf-8");

    // 상태변경은 POST + CSRF 토큰 검증(위조 요청 차단)
    if(!util.SecurityUtil.isPost(request) || !util.SecurityUtil.checkCsrf(request)){
%>
    <script type="text/javascript">alert("요청이 유효하지 않습니다."); history.back();</script>
<%
        return;
    }

    //로그인 세션얻기
	String loginok=(String)session.getAttribute("loginok");
	//아이디 얻기
	String myid=(String)session.getAttribute("myid");
    
	String q_num = request.getParameter("q_num");
	String q_category = request.getParameter("q_category");
	String q_subject = request.getParameter("q_subject");
	String q_content = request.getParameter("q_content");
	String currentPage = request.getParameter("currentPage");

    QaDao dao = new QaDao();

    // 로그인 + 작성자 본인(또는 관리자)만 수정 가능
    QaDto old = dao.selectDataQa(q_num);
    if(!util.SecurityUtil.isLogin(session) || old==null
            || !util.SecurityUtil.isOwnerOrAdmin(session, old.getQ_myid())){
%>
<script type="text/javascript">alert("수정 권한이 없습니다."); history.back();</script>
<%
        return;
    }

    QaDto dto = new QaDto();

    dto.setQ_num(q_num);
    dto.setQ_category(q_category);
    dto.setQ_subject(q_subject);
    dto.setQ_content(q_content);

    dao.updateQa(dto);
    
    
    
    //insert후 디테일 내용보기
    response.sendRedirect("../index.jsp?main=qaboard/qaDetail.jsp?q_num="+q_num+"&currentPage="+currentPage);
  %>

</body>
</html>