<%@page import="grade.model.GradeDto"%>
<%@page import="grade.model.GradeDao"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="org.json.simple.JSONArray"%>
<%@page import="java.util.List"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String h_num=request.getParameter("h_num");
	GradeDao dao=new GradeDao();
	List<GradeDto> list=dao.getGradeLatest(h_num);
	
	JSONArray arr=new JSONArray();
	SimpleDateFormat sdf=new SimpleDateFormat("yy.MM.dd");
	
	for(GradeDto dto:list){
		JSONObject ob=new JSONObject();
		
		ob.put("g_num", dto.getG_num());
		ob.put("h_num", dto.getH_num());
		ob.put("g_myid", dto.getG_myid());
		ob.put("g_content",dto.getG_content());
		ob.put("g_grade", dto.getG_grade());
		ob.put("g_writeday", sdf.format(dto.getG_writeday()));
		
		arr.add(ob);
		
	}
%>
<%=arr.toString()%>