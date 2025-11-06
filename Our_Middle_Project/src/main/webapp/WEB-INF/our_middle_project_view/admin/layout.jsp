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
	href="<%=request.getContextPath()%>/js/lib/bootstrap/css/bootstrap.min.css">
<script type="text/javascript"
	src="<%=request.getContextPath()%>/js/lib/bootstrap/js/bootstrap.min.js"></script>
<link rel="stylesheet"
	href="<%=request.getContextPath()%>/js/lib/sweetalert2/dist/sweetalert2.min.css">
<script type="text/javascript"
	src="<%=request.getContextPath()%>/js/lib/sweetalert2/dist/sweetalert2.min.js"></script>

<script type="text/javascript"
	src="<%=request.getContextPath()%>/js/lib/jquery/jquery-3.7.1.min.js"></script>

<%-- <script type="text/javascript" src="<%=request.getContextPath()%>/js/lib/axios/axios.min.js"></script> --%>

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/admin/admin_common.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/admin/admin_layout.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/admin/admin_dashboard.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/admin/admin_user_management.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/admin/admin_notice.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/admin/admin_review.css">



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
								<li id="get-user-menu" data-target="user-management"><span
									class="span-small">유저 관리</span></li>
							</ul>
						</div>
					</li>

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
								<li id="review-edit" data-target="review-management"><span
									class="span-small"> 리뷰 관리 </span>
							</ul>
						</div>
					</li>

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
						<span> <c:out value="${sessionScope.loginAdmin.mem_name}" />
						</span>


						<svg width="12" height="12" viewBox="0 0 24 24" fill="none"
							stroke="currentColor" stroke-width="2" stroke-linecap="round"
							stroke-linejoin="round">
							<polyline points="6 9 12 15 18 9"></polyline></svg>
					</button>
					<div class="user-profile-dropdown">
						<ul>
							<li><a href="/my-profile.do">내 프로필</a></li>
							<li><a
								href="${pageContext.request.contextPath}/adminlogout.do">로그아웃</a></li>
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
									<span class="main-number" id="total-game-count"></span>
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

				<div class="bodyArea" id="user-management">
					<div class="user-list-panel">
						<div class="list-toolbar">
							<div class="search-bar">
								<input type="text" id="user-search-input"
									placeholder="사용자 ID 또는 닉네임으로 검색">
								<button id="user-search-btn" class="action-btn primary">검색</button>
							</div>
						</div>

						<div class="user-list-wrapper">
							<table class="user-list-table">
								<thead>
									<tr>
										<th class="sortable" data-sort-key="userId"
											data-sort-order="none">아이디 <span class="sort-icon"></span>
										</th>
										<th class="sortable" data-sort-key="userName"
											data-sort-order="none">이름 <span class="sort-icon"></span>
										</th>
										<th class="sortable" data-sort-key="nickname"
											data-sort-order="none">닉네임 <span class="sort-icon"></span>
										</th>
										<th class="sortable" data-sort-key="status"
											data-sort-order="none">상태 <span class="sort-icon"></span>
										</th>
										<th class="sortable" data-sort-key="regDate">가입일 <span
											class="sort-icon"></span>
										</th>
									</tr>
								</thead>
								<tbody id="user-list-tbody">
									<tr class="no-results-row" style="display: none;">
										<td colspan="5">검색 결과가 없습니다.</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>

					<div class="user-detail-panel">
						<div class="detail-content">
							<div class="detail-header">
								<h2 id="detail-user-id"></h2>
								<p class="header-guideline">편집할 유저를 더블클릭하세요.</p>
							</div>
							<div class="detail-body">
								<div class="form-group">
									<label for="detail-nickname">닉네임</label> <input type="text"
										id="detail-nickname">
								</div>
								<div class="form-group">
									<label for="detail-status">계정 상태</label> <select
										id="detail-status">
										<option value="ACTIVE">ACTIVE</option>
										<option value="SUSPENDED">SUSPENDED</option>
										<option value="DELETED">DELETED</option>
									</select>
								</div>
								<div class="form-group">
									<label for="detail-role">역할 (ROLE)</label> <select
										id="detail-role">
										<option value="USER">USER</option>
										<option value="ADMIN">ADMIN</option>
									</select>
								</div>
								<div class="form-group">
									<label for="detail-email">이메일</label> <input type="text"
										id="detail-email" readonly>
								</div>
								<div class="form-group">
									<label for="detail-gender">성별</label> <input type="text"
										id="detail-gender" readonly>
								</div>
								<div class="form-group">
									<label for="detail-birth">생년월일</label> <input type="text"
										id="detail-birth" readonly>
								</div>
								<div class="form-group">
									<label for="detail-hp">핸드폰 번호</label> <input type="text"
										id="detail-hp" readonly>
								</div>
								<div class="form-group">
									<label for="detail-zip">우편번호</label> <input type="text"
										id="detail-zip" readonly>
								</div>
								<div class="form-group full-width">
									<label for="detail-add1">기본주소</label> <input type="text"
										id="detail-add1" readonly>
								</div>
								<div class="form-group full-width">
									<label for="detail-add2">상세주소</label> <input type="text"
										id="detail-add2" readonly>
								</div>
								<div class="form-group">
									<label for="detail-deleted-date">탈퇴일</label> <input type="text"
										id="detail-deleted-date" readonly>
								</div>
								<div class="form-group">
									<label for="detail-deleted-reason">탈퇴 사유</label> <input
										type="text" id="detail-deleted-reason" readonly>
								</div>
							</div>
							<div class="detail-footer">
								<button id="detail-apply-btn" class="action-btn primary">적용</button>
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


					<div class="editor-view" id="notice-editor-view"
						style="display: none;">
						<div class="toolbar">
							<h1 style="font-size: 1.8rem;">새 공지사항 작성</h1>
							<button id="btn-back-to-list" class="btn-back">목록으로 돌아가기</button>
						</div>
						<div class="editor-panel">
							<div class="form-group">
								<label for="notice-title">제목</label> <input type="text"
									id="notice-title" placeholder="제목을 입력하세요">
							</div>
							<div class="form-group full-width">
								<label for="notice-content">내용</label>
								<textarea id="notice-content" placeholder="내용을 입력하세요."></textarea>
							</div>
							<div class="crud-actions">
								<button id="btn-delete-notice" class="action-btn-danger"
									style="display: none;">삭제하기</button>
								<button id="btn-save-notice" class="action-btn-primary">저장하기</button>
							</div>
						</div>
					</div>

					<div class="bodyArea" id="post-management" style="display: none;">
						<div class="toolbar">
							<h1>게시물 관리 (자유게시판)</h1>
						</div>

						<div class="list-container">
							<table class="data-table" id="post-management-list">
								<thead>
									<tr>
										<th style="width: 10%;">번호</th>
										<th style="width: 45%;">제목</th>
										<th style="width: 15%;">작성자(MemNo)</th>
										<th style="width: 20%;">작성일</th>
										<th style="width: 10%;">관리</th>
									</tr>
								</thead>
								<tbody>
									<tr>
										<td colspan="5" style="text-align: center; padding: 40px;">게시물
											목록을 로드하는 중...</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>


					<div class="bodyArea" id="review-management">

						<div class="review-main-content">
							<div class="review-list-container" id="admin-review-list">
								<table class="review-list-table">
									<thead>
										<tr>
											<th class="sortable" data-sort-key="boardTitle">리뷰 제목 <span
												class="sort-icon"></span></th>
											<th class="sortable" data-sort-key="nickname">작성자 <span
												class="sort-icon"></span></th>
											<th class="sortable" data-sort-key="stars">별점 <span
												class="sort-icon"></span></th>
											<th class="sortable" data-sort-key="hasImage">사진 <span
												class="sort-icon"></span></th>
											<th class="sortable" data-sort-key="adminReply">관리자 댓글 <span
												class="sort-icon"></span></th>
											<th class="sortable" data-sort-key="createdDate">작성일 <span
												class="sort-icon"></span></th>
										</tr>
									</thead>
									<tbody>
									</tbody>
								</table>
							</div>

							<div class="review-detail-container">
								<div class="review-detail-placeholder">
									<p>
										왼쪽 목록에서 리뷰를 더블클릭하여<br>상세 정보를 확인하세요.
									</p>
								</div>

								<%-- ▼▼▼ (수정) 버튼(crud-actions)이 view 밖으로 이동된 올바른 구조 ▼▼▼ --%>
								<div class="review-detail-content" style="display: none;">

									<div class="review-detail-view">
										<h3 id="detail-review-title" class="review-card-title"></h3>

										<div class="review-card-meta-list">
											<div class="meta-item">
												<span class="meta-label">닉네임</span> <span
													id="detail-review-nickname" class="meta-value"></span>
											</div>
											<div class="meta-item">
												<span class="meta-label">작성일</span> <span
													id="detail-review-date" class="meta-value"></span>
											</div>
											<div class="meta-item">
												<span class="meta-label">별점</span> <span
													id="detail-review-stars"
													class="meta-value review-card-stars"></span>
											</div>
										</div>

										<div class="review-card-body">
											<p id="detail-review-content"></p>
											<div id="detail-review-image"
												class="review-card-image-wrapper"></div>
										</div>

										<div class="review-crud-panel">
											<h3>관리</h3>
											<div class="review-admin-box">
												<div class="form-group">
													<label for="admin-reply-textarea">관리자 댓글 (작성일: <span
														id="admin-reply-date"></span>)
													</label>
													<textarea id="admin-reply-textarea"
														placeholder="관리자 댓글을 입력하거나 수정하세요."></textarea>
												</div>
											</div>
										</div>
									</div>


									<div class="crud-actions">

										<button class="action-btn primary" data-action="save-reply">댓글
											저장</button>
										<button class="action-btn secondary"
											data-action="delete-image">이미지 삭제</button>
										<button class="action-btn danger" data-action="delete-review">리뷰
											삭제</button>
									</div>
								</div>
							</div>
						</div>
					</div>


					<div class="bodyArea" id="stats-main">데이터/통계</div>
			</main>
		</div>
	</div>

	<div id="review-image-modal" class="image-modal-overlay"
		style="display: none;">
		<span class="image-modal-close">&times;</span> <img
			class="image-modal-content" id="modal-image-src">
	</div>


	<%@ page import="com.our_middle_project.dto.UserInfoDTO"%>
	<%
	UserInfoDTO admin = (UserInfoDTO) session.getAttribute("loginAdmin");
	String adminName = "관리자";
	String adminId = "";
	String adminNickname = "";
	if (admin != null) {
		adminName = admin.getMem_name();
		adminId = admin.getMem_id();
		adminNickname = admin.getNickname();
	}
	%>
	<script type="text/javascript">
      
		const ADMIN_DATA = {
			name: "<%=adminName%>",
            id: "<%=adminId%>",
			nickname: "<%=adminNickname%>"
		};
		console.log(ADMIN_DATA);
	</script>

	<!-- <script type="text/javascript">
		(function() {

			document.addEventListener('keydown', function(e) {
				if (e.key === 'F5' || (e.ctrlKey && e.key === 'r')
						|| (e.ctrlKey && e.key === 'R')) {
					e.preventDefault();

					Swal.fire({
						icon : 'error',
						title : '새로고침 금지',
						text : '이 페이지에서는 새로고침을 사용할 수 없습니다.',
					});
				}
			});

			window.addEventListener('pageshow', function(event) {
				if (event.persisted) {
					window.location.reload();
				}
			});
		})();
	</script> -->




	<script
		src="${pageContext.request.contextPath}/js/lib/axios/axios.min.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
	<script>
		const CONTEXT_PATH = "${pageContext.request.contextPath}";
	</script>

	<script src="${pageContext.request.contextPath}/js/common.js"></script>
	<script src="${pageContext.request.contextPath}/js/admin/api-client.js"></script>
	<script
		src="${pageContext.request.contextPath}/js/admin/page-dashboard.js"></script>
	<script src="${pageContext.request.contextPath}/js/admin/page-user.js"></script>
	<script
		src="${pageContext.request.contextPath}/js/admin/page-notice.js"></script>
	<script src="${pageContext.request.contextPath}/js/admin/page-post.js"></script>
	<script src="${pageContext.request.contextPath}/js/admin/page-stats.js"></script>
	<script src="${pageContext.request.contextPath}/js/admin/admin-core.js"></script>
	<script src="${pageContext.request.contextPath}/js/admin/admin-main.js"></script>
	<script
		src="${pageContext.request.contextPath}/js/admin/page-review.js"></script>




</body>
</html>