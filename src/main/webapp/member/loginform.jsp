<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Grandiflora+One&family=Gugi&family=Hahmlet:wght@100..900&family=Hi+Melody&family=Sunflower:wght@300&display=swap" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Nanum+Gothic&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
<script src="https://code.jquery.com/jquery-3.7.0.js"></script>
<title>Insert title here</title>
<style type="text/css">
input{
	border: none;
	outline: none;
}
table th {
	text-align: center;
}

body{
	font-family: 'Nanum Gothic';
}

	.loginbtn{
		background-color: #618E6E;
		color: white;
		border-radius: 5px;
		border:0px;
		height: 50px;
		font-size: 1.4em;
	}
	a{
	text-decoration: none;
	color: black;
	}
	div img{
	cursor: pointer;
	}
	  	@font-face {
    font-family: 'Orbit-Regular';
    src: url('https://cdn.jsdelivr.net/gh/projectnoonnu/noonfonts_2310@1.0/Orbit-Regular.woff2') format('woff2');
    font-weight: normal;
    font-style: normal;
}
</style>

</head>
<%
String saveok=(String)session.getAttribute("saveok");
String myid="";

if(saveok!=null){
	myid=(String)session.getAttribute("myid");
}
%>
<body>

<div><img src="../image/mainbanner/logo1.png" style="width: 200px;margin-left:840px;margin-top:100px;"
onclick="location.href='../index.jsp'"></div>
<div style="width: 500px;  margin: 0 auto; margin-top: 50px; margin-bottom:100px; border: 1px solid #ccc; border-radius: 10px;" >
	
	<form style="margin:50px;" action="loginaction.jsp" method="post">

		<table class="table table-bordered" >
		<caption align="top" style="font-size: 1.2em;">아이디 로그인</caption>
		<tr>
			<th width="50"><i class="bi bi-person-circle fs-4"></i></th>
			<td >
				<input type="text" placeholder="아이디" name="m_id" required="required"
				value="<%=myid%>" style="width: 300px;height: 40px;">
			</td>
		</tr>
		<tr>
			<th width="50"><i class="bi bi-lock-fill fs-4"></i></th>
			<td>
				<input type="password" placeholder="비밀번호" name="m_pass" required="required"style="width: 300px;height: 40px;">
			</td>
		</tr>
		</table>
		<div class="d-inline-flex">
		<input type="checkbox" name="cbsave" value="<%=saveok==null?"":"checked"%>">&nbsp;&nbsp;
		아이디 저장
		</div>
		<div align="center" style="margin-top: 30px;">
		<button type="submit" style="width: 400px;" class="loginbtn">로그인</button>
		</div>
	</form>
	<div align="center" style="margin-bottom: 30px;">
		<span><a href='../index.jsp?main=member/idsearchform.jsp'>아이디 찾기</a></span>&nbsp;&nbsp;
		|
		<span><a href="../index.jsp?main=member/passSearchform.jsp">&nbsp;비밀번호 찾기</a></span>&nbsp;&nbsp;
		|
		<span><a href='gaipform.jsp'>&nbsp;회원가입</a></span>
	</div>
</div>
</body>
</html>