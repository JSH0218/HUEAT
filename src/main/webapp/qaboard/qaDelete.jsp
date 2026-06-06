<%@page import="qa.model.QaDao"%>
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
<title>Insert title here</title>
</head>
<body>

  <%
    String q_num = request.getParameter("q_num");
    String currentPage = request.getParameter("currentPage");

    // 상태변경은 POST + CSRF 토큰 검증(위조 요청 차단)
    if(!util.SecurityUtil.isPost(request) || !util.SecurityUtil.checkCsrf(request)){ response.sendError(403); return; }

    QaDao dao = new QaDao();

    // 로그인 + 작성자 본인(또는 관리자)만 삭제 가능
    qa.model.QaDto old = dao.selectDataQa(q_num);
    if(!util.SecurityUtil.isLogin(session) || old==null
            || !util.SecurityUtil.isOwnerOrAdmin(session, old.getQ_myid())){
%>
<script type="text/javascript">alert("삭제 권한이 없습니다."); history.back();</script>
<%
        return;
    }

    dao.deleteQa(q_num);
    
    //이동
    response.sendRedirect("../index.jsp?main=qaboard/qaList.jsp?currentPage="+currentPage);
  %>

</body>
</html>