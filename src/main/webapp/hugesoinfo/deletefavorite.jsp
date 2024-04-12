<%@page import="hugesoinfo.model.HugesoInfoDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    String m_num=request.getParameter("m_num");
String h_num=request.getParameter("h_num");
    HugesoInfoDao dao=new HugesoInfoDao();
    dao.deleteFavorite(m_num, h_num);
%>