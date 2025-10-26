window.onload = () => {
	loadKpiData();
	createSignupChart();
};

async function loadKpiData() {
	try {
		const contextPath = getContextPath();
		const response = await fetch(`${contextPath}/admin/api/kpi.do`);
		const data = await response.json();

		document.getElementById('total-users').textContent = data.totalUsers.toLocaleString();
		document.getElementById('today-users').textContent = data.todayUsers.toLocaleString();

	} catch (error) {
		console.error("KPI 데이터 로딩 실패:", error);
		document.getElementById('total-users').textContent = "Error";
		document.getElementById('today-users').textContent = "Error";
	}
}

async function createSignupChart() {
	try {
		const contextPath = getContextPath();
		const response = await fetch(`${contextPath}/admin/api/signup-stats.do`);
		const data = await response.json();

		const ctx = document.getElementById('signup-chart').getContext('2d');
		new Chart(ctx, {
			type: 'line',
			data: {
				labels: data.labels,
				datasets: [{
					label: '신규 가입자',
					data: data.values,
					borderColor: '#6c5ce7',
					tension: 0.3,
					fill: true,
					backgroundColor: 'rgba(108, 92, 231, 0.1)'
				}]
			},
			options: {
				scales: {
					y: {
						beginAtZero: true,
						ticks: { color: '#a0a0a0' },
						grid: { color: 'rgba(255, 255, 255, 0.1)' }
					},
					x: {
						ticks: { color: '#a0a0a0' },
						grid: { display: false }
					}
				},
				plugins: {
					legend: {
						labels: { color: '#e0e0e0' }
					}
				}
			}
		});
	} catch (error) {
		console.error("가입자 통계 차트 데이터 로딩 실패:", error);
	}
}

function getContextPath() {
	return '/' + location.pathname.split('/')[1];
}