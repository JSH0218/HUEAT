<%@page import="org.json.simple.JSONObject"%>
<%@page import="event.model.EventDao"%>
<%@ page language="java" contentType="application/json; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
  // 상태변경(추천수 +1)이므로 POST + 로그인 + CSRF를 강제한다.
  if(!util.SecurityUtil.isPost(request) || !util.SecurityUtil.isLogin(session)
        || !util.SecurityUtil.checkCsrf(request)){
      response.sendError(HttpServletResponse.SC_FORBIDDEN);
      return;
  }

  String e_num = util.SecurityUtil.digitsOnly(request.getParameter("e_num"));

  EventDao dao = new EventDao();
  dao.updateEventChu(e_num);

  // 증가된 chu 값 json 형태로 보내기
  int chu = dao.selectDataEvent(e_num).getE_chu();

  JSONObject ob = new JSONObject();
  ob.put("chu", chu);
%>
<%=ob.toString()%>
