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
				url:"passSearchaction.jsp",
				dataType:"json",
				data:{"m_name":name,"m_hp2":hp2,"m_id":id},
				success:function(res){
					//alert("비밀번호 찾기 성공");
					$("#passsearch").hide();
					$("#passresult").show();
					if(res.mempass==""){
						$("#result").html("일치하는 회원정보가 없습니다.<br>입력하신 정보를 다시 확인바랍니다.");
						
					}else{
						var password=res.mempass;
						
						//비밀번호 뒤에를 *로 마스킹해서 보이게했음
						//보안상의 이유로 5글자 이상의 비밀번호는 앞에 4글자만 보이고 뒤에는 무조건 4글자만 가려지게 했음
						if(password.length>4){
							var markPass=password.substring(0,4)+"*".repeat(4);
							$("#result").html("<b>"+name+"</b>"+"님의 비밀번호는"+"<b>"+markPass+"</b>입니다.");
						}else{
						//비밀번호가 4글자 이하일 경우에는 비밀번호 앞에 2글자만 보이게하고 뒤에는 4글자 가려지게함
						//어차피 나중에 비밀번호를 적어도 6글자 이상 입력하게 할거라 추후 삭제할 예정
							var markPass=password.substring(0,2)+"*".repeat(4);
							$("#result").html("<b>"+name+"</b>"+"님의 비밀번호는"+"<b>"+markPass+"</b>입니다.");
						}
										
					}
				}
				
			})
			
		
	});
	
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

<div id="passresult" style="width: 500px;margin: 0 auto;">
<h3 style="margin-top:200px; width: 500px; color: green;font-weight: bold; text-align: center;">비밀번호 확인</h3>
<div style="width: 500px;  margin: 0 auto; margin-top: 50px; border: 1px solid gray; border-radius: 10px;">
	<form style="margin:50px;text-align: center;" action="#" method="post" >
		<span id="result"></span>
		<hr>
		<button type="button" onclick="location.href='loginform.jsp'" id="loginbtn">로그인</button>
		<button type="button" onclick="location.href='passSearchform.jsp'" id="passRset">비밀번호 재설정</button>
	</form>
</div>
</div>
</body>
</html>