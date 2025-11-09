// page-stats.js (수정본 - Phase 2: 유저 활동 탭 추가)

const StatsPage = {
	charts: {},

	init: function() {
		const statsPage = document.getElementById('stats-main');
		if (!statsPage) return;

		const runButton = document.getElementById('stats-run-report-btn');
		if (runButton) {
			runButton.removeEventListener('click', this.handleRunReport.bind(this));
			runButton.addEventListener('click', this.handleRunReport.bind(this));
		}

		const today = new Date().toISOString().split('T')[0];
		const startDateInput = document.getElementById('stats-start-date');
		const endDateInput = document.getElementById('stats-end-date');

		if (startDateInput && !startDateInput.value) {
			const twoWeeksAgo = new Date();
			twoWeeksAgo.setDate(twoWeeksAgo.getDate() - 13); // 14일
			startDateInput.value = twoWeeksAgo.toISOString().split('T')[0];
		}
		if (endDateInput && !endDateInput.value) {
			endDateInput.value = today;
		}
	},

	handleRunReport: async function() {
		const startDate = document.getElementById('stats-start-date').value;
		const endDate = document.getElementById('stats-end-date').value;
		const reportType = document.getElementById('stats-report-type').value;

		if (!startDate || !endDate) {
			Swal.fire('입력 오류', '시작일과 종료일을 모두 선택해주세요.', 'warning');
			return;
		}
		if (new Date(startDate) > new Date(endDate)) {
			Swal.fire('입력 오류', '시작일은 종료일보다 늦을 수 없습니다.', 'warning');
			return;
		}
		if (!reportType) {
			Swal.fire('입력 오류', '분석 주제를 선택해주세요.', 'warning');
			return;
		}

		const container = document.getElementById('stats-chart-container');
		container.innerHTML = '<p class="stats-placeholder">데이터 조회 중...</p>';
		this.destroyAllCharts();

		try {
			const params = { startDate, endDate, reportType };
			const result = await apiClient.post('/getDynamicReport.do', params);

			container.innerHTML = '';

			switch (reportType) {
				case 'game_balance':
					this.renderGameBalanceReport(container, result.reportData);
					break;

				// [신규] Phase 2: 유저 활동
				case 'user_activity':
					// [수정] 3개의 차트를 그리도록 함수 호출
					this.renderUserActivityReport(container, result);
					break;

				case 'community_feedback':
					container.innerHTML = '<p class="stats-placeholder">\'커뮤니티 피드백\' 리포트는 현재 준비 중입니다.</p>';
					break;
				default:
					container.innerHTML = '<p class="stats-placeholder">알 수 없는 리포트 타입입니다.</p>';
			}

		} catch (error) {
			console.error('리포트 조회 실패:', error);
			container.innerHTML = '<p class="stats-placeholder" style="color: red;">데이터 조회 중 오류가 발생했습니다.</p>';
		}
	},

	// Phase 1: '게임 밸런스' (기존과 동일)
	renderGameBalanceReport: function(container, data) {
		if (!data || data.length === 0) {
			container.innerHTML = '<p class="stats-placeholder">선택한 기간에 해당하는 게임 데이터가 없습니다.</p>';
			return;
		}

		container.innerHTML = `
            <div class="scorecard-column" id="scorecard-easy">
                <div class="scorecard-header easy">Easy (Lv.1)</div>
            </div>
            <div class="scorecard-column" id="scorecard-normal">
                <div class="scorecard-header normal">Normal (Lv.2)</div>
            </div>
            <div class="scorecard-column" id="scorecard-hard">
                <div class="scorecard-header hard">Hard (Lv.3)</div>
            </div>
        `;

		const levels = ['easy', 'normal', 'hard'];
		const colors = {
			easy: 'rgba(0, 200, 83, 0.7)',   // 초록
			normal: 'rgba(54, 162, 235, 0.7)', // 파랑
			hard: 'rgba(213, 0, 0, 0.7)'     // 빨강
		};

		[1, 2, 3].forEach(levelNo => {
			const levelName = levels[levelNo - 1];
			const col = document.getElementById(`scorecard-${levelName}`);
			const item = data.find(d => d.levelNo == levelNo) || {};
			const playCount = item.playCount || 0;
			const uniqueUsers = item.uniqueUsers || 0;
			const avgClearTime = (item.avgClearTime || 0).toFixed(2);
			const avgScore = (item.avgScore || 0).toFixed(0);
			const maxScore = item.maxScore || 0;
			const avgCombo = (item.avgCombo || 0).toFixed(1);
			const maxCombo = item.maxCombo || 0;

			col.innerHTML += `
                <div class="kpi-section">
                    <div class="kpi-box"><div class="kpi-title">총 플레이</div><div class="kpi-value">${playCount} <span style="font-size:1rem">회</span></div></div>
                    <div class="kpi-box"><div class="kpi-title">플레이 유저</div><div class="kpi-value">${uniqueUsers} <span style="font-size:1rem">명</span></div></div>
                </div>
                <div class="kpi-section"><div class="kpi-box" style="grid-column: 1 / -1;"><div class="kpi-title">평균 클리어 시간</div><div class="kpi-value">${avgClearTime} <span style="font-size:1rem">초</span></div></div></div>
            `;

			col.innerHTML += `
                <div class="chart-section">
                    <div class="stats-chart-wrapper"><canvas id="balanceChartScore_${levelName}"></canvas></div>
                    <div class="stats-chart-wrapper"><canvas id="balanceChartCombo_${levelName}"></canvas></div>
                </div>
            `;

			this.charts[`score_${levelName}`] = new Chart(document.getElementById(`balanceChartScore_${levelName}`), {
				type: 'bar',
				data: {
					labels: ['평균 점수', '최고 점수'],
					datasets: [{ data: [avgScore, maxScore], backgroundColor: [colors[levelName], colors[levelName].replace('0.7', '0.3')], barPercentage: 0.7 }]
				},
				options: this.getChartOptions('y', '점수 성과', false)
			});

			this.charts[`combo_${levelName}`] = new Chart(document.getElementById(`balanceChartCombo_${levelName}`), {
				type: 'bar',
				data: {
					labels: ['평균 콤보', '최고 콤보'],
					datasets: [{ data: [avgCombo, maxCombo], backgroundColor: [colors[levelName], colors[levelName].replace('0.7', '0.3')], barPercentage: 0.7 }]
				},
				options: this.getChartOptions('y', '콤보 성과', false)
			});
		});
	},

	// [신규] Phase 2: '유저 활동' 리포트 렌더링 함수
	renderUserActivityReport: function(container, data) {
		const dauData = data.dauReport;
		const newData = data.newUserReport;
		const delData = data.deletedUserReport;
		const actData = data.activationReport; // Donut 차트용

		if (!dauData || dauData.length === 0) {
			container.innerHTML = '<p class="stats-placeholder">선택한 기간에 해당하는 유저 활동 데이터가 없습니다.</p>';
			return;
		}

		// [수정] 3개의 차트를 1:1:1 비율로 그림
		container.innerHTML = `
            <div class="stats-chart-wrapper"><canvas id="statsChart_DAU"></canvas></div>
            <div class="stats-chart-wrapper"><canvas id="statsChart_NewVsDel"></canvas></div>
            <div class="stats-chart-wrapper"><canvas id="statsChart_Activation"></canvas></div>
        `;

		// --- 차트 1: 일간 활성 유저 (DAU) (Area Chart) ---
		const dauChartData = this.extractChartData(dauData, "VALUE");
		const areaColor = 'rgba(0, 200, 83, 1)'; // 초록색

		this.charts.chart1 = new Chart(document.getElementById('statsChart_DAU'), {
			type: 'line',
			data: {
				labels: dauChartData.labels,
				datasets: [{
					label: '일간 활성 유저 (DAU)',
					data: dauChartData.values,
					fill: true, // [트랜디] 영역 채우기
					backgroundColor: areaColor.replace('1', '0.2'),
					borderColor: areaColor,
					tension: 0.4, pointRadius: 0, pointHoverRadius: 5
				}]
			},
			options: this.getChartOptions('x', '일간 활성 유저 (DAU)', true)
		});

		// --- 차트 2: 가입 vs 탈퇴 (Combined Bar/Line Chart) ---
		const newUserChartData = this.extractChartData(newData, "VALUE");
		const delUserChartData = this.extractChartData(delData, "VALUE");
		const newUserColor = 'rgba(54, 162, 235, 1)'; // 파란색 (Bar)
		const delUserColor = 'rgba(213, 0, 0, 1)';   // 붉은색 (Line)

		this.charts.chart2 = new Chart(document.getElementById('statsChart_NewVsDel'), {
			type: 'bar', // 기본 타입은 Bar
			data: {
				labels: newUserChartData.labels, // 공통 X축
				datasets: [
					{
						label: '일일 가입자',
						data: newUserChartData.values,
						backgroundColor: newUserColor.replace('1', '0.7'),
						type: 'bar', // Bar 차트
						order: 2 // Bar를 뒤에 그림
					},
					{
						label: '일일 탈퇴자',
						data: delUserChartData.values,
						borderColor: delUserColor,
						type: 'line', // Line 차트
						fill: false, tension: 0.4, pointRadius: 0, pointHoverRadius: 5,
						order: 1 // Line을 위에 그림
					}
				]
			},
			options: this.getChartOptions('x', '일일 가입 vs 탈퇴 추이', true)
		});

		// --- 차트 3: 신규 유저 활성화 (Donut Chart) ---
		const activated = actData.ACTIVATED_USERS || 0;
		const nonActivated = actData.NON_ACTIVATED_USERS || 0;

		this.charts.chart3 = new Chart(document.getElementById('statsChart_Activation'), {
			type: 'doughnut',
			data: {
				labels: ['1판 이상 플레이', '1판도 안 함 (이탈)'],
				datasets: [{
					data: [activated, nonActivated],
					backgroundColor: [
						'rgba(108, 92, 231, 1)', // 보라색
						'rgba(100, 100, 100, 0.7)' // 회색
					],
					borderWidth: 1
				}]
			},
			options: {
				responsive: true,
				maintainAspectRatio: false,
				plugins: {
					legend: {
						display: true,
						position: 'bottom', // 범례를 아래로
						labels: { color: '#ffffff' }
					},
					title: {
						display: true,
						text: '신규 유저 활성화 비율',
						color: '#ffffff',
						font: { size: 14 }
					}
				}
			}
		});
	},

	// [공통] 헬퍼 함수
	extractChartData: (dataset, dataKey = "VALUE") => {
		if (!dataset || dataset.length === 0) {
			return { labels: [], values: [] };
		}
		const labels = dataset.map(item => item.LABEL);
		const values = dataset.map(item => item[dataKey]);
		return { labels, values };
	},

	// [공통] 차트 옵션
	getChartOptions: function(axis = 'y', titleText = '', showLegend = false) {

		const xOptions = {
			beginAtZero: true,
			ticks: { color: '#ffffff', font: { size: (axis === 'y' ? 10 : 12) } },
			grid: { color: '#3c3c5a' }
		};
		const yOptions = {
			beginAtZero: true,
			ticks: { color: '#ffffff', font: { size: (axis === 'y' ? 12 : 10) } },
			grid: { color: '#3c3c5a' }
		};

		return {
			indexAxis: axis,
			responsive: true,
			maintainAspectRatio: false,
			scales: {
				x: (axis === 'y') ? xOptions : yOptions,
				y: (axis === 'y') ? yOptions : xOptions
			},
			plugins: {
				legend: {
					display: showLegend,
					labels: { color: '#ffffff' }
				},
				title: {
					display: true,
					text: titleText,
					color: '#ffffff',
					font: { size: 14 }
				}
			}
		};
	},

	// [공통] 차트 파괴
	destroyAllCharts: function() {
		Object.keys(this.charts).forEach(key => {
			if (this.charts[key]) {
				this.charts[key].destroy();
				this.charts[key] = null;
			}
		});
	}
};