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
    String m_num=request.getParameter("m_num");
	GradeDao dao=new GradeDao();
	List<GradeDto> list=dao.getGradeList(h_num);
	
	// 사용자 아이디 가져오기
    String m_id = dao.getM_id(h_num);
	
	JSONArray arr=new JSONArray();
	SimpleDateFormat sdf=new SimpleDateFormat("yy.MM.dd");
	
	for(GradeDto dto:list){
		JSONObject ob=new JSONObject();
		
		ob.put("g_num", dto.getG_num());
		ob.put("h_num", dto.getH_num());
		ob.put("m_num", dto.getM_num());
		ob.put("m_id", m_id); // 각 평점에 대한 사용자의 아이디
		ob.put("g_content",dto.getG_content());
		ob.put("g_grade", dto.getG_grade());
		ob.put("g_writeday", sdf.format(dto.getG_writeday()));
		
		arr.add(ob);
		
	}
%>
<%=arr.toString()%>
