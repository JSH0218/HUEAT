<%@page import="meminfo.model.MemInfoDto"%>
<%@page import="meminfo.model.MemInfoDao"%>
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
	*{
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
		margin-left: 200px;
	}
	#updatepassform{
	    width: 1000px;
     	margin-top: 100px;
     	margin-left: 50px;
	}
	.line {
	  border: 1px solid #000;
	  margin-top: 40px;
	}
	button.passcheck {
    background-color: #618E6E;
  }
  #m_pass::placeholder{
  	font-size: 12px;
  }

</style>
</head>
<%

	//로그인 세션얻기
	String loginok=(String)session.getAttribute("loginok");
	//아이디 얻기
	String myid=(String)session.getAttribute("myid");
	
	
%>
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

<div id="updatepassform">
<b style="font-size: 25px; color: black;">개인 정보 수정</b><br><br>

<b>비밀번호 재확인</b><br>
<span style="font-size: 12px;">회원님의 정보를 안전하게 보호하기 위해 비밀번호를 다시 한번 확인해주세요.</span>
<hr class="line">
<form style="margin:100px 200px;" id="passcheckfrm" >

      <table style="margin: 20px;">
         <tr style="width: 200px; height: 100px;">
            <th>아이디&nbsp;&nbsp;&nbsp;<input type="text" name="m_id" id="m_id" style="width: 250px;height: 40px; margin-left: 100px; padding-left: 10px;" value="<%=myid %>" readonly="readonly"></th>
         </tr>
         <tr style="width: 200px; height: 100px;">
            <th>비밀번호<input type="password" name="m_pass" id="m_pass" placeholder="비밀번호를 입력해 주세요."
               style="width: 250px; height: 40px; margin-left: 100px; padding-left: 10px;" required="required"></th>
         </tr>
         <tr style="width: 200px; height: 100px;">
         	<td style="text-align:  center;  vertical-align: middle;">
         	<button type="button" onclick="submitForm()" class="btn btn-success passcheck" style="width: 250px; height: 40px;">확인</button>
         	</td>
         </tr>
      </table>
   </form>
<hr class="line">
</div>
</div>
<script type="text/javascript">

function submitForm(){
		var m_id=$("#m_id").val();
		var m_pass=$("#m_pass").val();
		//alert(m_id+","+ m_pass);
		$.ajax({
         type: 'post',
         url: 'mypage/updatepassaction.jsp',
         data: {"m_id": m_id, "m_pass": m_pass},
         dataType: "json",
         success: function(res) {
        	 if(res.idpass) {
                 location.href = "index.jsp?main=mypage/updateform.jsp"; // 페이지 이동
             } else {
            	 swal("비밀번호가 다릅니다", "비밀번호를 확인해주세요", "error");
                 $("#m_pass").val("");
             }
         }
      });  

}

</script>

</body>
</html>