<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Nanum+Gothic&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
<script src="https://code.jquery.com/jquery-3.7.0.js"></script>
<title>Insert title here</title>
<style type="text/css">
	body {
		font-family: 'Nanum Gothic';
	}
	#container{
		display: flex;
		margin-bottom: 100px;
	}
	
	#sidebar{
     	width: 300px;
     	height: 300px;
     	margin-top: 100px;
     	margin-left: 300px;
	}
	#updatemember{
	    width: 1000px;
     	margin-top: 100px;
     	margin-left: 50px;
	}
	.line {
	  border: 5px solid green;
	  border-radius: 5px;
	}
	button.passcheck {
    background-color: #618E6E;
  }
</style>
</head>
<body>
<div id="container">
<div id="sidebar">
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

<div id="updatemember">
<b style="font-size: 25px; color: black;">개인 정보 수정</b><br><br>

<b>비밀번호 재확인</b><br>
<span style="font-size: 12px;">회원님의 정보를 안전하게 보호하기 위해 비밀번호를 다시 한번 확인해주세요.</span>
<hr class="line">
<form style="margin:100px 200px;" action="#" method="post" id="passcheckfrm" >

      <table style="margin: 20px;">
         <tr style="width: 200px; height: 100px;">
            <th>아이디&nbsp;&nbsp;&nbsp;<input type="text" name="id" id="id" style="width: 250px;height: 40px; margin-left: 100px;" value="ssoo1226"></th>
         </tr>
         <tr style="width: 200px; height: 100px;">
            <th>비밀번호<input type="password" name="pwd" id="pwd" placeholder="비밀번호를 입력해 주세요."
               style="width: 250px; height: 40px; margin-left: 100px;"></th>
         </tr>
         <tr style="width: 200px; height: 100px;">
         	<td style="text-align:  center;  vertical-align: middle;">
         	<button type="button" onclick="location.href='#'"
          class="btn btn-success passcheck" style="width: 250px; height: 40px;">확인</button>
         	</td>
         </tr>
      </table>
   </form>
<hr class="line">
</div>
</div>
</body>
</html>