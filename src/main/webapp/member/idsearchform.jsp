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

a.nav-link{
	color: black;
}

/*마우스를 올려두었을때 파란색으로 빛이나서 그걸 방지하기 위해서 마우스를 올려두었을 시 기존의 글자색으로 빛나게 설정*/
a.nav-link:hover{
color: inherit;
}

/*기존의 navs탭의 배경색 때문에 자꾸 탭의 색이 변경되어서 !inportant를 주어 내가 지정한 색상을 우선하게함 
아 진짜 이거 색 자꾸 바껴서 너무 힘들었음 ㅠㅠ*/
.nav-pills .nav-link.active, .nav-pills .nav-link.active:focus, .nav-pills .nav-link.active:hover {
      background-color:#618E6E !important;
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
	
	//prop을 사용해 처음에 버튼을 비활성화 상태로 둔다.
	$("#idsearchbtn,#idsearchbtn2").prop("disabled", true).css("background-color","#ccc");
	
	//버튼 활성화 비활성화 사용자 함수
	function toggleIdSearchButton() {
		var name = $("#m_name").val();
		var hp2 = $("#m_hp2").val();
		
		// 이름과 핸드폰 번호 둘 다 입력되면 버튼 활성화, 그렇지 않으면 비활성화
		if (name !== "" && hp2 !== "") {
			if(hp2.length==11){ //핸드폰 번호의 길이가 11자일때 활성화 그 외에 줄어드는 순간 비활성화 
				$("#idsearchbtn").prop("disabled", false).css("background-color","#618E6E");
			}else{
				$("#idsearchbtn").prop("disabled", true).css("background-color","#ccc");
			}	
		} else {
			$("#idsearchbtn").prop("disabled", true).css("background-color","#ccc");
		}
	};
	
	function toggleemailbtn(){
		var name=$("#m_name2").val();
		var email=$("#m_email2").val();
		
		if (name !== "" && email !== "") {
			$("#idsearchbtn2").prop("disabled", false).css("background-color","#618E6E");
		}else {
			$("#idsearchbtn2").prop("disabled", true).css("background-color","#ccc");
		}
		
	};
	
	// 입력 필드 내용이 변경될 때 toggleIdSearchButton 함수 호출
	$("#m_name, #m_hp2").on("input", toggleIdSearchButton);
	$("#m_name2,#m_email2").on("input",toggleemailbtn);
	
	//아이디 찾기 버튼을 눌렀을 때
	$("#idsearchbtn").click(function(){
		var name=$("#m_name").val();
		var hp2=$("#m_hp2").val();
		
		//alert(name+","+hp2);
	
		$.ajax({
			type:"post",
			url:"member/idsearchaction_hp.jsp",
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
			url:"member/idsearchaction_email.jsp",
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
<div class="container mt-3" align="center" style="padding-top: 170px; padding-bottom: 80px;" id="idsearch">
  <h2>아이디 찾기</h2>
	<br><br>
  <!-- Nav pills -->
  <ul class="nav nav-pills" role="tablist">
    <li class="nav-item">
      <a class="nav-link active" data-bs-toggle="pill" href="#hp">핸드폰으로 찾기</a>
    </li>
    <li class="nav-item">
      <a class="nav-link" data-bs-toggle="pill" href="#email" >이메일로 찾기</a>
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
								 oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');" maxlength="11">
							</td>
						</tr>
					</table>
					<div align="center">
						<button type="button" id="idsearchbtn"style="width: 300px;height: 45px;">아이디 찾기</button><br><br>
						<span> <a href='index.jsp?main=member/passSearchform.jsp' style="text-decoration: none; color: black;">비밀번호 찾기</a></span>
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
						<span> <a href='index.jsp?main=member/passSearchform.jsp' style="text-decoration: none; color: black;">비밀번호 찾기</a></span>
					</div>
				</form>
			</div>
      </p>
    </div>  
  </div>
</div>

<!-- 아이디 찾기를 성공했을 때 바로 로그인하고 비밀번호를 찾을 수 있게 -->
<div id="idsuccess" style="width: 500px;margin: 0 auto; margin-bottom: 240px;">
<h3 style="margin-top:230px; width: 500px; color: green;font-weight: bold; text-align: center;">아이디 확인</h3>
<div style="width: 500px; margin-top: 50px; border: 1px solid gray; border-radius: 10px;">
	<form style="margin:50px;text-align: center;" action="#" method="post" >
		<span class="result"></span>
		<hr>
		<div align="center">
			<button type="button" onclick="location.href='member/loginform.jsp'" id="loginbtn">로그인</button>
			<button type="button" onclick="location.href='index.jsp?main=member/passSearchform.jsp'" id="passbtn">비밀번호 찾기</button>
		</div>
	</form>
</div>
</div>

<!-- 아이디 찾기를 실패했을 때 다시 아이디 찾기로 돌아갈 수 있게 버튼 아이디 찾기로 변경 -->
<div id="idfail" style="width: 500px;margin: 0 auto; margin-bottom: 220px;">
<h3 style="margin-top:230px; width: 500px; color: green;font-weight: bold; text-align: center;">아이디 확인</h3>
<div style="width: 500px; margin-top: 50px; border: 1px solid gray; border-radius: 10px;" >
	<form style="margin:50px;text-align: center;" action="#" method="post" >
		<span class="result"></span>
		<hr>
		<div align="center">
			<button type="button" onclick="location.href='index.jsp?main=member/idsearchform.jsp'" id="idsearchform">다시 찾기</button>
			<button type="button" onclick="location.href='index.jsp?main=member/passSearchform.jsp'" id="passbtn">비밀번호 찾기</button>
		</div>
	</form>
</div>
</div>
</body>
</html>