<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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

	<link rel="stylesheet" href="./css/game/gameEnding.css">
</head>
<body>

	<div id="game-container">
	
		<button type="button" class="btn btn-outline-success" onclick="endGame()">게임종료</button>
	
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


	<script type="text/javascript" src="./js/game/gameEnding.js"></script>

</body>
</html>



































