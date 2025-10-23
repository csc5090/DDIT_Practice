<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Good Day, Commander.</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/CSC/admin_layout.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
    <div id="admin-wrapper">
        <nav class="sidebar">
            <a href="${pageContext.request.contextPath}/adminMain.do" class="logo-link">
                Admin
            </a>
            
            <ul class="nav-menu">
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/adminMain.do" class="nav-link ${activeMenu eq 'dashboard' ? 'active' : ''}">
                        대시보드
                    </a>
                </li>
                <li class="nav-item">
                    <a href="#" class="nav-link ${activeMenu eq 'users' ? 'active' : ''}">
                        사용자
                    </a>
                    <ul class="submenu">
                        <li><a href="${pageContext.request.contextPath}/adminUserList.do">목록 조회</a></li>
                        <li><a href="#">권한 관리</a></li>
                        <li><a href="#">닉네임 변경</a></li>
                        <li><a href="#">차단 관리</a></li>
                    </ul>
                </li>
                <li class="nav-item">
                    <a href="#" class="nav-link ${activeMenu eq 'stats' ? 'active' : ''}">
                        데이터/통계
                    </a>
                </li>
            </ul>
    
            <div class="nav-settings">
                <a href="#" class="nav-link">
                    설정
                </a>
            </div>
        </nav>

        <main class="main-content">
            <header class="main-header">
                <div class="header-title">
                    <h1>Dashboard</h1>
                </div>
                <div class="user-profile">
                    <c:if test="${empty sessionScope.loginUser}">
                        <img src="${pageContext.request.contextPath}/images/prtc.jpg" alt="User">
                        <span>Guest</span>
                    </c:if>
                </div>
            </header>
            
            <section class="content-body">
                <jsp:include page="${viewPage}" />
            </section>
        </main>
    </div>
</body>
</html>