// admin-core.js

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
    },

    handleSidebarClick: function(e) {
		// --- 사이드바 메뉴 토글 및 하이라이트 처리 ---
		const clickedBigMenu = e.target.closest('.bigmenu-container');
		if (clickedBigMenu) {
            // 2. 같은 객체 내의 다른 메소드를 호출할 때는 'this.' 사용
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
			
			
			if (targetId === 'user-management') {
			            UserPage.getList();
			        }
			
		}
    },
    
    // 1. 모든 함수를 'key: function() {}' 형태의 메소드로 변경
	sideBarToggleHandle: function(e) {
		let clicked = e.currentTarget;
		let parentLi = clicked.parentElement;
		let childElement = clicked.nextElementSibling;
		this.closeOtherSubmenus(parentLi); // 'this.' 추가

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
	
	highlightInitialMenu: function() {
		const dashboardContainer = document.getElementById('dashboard-container');
		if (dashboardContainer) {
			const parentLi = dashboardContainer.parentElement;
			if (parentLi) {
				parentLi.classList.add('active');
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