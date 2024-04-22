<%@page import="org.json.simple.JSONObject"%>
<%@page import="org.json.simple.JSONArray"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%@page import="foodcart.FoodCartDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
String m_num=request.getParameter("m_num");
String h_num=request.getParameter("h_num");

FoodCartDao dao=new FoodCartDao();
List<HashMap<String,String>> list=dao.getCartMenu(m_num, h_num);

JSONArray arr=new JSONArray();

for(HashMap<String,String> map:list){
	JSONObject ob=new JSONObject();
	int cnt=Integer.parseInt(map.get("cart_cnt"));
	int price=Integer.parseInt(map.get("f_price"));
	int total=cnt*price;
	
	for(String key:map.keySet()){
		ob.put("f_name", map.get("f_name"));
		ob.put("cart_cnt", map.get("cart_cnt"));
		ob.put("f_price", map.get("f_price"));
		ob.put("cart_total", total);
		ob.put("cart_idx", map.get("cart_idx"));
	}
	arr.add(ob);
}
%>
<%=arr.toString() %>

