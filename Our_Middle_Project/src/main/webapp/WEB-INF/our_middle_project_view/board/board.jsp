<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Board</title>
</head>

<link rel="stylesheet"
	href="<%=request.getContextPath()%>/js/lib/bootstrap/css/bootstrap.min.css">
<script type="text/javascript"
	src="<%=request.getContextPath()%>/js/lib/bootstrap/js/bootstrap.min.js"></script>

<!-- 스위트어럴트2 -->
<link rel="stylesheet"
	href="<%=request.getContextPath()%>/js/lib/sweetalert2/dist/sweetalert2.min.css">
<script type="text/javascript"
	src="<%=request.getContextPath()%>/js/lib/sweetalert2/dist/sweetalert2.min.js"></script>

<!-- jquery -->
<script type="text/javascript"
	src="<%=request.getContextPath()%>/js/lib/jquery/jquery-3.7.1.min.js"></script>

<!-- axios -->
<script type="text/javascript"
	src="<%=request.getContextPath()%>/js/lib/axios/axios.min.js"></script>

<link rel="stylesheet" href="./css/board/board.css">
<script src="https://unpkg.com/lucide@latest"></script>
<!-- 홈 이모티콘 -->
<link rel="stylesheet" href="./css/fonts.css">

<!-- ==================================================================================== -->
<body>
	<div class="header">
	
		<div id="nickname">
			<span class="nick"> 
				<c:out value="${sessionScope.loginUser.nickname}#${sessionScope.loginUser.mem_id}" />
			</span>
		</div>

		<div class="home-button-container">
			<button id="homeBtn" class="home-button">
				<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" data-lucide="home" class="lucide lucide-home">
					<path d="M15 21v-8a1 1 0 0 0-1-1h-4a1 1 0 0 0-1 1v8"></path>
					<path d="M3 10a2 2 0 0 1 .709-1.528l7-6a2 2 0 0 1 2.582 0l7 6A2 2 0 0 1 21 10v9a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path>
				</svg>
			</button>
		</div>
		
	</div>

	<div class="container">

		<h1 class="neon-text title">게시판</h1>

		<div class="board-header">
			<button class="neon-button" onclick="goToWritePage()">글쓰기</button>
		</div>

		<table class="board-table">
			<thead id="boardTableHead">
				<tr>
					<th class="neon-text-small">번호</th>
					<th class="neon-text-small">제목</th>
					<th class="neon-text-small">작성자</th>
					<th class="neon-text-small">작성일</th>
					<th class="neon-text-small">조회수</th>
				</tr>
			</thead>
			<tbody id="boardTableBody">
			</tbody>
		</table>

		<div class="footer">

			<div class="search-area">
				<input type="text" id="searchInput" class="neon-input" size="16" placeholder="제목 검색">

				<button class="neon-button" onclick="searchPosts()">검색</button>
			</div>

		</div>
	</div>

	<!-- ==================================================================================== -->
	<%@ page import="com.google.gson.Gson"%>
	<%@ page import="com.our_middle_project.dto.UserInfoDTO"%>

	<%
	    Gson gson = new Gson();
	    UserInfoDTO user = (UserInfoDTO) session.getAttribute("loginUser");
	    String userJson = gson.toJson(user);
	%>

	<script type="text/javascript">
		const userDataCase = JSON.parse('<%= userJson %>');
		console.log(userDataCase);
	</script>

	<script type="text/javascript" src="./js/common.js"></script>
	<script type="text/javascript" src="./js/board/board.js"></script>


</body>
</html>