<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>
	
	
	<!-- bootstrap -->
	<link rel="stylesheet" href="./js/lib/bootstrap/css/bootstrap.min.css">
	<script type="text/javascript" src="./js/lib/bootstrap/js/bootstrap.min.js"></script>
	
	<!-- sweetalert2 -->
	<link rel="stylesheet" href="./js/lib/sweetalert2/dist/sweetalert2.min.css">
	<script type="text/javascript" src="./js/lib/sweetalert2/dist/sweetalert2.min.js"></script>
	
	<!-- jquery -->
	<script type="text/javascript" src="<%=request.getContextPath()%>/js/lib/jquery/jquery-3.7.1.min.js"></script>
	
	<!-- axios -->
	<script type="text/javascript" src="<%=request.getContextPath()%>/js/lib/axios/axios.min.js"></script>
	
	<link rel="stylesheet" href="./css/fonts.css">
	<link rel="stylesheet"href="./css/game/cardGame.css">
	<link rel="stylesheet" href="./css/game/gameEnding.css">
</head>
<body>

	<div id="main" class="main">
		<!-- 좌측 영역 70% -->

		<div id="leftGame">
  			
			<div id="leftAreaLeft">
				<div class="score-board">
	   				  <div>점수: <span class="score">0</span></div>
	   		 		  <div>콤보: <span class="combo">0</span></div>
	  				  <div>최고 콤보: <span class="max-combo">0</span></div>
	  			</div>
				<div id="gameTimer">
					<div id="timeCount">00 : 00</div>
				</div>
			</div>	
	
			<div id="leftArea"></div>	<!--실제 카드 놓이는곳 -->
			<div id="countDown">
				<div></div>
				<div id="countDown-in"></div>
			</div> 
			
			
		</div>

		<!-- 우측 영역 30% -->
		<div id="rightArea">
			<!-- 버튼 영역 -->
			<div class="set">
				<button id="stopBtn">일시정지</button>
				<button id="exitBtn">나가기</button>
			</div>
			
			<div class="rightAreaContent">
			
				<!-- 프로필 영역 -->
				<div class="profile">
				
					<div class="player-card">
						<div class="player-infos">
							<span>USERNO: </span>
							<span>
								<c:out value="${sessionScope.loginUser.mem_no}" />
							</span>
						</div>
						<div class="player-infos">
							<span>NICKNAME: </span>
							<span>
								<c:out value="${sessionScope.loginUser.mem_id}" />
							</span>
						</div>
						<div class="player-infos">
							<span>NICKNAME: </span>
							<span>
								<c:out value="${sessionScope.loginUser.nickname}" />
							</span>
						</div>
					</div>
					
					<div class="empty-area">
					
						<svg 
						xmlns="http://www.w3.org/2000/svg"	
						viewBox="0 0 1024 1024" role="img"
						aria-label="Twin Cards logo - white outline back card, filled front card with question mark cutout, transparent background">
				
							<defs>
								<!-- 카드 내부 기준 마스크 -->
								<mask id="cutQuestion">
									<!-- 카드 전체 흰색 (보이는 영역) -->
									<rect x="0" y="0" width="100%" height="100%" fill="white" />
									<!-- 물음표: 카드 중앙에 위치, 가로폭 85%로 축소 -->
									<text x="165" y="270" text-anchor="middle"
										dominant-baseline="middle"
										font-family="'Arial Black', 'Malgun Gothic', sans-serif"
										font-weight="700" font-size="384" fill="black"
										transform="translate(15,0) scale(0.85,1)">?</text>
								</mask>
							</defs>
					
							<!-- 카드 그룹 -->
							<g id="cards" transform="translate(0,20)">
								<!-- 뒷카드 (20px 왼쪽 이동, 왼쪽으로 기울임 -12도) -->
								<g transform="translate(220,160) rotate(-12 170 240)">
									<rect x="0" y="0" width="330" height="480" rx="28" ry="28"
										fill="none" stroke="#E9674D" stroke-width="12" opacity="1" />
								</g>
					
								<!-- 앞카드 (오른쪽으로 총 25px 이동 + 오른쪽으로 기울이기 +6도) -->
								<g transform="translate(495,220) rotate(6 165 240)">
									<rect x="0" y="0" width="330" height="480" rx="28" ry="28"
										fill="#E9674D" mask="url(#cutQuestion)" />
								</g>
							</g>
					
							<!-- "Twin Cards" 텍스트 -->
							<g id="wordmark">
								<text x="512" y="880" text-anchor="middle"
									font-family="'KCCAnchangho', cursive"
									font-size="160" font-weight="600" letter-spacing="6" fill="#E9674D">
									Twin Cards
								</text>
					
								<text x="512" y="840" text-anchor="middle"
									font-family="'KCCAnchangho', cursive"
									font-size="152" font-weight="600" letter-spacing="6" fill="none"
									stroke="#E9674D" stroke-width="6" stroke-linejoin="round"
									stroke-linecap="round" paint-order="stroke fill" />
							</g>
						</svg>
					
					</div>
					
				</div>
	
				<div id="buttonCover">
	   				<button id="startBtn" class="start-on">Start</button>
				</div>

				<!-- 채팅창 영역 -->
				<div class="chat">
					<div class="chat-messages" id="chat-messages">
					
						<div class="message myChat">
							<div class="myChat_info">
								<span class="chat_detail">안녕하세요.</span>
							</div>
						</div>
						
						<div class="message theirChat">
							<div class="theirChat_info">
								<span class="chat_nickName">닉네임</span>
								<span class="chat_id">#molly001</span>
								:
								<span class="chat_detail">
									안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안
								</span>
							</div>
						</div>
						
						<div class="message theirChat">
							<div class="theirChat_info">
								<span class="chat_nickName">닉네임</span>
								<span class="chat_id">#molly001</span>
								:
								<span class="chat_detail">
									안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안
								</span>
							</div>
						</div>
						
						<div class="message myChat">
							<div class="myChat_info">
								<span class="chat_detail">안녕하세요.</span>
							</div>
						</div>
						
						<div class="message theirChat">
							<div class="theirChat_info">
								<span class="chat_nickName">닉네임</span>
								<span class="chat_id">#molly001</span>
								:
								<span class="chat_detail">
									안녕하세요안녕하
								</span>
							</div>
						</div>
						
						<div class="message myChat">
							<div class="myChat_info">
								<span class="chat_detail">안녕하세요.</span>
							</div>
						</div>
						
						<div class="message myChat">
							<div class="myChat_info">
								<span class="chat_detail">안녕하세요.</span>
							</div>
						</div>
						
						<div class="message myChat">
							<div class="myChat_info">
								<span class="chat_detail">안녕하세요.</span>
							</div>
						</div>
						
					</div>
					
					<div class="chat-send-area">
						<form class="chat-form" id="chat-form">
							<input type="text">
						</form>
						<button type="submit">전송</button>					
					</div>
				</div>
			
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
					<span class="info">클리어 타임 :</span>
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
	
	
	
	<form id="gameLogForm" action="gameLog.do" method="post">
	    <input type="hidden" name="memNo" value="${sessionScope.loginUser.mem_no}">
	    <input type="hidden" name="levelNo" value="">
	    <input type="hidden" name="score" value="">
	    <input type="hidden" name="combo" value="">
	    <input type="hidden" name="clearTime" value="">
	    <input type="hidden" name="startTime" value="">
	    <input type="hidden" name="endTime" value="">
	</form>

	<%@ page import="com.google.gson.Gson" %>
	<%@ page import="com.our_middle_project.dto.UserInfoDTO" %>
	
	<%
	    Gson gson = new Gson();
	    UserInfoDTO user = (UserInfoDTO) session.getAttribute("loginUser");
	    String userJson = gson.toJson(user);
	%>
	
	<script type="text/javascript">
		const userDataCase = JSON.parse('<%= userJson %>');
		console.log(userDataCase);

 		const savedNo = `${sessionScope.map.level_no}`;
		const savedName = `${sessionScope.map.level_name}`;
		const savedArray = `${sessionScope.map.level_array}`;
	
		console.log(savedNo);
		console.log(savedName);
		console.log(savedArray);
	</script>
	

<!-- 	<script type="text/javascript"> -->
<%-- 	    const BASE_URL = '<%= request.getContextPath() %>/'; // context path 기준으로 서버 URL --%>
<!-- 	</script> -->

	<script type="text/javascript" src="./js/common.js"></script>
	<script type="text/javascript" src="./js/game/gamePlay.js"></script>
	<script type="text/javascript" src="./js/game/gamePlayToDB.js"></script>
	<script type="text/javascript" src="./js/game/gameEnding.js"></script>


</body>
</html>



































