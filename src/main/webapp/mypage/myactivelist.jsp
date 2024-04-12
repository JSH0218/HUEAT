<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Nanum+Gothic:wght@400;700;800&display=swap" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
<script src="https://code.jquery.com/jquery-3.7.0.js"></script>
<title>Insert title here</title>
<style type="text/css">
	*{
			font-family: 'Nanum Gothic';
	}
		.line {
		  border: 1px solid #000;
		  margin-top: 30px;
		}
		#container {
		display: flex;
		margin-bottom: 100px;
		border: 1px solid red;
	}
		.container {
		width: 1000px;
		margin-top: 100px;
		margin-left: 50px;
		border: 1px solid red;
	}
		#sidebar {
		width: 300px;
		height: 300px;
		margin-top: 100px;
		margin-left: 200px;
		border: 1px solid red;
	}

		ul.tabs{
			margin: 0px;
			padding: 0px;
			list-style: none;
		}
		ul.tabs li{
			background: none;
			color: #222;
			display: inline-block;
			padding: 10px 15px;
			cursor: pointer;
		}

		ul.tabs li.current{
			background: white;
			color: #009900;
		}

		.tab-content{
			display: none;
			background: pink;
			padding: 15px;
		}

		.tab-content.current{
			display: inherit;
		}
	
		ul.tabs li span {
  		  font-weight: bold;
		}
		
</style>
<script type="text/javascript">
	$(document).ready(function(){
		
		$('ul.tabs li').click(function(){
			var tab_id = $(this).attr('data-tab');
	
			$('ul.tabs li').removeClass('current');
			$('.tab-content').removeClass('current');
	
			$(this).addClass('current');
			$("#"+tab_id).addClass('current');
		})
	
	})
</script>
</head>
<body>
<div id="container">
<div id="sidebar">
			<b style="font-size: 30px; color: black;">마이휴잇</b>
			<table style="width: 300px; margin-top: 50px;">
				<tr height="60px;" style="border: 1px solid gray;">
					<td style="vertical-align: middle; padding-left: 20px;">회원정보수정</td>
					<td><i class="bi bi-chevron-right"></i></td>
				</tr>
				<tr height="60px;" style="border: 1px solid gray;">
					<td style="vertical-align: middle; padding-left: 20px;">나의활동</td>
					<td><i class="bi bi-chevron-right"></i></td>
				</tr>
				<tr height="60px;" style="border: 1px solid gray;">
					<td style="vertical-align: middle; padding-left: 20px;">즐겨찾기</td>
					<td><i class="bi bi-chevron-right"></i></td>
				</tr>
			</table>
		</div>
<div class="container">
	<b style="font-size: 25px; color: black;">나의활동</b>

	<hr class="line">
	<ul class="tabs">
		<li class="tab-link current" data-tab="tab-1"><span>내가 작성한 Q&A</span></li>
		<li class="tab-link" data-tab="tab-2"><span>내가 작성한 리뷰</span></li>
	</ul>

	<div id="tab-1" class="tab-content current">
		Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
	</div>
	<div id="tab-2" class="tab-content">
		 Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
	</div>

</div><!-- container -->
</div>
</body>
</html>