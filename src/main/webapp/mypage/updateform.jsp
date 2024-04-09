<%@page import="java.text.SimpleDateFormat"%>
<%@page import="meminfo.model.MemInfoDao"%>
<%@page import="meminfo.model.MemInfoDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Grandiflora+One&family=Gugi&family=Hahmlet:wght@100..900&family=Hi+Melody&family=Sunflower:wght@300&display=swap" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Nanum+Gothic:wght@400;700;800&display=swap" rel="stylesheet">
<script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
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
	margin-left: 200px;
}

#updatemember {
	width: 1000px;
	margin-top: 100px;
	margin-left: 50px;
}

.line {
	  border: 1px solid #000;
	  margin-top: 30px;
	}

button.passcheck {
	background-color: #618E6E;
}

.mytable {
	line-height: 70px;
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
		
		var isNickChecked = true;

	    // 닉네임 입력란 값이 변경될 때마다 isNickChecked를 false로 설정
	    $("#m_nick").change(function() {
	        isNickChecked = false;
	    });
	    
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
						isNickChecked=true;
					} else {
						if (res.nickcount == 1) {
							alert("이미 사용 중인 닉네임입니다");
							$("#m_nick").val(res.nickname);
							isNickChecked=true;
						} else {
							alert("사용 가능한 닉네임입니다");
							isNickChecked=true;
						}
					}
				}

			})
			
		})
		
		
		$("form").submit(function(e){
			e.preventDefault();
			var f=this;
			
			if(f.m_pass.value != '<%=dto.getM_pass()%>') {
		        swal("현재 비밀번호가 일치하지 않습니다.", "다시 입력해주세요.", "error");
		        f.m_pass.value="";
		        return false;
		    } 
			
			if(f.m_upass.value!=f.m_upass1.value){
				//alert("비밀번호가 다릅니다.");
				swal("새 비밀번호가 다릅니다", "입력하신 비밀번호를 확인해주세요", "error");
				f.m_upass.value="";
				f.m_upass1.value="";
				return false;
			}
			
			 if (!isNickChecked) {
	                alert("닉네임 중복 확인을 해주세요.");
	                return;
	            }
			  
			
			if(f.m_upass.value==""){
				f.m_upass.value='<%=dto.getM_pass()%>';
				f.m_upass1.value='<%=dto.getM_pass()%>';
			} 
		
			
			
			
			swal("회원정보가 수정되었습니다.", "성공!","success").then(function() {
			    f.submit();
			});
		});
		
		$("#deletebtn").click(function(){
			location.href="index.jsp?main=mypage/deleteform.jsp";  
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
			<b style="font-size: 25px; color: black;">개인 정보 수정</b>

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
									style="width: 200px; height: 45px;"
									value="<%=dto.getM_nick()%>" class="form-control"
									required="required">
								<button type="button" class="btn btn-success"
									style="width: 90px; margin-left: 10px;" id="nickcheck">
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
							    <select id="m_hp1" name="m_hp1" class="form-control" style="width: 80px;"
							            required="required">
							        <option value="SKT" <%if (dto.getM_hp1().equals("SKT")) {%> selected <%}%>>SKT</option>
							        <option value="LG" <%if (dto.getM_hp1().equals("LG")) {%> selected <%}%>>LG</option>
							        <option value="KT" <%if (dto.getM_hp1().equals("KT")) {%> selected <%}%>>KT</option>
							        <option value="알뜰폰" <%if (dto.getM_hp1().equals("알뜰폰")) {%> selected <%}%>>알뜰폰</option>
							    </select>
							     <input type="text" name="m_hp2" id="m_hp2" style="width: 215px; height: 45px;  margin-left: 5px;"
							           value="<%=dto.getM_hp2()%>" class="form-control" required="required" oninput="this.value = this.value.replace(/[^0-9]/g, '');" maxlength="11">
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
								style="width: 100px;" id="deletebtn">
								<span style="font-size: 13px;">탈퇴하기</span>
							</button>
							<button type="submit" class="btn btn-success"
								style="width: 100px; margin-left: 10px;">
								<span style="font-size: 13px;">회원정보수정</span>
							</button>
						</td>
					</tr>
				</table>
			</form>
			<hr class="line">
		</div>
	</div>
</body>
</html>