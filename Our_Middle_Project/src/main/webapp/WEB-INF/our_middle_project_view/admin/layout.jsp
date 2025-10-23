<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>게임 관리자 페이지</title>

<link rel="stylesheet" href="${pageContext.request.contextPath}/js/lib/bootstrap/css/bootstrap.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/js/lib/sweetalert2/dist/sweetalert2.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/CSC/admin_common.css">
</head>
<body>
	<div class="d-flex">
		<nav class="sidebar bg-dark text-white p-3">
			<h2>관리 메뉴</h2>
			<ul class="nav flex-column">
				<li class="nav-item"><a class="nav-link text-white"
					href="/Our_Middle_Project/adminMain.do">대시보드</a></li>
				<li class="nav-item"><a class="nav-link text-white"
					href="/Our_Middle_Project/adminUserList.do">회원 관리</a></li>
				<li class="nav-item"><a class="nav-link text-white"
					href="/Our_Middle_Project/adminBoardList.do">게시판 관리</a></li>
				<li class="nav-item"><a class="nav-link text-white"
					href="/Our_Middle_Project/adminGame.do">게임 관리</a></li>
				<li class="nav-item"><a class="nav-link text-white"
					href="/Our_Middle_Project/adminLogs.do">로그 관리</a></li>
			</ul>
		</nav>

		<main class="main-content flex-grow-1 p-4">
			<jsp:include page="${viewPage}" />
		</main>
	</div>

	<script
		src="${pageContext.request.contextPath}/js/lib/bootstrap/js/bootstrap.bundle.min.js"></script>
	<script
		src="${pageContext.request.contextPath}/js/lib/sweetalert2/dist/sweetalert2.all.min.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</body>
</html>