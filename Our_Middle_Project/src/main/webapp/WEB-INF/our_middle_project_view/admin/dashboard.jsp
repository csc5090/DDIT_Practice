<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/admin_dashboard.css">

<div class="card-container">

	<div class="card">
		<div class="card-header">
			<h3>Total Users</h3>
			<i class="bi bi-people"></i>
		</div>
		<div class="card-body">
			<span class="main-number">10,242</span>
		</div>
	</div>

	<div class="card">
		<div class="card-header">
			<h3>Locations</h3>
			<i class="bi bi-pin-map-fill"></i>
		</div>
		<div class="card-body">
			<span class="main-number">142</span>
		</div>
	</div>

	<div class="card">
		<div class="card-header">
			<h3>Outliers</h3>
			<i class="bi bi-graph-up-arrow"></i>
		</div>
		<div class="card-body">
			<span class="main-number">2,328</span>
		</div>
	</div>

	<div class="card wide-card">
		<div class="card-header">
			<h3>Monthly Active Users</h3>
		</div>
		<div class="card-body">
			<canvas id="monthlyUsersChart"></canvas>
		</div>
	</div>

</div>

<script src="${pageContext.request.contextPath}/js/admin_dashboard.js"></script>