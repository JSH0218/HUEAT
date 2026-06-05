<%@page import="org.json.simple.JSONObject"%>
<%@page import="org.json.simple.JSONArray"%>
<%@page import="hugesoinfo.model.HugesoInfoDto"%>
<%@page import="java.util.List"%>
<%@page import="hugesoinfo.model.HugesoInfoDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	
	HugesoInfoDao dao=new HugesoInfoDao();
	List<HugesoInfoDto> list=dao.selectAllDatas();
	
	JSONArray arr=new JSONArray();
	
	for(int i=0;i<list.size();i++){
		HugesoInfoDto dto=list.get(i);
		
		JSONObject ob=new JSONObject();
		
		// 클라이언트에서 .html() 등으로 삽입될 수 있어 서버측 HTML 이스케이프(XSS 방지)
		ob.put("h_num",dto.getH_num());
		ob.put("h_name", util.SecurityUtil.escapeHtml(dto.getH_name()));
		ob.put("h_xvalue", dto.getH_xvalue());
		ob.put("h_yvalue", dto.getH_yvalue());
		ob.put("h_photo", dto.getH_photo());
		ob.put("h_hp", util.SecurityUtil.escapeHtml(dto.getH_hp()));
		ob.put("h_addr", util.SecurityUtil.escapeHtml(dto.getH_addr()));
		
		arr.add(ob);
	}
%>
<%=arr.toString() %>