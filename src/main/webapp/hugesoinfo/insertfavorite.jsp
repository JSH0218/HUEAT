<%@page import="favorite.model.FavoriteDto"%>
<%@page import="hugesoinfo.model.HugesoInfoDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
   request.setCharacterEncoding("utf-8");

   String h_num=request.getParameter("h_num");
   String m_num=request.getParameter("m_num");
   
   HugesoInfoDao dao=new HugesoInfoDao();
   FavoriteDto dto=new FavoriteDto();
   
   dto.setH_num(h_num);
   dto.setM_num(m_num);
   
   dao.favorite(dto);
%>