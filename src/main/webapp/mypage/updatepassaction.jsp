<%@page import="org.json.simple.JSONObject"%>
<%@page import="javax.swing.text.StyledEditorKit.BoldAction"%>
<%@page import="meminfo.model.MemInfoDto"%>
<%@page import="meminfo.model.MemInfoDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	
	response.setCharacterEncoding("UTF-8");
	// 로그인 필수 (인증 없는 자격증명 확인 오라클 방지)
	if(!util.SecurityUtil.isLogin(session)){
		response.sendError(403); return;
	}
	// 검증 대상 ID는 클라이언트 입력이 아닌 세션 사용자로 고정 (무차별 대입 방지)
	String m_id=util.SecurityUtil.currentId(session);
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
