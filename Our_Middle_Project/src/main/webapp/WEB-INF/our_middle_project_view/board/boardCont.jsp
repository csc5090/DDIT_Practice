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




<link rel="stylesheet" href="<%=request.getContextPath()%>/css/board/boardCont.css">


<!-- ==================================================================================== -->
<body>
<div class="container">

        <h1 class="neon-text title">⭐ 내 용 ⭐</h1>

        <%-- String boardNum = request.getParameter("id"); --%>
        <%-- BoardVO board = boardService.getPost(boardNum); --%>

        <div class="post-detail-box">
            <div class="detail-header">
                <h2 class="neon-text-small post-title-detail">
                    <span class="detail-label">[제목]</span> ${b.boardTitle}
                </h2>
            </div>
            
            <div class="detail-info">
                <span>작성자: ${b.memId}</span> |
                <span>작성일: ${b.createdDate}</span> |
       			<span>조회수: ${b.viewCount}</span>
            </div>

            <div class="detail-content">
                <p>
                 	<c:out value="${fn:replace(b.boardContent, '
									', '<br/>')}" escapeXml="false"/>
                </p>
            </div>
        </div>
        
        <div class="detail-actions">
            <button class="neon-button" onclick="goToEditPage('${b.boardNo}')">수정</button>
            <button class="neon-button" onclick="deletePost(${b.boardNo})">삭제</button>
			<button class="neon-button right-align-btn" onclick="goToList()">목록</button>
        </div>

    </div>
	
<!-- ==================================================================================== -->
<script src="<%=request.getContextPath()%>/js/board/boardCont.js"></script>
<script src="<%=request.getContextPath()%>/js/common.js"></script>

</body>
</html>