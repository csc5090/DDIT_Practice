<link rel="stylesheet" href="${pageContext.request.contextPath}/css/CSC/admin_dashboard.css">
<%@ page contentType="text/html; charset=UTF-8" %>
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
			<i class="bi bi-pin-map-fill"></i>
		</div>
		<div class="card-body">
			<span class="main-number">142</span>
		</div>
	</div>

	<div class="card">
		<div class="card-header">
			<h3>신규 유저수</h3>
			<i class="bi bi-graph-up-arrow"></i>
		</div>
		<div class="card-body">
			<span class="main-number">2,328</span>
		</div>
	</div>

	<div class="card wide-card">
		<div class="card-header">
			<h3>월간 활동 유저 수</h3>
		</div>
		<div class="card-body">
			<canvas id="monthlyUsersChart"></canvas>
		</div>
	</div>

</div>

<script src="${pageContext.request.contextPath}/js/CSC/admin_dashboard.js"></script>