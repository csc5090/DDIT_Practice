<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Board</title>
<link rel="stylesheet" href="<%=request.getContextPath()%>/js/lib/bootstrap/css/bootstrap.min.css">
</head>


	<script type="text/javascript" src="<%=request.getContextPath()%>/js/lib/bootstrap/js/bootstrap.min.js"></script>
	
	<!-- 스위트어럴트2 -->
	<link rel="stylesheet" href="<%=request.getContextPath()%>/js/lib/sweetalert2/dist/sweetalert2.min.css">
	<script type="text/javascript" src="<%=request.getContextPath()%>/js/lib/sweetalert2/dist/sweetalert2.min.js"></script>
	
	<!-- jquery -->
	<script type="text/javascript" src="<%=request.getContextPath()%>/js/lib/jquery/jquery-3.7.1.min.js"></script>
	
	<!-- axios -->
	<script type="text/javascript" src="<%=request.getContextPath()%>/js/lib/axios/axios.min.js"></script>




<link rel="stylesheet"href="./css/board/boardEdit.css">


<!-- ==================================================================================== -->
<body>

<div class="container">
    <h1 class="neon-text title">⭐ 게시물 수정 ⭐</h1>

    <form id="editForm" action="<%=request.getContextPath()%>/boardEdit.do?state=submit" method="post">
    
        <input type="hidden" name="boardNo" value="${b.boardNo}">

        <div class="form-group">
		    <label for="title" class="neon-text-small">제목</label>
		
		    <div style="display:flex;align-items:center;gap:6px;">
		        <span class="category-tag">[자유]</span>
		        <input type="text" id="title" name="boardTitle"
		               class="neon-input"
		               value="${empty b.boardTitle ? '' : fn:replace(b.boardTitle,'[자유]','')}"
		               required>
		    </div>
		</div>

        <div class="form-group">
            <label for="writer" class="neon-text-small">작성자</label>
            <input type="text" id="writer" name="memId" class="neon-input" 
                   value="${b.memId}" readonly>
        </div>

        <div class="form-group">
            <label for="content" class="neon-text-small">내용</label>
            <textarea id="content" name="boardContent" class="neon-textarea" required>${b.boardContent}</textarea>
        </div>

        <div class="write-actions">
            <button type="submit" class="neon-button edit-btn">수정 완료</button>
            <button type="button" class="neon-button cancel-btn" onclick="goBack()">취소</button>
        </div>            

    </form>  <!-- ← 이렇게 form 닫아야함 -->

</div> <!-- container 닫기 -->



	
<!-- ==================================================================================== -->
	<%@ page import="com.google.gson.Gson" %>
	<%@ page import="com.our_middle_project.dto.UserInfoDTO" %>
	
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
<script type="text/javascript" src="./js/board/boardEdit.js"></script>


</body>
</html>