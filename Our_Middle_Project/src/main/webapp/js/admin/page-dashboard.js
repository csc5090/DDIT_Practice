// page-dashboard.js

const DashboardPage = {
	chartAInstance: null, // A차트
	chartBInstance: null, // B차트
	chartCInstance: null, // C차트
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
				console.log('대시보드 갱신 신호 수신 (전체 갱신)');
				this.updateAllStats();
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
				totalUsers: data.chartA_TotalUsers || [],
				totalGames: data.chartA_TotalGames || []
			});
			this.renderChartB('chartB', {
				newUsers: data.chartB_NewUsers || [],
				deletedUsers: data.chartB_DeletedUsers || []
			});
			this.renderChartC('chartC', data.chartC_PlaysByLevel || []);
		} catch (error) {
			console.error('전체 통계 데이터 로딩 중 에러 발생:', error);
			this.showErrorOnCards();
		}
	},

	updateCards: function(data) {
		const {
			cardTotalUsers = 0, cardDailyDeleted = 0, cardDailyNewUsers = 0,
			cardTotalGames = 0, cardEasyGames = 0, cardNormalGames = 0, cardHardGames = 0
		} = data;

		document.getElementById('cardTotalUsers').textContent = cardTotalUsers.toLocaleString();
		document.getElementById('cardDailyDeleted').textContent = cardDailyDeleted.toLocaleString();
		document.getElementById('cardDailyNewUsers').textContent = cardDailyNewUsers.toLocaleString();

		document.getElementById('cardTotalGames').textContent = cardTotalGames.toLocaleString();
		document.getElementById('cardEasyGames').textContent = cardEasyGames.toLocaleString();
		document.getElementById('cardNormalGames').textContent = cardNormalGames.toLocaleString();
		document.getElementById('cardHardGames').textContent = cardHardGames.toLocaleString();
	},

	showErrorOnCards: function() {
		const ids = ['cardTotalUsers', 'cardDailyDeleted', 'cardDailyNewUsers',
			'cardTotalGames', 'cardEasyGames', 'cardNormalGames', 'cardHardGames'];
		ids.forEach(id => {
			const element = document.getElementById(id);
			if (element) {
				element.textContent = '오류';
			}
		});
	},

	extractChartData: (dataset, dataKey = "VALUE") => {
		if (!dataset || dataset.length === 0) {
			return { labels: [], values: [] };
		}
		const labels = dataset.map(item => item.LABEL);
		const values = dataset.map(item => item[dataKey]);
		return { labels, values };
	},

	// A차트
	renderChartA: function(chartId, data) {
		const ctx = document.getElementById(chartId);
		if (!ctx) return;

		const totalUsersData = data.totalUsers.length > 0 ? data.totalUsers[data.totalUsers.length - 1].VALUE : 0;
		const totalGamesData = data.totalGames.length > 0 ? data.totalGames[data.totalGames.length - 1].VALUE : 0;

		if (this.chartAInstance) {
			this.chartAInstance.data.datasets[0].data[0] = totalUsersData;
			this.chartAInstance.data.datasets[0].data[1] = totalGamesData;
			this.chartAInstance.update();
			return;
		}

		const primaryColor = 'rgba(108, 92, 231, 1)'; // 보라색
		const secondaryColor = 'rgba(0, 200, 83, 1)'; // 초록색

		this.chartAInstance = new Chart(ctx, {
			type: 'bar',
			data: {
				labels: ['총 회원 수', '모든 게임 누적 판수'],
				datasets: [{
					label: '누적 현황',
					data: [totalUsersData, totalGamesData],
					backgroundColor: [primaryColor, secondaryColor],
					barPercentage: 0.5
				}]
			},
			options: {
				responsive: true, maintainAspectRatio: false,
				scales: {
					x: {
						ticks: { color: '#ffffff', font: { size: 14 } },
						grid: { display: false }
					},
					y: {
						type: 'linear',
						beginAtZero: true,
						ticks: {
							color: '#ffffff'
						},
						grid: { color: '#3c3c5a' }
					}
				},
				plugins: { legend: { display: false } }
			}
		});
	},

	// B차트
	renderChartB: function(chartId, data) {
		const ctx = document.getElementById(chartId);
		if (!ctx) return;

		const newUsersData = data.newUsers.length > 0 ? data.newUsers[data.newUsers.length - 1].VALUE : 0;
		const deletedUsersData = data.deletedUsers.length > 0 ? data.deletedUsers[data.deletedUsers.length - 1].VALUE : 0;

		if (this.chartBInstance) {
			this.chartBInstance.data.datasets[0].data[0] = deletedUsersData;
			this.chartBInstance.data.datasets[0].data[1] = newUsersData;
			this.chartBInstance.update();
			return;
		}

		const deletedColor = 'rgba(255, 171, 0, 1)'; // 주황색
		const newUserColor = 'rgba(54, 162, 235, 1)'; // 파란색

		this.chartBInstance = new Chart(ctx, {
			type: 'bar',
			data: {
				labels: ['일일 탈퇴자', '일일 가입자'],
				datasets: [{
					label: '일일 현황',
					data: [deletedUsersData, newUsersData],
					backgroundColor: [deletedColor, newUserColor],
					barPercentage: 0.5
				}]
			},
			options: {
				responsive: true, maintainAspectRatio: false,
				scales: {
					x: {
						ticks: { color: '#ffffff', font: { size: 14 } },
						grid: { display: false }
					},
					y: {
						display: false, 
						beginAtZero: true,
						ticks: { stepSize: 1 },
						grid: { display: false } 
					}
				},
				plugins: { legend: { display: false } }
			}
		});
	},

	// C차트
	renderChartC: function(chartId, dataset) {
		const ctx = document.getElementById(chartId);
		if (!ctx) return;

		const { labels, values: level1Values } = this.extractChartData(dataset, "LEVEL_1");
		const { values: level2Values } = this.extractChartData(dataset, "LEVEL_2");
		const { values: level3Values } = this.extractChartData(dataset, "LEVEL_3");

		if (this.chartCInstance) {
			this.chartCInstance.data.labels = labels;
			this.chartCInstance.data.datasets[0].data = level1Values;
			this.chartCInstance.data.datasets[1].data = level2Values;
			this.chartCInstance.data.datasets[2].data = level3Values;
			this.chartCInstance.update();
			return;
		}

		const level1Color = 'rgba(108, 92, 231, 1)'; // 보라색
		const level2Color = 'rgba(0, 200, 83, 1)';   // 초록색
		const level3Color = 'rgba(255, 171, 0, 1)'; // 주황색

		this.chartCInstance = new Chart(ctx, {
			type: 'line',
			data: {
				labels: labels,
				datasets: [
					{
						label: '난이도 1 (Easy)',
						data: level1Values,
						borderColor: level1Color,
						fill: false, borderWidth: 3, pointRadius: 0, pointHoverRadius: 5, tension: 0.4
					},
					{
						label: '난이도 2 (Normal)',
						data: level2Values,
						borderColor: level2Color,
						fill: false, borderWidth: 3, pointRadius: 0, pointHoverRadius: 5, tension: 0.4
					},
					{
						label: '난이도 3 (Hard)',
						data: level3Values,
						borderColor: level3Color,
						fill: false, borderWidth: 3, pointRadius: 0, pointHoverRadius: 5, tension: 0.4
					}
				]
			},
			options: {
				responsive: true, maintainAspectRatio: false,
				interaction: { mode: 'nearest', intersect: true },
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