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
<title>Insert title here</title>
<style type="text/css">

  span.day{
     float: right;
     font-size: 10pt;
     color: gray;
  }
  
  a.mod {
    cursor: pointer;
    color: black;
  }
  
  i.del {
    cursor: pointer;
  }
  
   i.icon1 {
    cursor: pointer;
    font-size: 0.8em;
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
		position: relative;
		font-size: 3em;
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
			type : "get",
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
 		   location.href='reviewboard/reviewDelete.jsp?r_num='+r_num+"&currentPage="+currentPage;
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
	int totalCount=dao.getTotalCount();
	int perPage=5; //한페이지당 보여질 글의 갯수
	int perBlock=10; //한블럭당 보여질 페이지 갯수
	int startNum; //db에서 가져올 글의 시작번호(mysql은 첫글이0번,오라클은 1번);
	int startPage; //각블럭당 보여질 시작페이지
	int endPage; //각블럭당 보여질 끝페이지
	int currentPage;  //현재페이지
	int totalPage; //총페이지수
	int no; //각페이지당 출력할 시작번호 
	
	//현재페이지 읽는데 단 null일경우는 1페이지로 준다
	if(request.getParameter("currentPage")==null)
		currentPage=1;
	else
		currentPage=Integer.parseInt(request.getParameter("currentPage"));
	
	//총페이지수 구한다
	//총글갯수/한페이지당보여질갯수로 나눔(7/5=1)
	//나머지가 1이라도 있으면 무조건 1페이지 추가(1+1=2페이지가 필요)
	totalPage=totalCount/perPage+(totalCount%perPage==0?0:1);
	
	//각블럭당 보여질 시작페이지
	//perBlock=5일경우 현재페이지가 1~5일경우 시작페이지가1,끝페이지가 5
	//현재가 13일경우 시작:11 끝:15
	startPage=(currentPage-1)/perBlock*perBlock+1;
	endPage=startPage+perBlock-1;
	
	//총페이지가 23일경우 마지막블럭은 끝페이지가 25가 아니라 23
	if(endPage>totalPage)
		endPage=totalPage;
	
	//각페이지에서 보여질 시작번호
	//1페이지:0, 2페이지:5 3페이지: 10.....
	startNum=(currentPage-1)*perPage;
	
	//각페이지당 출력할 시작번호 구하기
	//총글개수가 23  , 1페이지:23 2페이지:18  3페이지:13
	no=totalCount-(currentPage-1)*perPage;
	
	//페이지에서 보여질 글만 가져오기
	List<ReviewDto> list = dao.getList(startNum, perPage);
		
	//해당 페이지에 게시물이 없을 경우 이전 페이지로 돌아가기
	//마지막 페이지의 단 한개 남은 글을 삭제 시 빈페이지가 남는데 해결책으로 그 이전 페이지로 가는 로직 설정
		if(list.size()==0 && currentPage !=1) {%>
			<script type="text/javascript">
			  location.href="index.jsp?main=reviewboard/reviewList.jsp?currentPage=<%=currentPage-1%>";
			</script>
		<%}
	
	//날짜변경
	SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd HH:mm");
	
	
	%>
<body>
  <div class="img-container" style="border: 0px solid green; background-image: url('image/mainbanner/qnabanner02.jpg'); background-size: cover; background-position: center center;">
</div>
<div class="span-container" style="border:0px solid purple;">
	<span>고객 후기<br><span style="font-size: 20px;">고객 여러분의 다양한 후기글을 남겨주세요.</span></span>
</div>
  


	<%
	//로그인을 한경우 리뷰폼이 나오도록 설정
	if (loginok != null) {%>
	
	<jsp:include page="reviewForm.jsp" />
	
	<%}
	%>

    
    <div style="margin:0 auto; width: 800px; margin-top: 3%;">
    <b style="color: gray;font-size: 1.2em;padding-left: 24px;">총 <%=totalCount %>개의 후기글이 있습니다</b><br><br>
    
    <%
      MemInfoDao rdao = new MemInfoDao();
      
      for(ReviewDto dto:list) {
    	  
    	   //아이디 얻기
    	    String name = rdao.getId(dto.getR_myid());

    	  %>
    	  
    	  <table class="table">
    	    <tr>
    	      <td>
    	        <b>작성자 : <%=name%>(<%=dto.getR_myid() %>)</b>

    	        
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
    	        
    	           <a href="reviewsave/<%=dto.getR_image()%>" target="_blank">
    	    	      <img alt="" src="reviewsave/<%=dto.getR_image()%>" align="left"
    	    	      style="width: 100px; " hspace="20">
    	    	   </a>
    	    	   
    	        <%}
    	        %>
    	        
    	         <%=dto.getR_content().replace("\n", "<br>")%>
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
      <%}
    %>
    
    </div>
    
    
    
    
   <div style="margin:0 auto; width: 800px; margin-top: 3%; margin-bottom:3%; text-align: center;" id="pagelayout">

  <!-- 페이지 번호 출력 -->
  <ul class="pagination justify-content-center">
  <%
  //이전
  if(startPage>1)
  {%>
	  <li class="page-item ">
	   <a class="page-link" href="index.jsp?main=reviewboard/reviewList.jsp?currentPage=<%=startPage-1%>" style="color: black;">이전</a>
	  </li>
  <%}
    for(int pp=startPage;pp<=endPage;pp++)
    {
    	if(pp==currentPage)
    	{%>
    		<li class="page-item active">
    		<a class="page-link" href="index.jsp?main=reviewboard/reviewList.jsp?currentPage=<%=pp%>"><%=pp %></a>
    		</li>
    	<%}else
    	{%>
    		<li class="page-item">
    		<a class="page-link" href="index.jsp?main=reviewboard/reviewList.jsp?currentPage=<%=pp%>"><%=pp %></a>
    		</li>
    	<%}
    }
    
    //다음
    if(endPage<totalPage)
    {%>
    	<li class="page-item">
    		<a  class="page-link" href="index.jsp?main=reviewboard/reviewList.jsp?currentPage=<%=endPage+1%>"
    		style="color: black;">다음</a>
    	</li>
    <%}
  %>
  
  </ul>
 
  
</div>

</body>
</html>