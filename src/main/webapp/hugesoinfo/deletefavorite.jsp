<%@page import="hugesoinfo.model.HugesoInfoDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
		// 로그인 필수 + 소유자는 세션 사용자로 강제
		if(!util.SecurityUtil.isLogin(session)){
			response.sendError(403); return;
		}
		//유지))삭제메서드 수정
    String m_num=new meminfo.model.MemInfoDao().getM_num(util.SecurityUtil.currentId(session));
		String h_num=request.getParameter("h_num");
    HugesoInfoDao dao=new HugesoInfoDao();
    dao.deleteFavorite(m_num, h_num);
%>