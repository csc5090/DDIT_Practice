// page-stats.js (최종 수정본 - 반응성, 화질, 레이아웃 문제 모두 해결)

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

			// 🚨 컨테이너 초기화 방식을 reportType에 따라 다르게 처리 🚨
			if (reportType === 'user_activity') {
				// 유저 활동: 새로운 wrapper를 생성하고 컨테이너의 그리드 스타일을 제거
				container.style.display = 'block'; // 그리드 레이아웃 제거
				container.innerHTML = '<div class="stats-report-wrapper"></div>';
				const wrapper = container.querySelector('.stats-report-wrapper');
				this.renderUserActivityReport(wrapper, result);
			} else {
				// 게임 밸런스: 기존의 3분할 그리드 레이아웃을 사용
				container.style.display = 'grid'; // 그리드 레이아웃 복구
				container.innerHTML = '';
				this.renderGameBalanceReport(container, result.reportData);
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

		// 🚨 컨테이너가 #stats-chart-container이므로, 여기에 직접 3개 컬럼을 그림 🚨
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

	renderUserActivityReport: function(wrapper, data) {
		const kpiData = data.kpi || {};
		const dauData = data.dauTrend;
		const newData = data.retentionNew;
		const delData = data.retentionReturning;
		const communityMixData = data.communityMix; // 커뮤니티 활성도 믹스 (Donut 차트)
		const ratingDistData = data.ratingDist; // 평점 분포
		const playtimeHeatmapData = data.playtimeHeatmap; // 히트맵

		// 데이터 유효성 검사: DAU 데이터가 없으면 리포트 없음 처리
		if (!dauData || dauData.length === 0) {
			wrapper.innerHTML = '<p class="stats-placeholder">선택한 기간에 해당하는 유저 활동 데이터가 없습니다.</p>';
			return;
		}

		// HTML 구조 통합 및 KPI 카드 삽입 (wrapper 내부에 삽입) 🚨
		wrapper.innerHTML = `
		<div class="kpi-row-activity">
		        <div class="kpi-card-activity">
		            <div class="kpi-title">실시간 접속 유저</div>
		            <div class="kpi-value kpi-realtime">${kpiData.realtimeUsers || 0} <span style="font-size:1rem">명</span></div>
		        </div>
		        <div class="kpi-card-activity">
		            <div class="kpi-title">오늘 신규 가입</div>
		            <div class="kpi-value kpi-signups">${kpiData.todaySignups || 0} <span style="font-size:1rem">명</span></div>
		        </div>
		        <div class="kpi-card-activity">
		            <div class="kpi-title">오늘 게임 플레이</div>
		            <div class="kpi-value kpi-plays">${kpiData.todayPlays || 0} <span style="font-size:1rem">회</span></div>
		        </div>
		        <div class="kpi-card-activity">
		            <div class="kpi-title">오늘 새 콘텐츠</div>
		            <div class="kpi-value kpi-contents">${kpiData.todayContents || 0} <span style="font-size:1rem">건</span></div>
		        </div>
		    </div>
		    
		    <div class="chart-row-activity">
		        <div class="chart-wrapper-activity"><canvas id="statsChart_DAU"></canvas></div>
		        <div class="chart-wrapper-activity"><canvas id="statsChart_NewVsDel"></canvas></div>
		        <div class="chart-wrapper-activity"><canvas id="statsChart_CommunityMix"></canvas></div> 
		    </div>
		    
		    <div class="chart-row-activity-secondary">
		        <div class="chart-wrapper-activity-secondary"><canvas id="statsChart_RatingDist"></canvas></div>
		        <div class="chart-wrapper-activity-secondary"><canvas id="statsChart_PlaytimeHeatmap"></canvas></div>
		    </div>
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
					fill: true,
					backgroundColor: areaColor.replace('1', '0.2'),
					borderColor: areaColor,
					tension: 0.4, pointRadius: 3, pointHoverRadius: 5
				}]
			},
			options: this.getChartOptions('x', '일간 활성 유저 (DAU)', true)
		});

		// --- 차트 2: 가입 vs 재방문 (Combined Bar/Line Chart) ---
		const newUserChartData = this.extractChartData(newData, "VALUE");
		const returningUserChartData = this.extractChartData(delData, "VALUE");

		const newUserColor = 'rgba(54, 162, 235, 1)'; // 파란색 (Bar)
		const returningUserColor = 'rgba(255, 159, 64, 1)'; // 주황색 (Line)

		this.charts.chart2 = new Chart(document.getElementById('statsChart_NewVsDel'), {
			type: 'bar',
			data: {
				labels: newUserChartData.labels,
				datasets: [
					{
						label: '일일 신규 가입자',
						data: newUserChartData.values,
						backgroundColor: newUserColor.replace('1', '0.7'),
						type: 'bar',
						order: 2
					},
					{
						label: '일일 재방문 플레이어',
						data: returningUserChartData.values,
						borderColor: returningUserColor,
						type: 'line',
						fill: false, tension: 0.4, pointRadius: 3, pointHoverRadius: 5,
						order: 1
					}
				]
			},
			options: this.getChartOptions('x', '일일 신규 가입 vs 재방문 추이', true)
		});

		// --- 차트 3: 커뮤니티 활성도 믹스 (Donut Chart) ---
		let communityLabels = [];
		let communityValues = [];

		const canvas3 = document.getElementById('statsChart_CommunityMix');

		if (communityMixData && typeof communityMixData === 'object' && Object.keys(communityMixData).length > 0) {
			// 키 이름(POSTS_COUNT, REVIEWS_COUNT, REPLIES_COUNT)을 한글 레이블로 변환
			const keyMap = {
				'POSTS_COUNT': '게시글 수',
				'REVIEWS_COUNT': '리뷰 수',
				'REPLIES_COUNT': '댓글 수'
			};

			// 키와 값 추출
			Object.keys(communityMixData).forEach(key => {
				communityLabels.push(keyMap[key] || key);
				communityValues.push(communityMixData[key] || 0);
			});

			this.charts.chart3 = new Chart(canvas3, {
				type: 'doughnut',
				data: {
					labels: communityLabels,
					datasets: [{
						data: communityValues,
						backgroundColor: [
							'rgba(108, 92, 231, 1)',
							'rgba(0, 188, 212, 1)',
							'rgba(255, 159, 64, 1)'
						],
						borderWidth: 1
					}]
				},
				options: {
					responsive: true,
					maintainAspectRatio: false,
					plugins: {
						legend: { display: true, position: 'right', labels: { color: '#ffffff' } },
						title: { display: true, text: '커뮤니티 활성도 믹스', color: '#ffffff', font: { size: 14 } }
					}
				}
			});

		} else {
			// 데이터가 없을 경우 Placeholder 유지
			const placeholderDiv = document.createElement('div');
			placeholderDiv.style.cssText = 'position: absolute; width: 100%; height: 100%; display: flex; align-items: center; justify-content: center; color: #a0a0c0; font-size: 1.1rem;';
			placeholderDiv.textContent = '커뮤니티 데이터 없음';
			canvas3.parentElement.appendChild(placeholderDiv);
		}

		// --- 차트 4: 리뷰 평점 분포 (Horizontal Bar Chart) ---
		if (ratingDistData && ratingDistData.length > 0) {
			const ratingLabels = ratingDistData.map(item => `${item.RATING}점`);
			const ratingCounts = ratingDistData.map(item => item.COUNT);

			this.charts.chart4 = new Chart(document.getElementById('statsChart_RatingDist'), {
				type: 'bar',
				data: {
					labels: ratingLabels,
					datasets: [{
						label: '리뷰 수',
						data: ratingCounts,
						backgroundColor: 'rgba(255, 206, 86, 0.8)',
						barPercentage: 0.8
					}]
				},
				options: this.getChartOptions('x', '리뷰 평점 분포', true)
			});
		}

		// --- 차트 5: 플레이타임 히트맵 (Placeholder) ---
		const heatmapCanvas = document.getElementById('statsChart_PlaytimeHeatmap');
		if (Array.isArray(playtimeHeatmapData) && playtimeHeatmapData.length > 0) {

			// 데이터 가공 (기존 로직 유지)
			const totalPlaysByHour = {};
			const hourLabels = Array.from({ length: 24 }, (_, i) => String(i).padStart(2, '0'));

			playtimeHeatmapData.forEach(item => {
				const hour = item.HOUR_OF_DAY;
				const count = item.COUNT;
				totalPlaysByHour[hour] = (totalPlaysByHour[hour] || 0) + count;
			});

			const playCounts = hourLabels.map(hour => totalPlaysByHour[hour] || 0);

			this.charts.chart5 = new Chart(heatmapCanvas, {
				type: 'bar',
				data: {
					labels: hourLabels.map(h => `${h}시`),
					datasets: [{
						label: '시간대별 플레이 총합',
						data: playCounts,
						backgroundColor: 'rgba(64, 186, 255, 0.7)',
					}]
				},
				options: this.getChartOptions('x', '플레이타임 히트맵 (시간대별 총합)', false)
			});
		} else if (heatmapCanvas) { // 데이터가 없는 경우만 Placeholder를 출력합니다.
			const placeholderDiv = document.createElement('div');
			placeholderDiv.style.cssText = 'position: absolute; width: 100%; height: 100%; display: flex; align-items: center; justify-content: center; color: #a0a0c0; font-size: 1.1rem;';
			placeholderDiv.textContent = '플레이타임 히트맵 데이터 없음';
			heatmapCanvas.parentElement.appendChild(placeholderDiv);
		}
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

		// ... (차트 옵션 코드 생략: 변경 없음)
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