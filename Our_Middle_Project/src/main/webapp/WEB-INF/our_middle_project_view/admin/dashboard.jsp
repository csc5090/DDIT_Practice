<%-- 이 파일은 layout.jsp에 포함될 내용만 작성합니다. --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%-- 이 페이지 전용 CSS 파일 연결 --%>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/CSC/admin_dashboard.css">

<div class="card-container">
    
    <div class="card">
        <div class="card-header">
            <h3>총 유저수</h3>
            <i class="bi bi-people"></i>
        </div>
        <div class="card-body">
            <span class="main-number">10,242</span>
        </div>
    </div>
    
    <div class="card">
        <div class="card-header">
            <h3>몇 판?</h3>
            <i class="bi bi-joystick"></i>
        </div>
        <div class="card-body">
            <span class="main-number">142</span>
        </div>
    </div>
    
    <div class="card">
        <div class="card-header">
            <h3>신규 유저수</h3>
            <i class="bi bi-person-plus"></i>
        </div>
        <div class="card-body">
            <span class="main-number">2,328</span>
        </div>
    </div>

</div>