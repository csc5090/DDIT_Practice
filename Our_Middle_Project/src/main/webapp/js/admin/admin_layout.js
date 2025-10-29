// ===============================================================
// ==================== 전역 변수 및 초기화 ====================
// ===============================================================

let myChartInstance = null;

/**
 * 페이지가 완전히 로드되었을 때 실행되는 메인 함수
 */
window.onload = () => {
	addEventHandlers(); // 모든 클릭 이벤트를 담당할 핸들러 딱 한 번만 등록
	highlightInitialMenu();
	
	// 초기 페이지 로딩 시 필요한 데이터 로딩 및 렌더링 작업들
	updateDashboardStats();
};


// ===============================================================
// ==================== 이벤트 핸들링 (중앙 관제실) ====================
// ===============================================================

/**
 * 모든 클릭 이벤트를 중앙에서 관리하는 함수 (이벤트 위임)
 * 이 함수는 페이지가 로드될 때 딱 한 번만 호출되어, 각 구역의 감시자를 배치합니다.
 */
function addEventHandlers() {
	// 1. 사이드바 메뉴 클릭 감시자
	const sidebar = document.querySelector('.sidearea');
	if (sidebar) {
		sidebar.addEventListener('click', handleSidebarClick);
	}
	
	// 2. 헤더의 유저 프로필 클릭 감시자
	setupUserProfileDropdown();
	
	// 3. 공지사항 페이지 내부 클릭 감시자
	const noticePage = document.getElementById('notice-management');
	if(noticePage) {
		noticePage.addEventListener('click', handleNoticePageClick);
	}
	
	// 4. 유저 관리 페이지 내부 이벤트 감시자 (더블클릭)
	const userManagementPage = document.getElementById('user-management');
	if(userManagementPage) {
		
		userManagementPage.addEventListener('click', handleUserManagementClick);
		userManagementPage.addEventListener('dblclick', handleUserManagementDblClick);
		// (나중에 검색 버튼 등 다른 이벤트도 여기에 추가)
	}
}

/**
 * 사이드바 메뉴 클릭 시 실행되는 함수
 */
function handleSidebarClick(e) {
	// --- 사이드바 메뉴 토글 및 하이라이트 처리 ---
	const clickedBigMenu = e.target.closest('.bigmenu-container');
	if (clickedBigMenu) {
		sideBarToggleHandle({ currentTarget: clickedBigMenu });
		toggleHighlight(clickedBigMenu);
	}
	
	// --- 콘텐츠 뷰(z-index) 전환 처리 ---
	const menuWithTarget = e.target.closest('[data-target]');
	if (menuWithTarget) {
		const targetId = menuWithTarget.dataset.target;

		document.querySelectorAll('.bodyArea').forEach(area => {
			area.classList.remove('active');
		});
		const targetArea = document.getElementById(targetId);
		if (targetArea) {
			targetArea.classList.add('active');
		}
	}
}


// ===============================================================
// ==================== 페이지별 기능 함수 =======================
// ===============================================================

/**
 * 공지사항 페이지 내부의 클릭 이벤트를 처리하는 함수
 */
function handleNoticePageClick(e) {
	const noticeListView = document.getElementById('notice-list-view');
	const noticeEditorView = document.getElementById('notice-editor-view');
	
	// '새 글 작성' 버튼을 클릭했는지 확인
	if (e.target.closest('#btn-new-notice')) {
		noticeListView.style.display = 'none';
		noticeEditorView.style.display = 'flex';
	}
	
	// '목록으로' 버튼을 클릭했는지 확인
	if (e.target.closest('#btn-back-to-list')) {
		noticeEditorView.style.display = 'none';
		noticeListView.style.display = 'flex';
	}
}

/**
 * 유저 관리 페이지의 더블클릭 이벤트를 처리하는 함수
 */
