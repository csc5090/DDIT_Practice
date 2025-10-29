window.onload = () => {
	addEventHandle();
	renderDashboardChart('myChart');
	highlightInitialMenu();
	setupUserProfileDropdown();
	updateDashboardStats();
};


//도저히 이해가 안되서 주석 남기면서 함...
function addEventHandle() {
	// 사이드바 전체를 감시하여 어떤 메뉴든 클릭을 감지합니다. (이벤트 위임)
	const sidebar = document.querySelector('.sidearea');
	if (!sidebar) return;

	sidebar.addEventListener('click', (e) => {
		// --- 1. 기존 기능: 토글 및 하이라이트 처리 ---
		// 클릭된 곳이 큰 메뉴(.bigmenu-container)의 일부인지 확인합니다.
		const clickedBigMenu = e.target.closest('.bigmenu-container');

		if (clickedBigMenu) {
			// 큰 메뉴를 클릭했다면, 기존의 토글과 하이라이트 기능을 그대로 실행합니다.
			sideBarToggleHandle({ currentTarget: clickedBigMenu });
			toggleHighlight(clickedBigMenu);
		}

		// --- 2. 추가된 기능: 화면 전환(z-index) 처리 ---
		// 클릭된 곳이 화면 전환 기능(data-target)을 가진 메뉴인지 확인합니다.
		const menuWithTarget = e.target.closest('[data-target]');

		if (menuWithTarget) {
			// data-target 값을 읽어옵니다. (예: "dashboard-main")
			const targetId = menuWithTarget.dataset.target;

			// 모든 bodyArea div에서 'active' 클래스를 제거합니다.
			const allBodyAreas = document.querySelectorAll('.bodyArea');
			allBodyAreas.forEach(area => {
				area.classList.remove('active');
			});

			// targetId와 일치하는 id를 가진 div에 'active' 클래스를 추가합니다.
			const targetArea = document.getElementById(targetId);
			if (targetArea) {
				targetArea.classList.add('active');
			}
		}
	});


	//공지사항 관련 js 코드
	const noticeListView = document.getElementById('notice-list-view');
	const noticeEditorView = document.getElementById('notice-editor-view');
	const btnNewNotice = document.getElementById('btn-new-notice');
	const btnBackToList = document.getElementById('btn-back-to-list');

	// '새 공지 작성' 버튼 클릭 시, 목록 숨기고 편집기 표시
	btnNewNotice?.addEventListener('click', () => {
		if (noticeListView && noticeEditorView) {
			noticeListView.style.display = 'none';
			noticeEditorView.style.display = 'flex'; // 또는 'block'
		}
	});

	// '목록으로 돌아가기' 버튼 클릭 시, 편집기 숨기고 목록 표시
	btnBackToList?.addEventListener('click', () => {
		if (noticeListView && noticeEditorView) {
			noticeEditorView.style.display = 'none';
			noticeListView.style.display = 'flex'; // 또는 'block'
		}
	});
}

function loadContent(url) {
	const mainArea = document.querySelector('.main-content-area');

	fetch(url)
		.then(response => {

			if (!response.ok) {
				throw new Error(`HTTP Error! status: ${response.status}`);
			}
			return response.text();
		})

		.then(html => {

			mainArea.innerHTML = html;

			if (url.includes('dashboard.do')) {
				if (typeof renderDashboardChart === 'function') {
					renderDashboardChart('myChart');
				} else {
					console.error("renderDashboardChart 함수 찾기 실패.")
				}
			}
		})
		.catch(error => {
			console.error('Error loading contetnt : ', error);
			mainArea.innerHTML = `<div style="padding: 50px; color: red;">콘텐츠 로드 실패: ${error.message}</div>`;
		});
}

function sideBarToggleHandle(e) {
	let clicked = e.currentTarget;
	let parentLi = clicked.parentElement;
	let childElement = clicked.nextElementSibling;
	closeOtherSubmenus(parentLi);

	if (childElement != null && childElement.classList.contains('ul-container-none')) {
		childElement.classList.toggle('active');

		parentLi.classList.toggle('active');
	}
}

function closeOtherSubmenus(currentItem) {
	let allBigAreas = document.getElementsByClassName('nav-big-area');
	for (let i = 0; i < allBigAreas.length; i++) {
		if (allBigAreas[i] !== currentItem) {
			let submenuToClose = allBigAreas[i].querySelector('.ul-container-none');
			if (submenuToClose) {
				submenuToClose.classList.remove('active');

				allBigAreas[i].classList.remove('active');
			}
		}
	}
}


let myChartInstance = null;

