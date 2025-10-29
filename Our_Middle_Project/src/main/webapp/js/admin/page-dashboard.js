// page-dashboard.js

const DashboardPage = {
	myChartInstance: null,

	init: function() {
		this.updateStats();
	},

	updateStats: async function() {
		try {
			const data = await apiClient.get('/getStats.do');


			const chartData = data.chartData || {};
			this.renderChart('myChart', chartData);

			const { totalUsers = 0, newUsers = 0, totalGames = 0 } = data;

			const userCountElement = document.getElementById('total-user-count');
			if (userCountElement) userCountElement.textContent = totalUsers.toLocaleString();

			const newUserCountElement = document.getElementById('new-user-count');
			if (newUserCountElement) newUserCountElement.textContent = newUsers.toLocaleString();

			const gameCountElement = document.getElementById('total-game-count');
			if (gameCountElement) gameCountElement.textContent = totalGames.toLocaleString();

		} catch (error) {
			console.error('통계 데이터 로딩 중 에러 발생:', error);
			['total-user-count', 'total-game-count', 'new-user-count'].forEach(id => {
				const element = document.getElementById(id);
				if (element) {
					element.textContent = '오류';
					element.style.fontSize = '1.5rem';
				}
			});
		}
	},

	renderChart: function(chartId, chartData) {
		const ctx = document.getElementById(chartId);
		if (!ctx) return;

		if (this.myChartInstance) {
			this.myChartInstance.destroy();
		}

		const labels = chartData?.labels || [];
		const dataValues = chartData?.values || [];

		const backgroundColors = [
			'rgba(108, 92, 231, 0.8)',
			'rgba(46, 204, 113, 0.8)',
			'rgba(52, 152, 219, 0.8)',
		];

		this.myChartInstance = new Chart(ctx, {
			type: 'bar',
			data: {
				labels: labels,
				datasets: [{
					label: '일일 가입자 수',
					data: dataValues,
					backgroundColor: backgroundColors,
					borderColor: backgroundColors.map(color => color.replace('0.8', '1')),
					borderWidth: 1
				}]
			},
			options: {
				responsive: true,
				maintainAspectRatio: false,
				plugins: { 
					legend: { 
						display: true,
						labels:{
							color: '#ffffff',
							font: {
								size: 16,
								weight: 'bold'
							}
						} 
					}
							},
				scales: {
					x: {
						ticks: {
							color: '#ffffff',
							maxRotation: 45,
							minRotation: 45
						},
						grid: { color: '#3c3c5a' }
					},
					y: { beginAtZero: true, ticks: { color: '#ffffff' }, grid: { color: '#3c3c5a' } }
				}
			}
		});
	}
};