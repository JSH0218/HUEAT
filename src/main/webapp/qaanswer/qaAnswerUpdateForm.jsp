<%@page import="org.json.simple.JSONObject"%>
<%@page import="qaanswer.model.QaanswerDto"%>
<%@page import="qaanswer.model.QaanswerDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
   String q_num=request.getParameter("q_num");
   String qa_num = request.getParameter("qa_num");
   // 비밀글의 답변은 글 작성자 본인 또는 관리자만 조회
   if(!util.SecurityUtil.isOwnerOrAdmin(session, new qa.model.QaDao().selectDataQa(q_num).getQ_myid())){
      response.sendError(403); return;
   }
   
   QaanswerDao qdao=new QaanswerDao();
   QaanswerDto qdto=qdao.selectAnswerData(q_num, qa_num);
   
   JSONObject ob=new JSONObject();
   ob.put("q_num", qdto.getQ_num());
   ob.put("qa_num", qdto.getQa_num());
   ob.put("qa_content", qdto.getQa_content());
%>

<%=ob.toString()%>