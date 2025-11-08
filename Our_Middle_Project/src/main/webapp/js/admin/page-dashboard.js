// page-dashboard.js (수정본 6 - 곡선 장력 조절)

const DashboardPage = {
	myChartInstance: null,
	dashboardSocket: null,

	init: function() {
		this.dashSocketConnector();
	},

	dashSocketConnector: function() {
		// WebSocket 경로 설정 (/dashboardEndPoint)
		const wsProtocol = window.location.protocol === 'https:' ? 'wss:' : 'ws:';
		const wsHost = window.location.host;
		// (참고: CONTEXT_PATH는 layout.jsp에서 선언된 전역 변수)
		const wsUrl = `${wsProtocol}//${wsHost}${CONTEXT_PATH}/dashboardEndPoint`;

		this.dashboardSocket = new WebSocket(wsUrl);

		// 연결 성공 시
		this.dashboardSocket.onopen = () => {
			console.log('대시보드 웹소켓 연결 성공');
			// 서버에 "접속 요청" JSON 전송
			this.dashboardSocket.send(JSON.stringify({ type: "REQUEST_JOIN" }));
			//  연결 성공 직후, 데이터 1회 강제 로드
			this.updateStats();
		};

		// 서버로부터 메시지 수신 시 (핵심)
		this.dashboardSocket.onmessage = (event) => {
			const message = JSON.parse(event.data);

			// 서버가 "갱신 응답"을 보내면
			if (message.type === "RESPONSE_REFRESH") {
				console.log('대시보드 갱신 신호 수신. 데이터 새로고침');
				// 통계 데이터를 다시 로드
				this.updateStats();
			}
		};

		// 연결 종료 시
		this.dashboardSocket.onclose = () => {
			console.log('대시보드 웹소켓 연결 종료');
		};

		this.dashboardSocket.onerror = (error) => {
			console.error('대시보드 웹소켓 에러:', error);
		};
	},

	updateStats: async function() {
		try {
			const data = await apiClient.post('/getStats.do', null);
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
    
    extractChartData: (dataset) => {
        if (!dataset || dataset.length === 0) {
            return { labels: [], values: [] };
        }
        const labels = dataset.map(item => item.LABEL);
        const values = dataset.map(item => item.VALUE);
        return { labels, values };
    },

	renderChart: function(chartId, chartData) {
		const ctx = document.getElementById(chartId);
		if (!ctx) return;

		if (this.myChartInstance) {
			this.myChartInstance.destroy();
		}

        const { labels, values: totalUserValues } = this.extractChartData(chartData.totalUsersChart);
        const { values: totalGameValues } = this.extractChartData(chartData.totalGamesChart);
        const { values: newUserValues } = this.extractChartData(chartData.newUsersChart);
        
		const primaryColor = 'rgba(108, 92, 231, 1)'; // 보라색 (총 회원)
		const secondaryColor = 'rgba(0, 200, 83, 1)'; // 초록색 (총 게임)
		const tertiaryColor = 'rgba(255, 171, 0, 1)'; // 주황색 (신규)

		this.myChartInstance = new Chart(ctx, {
			type: 'line',
			data: {
				labels: labels, // X축 라벨 (공통)
				datasets: [
                    // 1. 총 회원 수 (왼쪽 Y축)
                    {
					    label: '총 회원 수 (누적)',
					    data: totalUserValues,
					    fill: false,
					    borderColor: primaryColor,
					    borderWidth: 3,
					    pointBackgroundColor: primaryColor,
                        pointRadius: 0,
                        pointHoverRadius: 5,
					    tension: 0.4, // [수정] 0.1 -> 0.4
                        yAxisID: 'yLeft'
				    },
                    // 2. 총 게임 수 (왼쪽 Y축)
                    {
					    label: '총 게임 수 (누적)',
					    data: totalGameValues,
					    fill: false,
					    borderColor: secondaryColor,
					    borderWidth: 3,
					    pointBackgroundColor: secondaryColor,
                        pointRadius: 0,
                        pointHoverRadius: 5,
					    tension: 0.4, // [수정] 0.1 -> 0.4
                        yAxisID: 'yLeft'
				    },
                    // 3. 신규 가입자 수 (오른쪽 Y축)
                    {
                        label: '신규 가입자 수 (일별)',
                        data: newUserValues,
                        fill: false,
                        borderColor: tertiaryColor,
                        borderWidth: 2,
                        pointBackgroundColor: tertiaryColor,
                        pointRadius: 0,
                        pointHoverRadius: 5,
                        tension: 0.4, // [수정] 0.1 -> 0.4
                        yAxisID: 'yRight'
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
                stacked: false,
				plugins: {
					legend: {
						display: true,
						labels: {
							color: '#ffffff',
							font: { size: 14 }
						}
					},
                    tooltip: {
                        titleFont: { size: 14 },
                        bodyFont: { size: 12 },
                    }
				},
				scales: {
                    // X축 (공통)
					x: {
						ticks: { color: '#ffffff' },
						grid: { color: '#3c3c5a' }
					},
                    // Y축 (왼쪽 - 누적)
					yLeft: {
                        type: 'linear',
                        position: 'left',
						beginAtZero: true,
						ticks: {
							color: '#ffffff', // 중립적인 흰색
                            font: { weight: 'bold' }
						},
						grid: { color: '#3c3c5a' } // 메인 그리드
					},
                    // Y축 (오른쪽 - 일별)
                    yRight: {
                        type: 'linear',
                        position: 'right',
                        beginAtZero: true,
                        ticks: {
                            color: tertiaryColor, // 오른쪽 눈금 (주황색)
                            stepSize: 1, // 신규 유저는 1명 단위로
                            font: { weight: 'bold' }
                        },
                        grid: { drawOnChartArea: false } // 오른쪽 축은 그리드 안 그림
                    }
				}
			}
		});
	}
};