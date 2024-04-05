<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Grandiflora+One&family=Gugi&family=Hahmlet:wght@100..900&family=Hi+Melody&family=Sunflower:wght@300&display=swap" rel="stylesheet">
<script src="https://code.jquery.com/jquery-3.7.0.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<link href="https://fonts.googleapis.com/css2?family=Nanum+Gothic:wght@400;700;800&display=swap" rel="stylesheet">
<title>Insert title here</title>
<style type="text/css">
	body{
	font-family: 'Nanum Gothic';
	}
.nav-pills {
  justify-content: center;
  width: 400px;
}
.nav-item {
  width: 50%; /* Adjust the width as needed */
  text-align: center;
}

.nav-link{
	color: black;
}

.nav-pills .nav-link.active, .nav-pills .nav-link.active:focus, .nav-pills .nav-link.active:hover {
      background-color: #618E6E;
    }
.nav-link:hover{
	color: black;
}
#idsearchbtn,#idsearchbtn2{
		background-color: #618E6E;
		color: white;
		border-radius: 5px;
		border:0px;
		height: 50px;
		margin-top: 40px;
}
table th{
	padding-top:20px;
	font-size: 0.9em;
}
	a{
	text-decoration: none;
	color: black;
	}
	#loginbtn,#passbtn,#idsearchform{
	background-color: #618E6E;
		color: white;
		border-radius: 5px;
		border:0px;
		height: 40px;
		margin-top: 30px;
		width: 150px;
	}
	span.result{
		font-size: 1.2em;
	}
	input{
	width: 300px;
	height: 45px;"
	}

</style>
<script type="text/javascript">
$(function(){
	
	$("#idresult").hide();
	$("#idfail").hide();
	$("#idsuccess").hide();
	
	$("#idsearchbtn").click(function(){
		var name=$("#m_name").val();
		var hp2=$("#m_hp2").val();
		
		//alert(name+","+hp2);
	
		$.ajax({
			type:"post",
			url:"idsearchaction_hp.jsp",
			dataType:"json",
			data:{"m_name":name,"m_hp2":hp2},
			success:function(res){
				//alert("성공");
				//alert(res.memid);
				$("#idsearch").hide();
				
				if(res.memid==""){
					$("#idfail").show();
					$(".result").html("일치하는 아이디가 없습니다.<br>이름과 핸드폰 번호를 다시 확인바랍니다.");
					
				}else{
					$("#idsuccess").show();
					$(".result").html("<b>"+name+"</b>"+"님의 아이디는"+"<b>&nbsp;"+res.memid+"</b>입니다.");
					
				}
			
			}
		})
		
	});
	
	$("#idsearchbtn2").click(function(){
		var name2=$("#m_name2").val();
		var email2=$("#m_email2").val();
		
		//alert(name+","+email);
		
		$.ajax({
			type:"post",
			url:"idsearchaction_email.jsp",
			dataType:"json",
			data:{"m_name2":name2,"m_email2":email2},
			success:function(res){
				//alert("성공");
				//alert(res.memid);
				$("#idsearch").hide();
				$("#idresult").show();
				if(res.memid==""){
					$("#idfail").show();
					$(".result").html("일치하는 아이디가 없습니다.<br>이름과 이메일을 다시 확인바랍니다.");
					
				}else{
					$("#idsuccess").show();
					$(".result").html("<b>"+name2+"</b>"+"님의 아이디는"+"<b>"+res.memid+"</b>입니다.");
			
			}
		}
		})
	});

	
})
</script>
</head>
<body>
<div class="container mt-3" align="center" style="padding-top: 160px;" id="idsearch">
  <h2>아이디 찾기</h2>
	<br><br>
  <!-- Nav pills -->
  <ul class="nav nav-pills" role="tablist">
    <li class="nav-item">
      <a class="nav-link active" data-bs-toggle="pill" href="#hp">핸드폰으로 찾기</a>
    </li>
    <li class="nav-item">
      <a class="nav-link" data-bs-toggle="pill" href="#email">이메일로 찾기</a>
    </li>
  </ul>

  <!-- Tab panes -->
  <div class="tab-content">
    <div id="hp" class="container tab-pane active">
      <p>
				<div style="width: 500px;  margin: 0 auto; margin-top: 50px; ">
						<form style="margin:50px;" action="#" method="post" >

					<table style="margin: 0 auto;">
						<tr>
							<th>이름</th>
						</tr>
						<tr>
							<td>
								<input type="text" name="m_name" id="m_name" placeholder="이름을 입력해 주세요.">
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
						<button type="button" id="idsearchbtn"style="width: 300px;height: 45px;">아이디 찾기</button><br><br>
						<span> <a href='passSearchform.jsp'>비밀번호 찾기</a></span>
					</div>
				</form>
			</div>

	</p>
    </div>
    
	<!-- 이메일로 아이디 찾기 -->
    <div id="email" class="container tab-pane fade">
      
      <p>
      <div style="width: 500px;  margin: 0 auto; margin-top: 50px; ">
						<form style="margin:50px;" action="#" method="post" >

					<table style="margin: 0 auto;">
						<tr>
							<th>이름</th>
						</tr>
						<tr>
							<td>
								<input type="text" name="m_name2" id="m_name2" placeholder="이름을 입력해 주세요.">
							</td>
						</tr>
						<tr>
							<th>이메일</th>
						</tr>
						<tr>
							<td>
								<input type="text" name="m_email2" id="m_email2" placeholder="이메일을 입력해 주세요.">
							</td>
						</tr>
					</table>
					<div align="center">
						<button type="button" id="idsearchbtn2"style="width: 300px;height: 45px;">아이디 찾기</button><br><br>
						<span> <a href='passSearchform.jsp'>비밀번호 찾기</a></span>
					</div>
				</form>
			</div>
      </p>
    </div>  
  </div>
</div>

<!-- 아이디 찾기를 성공했을 때 바로 로그인하고 비밀번호를 찾을 수 있게 -->
<div id="idsuccess" style="width: 500px;margin: 0 auto;">
<h3 style="margin-top:200px; width: 500px; color: green;font-weight: bold; text-align: center;">아이디 확인</h3>
<div style="width: 500px; margin-top: 50px; border: 1px solid gray; border-radius: 10px;">
	<form style="margin:50px;text-align: center;" action="#" method="post" >
		<span class="result"></span>
		<hr>
		<div align="center">
			<button type="button" onclick="location.href='loginform.jsp'" id="loginbtn">로그인</button>
			<button type="button" onclick="location.href='passSearchform.jsp'" id="passbtn">비밀번호 찾기</button>
		</div>
	</form>
</div>
</div>

<!-- 아이디 찾기를 실패했을 때 다시 아이디 찾기로 돌아갈 수 있게 버튼 아이디 찾기로 변경 -->
<div id="idfail" style="width: 500px;margin: 0 auto;">
<h3 style="margin-top:200px; width: 500px; color: green;font-weight: bold; text-align: center;">아이디 확인</h3>
<div style="width: 500px; margin-top: 50px; border: 1px solid gray; border-radius: 10px;">
	<form style="margin:50px;text-align: center;" action="#" method="post" >
		<span class="result"></span>
		<hr>
		<div align="center">
			<button type="button" onclick="location.href='idsearchform.jsp'" id="idsearchform">다시 찾기</button>
			<button type="button" onclick="location.href='passSearchform.jsp'" id="passbtn">비밀번호 찾기</button>
		</div>
	</form>
</div>
</div>
</body>
</html>