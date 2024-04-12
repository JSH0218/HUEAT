<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
<link href="https: //fonts.googleapis.com/css2?family=Nanum+Gothic&display=swap" rel="stylesheet">
 <script src="https://code.jquery.com/jquery-3.7.0.js"></script>
<title>Insert title here</title>
<style type="text/css">
	*{
		font-family: 'Nanum Gothic';
	}
	#container{
			display: flex;
			margin-bottom: 100px;
		}
	#mypagesidebar{
	     	width: 300px;
			height: 300px;
			margin-top: 100px;
			margin-left: 200px;
	     	border: 1px solid green;
	     	
		}
	#area{
	   	width: 1000px;
		margin-top: 100px;
		margin-left: 50px;
     	border: 1px solid yellow;
	}
</style>
</head>

<%
   //1. 기본페이지 mypagemain 페이지 지정
   String mypagemain = "updatepassform.jsp"; //기본페이지
   
   //2. url을 통해서 mypagemain값을 읽어서 메인페이지에 출력
   if(request.getParameter("mypagemain") != null) {
	   mypagemain = request.getParameter("mypagemain");
   }
%>  


<body>
<div id="container">
<div id="mypagesidebar">
<b style="font-size: 30px; color: black;">마이휴잇</b>
<table style="width: 300px; margin-top: 50px;">
	<tr height="60px;" style="border: 1px solid gray;">
		<td style="vertical-align: middle; padding-left: 20px;">회원정보수정</td>
		<td><i class="bi bi-chevron-right"></i></td>
	</tr>
	<tr height="60px;" style="border: 1px solid gray;">
		<td style="vertical-align: middle; padding-left: 20px;">나의활동</td>
		<td><i class="bi bi-chevron-right"></i></td>
	</tr>
	<tr height="60px;" style="border: 1px solid gray;">
		<td style="vertical-align: middle; padding-left: 20px;">즐겨찾기</td>
		<td><i class="bi bi-chevron-right"></i></td>
	</tr>
</table>
</div>
<div id="area">
<div class="mypage updatepassform"><jsp:include page="<%=mypagemain %>"/></div>
</div>
</div>
</body>
</html>