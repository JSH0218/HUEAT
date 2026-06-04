<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Grandiflora+One&family=Gugi&family=Hahmlet:wght@100..900&family=Hi+Melody&family=Sunflower:wght@300&display=swap" rel="stylesheet">
<script src="https://code.jquery.com/jquery-3.7.0.js"></script>
<title>Insert title here</title>
<style type="text/css">
#passsearchbtn{
		background-color: #618E6E;
		color: white;
		border-radius: 5px;
		border:0px;
		height: 45px;
		margin-top: 40px;
		width: 300px;
}
	table th{
	padding-top: 20px;
	font-size: 0.9em;
}
	input {
		width:300px;
		height: 45px;
		border: 1px solid #ccc;
}
	body{
		font-family: 'Nanum Gothic';
	}
	#loginbtn, #passRset{
		background-color: #618E6E;
		color: white;
		border-radius: 5px;
		border:0px;
		height: 40px;
		margin-top: 30px;
		width: 150px;
	}
	#result{
		font-size: 1.2em;
	}
	.focused-input{
		outline-color: #648C78;
		
	}
</style>
<script type="text/javascript">
$(function(){
	
	$("input").focus(function(){
		$(this).addClass("focused-input");
	});
	$("input").blur(function(){
		$(this).removeClass("focused-input");
	})

	$("#passresult").hide();
	
	$("#passsearchbtn").click(function(){

			
			var name=$("#m_name").val();
			var hp2=$("#m_hp2").val();
			var id=$("#m_id").val();
			
			//alert(name+","+hp2+","+id);

			$.ajax({
				type:"post",
				url:"member/passSearchaction.jsp",
				dataType:"json",
				data:{"m_name":name,"m_hp2":hp2,"m_id":id},
				success:function(res){
					// 보안상 비밀번호 평문은 표시하지 않는다.
					// 신원이 확인되면 비밀번호 재설정 폼으로 유도한다.
					if(res.exists){
						// 재설정 폼에 신원 정보를 채워 넣고 노출
						$("#reset_m_id").val(id);
						$("#reset_m_name").val(name);
						$("#reset_m_hp2").val(hp2);
						$("#passsearch").hide();
						$("#passreset").show();
					}else{
						$("#passsearch").hide();
						$("#passresult").show();
						$("#result").html("일치하는 회원정보가 없습니다.<br>입력하신 정보를 다시 확인바랍니다.");
					}
				}

			})
			
		
	});
	
	$("#passsearchbtn").prop("disabled",true).css("background-color","#ccc");
	
	function togglepassbtn(){
		
		var m_id=$("#m_id").val();
		var m_name=$("#m_name").val();
		var m_hp2=$("#m_hp2").val();
		
		if(m_id !=="" && m_name!=="" && m_hp2!==""){
			if(m_hp2.length==11){
				$("#passsearchbtn").prop("disabled",false).css("background-color","#618E6E");
			}else{
				$("#passsearchbtn").prop("disabled",true).css("background-color","#ccc");
			}
		}else{
			$("#passsearchbtn").prop("disabled",true).css("background-color","#ccc");
		}
	};
	
	$("#m_id,#m_name,#m_hp2").on("input",togglepassbtn);
	
})

</script>
</head>
<body>
<div style="width: 500px;  margin: 0 auto; margin-top: 160px; border: 0px solid #ccc; border-radius: 10px;"
id="passsearch">
<h2 style="margin-top:50px; width: 500px; text-align: center; ">비밀번호 찾기</h2>
	<form style="margin:50px;" action="#" method="post" >

		<table style="margin: 0 auto;">
			<tr>
				<th>아이디</th>
			</tr>
			<tr>
				<td>
					<input type="text" name="m_id" id="m_id" placeholder="아이디를 입력해 주세요." required="required">
				</td>
			</tr>
			<tr>
				<th>이름</th>
			</tr>
			<tr>
				<td>
					<input type="text" name="m_name" id="m_name" placeholder="이름을 입력해 주세요." required="required">
				</td>
			</tr>
			<tr>
				<th>핸드폰 번호</th>
			</tr>
			<tr>
				<td>
					<input type="text" name="m_hp2" id="m_hp2" placeholder="핸드폰 번호를 입력해 주세요."
					oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');">
				</td>
			</tr>
			
		</table>
		<div align="center">
			<button type="button" id="passsearchbtn">비밀번호 찾기</button><br>
		</div>
	</form>
</div>

<div id="passresult" style="width: 500px;margin: 0 auto; display:none;">
<h3 style="margin-top:200px; width: 500px; color: green;font-weight: bold; text-align: center;">비밀번호 찾기</h3>
<div style="width: 500px;  margin: 0 auto; margin-top: 50px; border: 1px solid gray; border-radius: 10px;">
	<form style="margin:50px;text-align: center;" action="#" method="post" >
		<span id="result"></span>
		<hr>
		<button type="button" onclick="location.href='index.jsp?main=member/passSearchform.jsp'" id="loginbtn">다시 시도</button>
	</form>
</div>
</div>

<!-- 신원 확인 후 비밀번호 재설정 폼 -->
<div id="passreset" style="width: 500px; margin: 0 auto; display:none;">
<h3 style="margin-top:160px; width: 500px; color: green; font-weight: bold; text-align: center;">비밀번호 재설정</h3>
<div style="width: 500px; margin: 0 auto; margin-top: 30px; border: 1px solid gray; border-radius: 10px;">
	<form style="margin:40px;" action="member/passResetaction.jsp" method="post" id="resetfrm">
		<input type="hidden" name="_csrf" value="<%=util.SecurityUtil.csrfToken(session)%>">
		<input type="hidden" name="m_id" id="reset_m_id">
		<input type="hidden" name="m_name" id="reset_m_name">
		<input type="hidden" name="m_hp2" id="reset_m_hp2">
		<table style="margin: 0 auto;">
			<tr><th>새 비밀번호</th></tr>
			<tr><td><input type="password" name="m_newpass" id="m_newpass" placeholder="새 비밀번호(6자 이상)" required="required"></td></tr>
			<tr><th>새 비밀번호 확인</th></tr>
			<tr><td><input type="password" name="m_newpass2" id="m_newpass2" placeholder="새 비밀번호를 다시 입력" required="required"></td></tr>
		</table>
		<div align="center">
			<button type="submit" id="passsearchbtn">비밀번호 변경</button>
		</div>
	</form>
</div>
</div>

<script type="text/javascript">
$(function(){
	$("#resetfrm").submit(function(e){
		var p1=$("#m_newpass").val();
		var p2=$("#m_newpass2").val();
		if(p1.length<6){
			alert("비밀번호는 6자 이상이어야 합니다.");
			e.preventDefault();
			return false;
		}
		if(p1!==p2){
			alert("새 비밀번호가 일치하지 않습니다.");
			e.preventDefault();
			return false;
		}
	});
});
</script>
</body>
</html>