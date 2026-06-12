<%@page import="java.util.List"%>
<%@page import="java.util.HashMap"%>
<%@page import="favorite.model.FavoriteDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Grandiflora+One&family=Gugi&family=Hahmlet:wght@100..900&family=Hi+Melody&family=Sunflower:wght@300&display=swap" rel="stylesheet">
<script src="https://code.jquery.com/jquery-3.7.0.js"></script>
<title>즐겨찾기 목록</title>
<link rel="stylesheet" type="text/css" href="layout/banner.css">
<style type="text/css">
	button{
		background-color: #618E6E;
		color: white;
		border:0px;
		height: 30px;
		width: 100px;
	}
	
	div.span-container span{
		z-index: 9999;
		color: white;
		font-size: 3em;
		position: relative;

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
			
			
		});
	
	})
	
	function delfav(f_num){
		$.ajax({
			type:"post",
			url:"mypage/favdelete.jsp",
			dataType:"html",
			data:{"f_num":f_num},
			success:function(){
				location.reload();
			}
			
		})
	}
</script>
</head>
<body>
<div class="img-container" style="border: 0px solid green; background-image: url('image/mainbanner/memberbanner01.jpg'); background-size: cover; background-position: center center;">
	
</div>
<div class="span-container" style="border:0px solid purple;">
	<span>휴게소 즐겨찾기 목록<br><span style="display: block;font-size: 20px;">자주 방문하는 휴게소를 빠르게 찾아보세요.</span></span>
</div>

<%
String m_id=(String)session.getAttribute("myid");
FavoriteDao dao=new FavoriteDao();
List<HashMap<String,String>> list=dao.selectFavlist(m_id);
%>
<div style="margin: 0 auto; width: 65%;height:50%; padding: 20px 20px 20px 20px; margin-top: 50px;">
	<%--<h3><b>휴게소 즐겨찾기 목록</b></h3> --%>
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
			<th style="background-color: #DFE8E2;">연락처</th>
		
		</tr>
		<%
			if(list.size()==0){%>
				<tr>
					<td colspan="5" style="text-align: center;"><span>등록된 휴게소가 없습니다.<br>즐겨찾기로 등록해두고 편하게 찾아보세요.</span> </td>
				</tr>
			<%}
		%>
		<%
			for(int i=0;i<list.size();i++){
				HashMap<String,String> map=list.get(i);%>
			<tr style="text-align: center;">
				<td>
					<input type="checkbox" name="f_num" f_num=<%=map.get("f_num") %> class="f_num">
				</td>
				<td><a href="index.jsp?main=hugesoinfo/hugesodetail.jsp?h_num=<%=map.get("h_num") %>"
				style="text-decoration: none;"><%=util.SecurityUtil.escapeHtml(map.get("h_name")) %></a></td>
				<td><%=util.SecurityUtil.escapeHtml(map.get("h_addr")) %></td>
				<td><%=util.SecurityUtil.escapeHtml(map.get("h_pyeon")) %></td>
				<td><%=util.SecurityUtil.escapeHtml(map.get("h_hp")) %></td>
			
			</tr>	
		<%}
		%>

	</table>

</div>
</body>
</html>