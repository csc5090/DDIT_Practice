<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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




<link rel="stylesheet"href="./css/board/board.css">


<!-- ==================================================================================== -->
<body>
<div class="container">
        <h1 class="neon-text title">⭐ NEON BOARD ⭐</h1>
        
        <div class="board-header">
          	 <button class="neon-button" onclick="goToWritePage()">글쓰기</button>
        </div>

        <table class="board-table">
            <thead>
                <tr>
                    <th class="neon-text-small">번호</th>
                    <th class="neon-text-small">제목</th>
                    <th class="neon-text-small">작성자</th>
                    <th class="neon-text-small">작성일</th>
                    <th class="neon-text-small">조회수</th>
                </tr>
            </thead>
            <tbody>
               
                <tr class="board-row" onclick="viewPost(1)">
                    <td>1</td>
                    <td class="post-title">네온 컨셉 게시판을 만들었어요!</td>
                    <td>관리자</td>
                    <td>2025.11.03</td>
                    <td>811</td>
                </tr>
                
                <tr class="board-row" onclick="viewPost(2)">
                    <td>2</td>
                    <td class="post-title">CSS 네온 효과 적용 예시</td>
                    <td>User123</td>
                    <td>2025.11.02</td>
                    <td>122</td>
                </tr>
                <tr class="board-row" onclick="viewPost(2)">
                    <td>2</td>
                    <td class="post-title">CSS 네온 효과 적용 예시</td>
                    <td>User123</td>
                    <td>2025.11.02</td>
                    <td>122</td>
                </tr>
                <tr class="board-row" onclick="viewPost(2)">
                    <td>2</td>
                    <td class="post-title">CSS 네온 효과 적용 예시</td>
                    <td>User123</td>
                    <td>2025.11.02</td>
                    <td>122</td>
                </tr>
                <tr class="board-row" onclick="viewPost(2)">
                    <td>2</td>
                    <td class="post-title">CSS 네온 효과 적용 예시</td>
                    <td>User123</td>
                    <td>2025.11.02</td>
                    <td>122</td>
                </tr>
                <tr class="board-row" onclick="viewPost(2)">
                    <td>2</td>
                    <td class="post-title">CSS 네온 효과 적용 예시</td>
                    <td>User123</td>
                    <td>2025.11.02</td>
                    <td>122</td>
                </tr>
                <tr class="board-row" onclick="viewPost(2)">
                    <td>2</td>
                    <td class="post-title">CSS 네온 효과 적용 예시</td>
                    <td>User123</td>
                    <td>2025.11.02</td>
                    <td>122</td>
                </tr>
                <tr class="board-row" onclick="viewPost(2)">
                    <td>2</td>
                    <td class="post-title">CSS 네온 효과 적용 예시</td>
                    <td>User123</td>
                    <td>2025.11.02</td>
                    <td>122</td>
                </tr>
                <tr class="board-row" onclick="viewPost(2)">
                    <td>2</td>
                    <td class="post-title">CSS 네온 효과 적용 예시</td>
                    <td>User123</td>
                    <td>2025.11.02</td>
                    <td>122</td>
                </tr>
                <tr class="board-row" onclick="viewPost(2)">
                    <td>2</td>
                    <td class="post-title">CSS 네온 효과 적용 예시</td>
                    <td>User123</td>
                    <td>2025.11.02</td>
                    <td>122</td>
                </tr>
                <tr class="board-row" onclick="viewPost(2)">
                    <td>2</td>
                    <td class="post-title">CSS 네온 효과 적용 예시</td>
                    <td>User123</td>
                    <td>2025.11.02</td>
                    <td>122</td>
                </tr>
                <tr class="board-row" onclick="viewPost(2)">
                    <td>2</td>
                    <td class="post-title">CSS 네온 효과 적용 예시</td>
                    <td>User123</td>
                    <td>2025.11.02</td>
                    <td>122</td>
                </tr>
                <tr class="board-row" onclick="viewPost(2)">
                    <td>2</td>
                    <td class="post-title">CSS 네온 효과 적용 예시</td>
                    <td>User123</td>
                    <td>2025.11.02</td>
                    <td>122</td>
                </tr>
                
               
                
            </tbody>
        </table>
        
        <div class="footer">
            <span class="neon-link">Prev</span>
            <span class="neon-link current">1</span>
            <span class="neon-link" onclick="goToPage(2)">2</span>
            <span class="neon-link" onclick="goToPage(3)">3</span>
            <span class="neon-link">Next</span>
            
           		<div class="search-area">
				    <input type="text" id="searchInput" class="neon-input" placeholder="검색어를 입력하세요...">
				    <button class="neon-button" onclick="searchPosts()">검색</button>
				</div>
				
            
          
        </div>
    </div>
	
<!-- ==================================================================================== -->
<script type="text/javascript" src="./js/board/board.js"></script>
<script type="text/javascript" src="./js/common.js"></script>

</body>
</html>