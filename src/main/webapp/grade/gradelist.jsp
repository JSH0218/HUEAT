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
	List<GradeDto> list=dao.getGradeList(h_num);
	
	JSONArray arr=new JSONArray();
	SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd HH:mm");
	
	for(GradeDto dto:list)
	{
		JSONObject ob=new JSONObject();
		
		ob.put("g_num", dto.getG_num());
		ob.put("h_num", dto.getH_num());
		ob.put("m_num", dto.getM_num());
		ob.put("g_grade", dto.getG_grade());
		ob.put("writeday", sdf.format(dto.getG_writeday()));
		
		arr.add(ob);
	}
%>
<%=arr.toString()%>
