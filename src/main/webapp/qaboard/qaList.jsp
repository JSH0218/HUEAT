<%@page import="qaanswer.model.QaanswerDao"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="qa.model.QaDto"%>
<%@page import="java.util.List"%>
<%@page import="qa.model.QaDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
    <link href="https://fonts.googleapis.com/css2?family=Nanum+Brush+Script&family=Nanum+Pen+Script&family=Noto+Sans+KR:wght@100..900&family=Noto+Serif+KR&family=Stylish&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.7.0.js"></script>
<title>QnA 게시판</title>
<link rel="stylesheet" type="text/css" href="layout/pagination-b.css">
<link rel="stylesheet" type="text/css" href="layout/banner.css">
<style type="text/css">

  button.col {
    background-color: #618E6E;
    right: 20%;
  }
   
  
  a:link, a:visited {
    text-decoration: none;
    color: black;
  
  }
   
	div.span-container span{
		z-index: 999;
		color: white;
		position: relative;
		font-size: 3em;
}
	div.alldiv{
		width: 80%;
		margin:0 auto;
	}

	div.tablediv{
		margin:0 auto;
		padding-top: 5%;
		border: 0px solid red;
		width: 70%;
		display: block;

	}
	
	#pagelayout{
		margin:0 auto;
		border: 0px solid yellow;
		padding-top: 4%;
		width: 70%;
		display: block;
		margin-bottom: 4%;
	}
  
 	div.tablediv th{
  	background-color: #DFE8E2;
  }

</style>

</head>
   <%
   
    //로그인 세션얻기
	String loginok=(String)session.getAttribute("loginok");
    String myid=(String)session.getAttribute("myid");
   
	QaDao dao=new QaDao();
	
	//전체갯수
	int totalCount=dao.selectTotalCount();
	int perPage=10; //한페이지당 보여질 글의 갯수
	int perBlock=10; //한블럭당 보여질 페이지 갯수
%>
<%@ include file="/layout/pagingCalc.jspf" %>
<%
	
	//페이지에서 보여질 글만 가져오기
	List<QaDto> list = dao.selectPagingList(startNum, perPage);
		
	//해당 페이지에 게시물이 없을 경우 이전 페이지로 돌아가기
	//마지막 페이지의 단 한개 남은 글을 삭제 시 빈페이지가 남는데 해결책으로 그 이전 페이지로 가는 로직 설정
		if(list.size()==0 && currentPage !=1) {%>
			<script type="text/javascript">
			  location.href="index.jsp?main=qaboard/qaList.jsp?currentPage=<%=currentPage-1%>";
			</script>
		<%}
	
	//날짜변경
	SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");
	
	
	QaanswerDao qdao = new QaanswerDao();
	
	for(QaDto dto:list) {
		
		//댓글 변수에 댓글 총 갯수 넣기
		int acount = qdao.selectQaAnswerList(dto.getQ_num()).size();
		dto.setQa_cnt(acount);
	}
      
	
	%>
<script type="text/javascript">
$(function(){
	$("button.col").click(function(){
		
		var loginok="<%=loginok%>";
		  if(loginok == "null"){
	            alert("로그인이 필요한 서비스입니다.");
	            return;
	        }
		  else{
			  location.href = 'index.jsp?main=qaboard/qaForm.jsp';
		  }
	})
	
})

</script>
<body>
<div class="img-container" style="border: 0px solid green; background-image: url('image/mainbanner/qnabanner03.png'); background-size: cover; background-position: center center;">
</div>
<div class="span-container" style="border:0px solid purple;">
	<span >고객문의<span style="display: block;font-size: 20px;">문의를 남겨주시면 빠른 시일 내에 답변드리겠습니다.</span></span>
</div>


<div class="alldiv">
  <div class=tablediv>
    <table class="table table-bordered">
      <caption align="top" style="font-size: 1.2em;padding-left: 24px;"><b>목록</b></caption>
        <tr class="table-" align="center" style="height: 30px;">
          <th width="120">번호</th>
          <th width="250">카테고리</th>
          <th width="450">제목</th>
          <th width="200">작성자</th>
          <th width="150">조회수</th>
          <th width="350">등록일자</th>
        </tr>
        
        <%
        
          //게시물이 없는 경우
          if(totalCount == 0) {%>
            <tr>
              <td colspan="6">
                <h6><b>등록된 게시글이 없습니다</b></h6>
              </td>
            </tr>
          
          <%}
     
          //내용 넣으면 각 주제별로 게시물 추출
          else {
        	  for(QaDto dto:list) {%>
        		
        		  <tr>
        		    <td align="center" valign="<%=dto.getQ_num()%>"><%=no-- %></td>
        		    <td align="center"><%=util.SecurityUtil.escapeHtml(dto.getQ_category()) %></td>
        		    
        		    
        		    <td>
                    <% if (loginok != null && ("ADMIN".equals((String)session.getAttribute("role")) || myid.equals(dto.getQ_myid()))) { %>
                      <!-- 제목 선택하면 디테일 페이지로 이동 -->
                      <a href="index.jsp?main=qaboard/qaDetail.jsp?q_num=<%=dto.getQ_num()%>
                      &currentPage=<%=currentPage%>"><i class="bi bi-lock-fill"></i>비밀글입니다
                      </a>
        
                      <% } else { %>
                     <!-- 작성자와 admin이 아닌 경우에는 비밀글로 표시 -->
                     <i class="bi bi-lock-fill"></i>
                     <a href="#" onclick="clickSubject()">비밀글입니다</a>
                      <% } %>        
        
        
                      <!-- 댓글 갯수 -->
                     <% if(loginok != null && ("ADMIN".equals((String)session.getAttribute("role")) || myid.equals(dto.getQ_myid()))) { %>
                     <a href="index.jsp?main=qaboard/qaDetail.jsp?q_num=<%=dto.getQ_num()%>&currentPage=<%=currentPage %> 
                     #alist" style="color: red;">[<%=dto.getQa_cnt() %>]</a>  
                     <% }
                     
        	         else { %>
                         <a href="#" onclick="clickSubject()" style="color: red;">[<%=dto.getQa_cnt() %>]</a>
                      <% } %>        
                     </td>
               
                    <script>
                       function clickSubject() {
                             swal("작성자가 다릅니다", "해당 게시물의 작성자가 맞는지 확인해주세요", "error");
                      }
                    </script>
        		    
        		   
        		   
        		    <td align="center"><%=util.SecurityUtil.escapeHtml(dto.getQ_myid()) %></td>
        		    <td align="center"><%=dto.getQ_readcount() %></td>
        		    <td align="center"><%=sdf.format(dto.getQ_writeday())%></td>
        		    
        		  </tr>  
        	  <%}
          }
        %>

    </table>
           
     
        <div>
          <button type="button" 
          class="btn btn-success col" style="width: 80px; height: 40px;float: right;">글쓰기</button>
       </div>
    
  </div>
  
  
  <div style="text-align: center;" id="pagelayout">
  
  
  <!-- 페이지 번호 출력 -->
  <% String pageUrl="qaboard/qaList.jsp"; String pageQuery=""; %>
<%@ include file="/layout/pagingNav.jspf" %>
 
  
</div>
</div> <!-- 전체감싼 div -->
</body>
</html>