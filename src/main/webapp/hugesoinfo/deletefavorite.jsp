<%@page import="hugesoinfo.model.HugesoInfoDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    String f_num=request.getParameter("f_num");
    HugesoInfoDao dao=new HugesoInfoDao();
    dao.deleteFavorite(f_num);
%>