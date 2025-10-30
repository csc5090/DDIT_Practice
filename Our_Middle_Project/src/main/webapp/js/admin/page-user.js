// page-user.js

const UserPage = {
	currentList: [],
	currentSort: {
		key: 'regDate',
		order: 'desc'
	},
	currentDetailUserId: null,

	init: function() {
		const userManagementPage = document.getElementById('user-management');
		if (userManagementPage) {
			userManagementPage.addEventListener('click', this.handleClick.bind(this));
			userManagementPage.addEventListener('dblclick', this.handleDblClick.bind(this));
		}

		const searchInput = document.getElementById('user-search-input');
		if (searchInput) {
			searchInput.addEventListener('keydown', this.handleSearchEnter.bind(this));
		}


	},

	handleSearchEnter: function(e) {

		if (e.key === 'Enter') {
			e.preventDefault();

			const keyword = e.target.value;
			this.getList(keyword);
		}
	},

	clearDetailPanel: function() {
		const header = document.querySelector('.user-detail-panel .detail-header');
		if (header) {
			header.innerHTML = '<h2 id="detail-user-id"></h2><p class="header-guideline">편집할 유저를 더블클릭하세요.</p>';
		}
		document.getElementById('detail-nickname').value = '';
		document.getElementById('detail-status').value = 'ACTIVE';
		document.getElementById('detail-role').value = 'USER';
		document.getElementById('detail-email').value = '';
		document.getElementById('detail-gender').value = '';
		document.getElementById('detail-birth').value = '';
		document.getElementById('detail-hp').value = '';
		document.getElementById('detail-zip').value = '';
		document.getElementById('detail-add1').value = '';
		document.getElementById('detail-add2').value = '';
		document.getElementById('detail-deleted-date').value = '';
		document.getElementById('detail-deleted-reason').value = '';

		this.currentDetailUserId = null;
		const currentSelected = document.querySelector('#user-management .user-list-table tbody tr.selected');
		if (currentSelected) currentSelected.classList.remove('selected');
	},

	handleClick: function(e) {
		if (e.target.closest('#user-search-btn')) {
			this.getList(document.getElementById('user-search-input').value);
			return;
		}
		const sortHeader = e.target.closest('.sortable');
		if (sortHeader) {
			const clickedKey = sortHeader.dataset.sortKey;
			let newOrder = 'asc';
			if (this.currentSort.key === clickedKey) {
				newOrder = (this.currentSort.order === 'asc' ? 'desc' : 'asc');
			}
			this.currentSort.key = clickedKey;
			this.currentSort.order = newOrder;
			this.sortAndRenderTable(clickedKey, newOrder);
			return;
		}
		if (e.target.closest('#detail-apply-btn')) {
			this.updateDetails();
		}
	},

	handleDblClick: function(e) {
		const clickedRow = e.target.closest('.user-list-table tbody tr');
		if (!clickedRow || clickedRow.classList.contains('no-results-row')) return;
		this.showDetailPanel(clickedRow);
		this.getDetails(clickedRow.dataset.userid);
	},

	getList: async function(keyword = null) {
		try {
			const params = keyword ? { keyword } : {};
			this.currentList = await apiClient.post('/getUserList.do', null, { params });
			this.sortAndRenderTable(this.currentSort.key, this.currentSort.order);
		} catch (error) {
			console.error('사용자 목록 로딩 에러:', error);
			const tableBody = document.getElementById('user-list-tbody');
			if (tableBody) tableBody.innerHTML = `<tr class="no-results-row"><td colspan="5">목록 로딩 중 오류 발생</td></tr>`;
		}
	},

	sortAndRenderTable: function(key, order) {
		if (!this.currentList || this.currentList.length === 0) {
			this.renderTable([]);
			return;
		}
		this.currentList.sort((a, b) => {
			const valA = a[key];
			const valB = b[key];
			let compareResult = 0;
			if (key === 'userId' || key === 'nickname' || key === 'userMail') {
				const partA = (key === 'userMail' && valA) ? valA.split('@')[0] : valA;
				const partB = (key === 'userMail' && valB) ? valB.split('@')[0] : valB;
				const numA = parseInt((partA || '').replace(/[^0-9]/g, '') || 0);
				const numB = parseInt((partB || '').replace(/[^0-9]/g, '') || 0);
				if (numA < numB) compareResult = -1;
				else if (numA > numB) compareResult = 1;
			} else if (key === 'regDate') {
				const dateA = new Date(valA);
				const dateB = new Date(valB);
				if (dateA < dateB) compareResult = -1;
				else if (dateA > dateB) compareResult = 1;
			} else if (typeof valA === 'string' && typeof valB === 'string') {
				compareResult = valA.localeCompare(valB);
			} else {
				if (valA < valB) compareResult = -1;
				else if (valA > valB) compareResult = 1;
			}
			return (order === 'asc' ? compareResult : compareResult * -1);
		});
		this.updateSortIcons(key, order);
		this.renderTable(this.currentList);
	},

	updateSortIcons: function(key, order) {
		document.querySelectorAll('.sortable').forEach(th => {
			const icon = th.querySelector('.sort-icon');
			if (icon) {
				th.dataset.sortOrder = 'none';
				icon.textContent = '';
			}
		});
		const activeHeader = document.querySelector(`.sortable[data-sort-key="${key}"]`);
		if (activeHeader) {
			const icon = activeHeader.querySelector('.sort-icon');
			if (icon) {
				activeHeader.dataset.sortOrder = order;
				icon.textContent = (order === 'asc' ? ' ▲' : ' ▼');
			}
		}
	},

	getDetails: async function(userId) {
		try {
			const user = await apiClient.post('/getUserDetails.do', { userId: userId });
			this.currentDetailUserId = user.userId;

			const header = document.querySelector('.user-detail-panel .detail-header');
			if (header) {
				header.classList.add('user-selected');
				document.getElementById('detail-user-id').textContent = user.nickname;
			}

			document.getElementById('detail-nickname').value = user.nickname;
			document.getElementById('detail-status').value = user.status;
			document.getElementById('detail-role').value = user.role || 'USER';
			document.getElementById('detail-email').value = user.userMail || '정보 없음';

			const genderValue = user.memGender ? user.memGender.trim() : null;
			document.getElementById('detail-gender').value = (genderValue === 'M' ? '남성' : genderValue === 'F' ? '여성' : '미정');

			document.getElementById('detail-birth').value = user.memBirth || '정보 없음';
			document.getElementById('detail-hp').value = user.memHp || '정보 없음';
			document.getElementById('detail-zip').value = user.memZip || '정보 없음';
			document.getElementById('detail-add1').value = user.memAdd1 || '정보 없음';
			document.getElementById('detail-add2').value = user.memAdd2 || '정보 없음';
			document.getElementById('detail-deleted-date').value = user.deletedDate || '해당 없음';
			document.getElementById('detail-deleted-reason').value = user.deletedReason || '해당 없음';
		} catch (error) {
			console.error(`${userId} 사용자 상세 정보 로딩 에러:`, error);
		}
	},

	updateDetails: async function() {
		if (!this.currentDetailUserId) {
			Swal.fire('오류', '업데이트할 사용자를 선택해주세요.', 'error');
			return;
		}
		const userData = {
			userId: this.currentDetailUserId,
			nickname: document.getElementById('detail-nickname').value,
			status: document.getElementById('detail-status').value,
			role: document.getElementById('detail-role').value
		};
		try {
			const response = await apiClient.post('/updateUser.do', userData);
			if (response && response.status === 'success') {
				await Swal.fire('성공', '사용자 정보가 성공적으로 업데이트되었습니다.', 'success');
				this.getList();
			} else {
				throw new Error(response?.message || '업데이트에 실패했습니다.');
			}
		} catch (error) {
			console.error('사용자 정보 업데이트 에러:', error);
			Swal.fire('오류', error.message, 'error');
		}
	},

	renderTable: function(userList) {
		const tableBody = document.getElementById('user-list-tbody');
		if (!tableBody) return;
		tableBody.innerHTML = '';
		if (!userList || userList.length === 0) {
			tableBody.innerHTML = `<tr class="no-results-row"><td colspan="5">표시할 사용자가 없습니다.</td></tr>`;
			return;
		}
		userList.forEach(user => {
			const row = document.createElement('tr');
			row.dataset.userid = user.userId;
			row.innerHTML = `
	            <td>${user.userId}</td>
				<td>${user.userName}</td>
	            <td>${user.nickname}</td>
	            <td>${user.status || '활성'}</td>
	            <td>${user.regDate}</td>
	        `;
			tableBody.appendChild(row);
		});
	},

	showDetailPanel: function(clickedRow) {
		const currentSelected = document.querySelector('#user-management .user-list-table tbody tr.selected');
		if (currentSelected) currentSelected.classList.remove('selected');
		clickedRow.classList.add('selected');
	}
};

/* //어드민 권한 별 수정 목록 활성,비활성 함수
setFieldPermissions: function(adminRole) {
	const isSuperAdmin = (adminRole === 'SUPER_ADMIN');
	
	//나중에 어드민 따라서 만들기
	
	
	// 닉네임, 상태는 모든 관리자가 수정 가능
	document.getElementById('detail-nickname').readOnly = false;
	document.getElementById('detail-status').disabled = false;

	// 역할(ROLE)은 오직 최고 관리자만 수정 가능
	document.getElementById('detail-role').disabled = !isSuperAdmin;

	// 주소, 이메일 등 개인정보는 수정 불가능 (readonly)
	document.getElementById('detail-email').readOnly = true;
	document.getElementById('detail-add1').readOnly = true;
}*/