<%@page import="java.text.SimpleDateFormat"%>
<%@page import="qa.model.QaDto"%>
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
    <script src="https://code.jquery.com/jquery-3.7.0.js"></script>
<title>Insert title here</title>
<%
//로그인 세션얻기
String loginok = (String) session.getAttribute("loginok");
String myid=(String)session.getAttribute("myid");
String q_num = request.getParameter("q_num");
QaDao dao = new QaDao();

QaDto dto = dao.getDataQa(q_num);
String currentPage = request.getParameter("currentPage");

//조회수 가져오기
dao.updateReadcount(q_num);

//날짜
SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
%>

<style type="text/css">

  button.col {
    background-color: #618E6E;
    right: 20%;
  }
  
  span.day {
    float: right;
    font-size: 0.8em;
    color: gray;
  }
  
   span.read {
    float: right;
    font-size: 0.8em;
    color: gray;
    margin-right: 4%;
  }
  
   span.category {
    font-size: 0.8em;
    color: gray;
  }
  
    span.my {
    float: right;
    font-size: 0.8em;
    margin-top: 1%;
  }
  
  i.adel, i.amod {
    cursor: pointer;
  }
  span.aday{
  color:#ccc;
  font-size: 0.8em;
  }
</style>

<script type="text/javascript">
   
   $(function () {
	 
	   //처음 시작시 댓글 호출
		  list();

	         $("div.upform").hide();
		 
		  
		  $("#btnsend").click(function(){
			 var q_num = $("#q_num").val(); 
			//alert(q_num);
			 var qa_content = $("#qa_content").val().trim();
			 
			 //null일경우 안넘어가도록

			 if(qa_content.trim().length==0) {
				 alert("댓글 입력 후 저장해주세요");
				 return;
			 }
			 
			 $.ajax({
				
				 type : "get",
				 url : "qaanswer/qaAnswerInsertAction.jsp",
				 datatype : "html",
				 data : {"q_num":q_num,"qa_content":qa_content},
				 success : function () {
					
					 //alert("success!!");
					 
					 //댓글,닉네임  쓰고나면 초기화
					 
					 $("#qa_content").val('');
					 
					 
					 //댓글추가후 댓글목록 다시 출력하기
					list();
				}
			 })
		  });
		  
		  
		  //삭제
		   $(document).on("click","i.adel",function(){
			   
			   var q_num=$(this).attr("q_num");
			   var qa_num=$(this).attr("qa_num");
			   
			   //alert(q_num+","+qa_num);
			   
			   var ans=confirm("댓글을 삭제하려면 [확인]을 눌러주새요");
			   
			   if(ans){
				   $.ajax({
					   
					   type:"get",
					   url:"qaanswer/qaAnswerDelete.jsp",
					   dataType:"html",
					   data:{"q_num":q_num, "qa_num":qa_num},
					   success:function(){
						   
						   list();
					   }
				   });
			   }
		   });
		  
		  
		 //수정창 안보이게
		  
	     //댓글list의 수정 아이콘 누르면 수정 댓글창에 해당 idx의 내용 띄우기
	     $(document).on("click","i.amod",function(){
	    	 $("div.aform").hide();
	    	 $("div.upform").show();
	    	 
	    	 var q_num = $(this).attr("q_num");
	    	 var qa_num = $(this).attr("qa_num");
	    	 //alert(q_num+","+qa_num);
	    	 $("#q_num").val(q_num);
	    	 $("#qa_num").val(qa_num);
	    	 
	    	 $.ajax({
	    		 type : "get",
	    		 dataType : "json",
	    		 url : "qaanswer/qaAnswerOneData.jsp",
	    		 data : {"q_num":q_num, "qa_num":qa_num},
	    		 success : function(res) {
	    			 $("#q_num").val(res.q_num);
	    			 $("#qa_num").val(res.qa_num);
	    			 $("#uqa_content").val(res.uqa_content);
	    			 
	    		 }
	    	 })  
	     });
	     
	     //수정
	     $("#btnupdate").click(function(){
	    	 var q_num = $("#q_num").val();
	    	 var qa_num = $("#qa_num").val(); 
	    	 var qa_content = $("#uqa_content").val();
	    	
	    	//alert(q_num+","+qa_num+","+qa_content);
	    	
	    	$.ajax({
	    		type : "get",
	    		url : "qaanswer/qaAnswerUpdateAction.jsp",
	    		dataType : "html",
	    		data : {"q_num":q_num, "qa_num":qa_num,"qa_content":qa_content},
	    		success : function() {
	    			list();
	    			$("div.upform").hide();
	    			$("div.aform").show();
	    		}
	    	})
	     });
		
   });
   
 //게시물 삭제
   function funcdel(q_num,currentPage){
 	   
 	  // alert(q_num+","+currentPage);
 	   
 	  var ans=confirm("삭제하려면 [확인]을 눌러주세요");
 	   
 	   if(ans){
 		   location.href='qaboard/qaDelete.jsp?q_num='+q_num+"&currentPage="+currentPage;
 	   } 
   }
 
 
  //전체리스트 출력
 function list() {
    console.log("list q_num=" + $("#q_num").val());

    $.ajax({
        type: "get",
        url: "qaanswer/qaListAction.jsp",
        dataType: "json",
        data: {"q_num": $("#q_num").val()},
        success: function (res) {
            //댓글 갯수 출력
            $("b.acount>span").text(res.length);

            var s = "";
            $.each(res, function (idx, item) {
            	s += "<div>"+item.qa_myid+" : ";
                s += "<span>" +item.qa_content+ "</span>";
                s += "<span class='aday' >(" + item.qa_writeday + ")</span>";
                s += "<span class='icon'><i class='bi bi-trash adel' q_num=" + item.q_num + " qa_num="+item.qa_num+" ></i>";
                s += "<i class='bi bi-pencil-square amod' q_num=" + item.q_num + " qa_num="+item.qa_num+"></i></span>";
                s += "</div>";
            });

            $(".alist").html(s); 
        }
    })
}
  
