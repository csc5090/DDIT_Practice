<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<h3>대시보드</h3>
<div class="row">
    <div class="col-md-6">
        <div class="card">
            <div class="card-body">
                <h5 class="card-title">일일 신규 가입자 수</h5>
                <canvas id="dailySignupsChart"></canvas>
            </div>
        </div>
    </div>
    <div class="col-md-6">
        <div class="card">
            <div class="card-body">
                <h5 class="card-title">게임별 플레이 수</h5>
                <canvas id="gamePlaysChart"></canvas>
            </div>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/js/admin/dashboard.js"></script>