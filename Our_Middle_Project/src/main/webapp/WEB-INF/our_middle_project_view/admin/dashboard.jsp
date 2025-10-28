<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/admin_dashboard.css">

<div class="card-container">
    <div class="card">
        <div class="card-header">
            <h3>총 몇 명?</h3>
        </div>
        <div class="card-body">
            <span class="main-number">####</span>
        </div>
    </div>
    <div class="card">
        <div class="card-header">
            <h3>몇 판?</h3>
        </div>
        <div class="card-body">
            <span class="main-number">####</span>
        </div>
    </div>
    <div class="card">
        <div class="card-header">
            <h3>뉴비 몇 명?</h3>
        </div>
        <div class="card-body">
            <span class="main-number">####</span>
        </div>
    </div>
    
    <div class="chart">
        <div class="chart wide-card"> 
    		<h2>차트 영역</h2>
    		<canvas id="myChart"></canvas>
		</div>
    </div>
    
</div>