</script>

</head>
<body>

   <!-- 메뉴 타이틀 -->
  <input type="hidden" id="q_num" value="<%=q_num%>">
   
  <div style="margin-top: 70px; text-align: center;"><h4><b>고객문의</b></h4></div>
  

  <!-- 저장폼  -->
   <div style="margin: 100px 200px; width: 800px; margin-left: 28%;">
    <form id="frm">
     <table class="table">
      <caption align="top"><h5><b>문의글</b></h5></caption>
      
       <tr>
        <td>
          <span class="category"><%=dto.getQ_category() %></span><br>
          <span ><b><%=dto.getQ_subject() %></b></span>
          <span class="my"><%=dto.getQ_myid() %></span>
        </td>
      </tr>
      
	   <tr>
        <td>
          <span class="day"><%=sdf.format(dto.getQ_writeday()) %></span>
          <span class="read">조회 : <%=dto.getQ_readcount()%></span>
        </td>
      </tr>
      
       <tr height="300" align="center">
        <td><br><br>
           <%=dto.getQ_content().replace("\n", "<br>") %><br><br>
        </td>
     </tr>
    
    <!-- 댓글출력하기 -->
    
     <tr>
       <td>
         <b class="acount">댓글<span>0</span></b>
         <div class="alist">
          <br><b>댓글목록</b>
         </div>
      
     
        <div class="aform" >
           <span><%=dto.getQ_myid() %></span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
           <input type = "text" id="qa_content" class="form-control" style="width: 645px;"
           placeholder="댓글메세지">
           <button type="button" id="btnsend" class="btn btn-success">저장</button>
         </div>

    <!-- 댓글 수정창 -->
         
        <div class="upform" >
           <input type="hidden" id="q_num">
           <input type="hidden" id="qa_num">
           <span><%=dto.getQ_myid() %></span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
           <input type = "text" id="uqa_content" class="form-control" style="width: 645px;"
           placeholder="댓글메세지">
           <button type="button" id="btnupdate" class="btn btn-success">수정</button>
         </div>
     
   	   </td>
     </tr>	
      <!-- 버튼 -->
       
      <tr>
       <td colspan="1" align="right">
         <button type="button" class="btn btn-success col" style="width: 80px; height: 40px;" 
         onclick="location.href='index.jsp?main=qaboard/qaForm.jsp'">글쓰기</button>
         <button type="button" class="btn btn-success col" style="width: 80px; height: 40px;" 
         onclick="location.href='index.jsp?main=qaboard/qaList.jsp'">목록</button>
         <button type="button" class="btn btn-success col" style="width: 80px; height: 40px;"
         onclick="location.href='index.jsp?main=qaboard/qaUpdateForm.jsp?q_num=<%=q_num%>&currentPage=<%=currentPage%>'">
         수정</button>
         <button type="button" class="btn btn-success col" style="width: 80px; height: 40px;" 
         onclick="funcdel(<%=q_num%>,<%=currentPage%>)">삭제</button>
       </td>
		</tr>	
			
		</table> 
	  </form>	
   </div>
  
</body>
</html>