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
<div id="container">

	<div id="header">
	
		<div id="topNav">
			<button id="menuBtn">⚙️</button>
			
			<div id="menuItems">
			
				<div id="myPage">
					<button class="myBtn" onclick="goMyPage()">
						<span class="emoji">⚪</span>
        				<span class="text">My Page</span>
					</button>
				</div>
				<div id="exit">
					<button class="exitBtn" onclick="goExit()">
						<span class="emoji">⚪</span>
       					<span class="text">Exit</span>
					</button>
				</div>
			
			</div>
			
		</div>
		
	</div>	
		
	<div id="center">
	
		<div id="left">
			<img class="twinCards" src="./images/icon/Cards.png" alt="card">
			
			   <!-- 모달 -->
		    <div id="gameModal">
		        <div id="modalContent">
		            <!-- 모드 선택 영역 -->
		            <div id="modeSelect">
		                <h2>모드를 선택하세요</h2>
		                <button onclick="selectSingleMode()">싱글모드</button>
		                <button onclick="selectPvPMode()">대결모드</button>
		            </div>
		
		            <!-- 싱글 모드 난이도 선택 영역 -->
		            <div id="singleMode" style="display:none;">
		                <h2>난이도를 선택하세요</h2>
		                <button onclick="startGame4()">Easy (4x4)</button>
		                <button onclick="startGame6()">Normal (6x6)</button>
		                <button onclick="startGame8()">Hard (8x8)</button>
		                <button id="backToMode">뒤로</button>
		            </div>
		
		            <!-- 대결 모드 안내 -->
		            <div id="pvpMode" style="display:none;">
		                <h1>😓Coming Soon😓</h1>
		                <button id="backToMode2">뒤로</button>
		            </div>
		
		            <!-- 모달 닫기 -->
		            <button id="closeModal">닫기</button>
		        </div>
		    </div>
			
		</div>
		
			
	<div id="right">
		
			<div id="cards">
			
		
			    <div class="card" onclick="goBoard()">
			        <div class="card-inner">
			            <div class="card-front">Board</div>
			            <div class="card-back">?</div>
			        </div>
			    </div>
				
				  <div class="card" onclick="goReview()">
			        	<div class="card-inner">
			        	    <div class="card-front">Review</div>
			        	    <div class="card-back">?</div>
			      	    </div>
			   	  </div>
							
				  <div class="card" onclick="goRanking()">
				        <div class="card-inner">
				            <div class="card-front">Ranking</div>
				            <div class="card-back">?</div>
				        </div>
				   </div>    
				
			</div>
			
		    <div id="gameStart" onclick="goGameStart()">
		    	Game Start
		    </div>
		    
	</div>	
	
</div>
	

<!-- ================================================================ -->



<script type="text/javascript" src="./js/gameHome/gameHome.js"></script>
</body>
</html>