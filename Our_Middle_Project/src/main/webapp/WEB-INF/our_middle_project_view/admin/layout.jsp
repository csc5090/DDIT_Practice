<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Good Day, Commander.</title>

<%-- 라이브러리 CSS --%>
<link rel="stylesheet"
	href="<%=request.getContextPath()%>/js/lib/bootstrap/css/bootstrap.min.css">
<link rel="stylesheet"
	href="<%=request.getContextPath()%>/js/lib/sweetalert2/dist/sweetalert2.min.css">

<%-- 공통 CSS --%>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/admin/admin_common.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/admin/admin_layout.css">

<%-- 페이지별 CSS --%>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/admin/admin_dashboard.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/admin/admin_user_management.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/admin/admin_notice.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/admin/admin_review.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/admin/admin_post.css">


</head>
<body>
	<div id="admin-wrapper">
		<nav class="sidearea">
			<%-- ... (로고, 사이드바 메뉴) ... --%>
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
				<%-- ... (유저 프로필 드롭다운) ... --%>
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
				<%-- ================= 대시보드 ================= --%>
				<div class="bodyArea active" id="dashboard-main">
					<%-- ... (대시보드 HTML) ... --%>
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

				<%-- ================= 유저 관리 ================= --%>
				<div class="bodyArea" id="user-management">
					<%-- ... (유저 관리 HTML) ... --%>
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
											data-sort-order="none">아이디 <span class="sort-icon"></span></th>
										<th class="sortable" data-sort-key="userName"
											data-sort-order="none">이름 <span class="sort-icon"></span></th>
										<th class="sortable" data-sort-key="nickname"
											data-sort-order="none">닉네임 <span class="sort-icon"></span></th>
										<th class="sortable" data-sort-key="status"
											data-sort-order="none">상태 <span class="sort-icon"></span></th>
										<th class="sortable" data-sort-key="regDate">가입일 <span
											class="sort-icon"></span></th>
									</tr>
								</thead>
								<tbody id="user-list-tbody"></tbody>
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
										id="detail-status"><option value="ACTIVE">ACTIVE</option>
										<option value="SUSPENDED">SUSPENDED</option>
										<option value="DELETED">DELETED</option></select>
								</div>
								<div class="form-group">
									<label for="detail-role">역할 (ROLE)</label> <select
										id="detail-role"><option value="USER">USER</option>
										<option value="ADMIN">ADMIN</option></select>
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

				<%-- ================= 공지사항 관리 ================= --%>

				<div class="bodyArea" id="notice-management">

				    <%-- 1. 왼쪽: 목록 패널 --%>
				    <div class="user-list-panel">
				        <div class="list-toolbar">
				            <%-- '새 글 작성' 버튼을 list-toolbar로 이동 --%>
				            <button id="notice-new-btn" class="action-btn primary">새 공지사항 작성</button>
				        </div>

				        <div class="user-list-wrapper">
				            <%-- user-list-table 클래스 적용 --%>
				            <table class="user-list-table">
								<thead>
												                    <tr>
												                       
												                        <th class="sortable" data-sort-key="board_title" data-sort-order="none" style="width: 60%;">
												                        	제목 <span class="sort-icon"></span>
												                        </th>
												                        
												                        <th style="width: 15%;">작성자</th>
												                        
												                        
												                        <th class="sortable" data-sort-key="created_date" data-sort-order="none" style="width: 25%;">
												                        	작성일 <span class="sort-icon"></span>
												                        </th>
												                    </tr>
												                </thead>
				                <tbody id="notice-list-tbody">
				                    <%-- JS로 채워짐 --%>
				                </tbody>
				            </table>
				        </div>
				    </div>

				    <%-- 2. 오른쪽: 상세정보/편집 패널 --%>
				    <div class="user-detail-panel">
				        <div class="detail-content">
				            <%-- 헤더 (user-management 템플릿 적용) --%>
				            <div class="detail-header">
				                <h2 id="detail-notice-header"></h2>
				                <p class="header-guideline">편집할 공지사항을 더블클릭하세요.</p>
				            </div>

				            <%-- 상세정보 폼 (user-management 템플릿 적용) --%>
				            <div class="detail-body">
				                <div class="form-group full-width">
				                    <label for="notice-title">제목</label>
				                    <input type="text" id="notice-title" placeholder="제목을 입력하세요">
				                </div>
				                <div class="form-group full-width" style="flex: 1; display: flex; flex-direction: column;">
				                    <label for="notice-content">내용</label>
				                    <%-- CSS에서 높이를 제어할 수 있도록 style="flex: 1;" 추가 --%>
				                    <textarea id="notice-content" placeholder="내용을 입력하세요." style="flex: 1; resize: none;"></textarea>
				                </div>
				            </div>

				            <%-- 하단 버튼 (user-management 템플릿 적용) --%>
				            <div class="detail-footer">
				                <button id="notice-cancel-btn" class="action-btn secondary">취소</button>
				                <button id="notice-delete-btn" class="action-btn danger" style="display: none;">삭제하기</button>
				                <button id="notice-save-btn" class="action-btn primary">저장하기</button>
				            </div>
				        </div>
				    </div>

				</div>

				<%-- ================= 게시물 관리 ================= --%>

				<div class="bodyArea" id="post-management">

					<%-- 1. 왼쪽: 목록 패널 --%>
					<div class="user-list-panel">
						<div class="list-toolbar">
							<div class="search-bar">
								<input type="text" id="post-search-input"
									placeholder="게시물 제목으로 검색">
								<button id="post-search-btn" class="action-btn primary">검색</button>
							</div>
						</div>

						<div class="user-list-wrapper">
							<table class="user-list-table">
								<thead>
									<tr>
										<th class="sortable" data-sort-key="board_no"
											style="width: 10%;">번호 <span class="sort-icon"></span></th>
										<th class="sortable" data-sort-key="board_title"
											style="width: 40%;">제목 <span class="sort-icon"></span></th>
										<th class="sortable" data-sort-key="nickname"
											style="width: 20%;">작성자 <span class="sort-icon"></span></th>
										<th class="sortable" data-sort-key="created_date"
											style="width: 20%;">작성일 <span class="sort-icon">▼</span></th>
										<th class="sortable" data-sort-key="comment_count"
											style="width: 10%;">댓글<span class="sort-icon"></span></th>
									</tr>
								</thead>
								<tbody id="post-list-tbody">
									<%-- JS로 채워짐 --%>
								</tbody>
							</table>
						</div>
					</div>

					<%-- 2. 오른쪽: 상세정보/댓글 패널 --%>
					<div class="user-detail-panel">
						<div class="detail-content">
							<div class="detail-header">
								<h2 id="detail-post-id"></h2>
								<p class="header-guideline">편집할 게시물을 더블클릭하세요.</p>
							</div>

							<%-- 2-1. 상세정보 폼 --%>
							<div class="detail-body">
								<div class="form-group full-width">
									<label for="detail-post-title">제목</label> <input type="text"
										id="detail-post-title" readonly>
								</div>
								<div class="form-group full-width">
									<label for="detail-post-content">내용</label>
									<textarea id="detail-post-content"
										style="height: 250px; resize: vertical;" readonly></textarea>
								</div>

								<%-- 2-2. 댓글 영역 (추가) --%>
								<div class="form-group full-width">
									<label>댓글 관리</label>
									<div class="post-comment-wrapper">
										<div class="post-comment-list" id="post-comment-list">
											<%-- JS로 댓글 목록이 채워질 영역 --%>
											<div class="comment-placeholder">게시물을 선택하면 댓글이 표시됩니다.</div>
										</div>
									</div>
								</div>
							</div>

							<%-- 2-3. 하단 버튼 --%>
							<div class="detail-footer">
								<button id="detail-post-apply-btn" class="action-btn primary">적용</button>
								<button id="detail-post-deactivate-btn"
									class="action-btn restore">비활성화</button>
								<button id="detail-post-hard-delete-btn"
									class="action-btn danger">완전 삭제</button>
							</div>
						</div>
					</div>
				</div>

				<%-- ================= 리뷰 관리 ================= --%>
				<div class="bodyArea" id="review-management">

					<%-- 1. 왼쪽: 목록 패널 --%>
					<div class="user-list-panel">
						<div class="list-toolbar">
							<div class="search-bar">
								<input type="text" id="review-search-input"
									placeholder="리뷰 제목 또는 닉네임으로 검색">
								<button id="review-search-btn" class="action-btn primary">검색</button>
							</div>
						</div>
						<div class="user-list-wrapper">
							<table class="review-list-table" id="admin-review-list-table">
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
											class="sort-icon"></span>
										</th>
										<th class="sortable" data-sort-key="createdDate">작성일 <span
											class="sort-icon"></span></th>
									</tr>
								</thead>
								<tbody id="admin-review-list-tbody">
									<%-- JS로 채워짐 --%>
								</tbody>
							</table>
						</div>
					</div>

					<%-- 2. 오른쪽: 상세정보 패널 --%>
					<div class="user-detail-panel">
						<div class="detail-content" id="review-detail-content-area">
							<%-- [수정] JS가 이 헤더에 'user-selected' 클래스를 추가/제거합니다 --%>
							<div class="detail-header">
								<h2 id="detail-review-selected-title"></h2>
								<p class="header-guideline" id="review-detail-placeholder">
									편집할 리뷰를 더블클릭하세요.</p>
							</div>

							<div class="detail-body" id="review-detail-body">

								<div class="form-group">
									<label for="detail-review-nickname-input">닉네임</label> <input
										type="text" id="detail-review-nickname-input" readonly>
								</div>

								<div class="form-group">
									<label for="detail-review-date-input">작성일</label> <input
										type="text" id="detail-review-date-input" readonly>
								</div>

								<div class="form-group">
									<label for="detail-review-stars-input">별점</label> <input
										type="text" id="detail-review-stars-input" readonly>
								</div>

								<div class="form-group">
									<label>리뷰 이미지</label>
									<div id="detail-review-image-display"
										class="review-image-placeholder">
										<span>-</span>
									</div>
								</div>

								<div class="form-group full-width">
									<label for="detail-review-content-textarea">내용</label>
									<textarea id="detail-review-content-textarea"
										style="height: 150px; resize: vertical;" readonly></textarea>
								</div>

								<div class="form-group full-width">
									<label for="admin-reply-textarea">관리자 댓글 (작성일: <span
										id="admin-reply-date">미작성</span>)
									</label>
									<div class="post-comment-wrapper" style="height: 150px;">
										<textarea id="admin-reply-textarea"
											placeholder="관리자 댓글을 입력하거나 수정하세요."
											style="height: 100%; resize: none;"></textarea>
									</div>
								</div>
							</div>

							<div class="detail-footer" id="review-detail-footer"
								style="display: none;">
								<button class="action-btn primary" data-action="save-reply">댓글
									저장</button>
								<button class="action-btn secondary" data-action="delete-image">이미지
									삭제</button>
								<button class="action-btn danger" data-action="delete-review">리뷰
									삭제</button>
							</div>
						</div>
					</div>
				</div>

				<%-- ================= 데이터/통계 ================= --%>
				<div class="bodyArea" id="stats-main">데이터/통계</div>
			</main>
		</div>
	</div>

	<%-- ... (모달, ADMIN_DATA 스크립트) ... --%>
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

	// JS 특수 문자 이스케이프
	adminName = adminName.replace("\\", "\\\\").replace("\"", "\\\"").replace("\r", "\\r").replace("\n", "\\n");
	adminId = (adminId != null)
			? adminId.replace("\\", "\\\\").replace("\"", "\\\"").replace("\r", "\\r").replace("\n", "\\n")
			: "";
	adminNickname = (adminNickname != null)
			? adminNickname.replace("\\", "\\\\").replace("\"", "\\\"").replace("\r", "\\r").replace("\n", "\\n")
			: "";
	%>

	<!-- 따옴표 구간 -->
	<script type="text/javascript">
		const ADMIN_DATA = {
			name: "<%=adminName%>",
            id: "<%=adminId%>",
			nickname: "<%=adminNickname%>"
		};

		console.log(ADMIN_DATA);
	</script>

	<%-- F5/뒤로가기 차단 스크립트--%>
	<%--
    <script type="text/javascript">
        (function() {
            document.addEventListener('keydown', function(e) {
                if (e.key === 'F5' || (e.ctrlKey && e.key === 'r') || (e.ctrlKey && e.key === 'R')) {
                    e.preventDefault();
                    Swal.fire({
                        icon : 'error',
                        title : '새로고침 금지',
                        text : '이 페이지에서는 새로고침을 사용할 수 없습니다.',
                    });
                }
            });
        })();
    </script>
    --%>

	<%-- 라이브러리 JS --%>
	<script
		src="${pageContext.request.contextPath}/js/lib/axios/axios.min.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
	<script
		src="${pageContext.request.contextPath}/js/lib/jquery/jquery-3.7.1.min.js"></script>
	<script
		src="<%=request.getContextPath()%>/js/lib/bootstrap/js/bootstrap.min.js"></script>
	<script
		src="<%=request.getContextPath()%>/js/lib/sweetalert2/dist/sweetalert2.min.js"></script>

	<%-- 공통 스크립트 --%>
	<script>
		const CONTEXT_PATH = "${pageContext.request.contextPath}";
	</script>
	<script src="${pageContext.request.contextPath}/js/common.js"></script>
	<script src="${pageContext.request.contextPath}/js/admin/api-client.js"></script>

	<%-- 페이지별 스크립트 --%>
	<script
		src="${pageContext.request.contextPath}/js/admin/page-dashboard.js"></script>
	<script src="${pageContext.request.contextPath}/js/admin/page-user.js"></script>
	<script
		src="${pageContext.request.contextPath}/js/admin/page-notice.js"></script>
	<script src="${pageContext.request.contextPath}/js/admin/page-post.js"></script>
	<script
		src="${pageContext.request.contextPath}/js/admin/page-review.js"></script>
	<script src="${pageContext.request.contextPath}/js/admin/page-stats.js"></script>

	<%-- 메인 스크립트 (가장 마지막에) --%>
	<script src="${pageContext.request.contextPath}/js/admin/admin-core.js"></script>
	<script src="${pageContext.request.contextPath}/js/admin/admin-main.js"></script>

</body>
</html>