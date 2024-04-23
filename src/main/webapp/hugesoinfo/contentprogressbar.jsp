<%@page import="org.json.simple.JSONArray"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="grade.model.GradeDao"%>
<%@ page language="java" contentType="application/json; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    String h_num = request.getParameter("h_num");
    GradeDao dao = new GradeDao();
    String g_content = dao.get_Content(h_num);

    // 각 항목에 대해 등급을 카운트하여 JSON 객체로 구성
    JSONArray jsonArray = new JSONArray();
    String[] grades = g_content.split(", "); // 등급 데이터 파싱
    for (String grade : grades) {
        String[] parts = grade.split(" : ");
        if (parts.length == 2) { // 등급 데이터가 " : "로 올바르게 구분되었는지 확인
            JSONObject entry = new JSONObject();
            entry.put("label", parts[0]);
            entry.put("value", Integer.parseInt(parts[1]));
            jsonArray.add(entry);
        }
    }
    String jsonResult = jsonArray.toString();
    response.setContentType("application/json");
    response.setCharacterEncoding("UTF-8");
    response.getWriter().write(jsonResult);
%>
