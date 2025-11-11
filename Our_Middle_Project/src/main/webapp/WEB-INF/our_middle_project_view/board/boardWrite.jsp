<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>


<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Board</title>
<link rel="stylesheet"
	href="<%=request.getContextPath()%>/js/lib/bootstrap/css/bootstrap.min.css">
</head>


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

<link rel="stylesheet" href="./css/board/boardWrite.css">
<link rel="stylesheet" href="./css/fonts.css">

<!-- ==================================================================================== -->
<body>

	<div class="c_container">

		<div class="neon-text title">New Write</div>

		<form id="writeForm" action="boardWrite.do" method="post">
			<input type="hidden" name="state" value="submit">
			<div class="write-box">
				<div class="form-group">
					<label for="title" class="neon-text-small">제목</label> <input
						type="text" id="title" name="title" class="neon-input"
						placeholder="[자유] 게시물 제목을 입력하세요" required>
				</div>

				<div class="form-group">
					<label for="writer" class="neon-text-small">작성자</label> <input
						type="text" id="writer" name="writer" class="neon-input"
						value="${sessionScope.loginUser.mem_id != null ? sessionScope.loginUser.mem_id : ''}"
						readonly>
				</div>

				<div class="form-group">
					<label for="content" class="neon-text-small">내용</label>
					<textarea style="height: 250px;" id="content" name="content" class="neon-textarea"
						placeholder="게시물 내용을 입력하세요." required></textarea>
				</div>


			</div>

		</form>
		
		<div class="write-actions">
			<button type="submit" class="neon-button"
				onclick="return validateWrite()">등록</button>
			<button type="button" class="neon-button right-align-btn"
				onclick="goBack()">취소</button>
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
	<script type="text/javascript" src="./js/board/boardWrite.js"></script>

</body>
</html>