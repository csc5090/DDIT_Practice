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
			<div class="ul-wrapper">
				<ul class="nav-container">
					<li class="nav-big-area">
						<div class="bigmenu-container">
							<span class="span-big"> 대시보드 </span>
						</div>
					</li>

					<li class="nav-big-area">
						<div class="bigmenu-container">
							<span class="span-big"> 사용자 </span>
						</div>

						<div class="ul-container">
							<ul class="ul-small-container">
								<li><span class="span-small">목록 조회</span></li>
								<li><span class="span-small">권한 관리</span></li>
								<li><span class="span-small">닉네임 변경</span></li>
								<li><span class="span-small">차단 관리</span></li>
							</ul>
						</div>
					</li>

					<li class="nav-big-area">
						<div class="bigmenu-container">
							<span class="span-big"> 채팅 </span>
						</div>

						<div class="ul-conatainer">
							<ul class="ul-small-container">
								<li><span class="span-small"> 채팅 관리 </span></li>
							</ul>
						</div>
					</li>

					<li class="nav-big-area">
						<div class="bigmenu-container">
							<span class="span-big"> 게시판 </span>
						</div>

						<div class="ul-conatainer">
							<ul class="ul-small-container">
								<li><span class="span-small"> 공지사항 관리 </span>
								<li><span class="span-small"> 게시물 관리 </span>
							</ul>
						</div>
					</li>

					<li class="nav-big-area">
						<div class="bigmenu-container">
							<span class="span-big"> 게임 </span>
						</div>

						<div class="ul-container">
							<ul class="ul-small-container">
								<li><span class="span-small"> 게임 관리 </span>
								<li><span class="span-small"> 이벤트 관리 </span>
							</ul>
						</div>
					</li>

					<li class="nav-big-area">
						<div class="bigmenu-container">
							<span class="span-big"> 데이터/통계 </span>
						</div>
					</li>
				</ul>
			</div>

			<div class="nav-settings">
				<div
					class="bigmenu-container ${activeMenu eq 'settings' ? 'active' : ''}">
					<span class="span-big"> 설정 </span>
				</div>
			</div>

		</nav>

		<section class="content-body">
			<jsp:include page="${viewPage}" />
		</section>

	</div>




</body>
</html>