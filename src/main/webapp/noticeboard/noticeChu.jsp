<%@page import="org.json.simple.JSONObject"%>
<%@page import="notice.model.NoticeDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

    <%
    // 상태변경(추천수 +1)이므로 POST + 로그인 + CSRF를 강제한다.
    if(!util.SecurityUtil.isPost(request) || !util.SecurityUtil.isLogin(session)
          || !util.SecurityUtil.checkCsrf(request)){
        response.sendError(HttpServletResponse.SC_FORBIDDEN);
        return;
    }

    //num 읽기
    String n_num = util.SecurityUtil.digitsOnly(request.getParameter("n_num"));

    NoticeDao dao = new NoticeDao();
    dao.updateNoticeChu(n_num);
    
    //증가된 chu 값 json 형태로 보내기
    int chu = dao.getDataNotice(n_num).getN_chu();
    
    JSONObject ob = new JSONObject();
    ob.put("chu", chu);
    
    %>
    
    <%=ob.toString()%>