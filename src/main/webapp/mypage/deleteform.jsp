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
	
	#deletediv{
	    width: 1000px;
     	margin-top: 175px;
     	margin-left: auto;
   	    margin-right: auto;
	}
  
  .line {
	  border: 1px solid #000;
	  width: 800px;
	  margin: 0 auto;
	  margin-top: 20px;
	}
  
	.chk_box { display: block; position: relative; padding-left: 25px; margin-bottom: 10px; cursor: pointer; font-size: 14px; -webkit-user-select: none; -moz-user-select: none; -ms-user-select: none; user-select: none; }
	
	/* 기본 체크박스 숨기기 */
	.chk_box input[type="checkbox"] { display: none; }
	
	/* 선택되지 않은 체크박스 스타일 꾸미기 */
	.on { width: 20px; height: 20px; background: #ddd; position: absolute; top: 0; left: 0; }
	
	/* 선택된 체크박스 스타일 꾸미기 */
	.chk_box input[type="checkbox"]:checked + .on { background: #f86480; }
	.on:after { content: ""; position: absolute; display: none; }
	.chk_box input[type="checkbox"]:checked + .on:after { display: block; }
	.on:after { width: 6px; height: 10px; border: solid #fff; border-width: 0 2px 2px 0; -webkit-transform: rotate(45deg); -ms-transform: rotate(45deg); transform: rotate(45deg); position: absolute; left: 6px; top: 2px; }


</style>
</head>
<%

	//로그인 세션얻기
	String loginok=(String)session.getAttribute("loginok");
	//아이디 얻기
	String myid=(String)session.getAttribute("myid");
	
	MemInfoDao dao = new MemInfoDao();
	MemInfoDto dto = dao.getAlldatas(myid);
	
	
%>
<script type="text/javascript">
    $(function(){
        $("form").submit(function(e){
            e.preventDefault();
            var f = this;

            if (!$("#agree").is(":checked")) {
                alert("이용약관에 동의해야 합니다.");
                return false; // 제출 중지
            }

            if (f.m_pass.value != '<%=dto.getM_pass()%>') {
                swal("비밀번호가 일치하지 않습니다.", "다시 입력해주세요.", "error");
                f.m_pass.value = "";
                return false;
            }

            // 확인 대화 상자 표시
            confirmWithdrawal(f);
        });
    });

    function confirmWithdrawal(f) {
        swal({
            title: "정말 탈퇴하시겠습니까?",
            text: "탈퇴 후에는 계정을 복구할 수 없습니다.",
            icon: "warning",
            buttons: true,
            dangerMode: true,
        }).then((willWithdraw) => {
            if (willWithdraw) {
                swal("회원탈퇴가 완료되었습니다.","이용해주셔서 감사합니다.", {
                    icon: "success",
                }).then(() => {
                    f.submit(); // 폼 제출
                });
            } 
        });
    }
</script>

<body>
<div id="container">
<div id="deletediv">
<div style="text-align: center;">
<b style="font-size: 25px; color: black;">회원탈퇴안내</b>
</div>
<hr class="line">
<form style="margin:100px; margin-top: 100px;" id="deleteform" action="mypage/deleteaction.jsp" method="post">
	<div style="width: 800px; height: 300px; overflow: auto; border: 1px solid gray; padding: 20px;">
     	 <b style="font-size: 20px; color: black;">회원 탈퇴 약관</b>
    <br><br>
    <b>제1조 (목적)</b><br>
    본 약관은 회원이 회사에서 제공하는 서비스 이용을 종료하고 탈퇴하는 절차와 관련된 사항을 규정함을 목적으로 합니다.
    <br><br>
    <b>제2조 (탈퇴 요청)</b><br>
    회원은 언제든지 회원 탈퇴를 요청할 수 있습니다. 회원 탈퇴는 별도의 절차를 거쳐야 하며, 회원 본인의 의사에 따라 처리됩니다.
    <br><br>
    <b>제3조 (탈퇴 처리)</b><br>
    회원 탈퇴 요청 시, 회사는 회원의 신원을 확인한 후 탈퇴 처리를 진행합니다. 탈퇴 처리 완료 후에는 해당 회원의 모든 정보가 삭제되며, 복구가 불가능합니다. 탈퇴 처리 완료 후에는 회원이 회사의 서비스 및 혜택을 더 이상 이용할 수 없습니다.
    <br><br>
    <b>제4조 (재가입)</b><br>
    회원이 탈퇴한 후 재가입을 원할 경우, 새로운 회원 가입 절차를 따라야 합니다. 탈퇴한 회원의 정보를 활용하여 재가입 시도 시, 별도의 제한이 없는 한 재가입이 가능합니다.
    <br><br>
    <b>제5조 (약관 변경)</b><br>
    회사는 필요한 경우 본 약관을 변경할 수 있습니다. 변경된 약관은 회원에게 공지하고, 변경 후에도 계속해서 서비스를 이용하는 것은 약관 변경에 동의한 것으로 간주됩니다.
    <br><br>
    <b>제6조 (기타 사항)</b><br>
    본 약관에 명시되지 않은 사항에 대해서는 관련 법령과 회사의 개인정보 처리 방침에 따릅니다. 본 약관의 해석 및 적용에 관하여는 대한민국의 법령이 적용됩니다.
    <br><br>
    <b>제7조 (문의)</b><br>
    본 약관에 관한 문의 사항은 회사의 고객센터로 문의하여 주시기 바랍니다.
     </div>
     <div style="margin-top: 20px; display: flex; align-items: center;">
    <label for="agree" class="chk_box">
    <input type="checkbox" id="agree" name="agree">
    <span class="on"></span>이용약관에 동의합니다.<span style="color: red;"><b>(필수)</b></span>
	</label>
	</div>
     <div style="margin-top: 50px;" class="d-inline-flex align-items-center">
    <b style="margin-right: 20px;">비밀번호 입력</b>
    <input type="password" name="m_pass" id="m_pass" style="width: 200px; height: 40px;" class="form-control" required="required">
    <input type="hidden" name="m_num" value="<%=dto.getM_num() %>" >
	</div>
	<div style="margin-top: 100px; text-align: center;">
		<button type="button" class="btn btn-outline-success" style="width: 100px; height: 44px;" id="#"
		onclick="location.href='index.jsp?main=mypage/updateform.jsp'">
		취소
		</button>
		<button type="submit" class="btn btn-success" style="width: 100px; margin-left: 5px;  height: 44px;">
		탈퇴
		</button>
	</div>
   </form>
</div>
</div>


</body>
</html>