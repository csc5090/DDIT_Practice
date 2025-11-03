<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>
	
	<link rel="stylesheet" href="./css/fonts.css">
	
	<link rel="stylesheet" href="./js/lib/bootstrap/css/bootstrap.min.css">
	<script type="text/javascript" src="./js/lib/bootstrap/js/bootstrap.min.js"></script>
	
	<link rel="stylesheet" href="./js/lib/sweetalert2/dist/sweetalert2.min.css">
	<script type="text/javascript" src="./js/lib/sweetalert2/dist/sweetalert2.min.js"></script>

	<link rel="stylesheet"href="./css/game/cardGame.css">
	<link rel="stylesheet" href="./css/game/gameEnding.css">
</head>
<body>

	<div class="main">
		<!-- 좌측 영역 70% -->

		<div id="leftGame">
				
			<div id="leftAreaLeft">
				
				<div id="gameTimer">
				<div id="timeCount">00 : 00</div>
				</div>
			</div>	
	
			<div id="leftArea"></div>	<!--실제 카드 놓이는곳 -->
			<div id="countDown"></div> 
			
			<div id="leftAreaRight"></div>
			
			
		</div>

		<!-- 우측 영역 30% -->
		<div id="rightArea">
			<!-- 버튼 영역 -->
			<div class="set">
				<button id="stopBtn">일시정지</button>
				<button id="exitBtn">나가기</button>
			</div>
			
			<div class="score-board">
   				  <div>점수: <span class="score">0</span></div>
   		 		  <div>콤보: <span class="combo">0</span></div>
  				  <div>최고 콤보: <span class="max-combo">0</span></div>
  			</div>


			<!-- 프로필 영역 -->
			<div class="profile">
			
				<div class="player">
					<img src="" alt="*">
					<div class="name">
						<c:out value="${sessionScope.map.mem_id}" />
					</div>
					
				</div>
				
				<div class="other">
					<img src="" alt="*">
					<div class="name">미야옹</div>
					<div class="score">score:0</div>
				</div>
				
				<!-- 버튼 -->
				<div id="buttonCover">
    				<button id="startBtn">START</button>
				</div>
				<!-- 버튼 -->
			
				
			</div>

			<!-- 채팅창 영역 -->
			<div class="chat">
				<div class="chat-messages" id="chat-messages">
					<div class="message sent">안녕하세요!</div>
					<div class="message received">반갑습니다 😄</div>
				</div>
				<form class="chat-form" id="chat-form">
					<input type="text" id="chat-input">
					<button type="submit">전송</button>
				</form>
			</div>
		</div>
	</div>
	
	<div id="endingModal" class="ending-container">
	
		<div class="ending-head">
			<div id="endingText"></div>
		</div>
		<div class="ending-body">
			<div class="ending-left-box">
				<div class="ending-info">
					<span class="info">점수 :</span>
					<span class="value" data-info="score">0</span>
				</div>
				<div class="ending-info">
					<span class="info">남은 시간 :</span>
					<span class="value" data-info="plusTime">0</span>
				</div>
				<div class="ending-info">
					<span class="info">최대 콤보 횟수 :</span>
					<span class="value" data-info="combo">0</span>
				</div>
				<div class="ending-info">
					<span class="info">맞춘 카드의 개수 :</span>
					<span class="value" data-info="cardCount">0</span>
				</div>
			</div>
			<div class="ending-right-box">
				<div class="ending-right-box-btn" data-value="try">Try Again</div>
				<div class="ending-right-box-btn" data-value="home">Home</div>
			</div>
		</div>
		
	</div>

	<script type="text/javascript">
	
		const GlovalLevel = "<c:out value='${sessionScope.map.level_name}' />";
	
	</script>

	<script type="text/javascript" src="./js/game/gamePlay.js"></script>
	<script type="text/javascript" src="./js/game/gameEnding.js"></script>

</body>
</html>



































