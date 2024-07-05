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
	
	div.img-container{
    width: 100%; /* 이미지를 감싸는 부모 요소의 가로폭 */
    height: 250px; /* 원하는 높이로 설정 */
    overflow: hidden; /* 내용이 넘칠 경우를 대비하여 오버플로우를 숨김으로 설정 */
  	border: 0px solid black;
  	background-position: top;
  	text-align: center;
}
	
	div.img-container img {
		top: 0;
    width: 100%; /* 이미지가 부모 요소의 가로폭을 다 차지하도록 설정 */
    height: auto; /* 세로 비율을 유지하기 위해 자동으로 조정 */
    object-fit: cover; /* 이미지를 부모 요소에 맞게 잘라내어 배치 */
    
}
	div.span-container{
		width: 100%; /* 이미지를 감싸는 부모 요소의 가로폭 */
    height: 250px; /* 원하는 높이로 설정 */
    overflow: hidden; /* 내용이 넘칠 경우를 대비하여 오버플로우를 숨김으로 설정 */
  	background-position: top;
		margin-top:-14%;
  	text-align: center;
  	display: flex;
    justify-content: center; /* 수평 가운데 정렬 */
    align-items: center; /* 수직 가운데 정렬 */
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
			type:"get",
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
MemInfoDao dao=new MemInfoDao();
List<HashMap<String,String>> list=dao.getFavlist(m_id);
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
				style="text-decoration: none;"><%=map.get("h_name") %></a></td>
				<td><%=map.get("h_addr") %></td>
				<td><%=map.get("h_pyeon") %></td>
				<td><%=map.get("h_hp") %></td>
			
			</tr>	
		<%}
		%>

	</table>

</div>
</body>
</html>