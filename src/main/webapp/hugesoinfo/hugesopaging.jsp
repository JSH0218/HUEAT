<%@page import="org.json.simple.JSONObject"%>
<%@page import="org.json.simple.JSONArray"%>
<%@page import="hugesoinfo.model.HugesoInfoDto"%>
<%@page import="java.util.List"%>
<%@page import="hugesoinfo.model.HugesoInfoDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	//전체갯수
	int perPage=5; //한페이지당 보여질 글의 갯수
	int startNum; //db에서 가져올 글의 시작번호(mysql은 첫글이0번,오라클은 1번);
	int currentPage=Integer.parseInt(request.getParameter("currentPage"));  //현재페이지

	//각페이지에서 보여질 시작번호
	//1페이지:0, 2페이지:5 3페이지: 10.....
	startNum=(currentPage-1)*perPage;
	
	HugesoInfoDao dao=new HugesoInfoDao();
	List<HugesoInfoDto> list=dao.getPagingList(startNum, perPage);
	
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