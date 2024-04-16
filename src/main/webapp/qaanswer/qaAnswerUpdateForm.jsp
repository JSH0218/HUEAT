<%@page import="org.json.simple.JSONObject"%>
<%@page import="qaanswer.model.QaanswerDto"%>
<%@page import="qaanswer.model.QaanswerDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
   String q_num=request.getParameter("q_num");
   String qa_num = request.getParameter("qa_num");
   
   QaanswerDao qdao=new QaanswerDao();
   QaanswerDto qdto=qdao.getAnswerData(q_num, qa_num);
   
   JSONObject ob=new JSONObject();
   ob.put("q_num", qdto.getQ_num());
   ob.put("qa_num", qdto.getQa_num());
   ob.put("qa_content", qdto.getQa_content());
%>

<%=ob.toString()%>