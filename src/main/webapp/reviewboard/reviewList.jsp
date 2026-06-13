<%@page import="meminfo.model.MemInfoDao"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="review.model.ReviewDto"%>
<%@page import="java.util.List"%>
<%@page import="review.model.ReviewDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
    <link href="https://fonts.googleapis.com/css2?family=Nanum+Brush+Script&family=Nanum+Pen+Script&family=Noto+Sans+KR:wght@100..900&family=Noto+Serif+KR&family=Stylish&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <script src="https://code.jquery.com/jquery-3.7.0.js"></script>
<title>후기게시판</title>
<link rel="stylesheet" type="text/css" href="layout/pagination-b.css">
<link rel="stylesheet" type="text/css" href="layout/banner.css">
<link rel="stylesheet" type="text/css" href="layout/span-container-board.css">
<style type="text/css">

  span.day{
     float: right;
     font-size: 10pt;
     color: gray;
  }
  
  a.mod {
    cursor: pointer;
    color: black;
    float: right;
  }
  
  i.del {
    cursor: pointer;
    float: right;
  }
  
   i.icon1 {
    cursor: pointer;
    font-size: 0.8em;
  }
  
    

</style>


<script type="text/javascript">

  $(function () {
	 //누르면 추천 올라가기
	  $("i.icon1").click(function () {
		  
		  var r_num = $(this).attr("r_num");
		  //alert(r_num);
		  var tag = $(this); 
		  
		  
		  $.ajax ({
			type : "post",
			dataType : "json",
			url : "reviewboard/reviewChu.jsp",
			data : {"r_num":r_num},
			success : function (data) {
				
				//alert(data.chu);
				tag.next().next().text(data.chu);
				//location.reload();
				
			}
			
			  
		  })
		  
	  });
		
	$("i.mod").click(function () {
		//alert("성공");
		
	})
  
  
    //후기 삭제
  
    $("i.del").click(function(){
    	var r_num = $(this).attr("r_num");
    	var currentPage = $(this).attr("currentPage");
    	
    	//alert(r_num+","+currentPage);
    	
    	var ans=confirm("삭제하려면 [확인]을 눌러주세요");
 	   
 	    if(ans){
 		   postNav('reviewboard/reviewDelete.jsp', {r_num:r_num, currentPage:currentPage});
 	   } 
    })
    
  });
  
</script>
</head>
  <%
   
    //로그인 세션얻기
	String loginok=(String)session.getAttribute("loginok");
    
    
  
  
	ReviewDao dao=new ReviewDao();
	
	//전체갯수
	int totalCount=dao.selectTotalCount();
	int perPage=5; //한페이지당 보여질 글의 갯수
	int perBlock=10; //한블럭당 보여질 페이지 갯수
%>
<%@ include file="/layout/pagingCalc.jspf" %>
<%
	
	//페이지에서 보여질 글만 가져오기
	List<ReviewDto> list = dao.selectPagingList(startNum, perPage);
		
	//해당 페이지에 게시물이 없을 경우 이전 페이지로 돌아가기
	//마지막 페이지의 단 한개 남은 글을 삭제 시 빈페이지가 남는데 해결책으로 그 이전 페이지로 가는 로직 설정
		if(list.size()==0 && currentPage !=1) {%>
			<script type="text/javascript">
			  location.href="index.jsp?main=reviewboard/reviewList.jsp?currentPage=<%=currentPage-1%>";
			</script>
		<%}
	
	//날짜변경
	SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");
	
	
	%>
<body>
  <div class="img-container" style="border: 0px solid green; background-image: url('image/mainbanner/qnabanner03.png'); background-size: cover; background-position: center center;">
</div>
<div class="span-container" style="border:0px solid purple;">
	<span>고객 후기<br><span style="display: block;font-size: 20px;">고객 여러분의 다양한 후기글을 남겨주세요.</span></span>
</div>
  


	<%
	//로그인을 한경우 리뷰폼이 나오도록 설정
	if (loginok != null) {%>
	
	<jsp:include page="reviewForm.jsp" />
	
	<%}
	%>

    
    <div style="margin:0 auto; width: 800px; margin-top: 3%;">
    <b style="color: gray;font-size: 1.2em;padding-left: 10px;">총 <%=totalCount %>개의 후기글이 있습니다</b><br><br>
    
    <%
      MemInfoDao rdao = new MemInfoDao();

      for(ReviewDto dto:list) {
    	  
    	   //아이디 얻기
    	    String name = rdao.selectNickById(dto.getR_myid());

    	  %>
    	  
    	  <table class="table">
    	    <tr>
    	      <td>
    	        <b>작성자 : <%=util.SecurityUtil.escapeHtml(name)%>(<%=util.SecurityUtil.escapeHtml(dto.getR_myid()) %>)</b><br>
    	        <p style="margin-bottom: -3%;"><%=util.SecurityUtil.escapeHtml(dto.getR_category()) %></p>
                
    	        
    	        <%
    	        String myid=(String)session.getAttribute("myid"); 
    	    	
    	    	
    	    	//로그인한 아이디와 글을 쓴 아이디가 같을경우에만 수정, 삭제 보이게 함.
    	    	if (loginok != null && myid != null && dto.getR_myid() != null && dto.getR_myid().equals(myid)) {%>
    	    	
    	    	   <span>
    	    	     <a href="index.jsp?main=reviewboard/reviewUpdateForm.jsp?r_num=<%=dto.getR_num()%>&currentPage=<%=currentPage%>" 
    	    	     class="bi bi-pencil-square mod"><i></i></a>
    	    	     <i r_num=<%=dto.getR_num() %> currentPage=<%=currentPage %> class="bi bi-trash del"></i></span> 
    	    	   

    	    	<%}
    	    	%>
    	    	  <span class="day"><%=sdf.format(dto.getR_writeday()) %></span>
    	      </td>
    	    </tr>
    	    
    	    
    	    <!-- 이미지 -->
    	    <tr height="120">
    	      <td>
    	      
    	        <% 
    	        //<!-- 이미지가 null이 아닌 경우만 출력 -->
    	        if(dto.getR_image()!=null) {%>
    	        
    	           <a href="fileview?type=review&name=<%=util.SecurityUtil.urlEncode(dto.getR_image())%>" target="_blank">
    	    	      <img alt="" src="fileview?type=review&name=<%=util.SecurityUtil.urlEncode(dto.getR_image())%>" align="left"
    	    	      style="width: 100px; " hspace="20">
    	    	   </a>
    	    	   
    	        <%}
    	        %>
    	        
    	         <%=util.SecurityUtil.nl2brEscaped(dto.getR_content())%>
    	      </td>
    	    </tr>
    	    
    	    <!-- 추천 -->
    	    <tr>
    	      <td>
    	       <i class="icon1 bi bi-hand-thumbs-up" r_num=<%=dto.getR_num() %>></i>
               <span class="likes" style="font-size: 0.8em;">추천 : </span>
    	       <span class="chu" style="font-size: 0.8em;"><%=dto.getR_chu() %></span>
    	      </td>
    	      
    	    </tr>
    	    
    	    
    	  </table>
    	  <hr>
      <%}
    %>
    
    </div>
    
    
    
    
   <div style="margin:0 auto; width: 800px; margin-top: 3%; margin-bottom:3%; text-align: center;" id="pagelayout">

  <!-- 페이지 번호 출력 -->
  <% String pageUrl="reviewboard/reviewList.jsp"; String pageQuery=""; %>
<%@ include file="/layout/pagingNav.jspf" %>
 
  
</div>

</body>
</html>