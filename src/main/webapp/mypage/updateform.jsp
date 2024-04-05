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
		border: 1px solid red;
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
     	border: 1px solid red;
	}
	.line {
	  border: 5px solid green;
	  border-radius: 5px;
	}
	button.passcheck {
    background-color: #618E6E;
  }
  .mytable{
  	line-height: 70px;
  }
  .mytable tr, .mytable td{
   border: 1px solid gray;
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

<hr class="line">
<form style="margin:100px 200px;" action="#" method="post" id="passfrm" >
		<table class="mytable">
			<tr>
				<td style="width: 200px;">
				<b>아이디</b>
				</td>
				<td style="width: 500px;">
					<input type="text" name="id" id="id" style="width: 300px; height: 45px;" value="ssoo1226" class="form-control" readonly="readonly">
				</td>
			</tr>
			<tr>
				<td style="width: 200px;">
				<b>현재 비밀번호</b>
				</td>
				<td>
					<input type="password" name="id" id="id" style="width: 300px; height: 45px;" value="1234" class="form-control">
				</td>
			</tr>
			<tr>
				<td style="width: 200px;">
				<b>새 비밀번호</b>
				</td>
				<td>
					<input type="password" name="id" id="id" style="width: 300px; height: 45px;" class="form-control" placeholder="새 비밀번호를 입력해 주세요">
				</td>
			</tr>
			<tr style="padding-top: 12px;">
				<td style="width: 200px;">
				<b>새 비밀번호 확인</b>
				</td>
				<td>
					<input type="text" name="id" id="id" style="width: 300px; height: 45px;" class="form-control" placeholder="새 비밀번호를 다시 입력해 주세요">
				</td>
			</tr>
			<tr>
				<td style="width: 200px;">
				<b>이름</b>
				</td>
				<td>
					<input type="text" name="id" id="id" style="width: 300px; height: 45px;" value="손범수" class="form-control">
				</td>
			</tr>
			<tr>
				<td style="width: 200px;">
				<b>닉네임</b>
				</td>
				<td>
					<div class="d-inline-flex">
					<input type="text" name="id" id="id" style="width: 300px; height: 45px;" value="범스" class="form-control">
					<button style="margin-left: 10px;" class="btn btn-info">변경</button>
					</div>
				</td>
			</tr>
			<tr>
				<td style="width: 200px;">
				<b>이메일(선택)</b>
				</td>
				<td>
					<input type="text" name="id" id="id" style="width: 300px; height: 45px;" value="ssoo9271@naver.com" class="form-control">
				</td>
			</tr>
			<tr>
				<td style="width: 200px;">
				<b>휴대폰</b>
				</td>
				<td>
					<div class="d-inline-flex">
					<input type="text" name="id" id="id" style="width: 300px; height: 45px;" value="010-1234-5678" class="form-control">
					<select id="m_hp1" name="m_hp1" class="form-control"style="width: 80px; margin-left: 10px;">
                 	 <option value="SKT">SKT</option>
                 	<option value="LG">LG</option>
                  	<option value="KT">KT</option>
                 	 <option value="알뜰폰">알뜰폰</option>
              		</select>
              		</div>
				</td>
			</tr>
			<tr>
				<td style="width: 200px;">
				<b>생년월일</b>
				</td>
				<td>
					<input type="date" name="id" id="id" style="width: 300px; height: 45px;" value="1998-12-26" class="form-control">
				</td>
			</tr>
			<tr>
				<td style="width: 200px;">
				<b>가입일</b>
				</td>
				<td>
					<input type="text" name="id" id="id" style="width: 300px; height: 45px;" value="2024-03-25" class="form-control">
				</td>
			</tr>
			<tr>
				<td style="width: 200px;" colspan="2" align="center">
				<button type="button" class="btn btn-success" style="width: 150px;">탈퇴하기</button>
				<button type="button" class="btn btn-success" style="width: 150px;">회원정보수정</button>
			</tr>
		</table>	
 </form>
<hr class="line">
</div>
</div>
</body>
</html>