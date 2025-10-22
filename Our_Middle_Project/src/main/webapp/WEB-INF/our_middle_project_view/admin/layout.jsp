<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isELIgnored="false" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게임 관리자 페이지</title>
<style>
body { font-family: sans-serif; margin: 0; } /* 오타 수정: scans-serif -> sans-serif */
.admin-container { display : flex; }
.sidebar { width: 220px; background-color: #2c3e50; color: white; min-height: 100vh; padding-top: 20px; }
.sidebar h2 { text-align: center; }
.sidebar ul { list-style: none; padding: 0; }
.sidebar ul li a { display: block; padding: 15px 20px; color: white; text-decoration: none; } /* padding 수정 */
.sidebar ul li a:hover { background-color: #34495e; }
.main-content { flex-grow: 1; padding: 20px; }
.header { padding: 20px; background-color: #f8f9fa; border-bottom: 1px solid #dee2e6; }
</style>
</head>
<body>
    <div class="admin-container">
        <nav class="sidebar">
            <h2>관리 메뉴</h2>
            <ul>
                <li><a href="/Our_Middle_Project/adminMain.do">메인</a></li>
                <li><a href="/Our_Middle_Project/adminUserList.do">회원 관리</a></li>
                <li><a href="/Our_Middle_Project/adminBoardList.do">게시판 관리</a></li>
            </ul>
        </nav>
        
        <div class="main-content">
            <jsp:include page="${viewPage}" />
        </div>
    </div>
</body>
</html>