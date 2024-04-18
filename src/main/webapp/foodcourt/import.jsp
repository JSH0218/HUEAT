<%@page import="javax.swing.plaf.basic.BasicTextAreaUI"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%@page import="meminfo.model.MemInfoDto"%>
<%@page import="meminfo.model.MemInfoDao"%>
<%@page import="foodcart.FoodCartDto"%>
<%@page import="foodcart.FoodCartDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script src="https://cdn.iamport.kr/v1/iamport.js"></script>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Grandiflora+One&family=Gugi&family=Hahmlet:wght@100..900&family=Hi+Melody&family=Sunflower:wght@300&display=swap" rel="stylesheet">
<script src="https://code.jquery.com/jquery-3.7.0.js"></script>
<title>Insert title here</title>
</head>
<body>
<%

String foodname=request.getParameter("foodname");
String totalstr=request.getParameter("total");
String name=request.getParameter("name");
String hp=request.getParameter("hp");
String myid=request.getParameter("myid");

%>
<script type="text/javascript">

IMP.init('imp22445011');
IMP.request_pay({
    pg : 'html5_inicis',
    pay_method : 'card',
    //merchant_uid: myid+new Date().getTime(),
    //name : "foodname",
    amount : 100,
    //buyer_email : 'iamport@siot.do',
   // buyer_name : "name",
    //buyer_tel : "hp",
    //buyer_addr : '서울특별시 강남구 삼성동',
    //buyer_postcode : '123-456',
    m_redirect_url : '{http://localhost:8080/HuEatProject/index.jsp}' // 예: https://www.my-service.com/payments/complete/mobile
}, function(rsp) { // callback 로직
	//* ...중략 (README 파일에서 상세 샘플코드를 확인하세요)... *//
	if ( rsp.success ) { //결제 성공
		console.log(rsp);
	} else {
		alert('결제실패 : ' + rsp.error_msg);
	}
	
});

</script>
</body>
</html>