<%@page import="org.json.simple.JSONObject"%>
<%@page import="org.json.simple.JSONArray"%>
<%@page import="hugesoinfo.model.HugesoInfoDto"%>
<%@page import="java.util.List"%>
<%@page import="hugesoinfo.model.HugesoInfoDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	
	HugesoInfoDao dao=new HugesoInfoDao();
	List<HugesoInfoDto> list=dao.getAllDatas();
	
	JSONArray arr=new JSONArray();
	
	for(int i=0;i<list.size();i++){
		HugesoInfoDto dto=list.get(i);
		
		JSONObject ob=new JSONObject();
		
		ob.put("h_num",dto.getH_num());
		ob.put("h_name", dto.getH_name());
		ob.put("h_xvalue", dto.getH_xvalue());
		ob.put("h_yvalue", dto.getH_yvalue());
		ob.put("h_hp", dto.getH_hp());
		ob.put("h_addr", dto.getH_addr());
		
		arr.add(ob);
	}
%>
<%=arr.toString() %>