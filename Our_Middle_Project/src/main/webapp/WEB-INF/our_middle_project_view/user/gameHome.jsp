<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Game Home</title>
<!-- 부트스트랩 -->
	<link rel="stylesheet" href="<%=request.getContextPath()%>/js/lib/bootstrap/css/bootstrap.min.css">
	<script type="text/javascript" src="<%=request.getContextPath()%>/js/lib/bootstrap/js/bootstrap.min.js"></script>
	
	<!-- 스위트어럴트2 -->
	<link rel="stylesheet" href="<%=request.getContextPath()%>/js/lib/sweetalert2/dist/sweetalert2.min.css">
	<script type="text/javascript" src="<%=request.getContextPath()%>/js/lib/sweetalert2/dist/sweetalert2.min.js"></script>
	
	<!-- jquery -->
	<script type="text/javascript" src="<%=request.getContextPath()%>/js/lib/jquery/jquery-3.7.1.min.js"></script>
	
	<!-- axios -->
	<script type="text/javascript" src="<%=request.getContextPath()%>/js/lib/axios/axios.min.js"></script>

	<link rel="stylesheet"href="./css/gameHome/gameHome.css">
	
	
<body>

<!-- ========================================================== -->


	<div id="conteiner">
		
		<div id="main">
			
			<div id="header">
			
				<div id="logo">
					<img id="main" src="./images/icon/logo.png" alt="로고">
				</div>

				<div id="topNav">
					<button class="board">게시판</button>
					<button class="review">리뷰</button>
					<button class="ranking">랭킹</button>
				</div>
				
				<div id="rightNav">
					<button class="MyPage">MyPage</button>				
					<button class="exid">게임종료</button>
				</div>
				
			</div>
			
			<div id="centerDiv">
				<div id="leftCenter">
				
				</div>
				<div id="gameStart">
				
				</div>
			</div>
			
		</div>
	
	</div>
	
	
	
<!-- ================================================================ -->



<script type="text/javascript" src="./js/gameHome/gameHome.js"></script>
</body>
</html>