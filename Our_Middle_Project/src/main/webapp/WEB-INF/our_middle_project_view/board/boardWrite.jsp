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

<link rel="stylesheet"href="./css/board/boardWrite.css">

<!-- ==================================================================================== -->
<body>

<div class="container">
	
       <h1 class="neon-text title">⭐ 새 글 작성 ⭐</h1>

       <form id="writeForm" action="writeAction.jsp" method="post">
           <div class="write-box">
               <div class="form-group">
                   <label for="title" class="neon-text-small">제목</label>
                   <input type="text" id="title" name="title" class="neon-input" 
                          placeholder="게시물 제목을 입력하세요" required>
               </div>
               
               <div class="form-group">
                   <label for="writer" class="neon-text-small">작성자</label>
                   <input type="text" id="writer" name="writer" class="neon-input" 
                          placeholder="작성자를 입력하세요" required>
               </div>

               <div class="form-group">
                   <label for="content" class="neon-text-small">내용</label>
                   <textarea id="content" name="content" class="neon-textarea" 
                             placeholder="게시물 내용을 입력하세요." required></textarea>
               </div>
               
               <div class="form-group">
                   <label for="password" class="neon-text-small">비밀번호 (수정/삭제 시 필요)</label>
                   <input type="password" id="password" name="password" class="neon-input" 
                          placeholder="비밀번호를 입력하세요" required>
               </div>
           </div>
           
           <div class="write-actions">
               <button type="submit" class="neon-button" onclick="return validateWrite()">등록</button>
               <button type="button" class="neon-button right-align-btn" onclick="goBack()">취소</button>
           </div>
       </form>

   </div>

<!-- ==================================================================================== -->
<script type="text/javascript" src="./js/board/boardWrite.js"></script>

</body>
</html>