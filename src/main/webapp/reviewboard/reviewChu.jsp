<%@page import="org.json.simple.JSONObject"%>
<%@page import="review.model.ReviewDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

    <%
    //num 읽기
    String r_num = request.getParameter("r_num");
    
    ReviewDao dao = new ReviewDao();
    dao.updateReviewChu(r_num);
    
    //증가된 chu 값 json 형태로 보내기
    int chu = dao.getDataReview(r_num).getR_chu();
    
    JSONObject ob = new JSONObject();
    ob.put("chu", chu);
    
    %>
    
    <%=ob.toString()%>