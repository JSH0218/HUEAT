<%@page import="org.json.simple.JSONObject"%>
<%@page import="javax.swing.text.StyledEditorKit.BoldAction"%>
<%@page import="meminfo.model.MemInfoDto"%>
<%@page import="meminfo.model.MemInfoDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	
	response.setCharacterEncoding("UTF-8");
	String m_id=request.getParameter("m_id");
	String m_pass=request.getParameter("m_pass");
	
	MemInfoDao dao=new MemInfoDao();
	MemInfoDto dto=new MemInfoDto();
	
	boolean idpass=dao.isIdPassMember(m_id, m_pass);
	
	//System.out.print(m_id);
	//System.out.print(m_pass);
	//System.out.print(idpass);
	
	// idpass 값을 반환해줘야하기때문에 json형태로 사용함
	JSONObject jsonResponse = new JSONObject();
    jsonResponse.put("idpass", idpass);
    out.print(jsonResponse);
    
 %>
