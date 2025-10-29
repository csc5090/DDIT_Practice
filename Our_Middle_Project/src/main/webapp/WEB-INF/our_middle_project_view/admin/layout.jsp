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
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/admin/admin_userlist.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/admin/admin_nickname.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/admin/admin_block_management.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/admin/admin_notice.css">

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
						<div class="bigmenu-container" id="dashboard-container"
							data-target="dashboard-main">
							<span class="span-big"> 대시보드 </span>
						</div>
					</li>

					<li class="nav-big-area">
						<div class="bigmenu-container" id="user-container">
							<span class="span-big"> 사용자 </span>
						</div>

						<div class="ul-container-none" data-toggle="true">
							<ul class="ul-small-container">
								<li id="get-user" data-target="userlist-main"><span
									class="span-small">목록 조회</span></li>
								<li id="nickname-user" data-target="nickname-management"><span
									class="span-small">유저 닉네임 변경</span></li>
								<li id="black-user" data-target="block-management"><span
									class="span-small">차단 유저 관리</span></li>
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
								<li id="notice-edit" data-target="notice-management"><span
									class="span-small"> 공지사항 관리 </span>
								<li id="post-edit" data-target="post-management"><span
									class="span-small"> 게시물 관리 </span>
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
						<div class="bigmenu-container" id="data-container"
							data-target="stats-main">
							<span class="span-big"> 데이터/통계 </span>
						</div>
					</li>
				</ul>
			</div>

			<div class="nav-wrapper">
				<div
					class="bigmenu-container ${activeMenu eq 'settings' ? 'active' : ''}"
					id="setting-conatainer">
					<span class="span-big"> 설정 </span>
				</div>
			</div>

		</nav>

		<div class="main-area-wrapper">
			<header class="main-header">
				<div class="user-profile">
					<button type="button" class="user-profile-toggle">
						<span>${sessionScope.adminName eq null ? '관리자' : sessionScope.adminName}</span>
						<svg width="12" height="12" viewBox="0 0 24 24" fill="none"
							stroke="currentColor" stroke-width="2" stroke-linecap="round"
							stroke-linejoin="round">
							<polyline points="6 9 12 15 18 9"></polyline></svg>
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
									<h3>회원이 얼마나 있나요?</h3>
								</div>
								<div class="card-body">
									<span class="main-number" id="total-user-count"></span>
								</div>
							</div>
							<div class="card">
								<div class="card-header">
									<h3>지금까지 쌓인 게임 수는요?</h3>
								</div>
								<div class="card-body">
									<span class="main-number">1aa</span>
								</div>
							</div>
							<div class="card">
								<div class="card-header">
									<h3>뉴비 숫자는요?</h3>
								</div>
								<div class="card-body">
									<span class="main-number" id="new-user-count"></span>
								</div>
							</div>
						</div>
						<div class="chart">
							<canvas id="myChart"></canvas>
						</div>

					</div>
				</div>

				<div class="bodyArea" id="userlist-main">
					<div class="list-toolbar">
						<div class="search-bar">
							<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"
								fill="none" stroke="currentColor" stroke-width="2"
								stroke-linecap="round" stroke-linejoin="round">
								<circle cx="11" cy="11" r="8"></circle>
								<line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>
							<input type="text" class="search-btn"
								placeholder="사용자 아이디, 닉네임 검색...">
						</div>
						<div class="filter-options"></div>
					</div>

					<div class="table-container">
						<table>
							<thead>
								<tr>
									<th>아이디</th>
									<th>닉네임</th>
									<th>이메일</th>
									<th>상태</th>
									<th>가입일</th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<td>user001</td>
									<td>Commander</td>
									<td>commander@example.com</td>
									<td><span class="status-badge status-active">활성</span></td>
									<td>2025-10-28</td>
								</tr>
								<tr>
									<td>banned_user</td>
									<td>Aris</td>
									<td>aris@millennium.ac.kr</td>
									<td><span class="status-badge status-banned">차단</span></td>
									<td>2025-09-01</td>
								</tr>
								<tr>
									<td>user003</td>
									<td>Operator</td>
									<td>operator@example.com</td>
									<td><span class="status-badge status-active">활성</span></td>
									<td>2025-07-15</td>
								</tr>
							</tbody>
						</table>

						<div class="pagination">
							<a href="#" class="page-arrow">&laquo;</a> <a href="#"
								class="page-num active">1</a> <a href="#" class="page-num">2</a>
							<a href="#" class="page-num">3</a> <a href="#" class="page-num">4</a>
							<a href="#" class="page-num">5</a> <a href="#" class="page-arrow">&raquo;</a>
						</div>
					</div>

				</div>

				<div class="bodyArea" id="nickname-management">
					<div class="step-card">
						<h2>유저 닉네임 변경</h2>
						<div class="search-form">
							<input type="text" id="user-search-input"
								placeholder="변경할 사용자의 아이디 또는 닉네임">
							<button id="user-search-btn" class="action-btn primary">검색</button>
						</div>

						<div class="search-results" id="search-results-box">
							<ul>
								<li class="result-item" data-userid="user001"
									data-nickname="Commander"><span class="result-id">user001</span>
									<span class="result-nickname">Commander</span></li>
								<li class="result-item" data-userid="banned_user"
									data-nickname="Aris"><span class="result-id">banned_user</span>
									<span class="result-nickname">Aris</span></li>
								<li class="result-item" data-userid="user003"
									data-nickname="Operator"><span class="result-id">user003</span>
									<span class="result-nickname">Operator</span></li>
							</ul>
						</div>
					</div>
				</div>



				<div class="bodyArea" id="block-management">
					<h1>차단 유저 관리</h1>

					<div class="list-toolbar">
						<div class="search-bar">
							<svg xmlns="http://www.w.org/2000/svg" viewBox="0 0 24 24"
								fill="none" stroke="currentColor" stroke-width="2"
								stroke-linecap="round" stroke-linejoin="round">
								<circle cx="11" cy="11" r="8"></circle>
								<line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>
							<input type="text" placeholder="차단된 사용자 검색...">
						</div>
					</div>

					<div class="banned-user-list">
						<div class="banned-user-card">
							<div class="user-details">
								<div class="user-id-info">
									<span class="id">banned_user</span> <span class="nickname">Aris</span>
								</div>
								<div class="ban-reason">
									<span>사유: 부적절한 언어 사용 (2025-09-01)</span>
								</div>
							</div>
							<div class="card-actions">
								<button class="action-btn unban">차단 해제</button>
							</div>
						</div>

						<div class="banned-user-card">
							<div class="user-details">
								<div class="user-id-info">
									<span class="id">hacker_01</span> <span class="nickname">Yuzu</span>
								</div>
								<div class="ban-reason">
									<span>사유: 비인가 프로그램 사용 (2025-08-15)</span>
								</div>
							</div>
							<div class="card-actions">
								<button class="action-btn unban">차단 해제</button>
							</div>
						</div>
					</div>
				</div>

				<div class="bodyArea" id="notice-management">

					<div id="notice-list-view" class="notice-view">
						<div class="notice-toolbar">
							<h1>공지사항 관리</h1>
							<button id="btn-new-notice" class="btn-primary">새 글 작성</button>
						</div>

						<div class="notice-table-wrapper">
							<table class="notice-table">
								<thead>
									<tr>
										<th>제목</th>
										<th>작성자</th>
										<th>작성일</th>
										<th>액션</th>
									</tr>
								</thead>
								<tbody>
									<tr>
										<td>[점검] 10월 30일 정기 점검 안내</td>
										<td>운영팀</td>
										<td>2025-10-29</td>
										<td><button class="action-btn">수정</button></td>
									</tr>
									<tr>
										<td>[이벤트] 할로윈 이벤트 시작!</td>
										<td>이벤트팀</td>
										<td>2025-10-28</td>
										<td><button class="action-btn">수정</button></td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>

					<div id="notice-editor-view" class="notice-view"
						style="display: none;">
						<div class="notice-toolbar">
							<h1>새 공지사항 작성</h1>
						</div>

						<div class="form-group">
							<label for="notice-title">제목</label> <input type="text"
								id="notice-title" placeholder="제목을 입력하세요">
						</div>

						<div class="form-group content">
							<label for="notice-content">내용</label>
							<textarea id="notice-content" placeholder="내용을 입력하세요."></textarea>
						</div>

						<div class="editor-actions">
							<button id="btn-back-to-list" class="btn-secondary">목록으로</button>
							<button id="btn-save-notice" class="btn-primary">저장하기</button>
						</div>
					</div>

				</div>


				<div class="bodyArea" id="post-management">게시물 관리</div>




				<div class="bodyArea" id="stats-main">데이터/통계</div>

			</main>

		</div>
	</div>

	<script>
		const CONTEXT_PATH = "${pageContext.request.contextPath}";
	</script>

	<script type="text/javascript"
		src="${pageContext.request.contextPath}/js/admin/admin_layout.js"></script>

	<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</body>
</html>