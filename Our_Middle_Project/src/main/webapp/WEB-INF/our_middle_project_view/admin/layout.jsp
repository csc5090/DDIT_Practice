<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Good Day, Commander.</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/admin/admin_layout.css">
</head>
<body>
	<div id="admin-wrapper">
		<nav class="sidearea">
				<div class="logo-wrapper">
					<span class="logo-span"> 로고 들어갈 자리 </span>
				</div>
				
				<div class="ul-wrapper">
				<ul class="nav-container">
					<li class="nav-big-area">
						<div class="bigmenu-container" id="dashboard-container">
							<span class="span-big"> 대시보드 </span>
						</div>
					</li>
					
					<li class="nav-big-area">
						<div class="bigmenu-container" id="user-container">
							<span class="span-big"> 사용자 </span>
						</div>

						<div class="ul-container-none" data-toggle="true">
							<ul class="ul-small-container">
								<li id="get-user"><span class="span-small">목록 조회</span></li>
								<li id="management-user"><span class="span-small">권한 관리</span></li>
								<li id="nickname-user"><span class="span-small">닉네임 변경</span></li>
								<li id="black-user"><span class="span-small">차단 관리</span></li>
							</ul>
						</div>
					</li>

					<li class="nav-big-area">
						<div class="bigmenu-container" id="chat-container">
							<span class="span-big"> 채팅 </span>
						</div>

						<div class="ul-container-none" data-toggle="true">
							<ul class="ul-small-container">
								<li id="chat-management"><span class="span-small"> 채팅 관리 </span></li>
							</ul>
						</div>
					</li>

					<li class="nav-big-area">
						<div class="bigmenu-container" id="board-container">
							<span class="span-big"> 게시판 </span>
						</div>

						<div class="ul-container-none" data-toggle="true">
							<ul class="ul-small-container">
								<li id="notice-management"><span class="span-small"> 공지사항 관리 </span>
								<li id="post-management"><span class="span-small"> 게시물 관리 </span>
							</ul>
						</div>
					</li>

					<li class="nav-big-area">
						<div class="bigmenu-container" id="game-container">
							<span class="span-big"> 게임 </span>
						</div>

						<div class="ul-container-none" data-toggle="true">
							<ul class="ul-small-container">
								<li id="game-management"><span class="span-small"> 게임 관리 </span>
								<li id="event-management"><span class="span-small"> 이벤트 관리 </span>
							</ul>
						</div>
					</li>

					<li class="nav-big-area">
						<div class="bigmenu-container" id="data-container">
							<span class="span-big"> 데이터/통계 </span>
						</div>
					</li>
				</ul>
			</div>

			<div class="nav-wrapper">
				<div class="bigmenu-container ${activeMenu eq 'settings' ? 'active' : ''}" id="setting-conatainer">
					<span class="span-big"> 설정 </span>
				</div>
			</div>

		</nav>
		
		<main class="main-area">
		         
		        </main>
		

	</div>
	
	<script type="text/javascript" src="${pageContext.request.contextPath}/js/admin/admin_layout.js"></script>


</body>
</html>