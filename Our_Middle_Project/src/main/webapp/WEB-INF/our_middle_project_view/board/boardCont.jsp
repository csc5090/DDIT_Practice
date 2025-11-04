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




<link rel="stylesheet"href="./css/board/boardCont.css">


<!-- ==================================================================================== -->
<body>
<div class="container">

        <h1 class="neon-text title">⭐ 내 용 ⭐</h1>


        <%-- String boardNum = request.getParameter("id"); --%>
        <%-- BoardVO board = boardService.getPost(boardNum); --%>

        <div class="post-detail-box">
            <div class="detail-header">
                <h2 class="neon-text-small post-title-detail">
                    <span class="detail-label">[제목]</span> ${board.title} [CSS 네온 효과 적용 예시] 
                </h2>
            </div>
            
            <div class="detail-info">
                <span>작성자: User123</span> |
                <span>작성일: 2025.11.02</span> |
                <span>조회수: 122</span>
            </div>

            <div class="detail-content">
                <p>
                    안녕하세요. 네온 컨셉 게시판 상세 내용 페이지입니다. <br><br>
                    이 영역은 실제 게시물이 담고 있는 내용(Content)이 출력되는 부분입니다. <br>
                    배경색과 폰트색을 조정하여 어두운 컨셉을 유지하고 있습니다. <br><br>
                    게시판 번호: ${board.boardNum}
                </p>
            </div>
        </div>
        
        <div class="detail-actions">
            <button class="neon-button" onclick="goToEditPage(${board.boardNum})">수정</button>
            <button class="neon-button" onclick="deletePost(${board.boardNum})">삭제</button>
            <button class="neon-button right-align-btn" onclick="goToList()">목록</button>
        </div>

    </div>
	
<!-- ==================================================================================== -->
<script type="text/javascript" src="./js/board/boardCont.js"></script>
<script type="text/javascript" src="./js/common.js"></script>

</body>
</html>