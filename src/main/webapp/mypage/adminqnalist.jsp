<%@page import="meminfo.model.MemInfoDao"%>
<%@page import="qaanswer.model.QaanswerDto"%>
<%@page import="qaanswer.model.QaanswerDao"%>
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
<title>관리자 QnA 답변 목록</title>
<link rel="stylesheet" type="text/css" href="layout/pagination.css">
<link rel="stylesheet" type="text/css" href="layout/banner.css">
<link rel="stylesheet" type="text/css" href="layout/mypage-list.css">
<link rel="stylesheet" type="text/css" href="layout/anchor-reset.css">
<link rel="stylesheet" type="text/css" href="layout/mypage-tabs.css">
<link rel="stylesheet" type="text/css" href="layout/mypage-misc.css">
<style type="text/css">

ul.tabs li#next, ul.tabs li#event {
	   border: 1px solid #ccc;
       margin-left: 20px;
       border-radius: 100px;
}
ul.tabs li#next:hover, ul.tabs li#event:hover {
    background-color: #5b954d;
    transition: all 0.3s ease-in-out;
    border: 1px solid transparent;
      color: #fff;
}


#first {
   background-color: #5b954d;
   border-radius: 100px;
   color: #fff;
}


div.adminqnalist {
	width: 100%;
	padding-bottom: 40px;
	margin-left: auto;
	margin-right: auto;
}

	#btndel{
	    background-color:#fb4357;
	    color: #fff;
	    border:none;
	    border-radius:5px;

	    width: 45px;
		height: 30px;
		font-size: 13px;
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
		  $("#btndel").click(function(){
			  
			  var len=$(".alldel:checked").length;
			  //alert(len);
			  
			  if(len==0){
				  alert("최소 1개이상의 답변을 선택해 주세요");
			  }else{
				  
				  var a=confirm(len+"개의 답변을 삭제하려면 [확인]을 눌러주세요");
				  
				  if(a){
				  //체크된 곳의 value값(num)얻기
				    var n = "";
					$(".alldel:checked").each(function(idx) {
					    var values = $(this).val().split("_");
					    var qNum = values[0]; // Q_num 값
					    var qaNum = values[1]; // qa_num 값
					    n += qNum + "," + qaNum + ",";
					});
					// 마지막 콤마 제거
					n = n.substring(0, n.length - 1);
					//console.log(n);
				  
				  
				  //삭제파일로 전송
				  postNav("mypage/deleteadminqna.jsp", {nums:n});
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

	QaanswerDao dao=new QaanswerDao();
	
	//전체갯수
	int totalCount=dao.selectMyPageTotalCount();
	int perPage=10; //한페이지당 보여질 글의 갯수
	int perBlock=10; //한블럭당 보여질 페이지 갯수
%>
<%@ include file="/layout/pagingCalc.jspf" %>
<%
	
	//페이지에서 보여질 글만 가져오기
	List<QaanswerDto> list = dao.selectMyPageList(startNum, perPage);
		
	//해당 페이지에 게시물이 없을 경우 이전 페이지로 돌아가기
	//마지막 페이지의 단 한개 남은 글을 삭제 시 빈페이지가 남는데 해결책으로 그 이전 페이지로 가는 로직 설정
		if(list.size()==0 && currentPage !=1) {%>
			<script type="text/javascript">
			  location.href="index.jsp?main=mypage/adminqnalist.jsp?currentPage=<%=currentPage-1%>";
			</script>
		<%}
	
	//날짜변경
	SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");
	
	
	%>
<body>
<div class="img-container" style="border: 0px solid green; background-image: url('image/mainbanner/memberbanner01.jpg'); background-size: cover; background-position: center center;">
	
</div>
<div class="span-container" style="border:0px solid purple; font-size: 2.5em;">
   <span>Q&A</span>
</div>

<div class="container">

<div class="adminqnalist">
	<% String adminTab="qa"; %>
	<%@ include file="/layout/mypageAdminTabs.jspf" %>
	<div id="tab2" class="tab2" style="margin-top: 40px;">
      	<table class="table table-bordered">
         	<tr style="height: 30px;">
				<th width="50" style="background-color: #DFE8E2;">번호</th>
				<th width="200" style="background-color: #DFE8E2;">고객문의글</th>
				<th width="500" style="background-color: #DFE8E2;">답변한 내용</th>
				<th width="120" style="background-color: #DFE8E2;">닉네임</th>
				<th width="100" style="background-color: #DFE8E2;">작성일</th>
			</tr>
		<%
	      MemInfoDao mdao=new MemInfoDao();
		  String name=mdao.selectNickById(myid);
		 
	        
          //게시물이 없는 경우
          if(totalCount == 0) {%>
            <tr>
              <td colspan="4">
                <h6><b>등록된 게시글이 없습니다</b></h6>
              </td>
            </tr>
          
          <%}
          
          //내용 넣으면 각 주제별로 게시물 추출
          else {
		  
	      for(QaanswerDto dto: list) {
		%>
		<tr>
			<td><input type="checkbox" class="alldel" value="<%=dto.getQ_num() %>_<%=dto.getQa_num() %>">
			<%=no-- %>
			</td>
			<td>
				<%=util.SecurityUtil.escapeHtml(dao.selectTitle(dto.getQ_num()))%>
			</td>
		    <td>
		    <a href="index.jsp?main=qaboard/qaDetail.jsp?currentPage=<%=currentPage %>&q_num=<%=dto.getQ_num() %>"><%=util.SecurityUtil.escapeHtml(dto.getQa_content())%></a>
		    </td>
		    <td>
				<%=util.SecurityUtil.escapeHtml(name) %>
			</td>
		    <td class="day">
		        <%=sdf.format(dto.getQa_writeday())%>
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
  <% String pageUrl="mypage/adminqnalist.jsp"; String pageQuery=""; %>
<%@ include file="/layout/pagingNav.jspf" %>
  <% } %>
 
  
</div>
</div><!-- container -->
</div>
</body>
</html>