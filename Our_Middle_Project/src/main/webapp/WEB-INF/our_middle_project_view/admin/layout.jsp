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
<link rel="stylesheet" 
	  href="${pageContext.request.contextPath}/css/admin/admin_dashboard.css">
	
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
						<div class="bigmenu-container" id="dashboard-container" data-target="dashboard-main">
							<span class="span-big"> 대시보드 </span>
						</div>
					</li>
					
					<li class="nav-big-area">
						<div class="bigmenu-container" id="user-container">
							<span class="span-big"> 사용자 </span>
						</div>

						<div class="ul-container-none" data-toggle="true">
							<ul class="ul-small-container">
								<li id="get-user" data-target="userlist-main"><span class="span-small">목록 조회</span></li>
								<li id="management-user" data-target="user-auth-management"><span class="span-small">권한 관리</span></li>
								<li id="nickname-user" data-target="nickname-management"><span class="span-small">닉네임 변경</span></li>
								<li id="black-user" data-target="block-management"><span class="span-small">차단 관리</span></li>
							</ul>
						</div>
					</li>

				<!-- 	<li class="nav-big-area">
						<div class="bigmenu-container" id="chat-container">
							<span class="span-big"> 채팅 </span>
						</div>

						<div class="ul-container-none" data-toggle="true">
							<ul class="ul-small-container">
								<li id="chat-management"><span class="span-small"> 채팅 관리 </span></li>
							</ul>
						</div>
					</li> -->

					<li class="nav-big-area">
						<div class="bigmenu-container" id="board-container">
							<span class="span-big"> 게시판 </span>
						</div>

						<div class="ul-container-none" data-toggle="true">
							<ul class="ul-small-container">
								<li id="notice-edit" data-target="notice-management"><span class="span-small"> 공지사항 관리 </span>
								<li id="post-edit" data-target="post-management"><span class="span-small"> 게시물 관리 </span>
							</ul>
						</div>
					</li>

					<!-- <li class="nav-big-area">
						<div class="bigmenu-container" id="game-container">
							<span class="span-big"> 게임 </span>
						</div>

						<div class="ul-container-none" data-toggle="true">
							<ul class="ul-small-container">
								<li id="game-management"><span class="span-small"> 게임 관리 </span>
								<li id="event-management"><span class="span-small"> 이벤트 관리 </span>
							</ul>
						</div>
					</li> -->

					<li class="nav-big-area">
						<div class="bigmenu-container" id="data-container" data-target="stats-main">
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
		
		<div class="main-area-wrapper">
			<header class="main-header">
				<div class="user-profile">
					<button type="button" class="user-profile-toggle">
						<span>${sessionScope.adminName eq null ? '관리자' : sessionScope.adminName}</span>
						<svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="6 9 12 15 18 9"></polyline></svg>
					</button>
					<div class="user-profile-dropdown">
						<ul>
							<li><a href="/my-profile.do">내 프로필</a></li>
							<li><a href="/logout.do">로그아웃</a></li>
						</ul>
					</div>
				</div>
			</header>
			
			<main class="main-content-area">
				<%-- <jsp:include page="${requestScope.viewPage}" flush="true" /> --%>
				<div class="bodyArea active" id="dashboard-main">
					<div class="card-container">
					    
					    <div class="card-row"> 
					        <div class="card">
					            <div class="card-header">
					                <h3>총 몇 명?</h3>
					            </div>
					            <div class="card-body">
					                <span class="main-number">####</span>
					            </div>
					        </div>
					        <div class="card">
					            <div class="card-header">
					                <h3>몇 판?</h3>
					            </div>
					            <div class="card-body">
					                <span class="main-number">####</span>
					            </div>
					        </div>
					        <div class="card">
					            <div class="card-header">
					                <h3>뉴비 몇 명?</h3>
					            </div>
					            <div class="card-body">
					                <span class="main-number">####</span>
					            </div>
					        </div>
					    </div>
					    <div class="chart">
					        <canvas id="myChart"></canvas>
					    </div>
					    
					</div>
				</div>
				
				
				
				
				<div class="bodyArea" id="userlist-main">목록조회 </div>
				
				
				
				
				<div class="bodyArea" id="user-auth-management">권한관리</div>
				
				
				
				
				<div class="bodyArea" id="block-management">차단 관리</div>
				
				
				
				
				<div class="bodyArea" id="nickname-management">닉네임 변경</div>
				
				
				
				
				<div class="bodyArea" id="notice-management">공지사항 관리</div>
				
				
				
				
				<div class="bodyArea" id="post-management">게시물 관리</div>
				
				
				
				
				<div class="bodyArea" id="stats-main">데이터/통계</div>
				
			</main>
			
		</div>
	</div>
	
	<script type="text/javascript" src="${pageContext.request.contextPath}/js/admin/admin_layout.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</body>
</html>