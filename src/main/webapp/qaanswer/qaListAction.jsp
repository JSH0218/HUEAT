<%@page import="org.json.simple.JSONObject"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="org.json.simple.JSONArray"%>
<%@page import="qaanswer.model.QaanswerDto"%>
<%@page import="java.util.List"%>
<%@page import="qaanswer.model.QaanswerDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
  String q_num=request.getParameter("q_num");
  QaanswerDao dao=new QaanswerDao();
  List<QaanswerDto> list=dao.getQaAnswerList(q_num);
  
  JSONArray arr=new JSONArray();
  SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd HH:mm");
  
  for(QaanswerDto dto:list)
  {
	  JSONObject ob=new JSONObject();
	  ob.put("q_num", dto.getQ_num());
	  ob.put("qa_num", dto.getQa_num());
	  ob.put("qa_myid", dto.getQa_myid());
	  ob.put("qa_content", dto.getQa_content());
	  ob.put("qa_writeday", sdf.format(dto.getQa_writeday()));
	  
	  arr.add(ob);
  }
%>
<%=arr.toString()%>