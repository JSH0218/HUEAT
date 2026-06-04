<%@page import="grade.model.GradeDao"%>
<%@page import="hugesoinfo.model.HugesoInfoDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    // 로그인 사용자만 평점 삭제 가능
    if(!util.SecurityUtil.isLogin(session)){
        response.sendError(403); return;
    }
    // CSRF 토큰 검증(위조 요청 차단)
    if(!util.SecurityUtil.checkCsrf(request)){ response.sendError(403); return; }
    String h_num=util.SecurityUtil.digitsOnly(request.getParameter("h_num"));
	String g_num=util.SecurityUtil.digitsOnly(request.getParameter("g_num"));
    GradeDao dao = new GradeDao();
    // IDOR 방어: 관리자는 전체 삭제, 일반 사용자는 본인 작성분만 삭제
    if(util.SecurityUtil.isAdmin(session)){
        dao.deleteGrade(g_num);
    }else{
        dao.deleteGrade(g_num, util.SecurityUtil.currentId(session));
    }
%>