<%@page import="java.text.SimpleDateFormat"%>
<%@page import="meminfo.model.MemInfoDao"%>
<%@page import="meminfo.model.MemInfoDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link
	href="https://fonts.googleapis.com/css2?family=Nanum+Gothic&display=swap"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
<script src="https://code.jquery.com/jquery-3.7.0.js"></script>
<title>Insert title here</title>
<style type="text/css">
body {
	font-family: 'Nanum Gothic';
}

#container {
	display: flex;
	margin-bottom: 100px;
}

#sidebar {
	width: 300px;
	height: 300px;
	margin-top: 100px;
	margin-left: 300px;
}

#updatemember {
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

.mytable {
	line-height: 70px;
}

.mytable tr, .mytable td {
	border: 1px solid red;
}

.mytable input {
	font-size: 15px;
}
</style>
<%
//로그인 세션얻기
String loginok = (String) session.getAttribute("loginok");
//아이디 얻기
String myid = (String) session.getAttribute("myid");

MemInfoDao dao = new MemInfoDao();
MemInfoDto dto = dao.getAlldatas(myid);
SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
%>
<script type="text/javascript">
	$(function() {
		$("#nickcheck").click(function() {
			var nickname = $("#m_nick").val();
			var num = $("#m_num").val();
			//alert(nickname+","+num);
			$.ajax({
				type : "get",
				url : "mypage/nickcheck.jsp",
				dataType : "json",
				data : {
					"m_nick" : nickname,
					"m_num" : num
				},
				success : function(res) {
					//alert(res.nick);
					if (res.count == 1) {
						alert("현재 닉네임입니다");
					} else {
						if (res.nickcount == 1) {
							alert("이미 사용 중인 닉네임입니다")
							$("#m_nick").val(res.nickname);
						} else {
							alert("사용 가능한 닉네임입니다")
						}
					}
				}

			})

		})
	})
</script>
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
			<b style="font-size: 25px; color: black;">개인 정보 수정</b><br>
			<br>

			<hr class="line">
			<form style="margin: 100px 200px;" action="mypage/updateaction.jsp"
				method="post" id="updatefrm">
				<input type="hidden" name="m_num" id="m_num"
					value="<%=dto.getM_num()%>">
				<table class="mytable">
					<tr>
						<td style="width: 200px;"><b>아이디</b></td>
						<td style="width: 500px;"><input type="text" name="m_id"
							id="m_id" style="width: 300px; height: 45px;"
							value="<%=dto.getM_id()%>" class="form-control"
							readonly="readonly">
						</td>
					</tr>
					<tr>
						<td style="width: 200px;"><b>현재 비밀번호</b></td>
						<td><input type="password" name="m_pass" id="m_pass"
							style="width: 300px; height: 45px;" value="<%=dto.getM_pass()%>"
							class="form-control" required="required">
						<div style="width: 400px; height: 0">
								<span id="check_id" style="font-size: 12px; height: 0; width: 400px; position: relative; bottom: 25px; color: red;">현재 비밀번호를 확인해주세요</span>
							</div>	
						</td>
					</tr>
					<tr>
						<td style="width: 200px;"><b>새 비밀번호</b></td>
						<td><input type="password" name="m_upass" id="m_upass"
							style="width: 300px; height: 45px;" class="form-control"
							placeholder="새 비밀번호를 입력해 주세요"></td>
					</tr>
					<tr style="padding-top: 12px;">
						<td style="width: 200px;"><b>새 비밀번호 확인</b></td>
						<td><input type="password" name="m_upass1" id="m_upass1"
							style="width: 300px; height: 45px;" class="form-control"
							placeholder="새 비밀번호를 다시 입력해 주세요">
						<div style="width: 400px; height: 0">
								<span id="check_pass" style="font-size: 12px; height: 0; width: 400px; position: relative; bottom: 25px; color: red;">동일한 비밀번호를 입력해주세요</span>
							</div>	
						</td>
					</tr>
					<tr>
						<td style="width: 200px;"><b>이름</b></td>
						<td><input type="text" name="m_name" id="m_name"
							style="width: 300px; height: 45px;" value="<%=dto.getM_name()%>"
							class="form-control" required="required"></td>
					</tr>
					<tr>
						<td style="width: 200px;"><b>닉네임</b></td>
						<td>
							<div class="d-inline-flex">
								<input type="text" name="m_nick" id="m_nick"
									style="width: 300px; height: 45px;"
									value="<%=dto.getM_nick()%>" class="form-control"
									required="required">
								<button type="button" class="btn btn-success"
									style="width: 90px; margin-left: 30px;" id="nickcheck">
									<span style="font-size: 13px;">중복확인</span>
								</button>
							</div>
						</td>
					</tr>
					<tr>
						<td style="width: 200px;"><b>이메일(선택)</b></td>
						<td><input type="text" name="m_email" id="m_email"
							style="width: 300px; height: 45px;"
							value="<%=dto.getM_email() == null ? "" : dto.getM_email()%>"
							class="form-control"></td>
					</tr>
					<tr>
						<td style="width: 200px;"><b>휴대폰</b></td>
						<td>
							<div class="d-inline-flex">
								<input type="text" name="m_hp2" id="m_hp2"
									style="width: 300px; height: 45px;"
									value="<%=dto.getM_hp2()%>" class="form-control"
									required="required"> <select id="m_hp1" name="m_hp1"
									class="form-control" style="width: 80px; margin-left: 30px;"
									required="required">
									<option value="SKT" <%if (dto.getM_hp1().equals("SKT")) {%>
										selected <%}%>>SKT</option>
									<option value="LG" <%if (dto.getM_hp1().equals("LG")) {%>
										selected <%}%>>LG</option>
									<option value="KT" <%if (dto.getM_hp1().equals("KT")) {%>
										selected <%}%>>KT</option>
									<option value="알뜰폰">알뜰폰</option>
								</select>
							</div>
						</td>
					</tr>
					<tr>
						<td style="width: 200px;"><b>생년월일</b></td>
						<td><input type="date" name="m_birth" id="m_birth"
							style="width: 300px; height: 45px;"
							value="<%=dto.getM_birth()%>" class="form-control"
							required="required"></td>
					</tr>
					<tr>
						<td style="width: 200px;"><b>가입일</b></td>
						<td><input type="text" name="m_gaipday" id="m_gaipday"
							style="width: 300px; height: 45px;"
							value="<%=sdf.format(dto.getM_gaipday())%>" class="form-control"
							readonly="readonly"></td>
					</tr>
					<tr>
						<td style="width: 200px;" colspan="2" align="center">
							<button type="button" class="btn btn-outline-success"
								style="width: 100px;">
								<span style="font-size: 13px;">탈퇴하기</span>
							</button>
							<button type="submit" class="btn btn-success"
								style="width: 100px; margin-left: 10px;">
								<span style="font-size: 13px;">회원정보수정</span>
							</button>
					</tr>
				</table>
			</form>
			<hr class="line">
		</div>
	</div>
</body>
</html>