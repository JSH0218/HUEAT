<%@page import="org.json.simple.JSONObject"%>
<%@page import="org.json.simple.JSONArray"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%@page import="foodcart.FoodCartDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
// 로그인 필수(무인증 조회 차단)
if(!util.SecurityUtil.isLogin(session)){
	response.sendError(403); return;
}
// 소유자(m_num)는 클라이언트 입력을 신뢰하지 않고 세션 사용자로부터 서버에서 도출(읽기 IDOR 방지)
String m_num=new meminfo.model.MemInfoDao().selectM_num(util.SecurityUtil.currentId(session));
String h_num=request.getParameter("h_num");

FoodCartDao dao=new FoodCartDao();
List<HashMap<String,String>> list=dao.selectCartMenu(m_num, h_num);

JSONArray arr=new JSONArray();

for(HashMap<String,String> map:list){
	JSONObject ob=new JSONObject();
	int cnt=Integer.parseInt(map.get("cart_cnt"));
	int price=Integer.parseInt(map.get("f_price"));
	int total=cnt*price;
	
	for(String key:map.keySet()){
		// DOM 저장형 XSS 방어: f_name이 클라이언트 .html()로 삽입되므로 서버측에서 HTML 이스케이프
		ob.put("f_name", util.SecurityUtil.escapeHtml(map.get("f_name")));
		ob.put("cart_cnt", map.get("cart_cnt"));
		ob.put("f_price", map.get("f_price"));
		ob.put("cart_total", total);
		ob.put("cart_idx", map.get("cart_idx"));
	}
	arr.add(ob);
}
%>
<%=arr.toString() %>

