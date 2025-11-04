// page-dashboard.js

const DashboardPage = {
	myChartInstance: null,
	dashboardSocket: null, // WebSocket 변수

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
			// (필요시 5초 후 재연결 시도 로직 추가)
		};

		this.dashboardSocket.onerror = (error) => {
			console.error('대시보드 웹소켓 에러:', error);
		};
	},

	// 기존 통계 업데이트 함수
	updateStats: async function() {
		try {
			const data = await apiClient.post('/getStats.do', null);

			// === 차트 렌더링 ===
			const chartData = data.chartData || {};
			this.renderChart('myChart', chartData);

			// === KPI 카드 업데이트 ===
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

		// 꺾은선 그래프용 색상 정의
		const primaryColor = 'rgba(108, 92, 231, 1)';
		const primaryColorFill = 'rgba(108, 92, 231, 0.2)';

		this.myChartInstance = new Chart(ctx, {
			type: 'line', // 'line'으로 변경
			data: {
				labels: labels,
				datasets: [{
					label: '일일 가입자 수',
					data: dataValues,

					// 꺾은선 그래프 스타일로 변경 ---
					fill: true, // 라인 아래 영역 채우기
					backgroundColor: primaryColorFill, // 영역 색상
					borderColor: primaryColor,         // 라인 색상
					borderWidth: 2,                  // 라인 굵기
					pointBackgroundColor: primaryColor, // 점 색상
					tension: 0.1                     // 선을 부드럽게
				}]
			},
			options: {
				responsive: true,
				maintainAspectRatio: false,
				plugins: {
					legend: {
						display: true,
						labels: {
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
							maxRotation: 90,
							minRotation: 45
						},
						grid: { color: '#3c3c5a' }
					},
					y: {
						beginAtZero: true,
						ticks: {
							color: '#ffffff',
							stepSize: 1
						},
						grid: { color: '#3c3c5a' }
					}
				}
			}
		});
	}
};