function renderDashboardChart(chartId) {
	const ctx = document.getElementById(chartId);
	if (!ctx) return;

	if (myChartInstance) {
		myChartInstance.destroy();
	}

	// 나중에 DB 데이터로 교체할 부분: 데이터 배열
	const labels = ['신규 가입자', '총 게임 수', '평균 게임 시간', '최원효 조팬 수', '최원효 병신짓 수'];
	const dataValues = [4923, 4788, 62, 52000, 12322];
	const backgroundColors = [
		'rgba(108, 92, 231, 0.8)',
		'rgba(46, 204, 113, 0.8)',
		'rgba(52, 152, 219, 0.8)',
	];


	myChartInstance = new Chart(ctx, {
		type: 'bar',
		data: {
			labels: labels,
			datasets: [{
				label: '주요 통계 지표',
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
				legend: { display: false }
			},
			scales: {
				x: {
					barPercentage: 0.8,
					categoryPercentage: 0.8,
					ticks: { color: '#ffffff' },
					grid: { color: '#3c3c5a' }
				},
				y: {
					beginAtZero: true,
					ticks: { color: '#ffffff' },
					grid: { color: '#3c3c5a' }
				}
			}
		}
	});
}

function highlightInitialMenu() {
	const dashboardContainer = document.getElementById('dashboard-container');


	if (dashboardContainer) {
		const parentLi = dashboardContainer.parentElement;
		if (parentLi) {
			parentLi.classList.add('active');
		}
	}
}

function toggleHighlight(clickedMenu) {

	let allBigAreas = document.getElementsByClassName('nav-big-area');
	for (let i = 0; i < allBigAreas.length; i++) {

		allBigAreas[i].classList.remove('active');
	}

	let parentLi = clickedMenu.parentElement;
	parentLi.classList.add('active');
}

function setupUserProfileDropdown() {
	const userProfile = document.querySelector('.user-profile');
	if (!userProfile) return;

	const toggleButton = userProfile.querySelector('.user-profile-toggle');
	const dropdownMenu = userProfile.querySelector('.user-profile-dropdown');

	toggleButton.addEventListener('click', (e) => {
		e.stopPropagation();
		dropdownMenu.classList.toggle('active');
	});

	window.addEventListener('click', (e) => {
		if (!userProfile.contains(e.target) && dropdownMenu.classList.contains('active')) {
			dropdownMenu.classList.remove('active');
		}
	});
}

async function updateDashboardStats() {
	try {
		// 1-1. 데이터를 요청하고 응답을 기다립니다.
		const response = await fetch(`${CONTEXT_PATH}/getStats.do`);

		// 1-2. 응답이 성공적이지 않으면 에러를 발생시킵니다.
		if (!response.ok) {
			throw new Error(`서버 응답이 올바르지 않습니다. (상태 코드: ${response.status})`);
		}

		// 1-3. 응답을 JSON 형태로 변환하고 기다립니다.
		const data = await response.json();
		console.log(data);

		// 2. 성공적으로 데이터를 받으면, id로 위치를 찾아 내용을 채웁니다.
		// 기능 추가할 때 여기에 먼저 데이터 추출 코드를 넣어야 합니다.
		const totalUsers = data.totalUsers ?? 0;
		const newUsers = data.newUsers ?? 0;

		const userCountElement = document.getElementById('total-user-count');
		if (userCountElement) {
			// toLocaleString()을 사용하면 세 자리마다 콤마가 찍힙니다.
			userCountElement.textContent = totalUsers.toLocaleString();
		}

		// (여기에 "몇 판?", "뉴비 몇 명?" 등 다른 데이터 업데이트 로직도 추가 가능)
		const newUserCountElement = document.getElementById('new-user-count');
		if (newUserCountElement) {
			newUserCountElement.textContent = newUsers.toLocaleString();
		}

		//이 아래로 위와 비슷하게 코드 추가해야합니다.

	} catch (error) {
		// 3. 데이터 로딩에 실패하면 콘솔에 에러를 표시하고, 화면에도 오류를 알립니다.
		// (네트워크 오류, JSON 파싱 오류, throw new Error로 발생시킨 오류 등이 모두 이곳에서 처리됩니다.)
		console.error('통계 데이터 로딩 에러:', error);

		//추가한 기능에 대한 에러 처리도 아래 배열에 추가해야 합니다.
		['total-user-count', 'total-game-count', 'new-user-count'].forEach(id => {
			const element = document.getElementById(id);
			if (element) {
				element.textContent = '오류';
				element.style.fontSize = '1.5rem';
			}
		});
	}
}