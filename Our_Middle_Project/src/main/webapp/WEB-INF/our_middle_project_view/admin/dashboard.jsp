<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/admin_dashboard.css">

<div class="card-container">
    <div class="card">
        <div class="card-header"><h3>총 유저 수</h3></div>
        <div class="card-body"><span id="total-users" class="main-number">Loading...</span></div>
    </div>
    <div class="card">
        <div class="card-header"><h3>오늘 신규 가입</h3></div>
        <div class="card-body"><span id="today-users" class="main-number">Loading...</span></div>
    </div>
    <div class="card">
        <div class="card-header"><h3>게시판별 게시물 수</h3></div>
        <div class="card-body"><span id="total-posts" class="main-number">Loading...</span></div>
    </div>
</div>

<div class="card wide-card">
    <div class="card-header"><h3>최근 7일 가입자 추이</h3></div>
    <div class="card-body">
        <canvas id="signup-chart"></canvas>
    </div>
</div>

<script src="${pageContext.request.contextPath}/js/admin/admin_dashboard.js"></script>