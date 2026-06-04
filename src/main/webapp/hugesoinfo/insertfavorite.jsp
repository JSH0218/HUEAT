<%@page import="favorite.model.FavoriteDto"%>
<%@page import="hugesoinfo.model.HugesoInfoDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
   request.setCharacterEncoding("utf-8");

   // 로그인 필수 + 즐겨찾기 소유자는 세션 사용자로 강제(클라이언트 m_num 신뢰 안 함)
   if(!util.SecurityUtil.isLogin(session)){
      response.sendError(403); return;
   }
   // 상태변경은 POST + CSRF 토큰 검증(위조 요청 차단)
   if(!util.SecurityUtil.isPost(request) || !util.SecurityUtil.checkCsrf(request)){ response.sendError(403); return; }
   String h_num=request.getParameter("h_num");
   String m_num=new meminfo.model.MemInfoDao().getM_num(util.SecurityUtil.currentId(session));

   HugesoInfoDao dao=new HugesoInfoDao();
   FavoriteDto dto=new FavoriteDto();
   
   dto.setH_num(h_num);
   dto.setM_num(m_num);
   
   dao.favorite(dto);
%>