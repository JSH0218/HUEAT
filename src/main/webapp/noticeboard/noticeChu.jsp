<%@page import="org.json.simple.JSONObject"%>
<%@page import="notice.model.NoticeDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

    <%
    //num 읽기
    String n_num = request.getParameter("n_num");
    
    NoticeDao dao = new NoticeDao();
    dao.updateNoticeChu(n_num);
    
    //증가된 chu 값 json 형태로 보내기
    int chu = dao.getDataNotice(n_num).getN_chu();
    
    JSONObject ob = new JSONObject();
    ob.put("chu", chu);
    
    %>
    
    <%=ob.toString()%>