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

    <form id="editForm" action="boardEdit.do?state=submit" method="post" onsubmit="return validateEdit()">
    
        	<!-- 게시물 번호 -->
        <input type="hidden" name="boardNo" value="${b.boardNo}">
        
         	<!-- 제목 -->
        <div class="form-group">
            <label for="title" class="neon-text-small">제목</label>
            <input type="text" id="title" name="boardTitle" class="neon-input"
                   value="${b.boardTitle}" required>
        </div>
            
            <!-- 작성자 (읽기전용) -->
        <div class="form-group">
            <label for="writer" class="neon-text-small">작성자</label>
            <input type="text" id="writer" name="memId" class="neon-input" 
                   value="${b.memId}" readonly>
        </div>

             <!-- 내용 -->
        <div class="form-group">
            <label for="content" class="neon-text-small">내용</label>
            <textarea id="content" name="boardContent" class="neon-textarea" required>${b.boardContent}</textarea>
        </div>
            
           
        </div>
        
        	<!-- 버튼 -->
        <div class="write-actions">
            <button type="submit" class="neon-button">수정 완료</button>
            <button type="button" class="neon-button right-align-btn" onclick="goBack()">취소</button>
        </div>
        
    </form>
</div>


	
<!-- ==================================================================================== -->
<script type="text/javascript" src="./js/board/boardEdit.js"></script>
<script type="text/javascript" src="./js/common.js"></script>


</body>
</html>