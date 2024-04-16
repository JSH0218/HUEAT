<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
    <link href="https://fonts.googleapis.com/css2?family=Nanum+Brush+Script&family=Nanum+Pen+Script&family=Noto+Sans+KR:wght@100..900&family=Noto+Serif+KR&family=Stylish&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Nanum+Gothic&display=swap" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.7.0.js"></script>

<title>Insert title here</title>
<style type="text/css">
#primary_nav_wrap
{
	margin-top: -3.5%;
	margin-left: 18%;
}

#primary_nav_wrap ul
{
	list-style:none;
	position:relative;
	float:left;
	margin:0;
	padding:0;
	z-index: 9999;
}

#primary_nav_wrap ul a
{
	display:block;
	color:#333;
	text-decoration:none;
	font-weight:700;
	font-size:14px;
	line-height:32px;
	padding:0 15px;
	margin-left: 10px;
}

#primary_nav_wrap ul li
{
	position:relative;
	float:left;
	margin:0;
	padding:0
}



#primary_nav_wrap ul ul
{
	display:none;
	position:absolute;
	top:100%;
	left:0;
	background:#fff;
	padding:0
}

#primary_nav_wrap ul ul li
{
	float:none;
	width:140px
}

#primary_nav_wrap ul ul a
{
	line-height:120%;
	padding:10px 15px; 
}


#primary_nav_wrap ul li:hover > a
{
	color: green;
}
 

#primary_nav_wrap ul li:hover > ul
{
	display:block
}
 
 div.topbax {
    width: 100%;
    background-color: #618E6E; /* 배경색 지정 */
    padding: 3px; /* 내부 여백 설정 */
    box-sizing: border-box; /* 내부 여백과 테두리를 요소의 전체 너비와 높이에 포함시킴 */
    /* 그 외에 필요한 스타일 추가 */
}


</style>
</head>
  <%
    //1.프로젝트 절대 경로 설정
    String root = request.getContextPath();
    String loginok=(String)session.getAttribute("loginok");
    String myid=(String)session.getAttribute("myid");
  %>
<body>
   
    <div class="topbax"></div>

  <div> 
    <!-- 1. title 상부 만들기 -->
       <!-- 이미지 로고 -->
       <a href="<%=root%>" style="color: black; text-decoration: none;">
       <img src="<%=root%>/image/mainbanner/logo1.png" style="width: 7%; margin-top: 1%; margin-left: 10%;">
      </a>
     
     
   
      <nav id="primary_nav_wrap">
		<ul>
		  <li><a href="#">소개</a>
		    <ul>
		      <li><a href="index.jsp?main=noticeboard/noticeList.jsp">공지사항</a></li>
		      <li><a href="#">소개글</a></li>
		      <li><a href="index.jsp?main=eventboard/eventList.jsp">이벤트</a></li>
		    </ul>
		  </li>
		  
		  <li><a href="#">휴게소정보</a>
		    <ul>
		      <li><a href="index.jsp?main=hugesoinfo/hugesomap.jsp">휴게소찾기</a></li>
		      <li><a href="index.jsp?main=hugesoinfo/hugesolist.jsp">휴게소목록</a></li>
		    </ul>
		  </li>
		  
		  <li><a href="#">고객센터</a>
		    <ul>
		      <li class="dir"><a href="index.jsp?main=qaboard/qaList.jsp">고객문의</a></li>
		      <li class="dir"><a href="index.jsp?main=reviewboard/reviewList.jsp">고객후기</a></li>
		    </ul>
		  </li>
		  <%
		  	//로그아웃 상태일때 로그인 버튼이 보이게
		  	if(loginok==null){%>
		  		<li style="padding-left: 590px;"><a href="member/loginform.jsp">로그인</a></li>
		  		<li><a href="member/gaipform.jsp">회원가입</a></li>
		  	<%}else{%>
		  		<li style="padding-left: 590px;"><a href="member/logoutaction.jsp">로그아웃</a></li>
		  		<li><a href="index.jsp?main=mypage/updatepassform.jsp">마이페이지</a>
		  			<ul>
				      <li><a href="index.jsp?main=mypage/updatepassform.jsp">회원정보수정</a></li>
				      <li><a href="index.jsp?main=mypage/myqnalist.jsp">나의 활동</a></li>
				      <li><a href="#">즐겨찾기</a></li>
		    		</ul>
		  		</li>
		  	<%}
		  %>

		</ul>
		</nav>
      
      
    </div>
    

</body>
</html>