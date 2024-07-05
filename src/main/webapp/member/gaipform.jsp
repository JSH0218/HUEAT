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
	input {
		height: 50px;
		border-radius:5px;
		border: 1px solid gray;
		font-family: 'Nanum Gothic';
	
}

	body{ 
		font-family: 'Nanum Gothic';
	}
	
	.swal-footer{
		text-align: center;
	}
	/*.swal-button {
		background-color: tomato;
	}*/
	.swal-title,.swal-text{
		font-family: 'Orbit-Regular';
		font-weight: 100;
	}
	.btninsert,.btnreset,#btnidcheck{
		background-color: #618E6E;
		color: white;
		border-radius: 5px;
		border:0px;
		height: 40px;

	}

table.table tr,table.table td,table.table th{
	border: none;
}
.btninsert,.btnreset{
	height:45px;
	margin-top: 20px;
}

</style>
<script type="text/javascript">
$(function(){
	$("#check_id").hide();
	$("#check_nick").hide();
	
	var isIdChecked = false;
	
	//아이디 중복체크
	$("#btnidcheck").click(function(){
		
		var id=$("#m_id").val();
		//alert(id);
		
		//아이디를 입력하지 않았을 때 발생하는 경고창
		if(id.trim() === "") {
   alert("아이디를 입력해주세요.")
    return; // Exit the function early if id is empty
}
		
		$.ajax({
			type:"get",
			url:"idcheck.jsp",
			dataType:"json",
			data:{"id":id},
			success:function(res){
				//alert("중복체크확인");
				
				//아이디가 중복일 경우
				if(res.idcount==1){
					$("#check_id").show();
					$("#id").val("");
					$("#check_id").html("<i class='bi bi-exclamation-triangle'></i>사용할 수 없는 아이디입니다. 다른 아이디를 입력해주세요.").css("color","red");
				}else {
					$("#check_id").show();
					$("#check_id").html("<i class='bi bi-check-circle'></i>사용 가능한 아이디입니다.").css("color","green");
				}
			}
			
		})
		
		isIdChecked = true;
	});
	
	//닉네임의 중복여부는 닉네임을 입력하고 다음 칸으로 떠날 때 알 수 있음. (blur)
	$("#m_nick").on("blur",function(){
	 var nick=$(this).val();
	 //alert(nick);
	 
	 //닉네임을 입력하지 않았을때는 span부분에 있는 text가 사라짐
				if (!nick) {
        $("#check_nick").hide();
        return; 
    }
	 
	 $.ajax({
		 type:"get",
		 url:"nickcheck.jsp",
		 dataType:"json",
		 data:{"m_nick":nick},
		 success:function(res){
			 //alert("닉네임중복방지성공");
			 if(res.nickcount==1){
				$("#check_nick").show();
				$("#check_nick").html("<i class='bi bi-exclamation-triangle'></i>사용할 수 없는 닉네임입니다. 다른 닉네임을 입력해주세요.").css("color","red");
			 }else{
				$("#check_nick").show();
				$("#check_nick").html("<i class='bi bi-check-circle'></i>사용 가능한 닉네임입니다.").css("color","green");
			 }
		 }
		 
	 })
		
	});
	
	$("#frm").submit(function(e){
		e.preventDefault();
		var f=this;
		
		if(f.m_pass.value!=f.m_pass2.value){
			//alert("비밀번호가 다릅니다.");
			swal("비밀번호가 다릅니다", "비밀번호를 확인해주세요", "error");
			f.m_pass.value="";
			f.m_pass2.value="";
			return false;
		}
		//아이디 중복체크 버튼을 누르지 않으면 회원가입을 완료할 수 없다. 
		  if (!isIdChecked) {
                alert("아이디 중복 확인을 해주세요.");
                return;
            }
		
		var name=$("#m_name").val();
		swal("회원가입 완료",name+"님의 회원가입이 성공적으로 완료되었습니다.","success")
		.then(function(){
			f.submit();
		})
		
	});
	
	
})

	function goBack(){
	window.history.back();
}
</script>

</head>
<body>
<h3 style="width: 500px; margin: 0 auto; margin-top: 50px; text-align: center;">회원가입</h3>
<div  style="width: 500px; margin: 0 auto; margin-top: 40px; border: 1px solid #ccc; border-radius: 10px;">

	<form style="width: 400px;padding: 60px;" action="gaipaction.jsp" method="post" onsubmit="return check(this)" id="frm">
	
		<table class="table table-bordered-light" style="width: 400px; margin: 0 auto;">
			<tr>
				
				<td >
					<input  type="text" placeholder=" 아이디"  style="width: 250px;"required="required"
					name="m_id" id="m_id">		
					<button type="button" class="btn btn-outline-success btn-sm" style="width: 100px;"
					id="btnidcheck">중복확인</button>
					<div style="width: 400px;">
						<span id="check_id" style="font-size: 14px;"></span>
					</div>
				</td>
			</tr>

			<tr>
				<td>
					<input type="text" placeholder=" 닉네임(1~6글자)" style="width: 350px;" required="required"
					name="m_nick" id="m_nick" maxlength="6" >
					<div style="width: 400px;">
						<span id="check_nick" style="font-size: 14px;"></span>
					</div>
				</td>
			</tr>

			<tr>
				<td >
					<input type="password" placeholder=" 비밀번호" style="width: 350px;" required="required"
					name="m_pass" >
				</td>
			</tr>
			<tr>
				<td >
					<input type="password" placeholder=" 비밀번호 확인" style="width: 350px;" required="required"
					name="m_pass2">
				</td>
			</tr>
			<tr>
				<td>
					<input type="text" placeholder=" [선택]이메일 주소(본인 확인용) " style="width: 350px;"
					name="m_email" id="m_email">
				</td>
			</tr>	
			<tr>
				<td>
					<input type="text" placeholder=" 이름" style="width: 350px;" required="required"
					name="m_name" id="m_name">
				</td>
			</tr>
			<tr>
				<td>
					생년월일&nbsp;&nbsp;<i class="bi bi-calendar-check"></i>&nbsp;&nbsp;&nbsp;&nbsp;
					<input type="date" style="width: 240px; text-align: center;" required="required"
					name="m_birth" id="m_birth" value="1990-01-01">
				</td>
			</tr>
			<tr>
				<td>
					<select id="m_hp1" name="m_hp1">
						<option value="SKT">SKT</option>
						<option value="LG">LG</option>
						<option value="KT">KT</option>
						<option value="알뜰폰">알뜰폰</option>
					</select>
					<input type="text" placeholder="휴대전화번호('-'생략)" style="width: 280px;" required="required"
					name="m_hp2" id="m_hp2"  oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');">
				</td>
			</tr>
			<tr>
				<td align="center" style="padding-right: 40px;">
					<button type="submit" style="width: 145px;" class="btninsert">회원가입</button>&nbsp;&nbsp;&nbsp;
					<button type="button" style="width: 145px;" class="btnreset"
					onclick="goBack();">취소</button>
				</td>
			</tr>
		</table>
	</form>
</div>
</body>
</html>