function handleUserManagementDblClick(e) {
	const clickedRow = e.target.closest('.user-list-table tbody tr');
	if (!clickedRow) return;

	const detailPanel = document.querySelector('#user-management .user-detail-panel');
    const emptyMessage = detailPanel.querySelector('.empty-message');
    const detailContent = detailPanel.querySelector('.detail-content');

	// 기존에 선택된 행이 있다면 선택 해제
	const currentSelected = document.querySelector('#user-management .user-list-table tbody tr.selected');
	if(currentSelected) currentSelected.classList.remove('selected');
	
	// 새로 클릭된 행에 선택 효과 주기
	clickedRow.classList.add('selected');

	// 6번 영역: 상세 정보 창 보여주기
	const userId = clickedRow.dataset.userid; // tr에 data-userid가 있어야 함
	console.log(userId + " 사용자의 상세 정보를 표시합니다.");

	// (실제로는 여기서 axios로 userId의 상세 데이터를 요청해야 함)
	
	// UI 변경: 초기 메시지 숨기고, 상세 정보 폼 보여주기
	detailPanel.classList.remove('is-empty');
	emptyMessage.style.display = 'none';
	detailContent.style.display = 'flex';
	
	// (axios 응답 성공 후) 가져온 데이터로 폼 채우기
	document.getElementById('detail-user-id').textContent = userId;
	// document.getElementById('detail-nickname').value = data.nickname;
	// ...
}

/**
 * 유저 관리 페이지의 '일반 클릭' 이벤트를 처리하는 함수 (검색, 적용 버튼 등)
 */
function handleUserManagementClick(e) {
    // 1번: '검색' 버튼 클릭 시
    if (e.target.closest('#user-search-btn')) {
        const keyword = document.getElementById('user-search-input').value;
        console.log(`'${keyword}'(으)로 사용자를 검색합니다.`);
        searchUsers(keyword); // 아래에 새로 추가할 axios(fetch) 함수 호출
    }

    // 5번: '적용' 버튼 클릭 시
    if (e.target.closest('#detail-apply-btn')) {
        const userId = document.getElementById('detail-user-id').textContent;
        console.log(`${userId} 사용자의 정보를 업데이트합니다.`);
        // updateUserDetails(userId); // 아래에 새로 추가할 axios(fetch) 함수 호출
    }
}


// ===============================================================
// ==================== 개별 기능 함수들 (기존 코드) ====================
// ===============================================================

//도저히 이해가 안되서 주석 남기면서 함... (-> 이 주석은 addEventHandle에서 이곳으로 이동되었습니다)
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
		console.log("서버로부터 받은 데이터:", data);
		
		renderDashboardChart('myChart');

		// 2. 성공적으로 데이터를 받으면, id로 위치를 찾아 내용을 채웁니다.
		// 기능 추가할 때 여기에 먼저 데이터 추출 코드를 넣어야 합니다.
		const totalUsers = data.totalUsers ?? 0;
		const newUsers = data.newUsers ?? 0;
        const totalGames = data.totalGames ?? 0; // 예시로 게임 수 추가

		const userCountElement = document.getElementById('total-user-count');
		if (userCountElement) {
			userCountElement.textContent = totalUsers.toLocaleString();
		}

		const newUserCountElement = document.getElementById('new-user-count');
		if (newUserCountElement) {
			newUserCountElement.textContent = newUsers.toLocaleString();
		}
        
        //이 아래로 위와 비슷하게 코드 추가해야합니다.
        // const gameCountElement = document.getElementById('total-game-count');
        // if (gameCountElement) {
        //     gameCountElement.textContent = totalGames.toLocaleString();
        // }

	} catch (error) {
		// 3. 데이터 로딩에 실패하면 콘솔에 에러를 표시하고, 화면에도 오류를 알립니다.
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
			plugins: { legend: { display: false } },
			scales: {
				x: { ticks: { color: '#ffffff' }, grid: { color: '#3c3c5a' } },
				y: { beginAtZero: true, ticks: { color: '#ffffff' }, grid: { color: '#3c3c5a' } }
			}
		}
	});
}