<%@page import="foodcart.FoodCartDto"%>
<%@page import="foodcart.FoodCartDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Grandiflora+One&family=Gugi&family=Hahmlet:wght@100..900&family=Hi+Melody&family=Sunflower:wght@300&display=swap" rel="stylesheet">
<script src="https://code.jquery.com/jquery-3.7.0.js"></script>
<title>장바구니 담기</title>
</head>
<body>
<%
// 로그인 필수 + 장바구니 소유자는 세션 사용자로 강제
if(!util.SecurityUtil.isLogin(session)){
	response.sendError(403); return;
}
// 상태변경은 POST + CSRF 토큰 검증(위조 요청 차단)
if(!util.SecurityUtil.isPost(request) || !util.SecurityUtil.checkCsrf(request)){ response.sendError(403); return; }
String f_num=request.getParameter("f_num");
String h_num=request.getParameter("h_num");
String m_num=new meminfo.model.MemInfoDao().selectM_num(util.SecurityUtil.currentId(session));
int cart_cnt=Integer.parseInt(request.getParameter("cart_cnt"));

FoodCartDao dao=new FoodCartDao();
boolean cnt=dao.selectCartItemExists(f_num, m_num);

if(cnt){
	FoodCartDto dto=new FoodCartDto();
	dto.setH_num(h_num);
	dto.setF_num(f_num);
	dto.setM_num(m_num);
	dao.updateCnt(dto);
}else{
	FoodCartDto dto=new FoodCartDto();
	dto.setH_num(h_num);
	dto.setF_num(f_num);
  dto.setM_num(m_num);
  dto.setCart_cnt(cart_cnt);
  dao.insertFoodCart(dto);
}


%>
</body>
</html>