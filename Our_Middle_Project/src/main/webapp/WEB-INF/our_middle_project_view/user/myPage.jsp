<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>   
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>
	
	<!-- 폰트 -->
	<link rel="stylesheet" href="./css/fonts.css">
	
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
	
	<link rel="stylesheet" href="<%=request.getContextPath()%>/css/myPage/myPage.css">
	<link rel="stylesheet" href="<%=request.getContextPath()%>/css/fonts.css">

</head>
<body>

	<div class="my-container">

		<div class="my-main-header">
			<div class="my-logo">MyLogo</div>
			<div class="my-header-menu">
				<div data-text="게임하러가기" data-hover="PLAY GAME" onclick="location.href='gameHome.do'"></div>
				<div data-text="게시판가기" data-hover="BOARD" onclick="location.href='board.do'"></div>
				<div data-text="로그아웃" data-hover="LOGOUT" onclick="location.href='login.do'"></div>
			</div>
		</div>

		<div class="my-main-body">
			<!-- 왼쪽: 랭킹정보 -->
			<div class="my-panel my-left-panel">
				<div class="my-panel-header">
					<span>Ranking</span>
				</div>
				<div class="my-panel-content">
					<div class="my-game-card">
						<div class="my-game-info-head">
							<span>Hard Mode</span>
							<span>${sessionScope.MyPage_RankingDataHard.rank}등</span>
						</div>
						<div class="my-game-info-row">
							<span>일자</span>
							<span>${fn:substring(sessionScope.MyPage_RankingDataHard.played_last_date, 0, 10)}</span>
						</div>
						<div class="my-game-info-row">
							<span>점수</span>
							<span>${sessionScope.MyPage_RankingDataHard.score_best}</span>
						</div>
						<div class="my-game-info-row">
							<span>클리어타임</span>
							<span>${sessionScope.MyPage_RankingDataHard.clear_time}</span>
						</div>
						<div class="my-game-info-row">
							<span>콤보</span>
							<span>${sessionScope.MyPage_RankingDataHard.combo}</span>
						</div>
					</div>
					<div class="my-game-card">
						<div class="my-game-info-head">
							<span>Normal Mode</span>
							<span>${sessionScope.MyPage_RankingDataNormal.rank}등</span>
						</div>
						<div class="my-game-info-row">
							<span>일자</span>
							<span>${fn:substring(sessionScope.MyPage_RankingDataNormal.played_last_date, 0, 10)}</span>
						</div>
						<div class="my-game-info-row">
							<span>점수</span>
							<span>${sessionScope.MyPage_RankingDataNormal.score_best}</span>
						</div>
						<div class="my-game-info-row">
							<span>클리어타임</span>
							<span>${sessionScope.MyPage_RankingDataNormal.clear_time}</span>
						</div>
						<div class="my-game-info-row">
							<span>콤보</span>
							<span>${sessionScope.MyPage_RankingDataNormal.combo}</span>
						</div>
					</div>
					<div class="my-game-card">
						<div class="my-game-info-head">
							<span>Easy Mode</span>
							<span>${sessionScope.MyPage_RankingDataEasy.rank}등</span>
						</div>
						<div class="my-game-info-row">
							<span>일자</span>
							<span>${fn:substring(sessionScope.MyPage_RankingDataEasy.played_last_date, 0, 10)}</span>
						</div>
						<div class="my-game-info-row">
							<span>점수</span>
							<span>${sessionScope.MyPage_RankingDataEasy.score_best}</span>
						</div>
						<div class="my-game-info-row">
							<span>클리어타임</span>
							<span>${sessionScope.MyPage_RankingDataEasy.clear_time}</span>
						</div>
						<div class="my-game-info-row">
							<span>콤보</span>
							<span>${sessionScope.MyPage_RankingDataEasy.combo}</span>
						</div>
					</div>
				</div>
			</div>

			<!-- 중앙: 최근 30게임 -->
			<div class="my-panel my-middle-panel">
			    <div class="my-panel-header">
			        <span>Recent Game</span>
			    </div>
			    <div class="my-panel-content">
			        <div class="my-recent-header">
			            <div>번호</div>
			            <div>난이도</div>
			            <div>일자</div>
			            <div>점수</div>
			            <div>클리어타임</div>
			            <div>콤보</div>
			        </div>
			
			        <div class="my-recent-games">
			
			            <c:forEach var="log" items="${sessionScope.MyPage_GameLogData}" varStatus="status">
			                <c:if test="${status.index < 30}">
			                    <div class="my-recent-row">
			                        <div>${status.index + 1}</div>
			                        <div>
			                            <c:choose>
			                                <c:when test="${log.levelNo == 3}">상</c:when>
			                                <c:when test="${log.levelNo == 2}">중</c:when>
			                                <c:when test="${log.levelNo == 1}">하</c:when>
			                            </c:choose>
			                        </div>
			                        <div>${log.startTimeStr}</div>
			                        <div>${log.score}</div>
			                        <div>${log.clearTime}</div>
			                        <div>${log.combo}</div>
			                    </div>
			                </c:if>
			            </c:forEach>
			
			        </div>
			    </div>
			</div>



			<!-- 오른쪽: 나의 정보 -->
			<div class="my-panel my-right-panel">
				<div class="my-panel-header">
					<span>My Information</span>
				</div>
				<div class="my-panel-content">
					<div class="my-my-info-content">

						<!-- 1번 그룹: 계정 정보 -->
						<div class="my-info-group">
							<div class="my-group-col">
								<div class="my-info-item">
									<label>아이디</label>
									<input type="text" value="${sessionScope.MyPage_UserData.mem_id}" readonly>
								</div>
								<div class="my-info-item">
									<label>닉네임</label>
									<input type="text" value="${sessionScope.MyPage_UserData.nickname}">
								</div>
							</div>
							<div class="my-group-col">
								<div class="my-info-item">
									<label>비밀번호 변경</label><input type="password" placeholder="새 비밀번호 입력">
								</div>
								<div class="my-info-item">
									<label>변경 확인</label><input type="password" placeholder="새 비밀번호 입력 확인">
								</div>
							</div>
						</div>

						<!-- 2번 그룹: 개인정보 -->
						<div class="my-info-group">
							<div class="my-group-col">
								<div class="my-info-item">
									<label>실제 이름</label>
									<input type="text" value="${sessionScope.MyPage_UserData.mem_name}" readonly>
								</div>
								<div class="my-info-item">
									<label>성별</label>
									<input type="text" value="${sessionScope.MyPage_UserData.mem_gender == 'M' ? '남성' : '여성'}" readonly>
								</div>
							</div>
							<div class="my-group-col">
								<div class="my-info-item">
									<label></label><input type="hidden">
								</div>
								<div class="my-info-item">
									<label>생일</label>
									<input type="text" value="${sessionScope.MyPage_UserData.mem_birth.substring(0,10)}" readonly>
								</div>
							</div>
						</div>

						<!-- 3번 그룹: 연락처 -->
						<div class="my-info-group">
							<div class="my-group-col">
								<div class="my-info-item">
									<label>핸드폰번호</label>
									<input type="tel" value="${sessionScope.MyPage_UserData.mem_hp}">
								</div>
							</div>
							<div class="my-group-col">
								<div class="my-info-item">
									<label>메일</label>
									<input type="email" value="${sessionScope.MyPage_UserData.mem_mail}">
								</div>
							</div>
						</div>

						<!-- 4번 그룹: 주소 -->
						<div class="my-info-group">
							<div class="my-group-col">
								<div class="my-info-item">
									<label>우편번호</label>
									<input type="text" value="${sessionScope.MyPage_UserData.mem_zip}">
								</div>
								<div class="my-info-item">
									<label>주소1</label>
									<input type="text" value="${sessionScope.MyPage_UserData.mem_add1}">
								</div>
							</div>
							<div class="my-group-col">
								<div class="my-info-item">
									<label></label>
								</div>
								<div class="my-info-item">
									<label>주소2</label>
									<input type="text" value="${sessionScope.MyPage_UserData.mem_add2}">
								</div>
							</div>
						</div>
					</div>

					<!-- ✅ 새로 분리된 가입일자 섹션 -->
					<div class="my-join-section">
						<div class="my-join-row">
							<span class="my-join-label">Join Day</span>
							<span class="my-join-text">${fn:substring(sessionScope.MyPage_UserData.create_date, 0, 10)}</span>
						</div>
					</div>

					<div class="my-info-footer">
						<button type="button">탈퇴</button>
						<button type="button">변경</button>
					</div>
				</div>
			</div>
		</div>
	</div>

</body>
</html>