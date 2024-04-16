<%@page import="org.json.simple.JSONObject"%>
<%@page import="qaanswer.model.QaanswerDto"%>
<%@page import="qaanswer.model.QaanswerDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%
    
    String q_num = request.getParameter("q_num");
    String qa_num = request.getParameter("qa_num");
    QaanswerDao dao = new QaanswerDao();
    QaanswerDto dto = dao.getAnswerData(q_num, qa_num);
    
    JSONObject ob = new JSONObject();
    ob.put("q_num", dto.getQ_num());
    ob.put("qa_num", dto.getQa_num());
    ob.put("qa_content", dto.getQa_content());
    
    %>
    
    
    <%=ob.toString() %>