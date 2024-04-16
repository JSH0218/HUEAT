<%@page import="qaanswer.model.QaanswerDto"%>
<%@page import="qaanswer.model.QaanswerDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
  request.setCharacterEncoding("utf-8");

  String q_num=request.getParameter("q_num");
  String qa_num = request.getParameter("qa_num");
  
  
  QaanswerDto dto = new QaanswerDto();
  
  dto.setQ_num(q_num);
  dto.setQa_num(qa_num);
  
  QaanswerDao dao=new QaanswerDao();
  dao.deleteQaAnswer(dto);
%>