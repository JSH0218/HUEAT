<%@page import="java.text.SimpleDateFormat"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="org.json.simple.JSONArray"%>
<%@page import="meminfo.model.MemInfoDao"%>
<%@page import="meminfo.model.MemInfoDto"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
String m_name=request.getParameter("m_name");
MemInfoDao dao=new MemInfoDao();
List<MemInfoDto> list=dao.searchMem(m_name);
SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");

JSONArray arr=new JSONArray();

for(MemInfoDto dto:list){
	JSONObject ob=new JSONObject();
	ob.put("m_num", dto.getM_num());
	ob.put("m_name", dto.getM_name());
	ob.put("m_nick", dto.getM_nick());
	ob.put("m_id", dto.getM_id());
	ob.put("m_hp1", dto.getM_hp1());
	ob.put("m_hp2", dto.getM_hp2());
	ob.put("m_email", dto.getM_email());
	ob.put("m_birth", dto.getM_birth());
	ob.put("m_gaipday", sdf.format(dto.getM_gaipday()));
	arr.add(ob);
}
%>
<%=arr.toString()%>