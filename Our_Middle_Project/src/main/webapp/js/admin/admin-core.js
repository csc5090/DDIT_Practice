// admin-core.js (수정본 - if (window.Page) 버그 완전 제거)

const AdminCore = {
	init: function() {
		this.addEventHandlers();
	},

	addEventHandlers: function() {
		const sidebar = document.querySelector('.sidearea');
		if (sidebar) {
			sidebar.addEventListener('click', this.handleSidebarClick.bind(this));
		}

		this.setupUserProfileDropdown();
		this.highlightInitialMenu();

		// 수동 갱신 버튼 이벤트
		const refreshBtn = document.getElementById('global-refresh-btn');
		if (refreshBtn) {
			refreshBtn.addEventListener('click', this.handleGlobalRefresh.bind(this));
		}
	},

	// '데이터/통계' 페이지 갱신 로직 추가 및 if (window.Page) 버그 제거
	handleGlobalRefresh: function() {
		const activePage = document.querySelector('.bodyArea.active');
		if (!activePage) return;

		const activePageId = activePage.id;
		console.log(`수동 갱신: ${activePageId}`);

		// "if (window.Page)" 검사를 모두 제거하고 함수를 직접 호출
		switch (activePageId) {
			case 'dashboard-main':
				DashboardPage.updateAllStats();
				break;
			case 'user-management':
				UserPage.getList(document.getElementById('user-search-input').value); // 현재 검색어 유지
				break;
			case 'notice-management':
				NoticePage.Start();
				break;
			case 'post-management':
				PostPage.Start();
				break;
			case 'review-management':
				ReviewPage.loadAndRender();
				break;
			case 'stats-main':
				StatsPage.handleRunReport(); // '조회' 버튼 클릭과 동일하게 작동
				break;
		}
	},

	handleSidebarClick: function(e) {
		// --- 사이드바 메뉴 토글 및 하이라이트 처리 ---
		const clickedBigMenu = e.target.closest('.bigmenu-container');
		if (clickedBigMenu) {
			this.sideBarToggleHandle({ currentTarget: clickedBigMenu });
			this.toggleHighlight(clickedBigMenu);
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

			// 페이지 전환 시 갱신 로직 (if (window.Page) 버그 제거)
			if (targetId === 'dashboard-main') {
				DashboardPage.updateAllStats();
			} else if (targetId === 'user-management') {
				UserPage.clearDetailPanel();
				UserPage.getList();
			} else if (targetId === 'review-management') {
				ReviewPage.loadAndRender();
			} else if (targetId === 'notice-management') {
				NoticePage.Start();
			} else if (targetId === 'post-management') {
				PostPage.Start();
			} else if (targetId === 'stats-main') {
				// '데이터/통계' 탭 클릭 시 init()을 호출하여 버튼 이벤트를 연결
				StatsPage.init();
			}
			sessionStorage.setItem('lastView', targetId);
		}
	},

	// 모든 함수를 'key: function() {}' 형태의 메소드로 변경
	sideBarToggleHandle: function(e) {
		let clicked = e.currentTarget;
		let parentLi = clicked.parentElement;
		let childElement = clicked.nextElementSibling;
		this.closeOtherSubmenus(parentLi);

		if (childElement != null && childElement.classList.contains('ul-container-none')) {
			childElement.classList.toggle('active');
			parentLi.classList.toggle('active');
		}
	},

	closeOtherSubmenus: function(currentItem) {
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
	},

	//하이라이트 메뉴 관련
	highlightInitialMenu: function() {

		const lastViewId = sessionStorage.getItem('lastView');
		let targetMenuElement;

		if (lastViewId) {

			targetMenuElement = document.querySelector(`[data-target="${lastViewId}"]`);
		}

		if (!targetMenuElement) {
			targetMenuElement = document.getElementById('dashboard-container');
		}

		if (targetMenuElement) {
			document.querySelectorAll('.nav-big-area').forEach(li => {
				li.classList.remove('active');
				const submenu = li.querySelector('.ul-container-none');
				if (submenu) {
					submenu.classList.remove('active');
				}
			});

			const parentLiToActivate = targetMenuElement.closest('.nav-big-area');

			if (parentLiToActivate) {

				parentLiToActivate.classList.add('active');

				const submenuToOpen = parentLiToActivate.querySelector('.ul-container-none');
				if (submenuToOpen) {
					submenuToOpen.classList.add('active');
				}
			}
		}
	},

	toggleHighlight: function(clickedMenu) {
		let allBigAreas = document.getElementsByClassName('nav-big-area');
		for (let i = 0; i < allBigAreas.length; i++) {
			allBigAreas[i].classList.remove('active');
		}
		let parentLi = clickedMenu.parentElement;
		parentLi.classList.add('active');
	},

	setupUserProfileDropdown: function() {
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
};