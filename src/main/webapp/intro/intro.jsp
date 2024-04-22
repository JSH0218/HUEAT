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
.intro {
  margin-top: 10%;
}

.title1 {
  text-align: center; /* 가로 가운데 정렬 */
  margin-top: 10vh; /* 화면 세로 중앙으로 이동 */
   }

  .subtitle {
  margin-top: 4%;
  text-align: center; /* 가로 가운데 정렬 */       
  }
  
  .intro_img {
  width: 800px;
   margin-top: 4%;
  }
</style>
</head>
     <%
   //프로젝트 경로
   String root = request.getContextPath();  
  %>
<body>
  <div class="intro">
	<div class="title1">
		<h2><b>"HUEAT"에 오신 여러분을 환영합니다</b></h2>
			<img alt="" src="<%=root%>/image/main/intro_대지 1.jpg" class="intro_img">
		
	</div>

	<div class="subtitle">
		<P>여러분을 환영합니다. 
		HUEAT은 고객 여러분의 몸과 마음, 정신까지 편안해지며, <br>
		가족, 연인, 친구들이 함께 재미있고 즐겁게 놀 수 있는 곳을 찾아<br> 
		삶의 활력과 에너지가 재충전되길 바라며 정보를 제공해드리는 곳입니다.<br>

        HUEAT은 휴게소 위치 검색, 상세 정보 제공, 음식 판매 정보 제공, 사용자 리뷰 및 평가, 그리고 다양한 이벤트 정보를 제공하는 다채로운 기능을 제공합니다. <br>
        이를 통해 사용자들은 편리하게 휴게소를 찾고 필요한 정보를 얻을 수 있으며, 더 나은 경험을 위한 서비스를 제공하고 있습니다.<br>

        우리는 고객 여러분께 마음을 움직이는 서비스와 항상 새로운 정보를 제공하기 위해 끊임없이 변화해 나갈 생각입니다. <br>
        저희 홈페이지를 방문해 주신 모든 고객님들께 진심으로 감사드립니다.<br>

        HUEAT은 앞으로도 고객 여러분들이 자연과 함께 편안하고, 즐겁게 휴식할 수 있는 진정한 쉼터로 거듭나기 위해 최선을 다하겠습니다.<br>

         감사합니다.
         </P><br>
		<b>"휴잇(주) 일동"</b>	
	</div>
  </div>

</body>
</html>