// ===============================================================
// ==================== 전역 변수 및 초기화 ====================
// ===============================================================

// common.js에 있을 것으로 예상되는 전역 설정
const PROTOCOL_HOST = "http://localhost:";
const PORT = "8095";
const P_NAME = "/Our_Middle_Project";
const BASE_URL = PROTOCOL_HOST + PORT + P_NAME;

let myChartInstance = null;

/**
 * 페이지가 완전히 로드되었을 때 실행되는 메인 함수
 */
window.onload = () => {
	addEventHandlers(); // 모든 클릭 이벤트를 담당할 핸들러 딱 한 번만 등록
	highlightInitialMenu();

	// 초기 페이지 로딩 시 필요한 데이터 로딩 및 렌더링 작업들
	updateDashboardStats(); // 대시보드 데이터 로딩
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
	if (noticePage) {
		noticePage.addEventListener('click', handleNoticePageClick);
	}

	// 4. 유저 관리 페이지 내부 이벤트 감시자 (클릭, 더블클릭)
	const userManagementPage = document.getElementById('user-management');
	if (userManagementPage) {
		userManagementPage.addEventListener('click', handleUserManagementClick);
		userManagementPage.addEventListener('dblclick', handleUserManagementDblClick);
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

        // '유저 관리' 메뉴를 클릭했을 때, 사용자 목록을 바로 로드합니다.
        if (targetId === 'user-management') {
            getUserList();
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
 * 유저 관리 페이지의 '일반 클릭' 이벤트를 처리하는 함수 (검색, 적용 버튼 등)
 */
function handleUserManagementClick(e) {
    // '검색' 버튼 클릭 시
    if (e.target.closest('#user-search-btn')) {
        const keyword = document.getElementById('user-search-input').value;
        console.log(`'${keyword}'(으)로 사용자를 검색합니다.`);
        getUserList(keyword); // 검색어를 인자로 넘겨 사용자 목록 조회
    }

    // '적용' 버튼 클릭 시
    if (e.target.closest('#detail-apply-btn')) {
        updateUserDetails();
    }
}

/**
 * 유저 관리 페이지의 더블클릭 이벤트를 처리하는 함수
 */
function handleUserManagementDblClick(e) {
	const clickedRow = e.target.closest('.user-list-table tbody tr');
    // 검색 결과 없음 행을 더블클릭한 경우는 무시
	if (!clickedRow || clickedRow.classList.contains('no-results-row')) return;

	const detailPanel = document.querySelector('#user-management .user-detail-panel');
    const emptyMessage = detailPanel.querySelector('.empty-message');
    const detailContent = detailPanel.querySelector('.detail-content');

	// 기존에 선택된 행이 있다면 선택 해제
	const currentSelected = document.querySelector('#user-management .user-list-table tbody tr.selected');
	if(currentSelected) currentSelected.classList.remove('selected');

	// 새로 클릭된 행에 선택 효과 주기
	clickedRow.classList.add('selected');

	// 상세 정보 창 보여주기
	const userId = clickedRow.dataset.userid;
	console.log(userId + " 사용자의 상세 정보를 요청합니다.");
    getUserDetails(userId);

	// UI 변경: 초기 메시지 숨기고, 상세 정보 폼 보여주기
	detailPanel.classList.remove('is-empty');
	emptyMessage.style.display = 'none';
	detailContent.style.display = 'flex';
}


// ===============================================================
// ==================== API 호출 (Axios) =======================
// ===============================================================

/**
 * 서버로부터 전체 또는 검색된 사용자 목록을 가져와 테이블에 렌더링하는 함수
 * @param {string} [keyword=null] - 검색어. 없으면 전체 목록을 가져옵니다.
 */
function getUserList(keyword = null) {
    // 서버에 전송할 데이터. 검색어가 있으면 포함시킵니다.
    const requestData = {};
    if (keyword) {
        requestData.keyword = keyword;
    }

    axios.post(`${BASE_URL}/getUserList.do`, requestData)
        .then(response => {
            renderUserTable(response.data); // 테이블 렌더링 함수 호출
        })
        .catch(error => {
            console.error('사용자 목록 로딩 에러:', error);
            const tableBody = document.getElementById('user-list-tbody');
            tableBody.innerHTML = `
                <tr class="no-results-row">
                    <td colspan="5">사용자 목록을 불러오는 중 오류가 발생했습니다.</td>
                </tr>`;
        });
}

/**
 * 특정 사용자의 상세 정보를 서버로부터 가져와 상세 정보 패널에 채우는 함수
 * @param {string} userId - 상세 정보를 조회할 사용자의 ID
 */
function getUserDetails(userId) {
    axios.post(`${BASE_URL}/getUserDetails.do`, { member_id: userId })
        .then(response => {
            const user = response.data;
            // 가져온 데이터로 폼 채우기
            document.getElementById('detail-user-id').textContent = user.member_id;
            document.getElementById('detail-nickname').value = user.member_name; // DTO 필드명에 맞게 수정 (member_nickname -> member_name)
            document.getElementById('detail-status').value = user.member_status; // (예시)
            document.getElementById('detail-role').value = user.member_role; // (예시)
            document.getElementById('detail-deleted-date').value = user.member_deleted_date || '해당 없음';
            document.getElementById('detail-deleted-reason').value = user.member_deleted_reason || '해당 없음';
        })
        .catch(error => {
            console.error(`${userId} 사용자 상세 정보 로딩 에러:`, error);
            Swal.fire('오류', '사용자 정보를 불러오는 데 실패했습니다.', 'error');
        });
}

/**
 * 상세 정보 패널의 내용을 서버에 전송하여 사용자 정보를 업데이트하는 함수
 */
function updateUserDetails() {
    const userData = {
        member_id: document.getElementById('detail-user-id').textContent,
        member_name: document.getElementById('detail-nickname').value,
        member_status: document.getElementById('detail-status').value,
        member_role: document.getElementById('detail-role').value,
    };

    console.log(`${userData.member_id} 사용자의 정보를 업데이트합니다.`, userData);

    axios.post(`${BASE_URL}/updateUser.do`, userData)
        .then(response => {
            if (response.data.status === 'success') {
                Swal.fire('성공', '사용자 정보가 성공적으로 업데이트되었습니다.', 'success');
                getUserList(); // 정보 업데이트 후 목록 새로고침
            } else {
                throw new Error(response.data.message || '업데이트 실패');
            }
        })
        .catch(error => {
            console.error('사용자 정보 업데이트 에러:', error);
            Swal.fire('오류', '정보 업데이트 중 문제가 발생했습니다.', 'error');
        });
}


/**
 * 대시보드 통계 데이터를 비동기(axios)로 가져와 업데이트하는 함수
 */
async function updateDashboardStats() {
	try {
		// 1-1. axios를 사용하여 데이터를 요청하고 응답을 기다립니다.
		const response = await axios.get(`${BASE_URL}/getStats.do`);

		// 1-2. 응답 데이터를 변수에 저장합니다. axios는 자동으로 JSON을 파싱합니다.
		const data = response.data;
		console.log("서버로부터 받은 데이터:", data);

		renderDashboardChart('myChart'); // 차트 렌더링

		// 2. 성공적으로 데이터를 받으면, id로 위치를 찾아 내용을 채웁니다.
		const totalUsers = data.totalUsers ?? 0;
		const newUsers = data.newUsers ?? 0;
        const totalGames = data.totalGames ?? 0;

		const userCountElement = document.getElementById('total-user-count');
		if (userCountElement) userCountElement.textContent = totalUsers.toLocaleString();

		const newUserCountElement = document.getElementById('new-user-count');
		if (newUserCountElement) newUserCountElement.textContent = newUsers.toLocaleString();

        const gameCountElement = document.getElementById('total-game-count');
        if (gameCountElement) gameCountElement.textContent = totalGames.toLocaleString();

	} catch (error) {
		// 3. 데이터 로딩에 실패하면 콘솔에 에러를 표시하고, 화면에도 오류를 알립니다.
		console.error('통계 데이터 로딩 에러:', error);
		['total-user-count', 'total-game-count', 'new-user-count'].forEach(id => {
			const element = document.getElementById(id);
			if (element) {
				element.textContent = '오류';
				element.style.fontSize = '1.5rem';
			}
		});
	}
}


// ===============================================================
// ==================== UI 렌더링 및 유틸리티 함수 ===================
// ===============================================================

/**
 * 사용자 데이터 배열을 받아와 HTML 테이블로 렌더링하는 함수
 * @param {Array} userList - 서버로부터 받은 사용자 객체 배열
 */
function renderUserTable(userList) {
    const tableBody = document.getElementById('user-list-tbody');
    tableBody.innerHTML = ''; // 기존 내용 초기화

    if (!userList || userList.length === 0) {
        tableBody.innerHTML = `
            <tr class="no-results-row">
                <td colspan="5">표시할 사용자가 없습니다.</td>
            </tr>`;
        return;
    }

    userList.forEach(user => {
        // JSP와 동일한 구조로 테이블 행을 만듭니다.
        const row = document.createElement('tr');
        row.dataset.userid = user.member_id;
        row.innerHTML = `
            <td>${user.member_id}</td>
            <td>${user.member_name}</td>
            <td>${user.member_email}</td>
            <td>${user.member_status || '활성'}</td>
            <td>${user.member_join_date}</td>
        `;
        tableBody.appendChild(row);
    });
}


function sideBarToggleHandle(e) {
	//도저히 이해가 안되서 주석 남기면서 함...
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