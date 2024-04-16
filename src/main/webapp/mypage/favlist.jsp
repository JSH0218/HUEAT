<%@page import="java.util.List"%>
<%@page import="java.util.HashMap"%>
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
		border:0px;
		height: 30px;
		width: 100px;
	}
</style>
<script type="text/javascript">
	$(function(){
		
		$("#allcheck").click(function(){
			var ck=$(this).is(":checked");
			$(".f_num").prop("checked",ck);
			console.log(ck);
		});
		
		$("#delbtn").click(function(){
			
			var cnt=$(".f_num:checked").length;
			
			if(cnt==0){
				alert("1개 이상 선택해주세요.");
				return;
			}
			
			$(".f_num:checked").each(function(i,elt){
				var f_num=$(this).attr("f_num");
				delfav(f_num);
			})
			
			location.reload();
		});
	
	})
	
	function delfav(f_num){
		$.ajax({
			type:"get",
			url:"mypage/favdelete.jsp",
			dataType:"html",
			data:{"f_num":f_num},
			success:function(){
				
			}
			
		})
	}
</script>
</head>
<body>
<%
String m_id=(String)session.getAttribute("myid");
MemInfoDao dao=new MemInfoDao();
List<HashMap<String,String>> list=dao.getFavlist(m_id);
%>
<div style="margin: 0 auto; width: 80%;height:100%; padding: 20px 20px 20px 20px; margin-top: 50px;">
	<h3><b>휴게소 즐겨찾기 목록</b></h3>
	<br><br>
	<button type="button" id="delbtn" style="float: left;">삭제</button>
	<br><br>
	<table class="table table-bordered">
		<tr align="center">
			<th style="background-color: #DFE8E2;">
				<input type="checkbox" id="allcheck">
			</th>
			<th style="background-color: #DFE8E2;">휴게소</th>
			<th style="background-color: #DFE8E2;">주소</th>
			<th style="background-color: #DFE8E2;">편의시설</th>
			<th style="background-color: #DFE8E2;">입점브랜드</th>
		</tr>
		<%
			for(int i=0;i<list.size();i++){
				HashMap<String,String> map=list.get(i);%>
			<tr>
				<td>
					<input type="checkbox" name="f_num" f_num=<%=map.get("f_num") %> class="f_num">
				</td>
				<td><%=map.get("h_name") %></td>
				<td><%=map.get("h_addr") %></td>
				<td><%=map.get("h_pyeon") %></td>
				<td><%=map.get("h_brand") %></td>
			</tr>	
		<%}
		%>

	</table>

</div>
</body>
</html>