<%@page import="java.text.SimpleDateFormat"%>
<%@page import="meminfo.model.MemInfoDto"%>
<%@page import="java.util.List"%>
<%@page import="meminfo.model.MemInfoDao"%>
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
	button{
		background-color: #618E6E;
		color: white;
		border-radius: 5px;
		border:0px;
		height: 30px;

	}
</style>
<script type="text/javascript">
$(function(){
	
	$("#result").hide();
	
	$("button.search").click(function(){
		var m_name=$("#m_name").val();
		//alert(m_name);
		
		$.ajax({
			type:"get",
			url:"mypage/membersearch.jsp",
			dataType:"json",
			data:{"m_name":m_name},
			success:function(data){
				//alert("여기까지는 성공");
				//alert(data.length);
				if(data.length){
					var s="<table class='table table-bordered-light'>";
					s+="<tr align='center'><th>회원번호</th>";
					s+="<th>이름</th>";
					s+="<th>아이디</th>";
					s+="<th>닉네임</th>";
					s+="<th>연락처</th>";
					s+="<th>이메일</th>";
					s+="<th>생일</th>";
					s+="<th>가입일</th>";
					s+="<th>비고</th>";
					s+="</tr>";
					
				$.each(data,function(i,elt){
					s+="<tr><td align='center'>"+elt.m_num+"</td>";
					s+="<td align='center'>"+elt.m_name+"</td>";
					s+="<td align='center'>"+elt.m_id+"</td>";
					s+="<td align='center'>"+elt.m_nick+"</td>";
					s+="<td>"+elt.m_hp1+"-"+elt.m_hp2+"</td>";
					s+="<td>"+(elt.m_email==null?"":elt.m_email)+"</td>";
					s+="<td align='center'>"+elt.m_birth+"</td>";
					s+="<td align='center'>"+elt.m_gaipday+"</td>";
					s+="<td align='center'><button type='button' onclick='delemem("+elt.m_num+")'>강퇴</button></td>"
					s+="</tr>";
					})
					s+="</table>";
					$("#list").hide();
				}else{
					$("#result").hide();
					alert("검색결과가 없습니다.");
				}
				$("#result").show();
					$("#result").html(s);
			}
			
		})
	});
	
	
})

function delemem(m_num){
	if(confirm("정말 강퇴하시겠습니까?")){
		location.href="mypage/memberdelete.jsp?m_num="+m_num;
	}
}
</script>
</head>
<body>
<%
MemInfoDao dao=new MemInfoDao();
List<MemInfoDto> list=dao.getMemDatas();
SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");
%>

<div style="margin: 0 auto; width: 80%;height:100%; padding: 20px 20px 20px 20px; margin-top: 50px;">
	<h3><b>회원목록/관리</b></h3>
	<h6>총<%=list.size() %>명의 회원이 있습니다.</h6>
	<hr><br><br>
	<div style="margin: 0 auto;" align="center">
		<input name="m_name" id="m_name" style="width: 200px;" placeholder="검색할 이름을 입력하세요">
		<button type="button" class="search">검색</button>	
	</div>
	<div id="result" style="margin: 0 auto; width: 100%;height:100%; padding: 20px 20px 20px 20px;">
	</div>
	<br><br>
	<div id="list" style="margin: 0 auto; width: 100%; height:100%;padding: 20px 20px 20px 20px;">
	<table class="table table-bordered-light">
		<tr align="center">
			<th width="100">회원번호</th>
			<th>이름</th>
			<th>아이디</th>
			<th>닉네임</th>
			<th>연락처</th>
			<th>이메일</th>
			<th>생일</th>
			<th>가입일</th>
			<th>비고</th>
		</tr>
		<%
		for(MemInfoDto dto:list){%>
		<tr>
			<td align="center"><%=dto.getM_num() %></td>
			<td align="center"><%=dto.getM_name() %></td>
			<td align="center"><%=dto.getM_id() %></td>
			<td align="center"><%=dto.getM_nick() %></td>
			<td><%=dto.getM_hp1() %>-<%=dto.getM_hp2() %></td>
			<td><%=dto.getM_email()==null?"":dto.getM_email() %></td>
			<td align="center"><%=dto.getM_birth() %></td>
			<td align="center"><%=sdf.format(dto.getM_gaipday())%></td>
			<td align="center">
				<button type="button" class="deletemem" onclick="delemem('<%=dto.getM_num()%>')">강퇴</button>
			</td>
		</tr>
		<%}
		%>
	</table>
	</div>
</div>
</body>
</html>