// page-dashboard.js

const DashboardPage = {
	chartAInstance: null, // A차트 (실시간)
	chartBInstance: null, // B차트 (모드별)
	dashboardSocket: null,

	init: function() {
		this.dashSocketConnector();
	},

	dashSocketConnector: function() {
		const wsProtocol = window.location.protocol === 'https:' ? 'wss:' : 'ws:';
		const wsHost = window.location.host;
		const wsUrl = `${wsProtocol}//${wsHost}${CONTEXT_PATH}/dashboardEndPoint`;

		this.dashboardSocket = new WebSocket(wsUrl);

		this.dashboardSocket.onopen = () => {
			console.log('대시보드 웹소켓 연결 성공');
			this.dashboardSocket.send(JSON.stringify({ type: "REQUEST_JOIN" }));
			this.updateAllStats();
		};

		this.dashboardSocket.onmessage = (event) => {
			const message = JSON.parse(event.data);
			if (message.type === "RESPONSE_REFRESH") {
				console.log('대시보드 갱신 신호 수신 (A차트만 갱신)');
				this.updateRealtimeStats();
			}
		};

		this.dashboardSocket.onclose = () => console.log('대시보드 웹소켓 연결 종료');
		this.dashboardSocket.onerror = (error) => console.error('대시보드 웹소켓 에러:', error);
	},

	updateAllStats: async function() {
		try {
			const data = await apiClient.post('/getStats.do', null);
			this.updateCards(data);
			this.renderChartA('chartA', {
				totalUsers: data.totalUsers,
				activeUsers: data.activeUsers
			});
			this.renderChartB('chartB', data.playCountByLevel || []);
		} catch (error) {
			console.error('전체 통계 데이터 로딩 중 에러 발생:', error);
			this.showErrorOnCards();
		}
	},

	updateRealtimeStats: async function() {
		try {
			const data = await apiClient.post('/getStats.do', null);
			this.updateCards(data);
			this.renderChartA('chartA', {
				totalUsers: data.totalUsers,
				activeUsers: data.activeUsers
			});
		} catch (error) {
			console.error('실시간 통계 데이터 로딩 중 에러 발생:', error);
			this.showErrorOnCards();
		}
	},

	updateCards: function(data) {
		const { totalUsers = 0, newUsersToday = 0, totalGames = 0 } = data;

		const userCountElement = document.getElementById('total-user-count');
		if (userCountElement) userCountElement.textContent = totalUsers.toLocaleString();

		const newUserCountElement = document.getElementById('new-user-count');
		if (newUserCountElement) newUserCountElement.textContent = newUsersToday.toLocaleString();

		const gameCountElement = document.getElementById('total-game-count');
		if (gameCountElement) gameCountElement.textContent = totalGames.toLocaleString();
	},

	showErrorOnCards: function() {
		['total-user-count', 'total-game-count', 'new-user-count'].forEach(id => {
			const element = document.getElementById(id);
			if (element) {
				element.textContent = '오류';
				element.style.fontSize = '1.5rem';
			}
		});
	},


	// A차트: 세로 막대 (Vertical) + 로그 스케일
	renderChartA: function(chartId, data) {
		const ctx = document.getElementById(chartId);
		if (!ctx) return;

		const activeUsersData = data.activeUsers === 0 ? 0.1 : data.activeUsers;
		const totalUsersData = data.totalUsers === 0 ? 1 : data.totalUsers;

		if (this.chartAInstance) {
			this.chartAInstance.data.datasets[0].data[0] = totalUsersData;
			this.chartAInstance.data.datasets[0].data[1] = activeUsersData;
			this.chartAInstance.update();
			return;
		}

		const primaryColor = 'rgba(108, 92, 231, 1)'; // 보라색
		const activeColor = 'rgba(255, 171, 0, 1)'; // 주황색

		this.chartAInstance = new Chart(ctx, {
			type: 'bar',
			data: {
				labels: ['총 가입자 수', '현재 접속자 수'],
				datasets: [{
					label: '사용자 현황',
					data: [totalUsersData, activeUsersData],
					backgroundColor: [primaryColor, activeColor],
					borderColor: [primaryColor, activeColor],
					borderWidth: 1,
					barPercentage: 0.5
				}]
			},
			options: {
				responsive: true,
				maintainAspectRatio: false,
				scales: {
					x: {
						ticks: { color: '#ffffff', font: { size: 14 } },
						grid: { display: false }
					},
					y: {
						type: 'logarithmic',
						beginAtZero: false,
						min: 0.1,
						ticks: {
							color: '#ffffff',
							// [수정] 0.1을 0으로 바꾸는 것 외에는
							// Chart.js가 자동으로 생성하는 눈금(10, 100 등)을 그대로 사용
							callback: function(value, index, ticks) {
								if (value === 0.1) return '0';
								// (수정) 불필요한 필터링 제거
								return value.toLocaleString();
							}
						},
						grid: { color: '#3c3c5a' }
					}
				},
				plugins: {
					legend: {
						display: false
					},
					tooltip: {
						callbacks: {
							label: function(context) {
								let label = context.dataset.label || '';
								if (label) {
									label += ': ';
								}
								if (context.parsed.y !== null) {
									let value = context.parsed.y;
									if (value === 0.1) value = 0;
									label += value.toLocaleString() + '명';
								}
								return label;
							}
						}
					}
				}
			}
		});
	},

	// B차트 (기존과 동일)
	renderChartB: function(chartId, dataset) {
		const ctx = document.getElementById(chartId);
		if (!ctx) return;

		if (this.chartBInstance) {
			this.chartBInstance.destroy();
		}

		const labels = dataset.map(item => item.LABEL);
		const level1Values = dataset.map(item => item.LEVEL_1);
		const level2Values = dataset.map(item => item.LEVEL_2);
		const level3Values = dataset.map(item => item.LEVEL_3);

		const level1Color = 'rgba(108, 92, 231, 1)';
		const level2Color = 'rgba(0, 200, 83, 1)';
		const level3Color = 'rgba(255, 171, 0, 1)';

		this.chartBInstance = new Chart(ctx, {
			type: 'line',
			data: {
				labels: labels,
				datasets: [
					{
						label: '난이도 1 (Easy)',
						data: level1Values,
						fill: false,
						borderColor: level1Color,
						borderWidth: 3,
						pointRadius: 0,
						pointHoverRadius: 5,
						tension: 0.4
					},
					{
						label: '난이도 2 (Normal)',
						data: level2Values,
						fill: false,
						borderColor: level2Color,
						borderWidth: 3,
						pointRadius: 0,
						pointHoverRadius: 5,
						tension: 0.4
					},
					{
						label: '난이도 3 (Hard)',
						data: level3Values,
						fill: false,
						borderColor: level3Color,
						borderWidth: 3,
						pointRadius: 0,
						pointHoverRadius: 5,
						tension: 0.4
					}
				]
			},
			options: {
				responsive: true,
				maintainAspectRatio: false,
				interaction: {
					mode: 'nearest',
					intersect: true,
				},
				plugins: {
					legend: {
						display: true,
						labels: { color: '#ffffff', font: { size: 14 } }
					}
				},
				scales: {
					x: {
						ticks: { color: '#ffffff' },
						grid: { color: '#3c3c5a' }
					},
					y: {
						beginAtZero: true,
						ticks: { color: '#ffffff', stepSize: 1 }, // 1판 단위로
						grid: { color: '#3c3c5a' }
					}
				}
			}
		});
	}
};