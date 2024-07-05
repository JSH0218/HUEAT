<%@page import="grade.model.GradeDto"%>
<%@page import="grade.model.GradeDao"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="org.json.simple.JSONArray"%>
<%@page import="java.util.List"%>

<%@ page language="java" contentType="application/json; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    String h_num = request.getParameter("h_num");
    String sortType = request.getParameter("sortType");

    GradeDao dao = new GradeDao();
    List<GradeDto> list;

    // 정렬 유형에 따라 적절한 메서드를 호출하여 평점 목록을 가져옴
    if (sortType.equals("latest")) {
        list = dao.getGradeLatest(h_num);
    } else if (sortType.equals("high")) {
        list = dao.getGradeHigh(h_num);
    } else if (sortType.equals("low")) {
        list = dao.getGradeLow(h_num);
    } else {
        // 기본적으로 최신순으로 정렬
        list = dao.getGradeLatest(h_num);
    }

    JSONArray arr = new JSONArray();
    SimpleDateFormat sdf = new SimpleDateFormat("yy.MM.dd");

    for (GradeDto dto : list) {
        JSONObject ob = new JSONObject();

        ob.put("g_num", dto.getG_num());
        ob.put("h_num", dto.getH_num());
        ob.put("g_myid", dto.getG_myid());
        ob.put("g_content", dto.getG_content());
        ob.put("g_grade", dto.getG_grade());
        ob.put("g_writeday", sdf.format(dto.getG_writeday()));

        arr.add(ob);
    }
%>
<%=arr.toString()%>
