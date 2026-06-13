<%@page import="notice.model.NoticeDto"%>
<%@page import="notice.model.NoticeDao"%>
<%@page import="meminfo.model.MemInfoDao"%>
<%@page import="java.util.List"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Nanum+Gothic:wght@400;700;800&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
<script src="https://code.jquery.com/jquery-3.7.0.js"></script>
<title>공지 관리</title>
<link rel="stylesheet" type="text/css" href="layout/pagination.css">
<link rel="stylesheet" type="text/css" href="layout/banner.css">
<link rel="stylesheet" type="text/css" href="layout/mypage-list.css">
<link rel="stylesheet" type="text/css" href="layout/anchor-reset.css">
<link rel="stylesheet" type="text/css" href="layout/mypage-tabs.css">
<link rel="stylesheet" type="text/css" href="layout/mypage-misc.css">
<link rel="stylesheet" type="text/css" href="layout/mypage-btndel.css">
<style type="text/css">
ul.tabs li#first{
	  border-radius: 100px;
	  border: 1px solid #ccc;
}
ul.tabs li#next{
	margin-left: 20px;
	  background-color: #5b954d;
	border-radius: 100px;
	color: #fff;
}

ul.tabs li#event {
	border: 1px solid #ccc;
	margin-left: 20px;
	    border-radius: 100px;
	    text-align: center;
}
ul.tabs li#first:hover, ul.tabs li#event:hover {
    background-color: #5b954d;
    transition: all 0.3s ease-in-out;
    border: 1px solid transparent;
    color: #fff;
}


div.adminnoticelist {
	width: 100%;
	padding-bottom: 40px;
	margin-left: auto;
	margin-right: auto;
}

</style>
<script type="text/javascript">
	$(function(){
		 //전체체크 클릭시 체크값 얻어서 모든체크값 에 전달
		  $(".alldelcheck").click(function(){
			  
			  //전체 체크값 얻기
			  var chk=$(this).is(":checked");
			  console.log(chk);
			  
			  //전체체크값을 글앞에 체크에 일괄 전달하기
			  $(".alldel").prop("checked",chk);
		  });
		 
		  //삭제버튼 클릭시 삭제
		   //삭제버튼 클릭시 삭제
		  $("#btndel").click(function(){
			  
			  var len=$(".alldel:checked").length;
			  //alert(len);
			  
			  if(len==0){
				  alert("최소 1개이상의 글을 선택해 주세요");
			  }else{
				  
				  var a=confirm(len+"개의 글을 삭제하려면 [확인]을 눌러주세요");
				  
				  if(a){
				  //체크된 곳의 value값(num)얻기
				  var n="";
				  $(".alldel:checked").each(function(idx){
					  n+=$(this).val()+",";
				  });
				  
				  //마지막 컴마 제거
				  n=n.substring(0,n.length-1);
				  //console.log(n);
				  
				  //삭제파일로 전송
				  postNav("mypage/deleteadminnotice.jsp", {nums:n});
				  }
			  }
		  })
		
	
	});
</script>
</head>
<%
   
    //로그인 세션얻기
	String loginok=(String)session.getAttribute("loginok");
	String myid=(String)session.getAttribute("myid");

	NoticeDao dao=new NoticeDao();
	
	//전체갯수
	int totalCount=dao.selectMyPageTotalCount();
	int perPage=5; //한페이지당 보여질 글의 갯수
	int perBlock=10; //한블럭당 보여질 페이지 갯수
%>
<%@ include file="/layout/pagingCalc.jspf" %>
<%
	
	//페이지에서 보여질 글만 가져오기
	List<NoticeDto> list = dao.selectMyPageList(startNum, perPage);
		
	//해당 페이지에 게시물이 없을 경우 이전 페이지로 돌아가기
	//마지막 페이지의 단 한개 남은 글을 삭제 시 빈페이지가 남는데 해결책으로 그 이전 페이지로 가는 로직 설정
		if(list.size()==0 && currentPage !=1) {%>
			<script type="text/javascript">
			  location.href="index.jsp?main=mypage/adminnoticelist.jsp?currentPage=<%=currentPage-1%>";
			</script>
		<%}
	
	//날짜변경
	SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");
	
	
	%>
<body>
<div class="img-container" style="border: 0px solid green; background-image: url('image/mainbanner/memberbanner01.jpg'); background-size: cover; background-position: center center;">	
</div>
<div class="span-container" style="border:0px solid purple; font-size: 2.5em;">
   <span>NOTICE</span>
</div>

<div class="container">

<div class="adminnoticelist">
	<% String adminTab="notice"; %>
	<%@ include file="/layout/mypageAdminTabs.jspf" %>
	<div id="tab2" class="tab2" style="margin-top: 40px;">
      	<table class="table table-bordered">
         	<tr style="height: 30px;">
				<th width="50" style="background-color: #DFE8E2;">번호</th>
				<th width="500" style="background-color: #DFE8E2;">제목</th>
				<th width="50" style="background-color: #DFE8E2;">조회수</th>
				<th width="100" style="background-color: #DFE8E2;">작성자</th>
				<th width="120" style="background-color: #DFE8E2;">작성일</th>
			</tr>
		<%
	      MemInfoDao mdao=new MemInfoDao();
		  String name=mdao.selectNickById(myid);
		 
	        
          //게시물이 없는 경우
          if(totalCount == 0) {%>
            <tr>
              <td colspan="5">
                <h6><b>등록된 게시글이 없습니다</b></h6>
              </td>
            </tr>
          
          <%}
          
          //내용 넣으면 각 주제별로 게시물 추출
          else {
		  
	      for(NoticeDto dto: list) {
		%>
		<tr>
			<td><input type="checkbox" class="alldel" value="<%=dto.getN_num()%>">
			<%=no-- %>
			</td>
			<td>
				 <a href="index.jsp?main=noticeboard/noticeDetail.jsp?currentPage=<%=currentPage %>&n_num=<%=dto.getN_num()%>">
				<%=util.SecurityUtil.escapeHtml(dto.getN_subject())%>
				</a>
			</td>
		    <td>
		   <%=dto.getN_readcount()%>
		    </td>
		    <td>
				<%=name %>
			</td>
		    <td class="day">
		        <%=sdf.format(dto.getN_writeday())%>
		    </td>		
		</tr>
    	<%}
    	%> 
      <tr style="border-bottom: none;">
             <td colspan="5" style="border-left: none; border-right: none;">
                <label style="float: left"><input type="checkbox" class="alldelcheck"> 전체선택</label>
                <span style="float: right;">
                   <button type="button" id="btndel">삭제</button>
                </span>
             </td>
           </tr>
    	</table>  
    </div>
    
    
    
    
   <div id="pagelayout">

  <!-- 페이지 번호 출력 -->
  <% String pageUrl="mypage/adminnoticelist.jsp"; String pageQuery=""; %>
<%@ include file="/layout/pagingNav.jspf" %>
  <% } %>
 
  
</div>
</div><!-- container -->
</div>
</body>
</html>