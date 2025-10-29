// page-user.js

const UserPage = {
	init: function() {
		const userManagementPage = document.getElementById('user-management');
		if (userManagementPage) {
			userManagementPage.addEventListener('click', this.handleClick.bind(this));
			userManagementPage.addEventListener('dblclick', this.handleDblClick.bind(this));
			this.getList();
		}
	},

	handleClick: function(e) {
		if (e.target.closest('#user-search-btn')) {
			const keyword = document.getElementById('user-search-input').value;
			this.getList(keyword);
		}
		if (e.target.closest('#detail-apply-btn')) {
			this.updateDetails();
		}
	},

	handleDblClick: function(e) {
		const clickedRow = e.target.closest('.user-list-table tbody tr');
		if (!clickedRow || clickedRow.classList.contains('no-results-row')) return;
        const userId = clickedRow.dataset.userid;
		this.getDetails(userId);
        this.showDetailPanel(clickedRow);
	},

	getList: async function(keyword = null) {
		try {
            const params = keyword ? { keyword } : {};
            // apiClient를 사용하고, baseURL이 빠진 경로만 입력합니다.
			const userList = await apiClient.post('/getUserList.do', null, { params });
            // 인터셉터 덕분에 userList 변수에는 이미 response.data가 담겨 있습니다.
			this.renderTable(userList);
		} catch (error) {
            // apiClient의 인터셉터가 이미 에러 알림창을 띄워주므로, 여기서는 UI 처리만 합니다.
			console.error('사용자 목록 로딩 에러:', error);
			const tableBody = document.getElementById('user-list-tbody');
			if(tableBody) tableBody.innerHTML = `<tr class="no-results-row"><td colspan="5">목록 로딩 중 오류 발생</td></tr>`;
		}
	},

	getDetails: async function(userId) {
		try {
			const user = await apiClient.post('/getUserDetails.do', { member_id: userId });
			document.getElementById('detail-user-id').textContent = user.member_id;
			document.getElementById('detail-nickname').value = user.member_name;
			document.getElementById('detail-status').value = user.member_status;
			document.getElementById('detail-role').value = user.member_role;
			document.getElementById('detail-deleted-date').value = user.member_deleted_date || '해당 없음';
			document.getElementById('detail-deleted-reason').value = user.member_deleted_reason || '해당 없음';
		} catch (error) {
            // 에러 처리는 인터셉터가 담당하므로 catch 블록이 비어있어도 괜찮습니다.
			console.error(`${userId} 사용자 상세 정보 로딩 에러:`, error);
		}
	},

	updateDetails: async function() {
		const userData = {
			member_id: document.getElementById('detail-user-id').textContent,
			member_name: document.getElementById('detail-nickname').value,
			member_status: document.getElementById('detail-status').value,
			member_role: document.getElementById('detail-role').value,
		};
		try {
			const response = await apiClient.post('/updateUser.do', userData);
			if (response.status === 'success') {
				Swal.fire('성공', '사용자 정보가 성공적으로 업데이트되었습니다.', 'success');
				this.getList();
			} else {
                // 서버에서 status:'fail' 등을 보냈을 경우를 대비한 처리
				throw new Error(response.message || '업데이트 실패');
			}
		} catch (error) {
			console.error('사용자 정보 업데이트 에러:', error);
            if(error.response === undefined){ // 위에서 throw new Error로 직접 발생시킨 에러 처리
                Swal.fire('오류', error.message, 'error');
            }
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
	            <td>${user.nickname}</td>
	            <td>${user.memberEmail || '-'}</td>
	            <td>${user.status || '활성'}</td>
	            <td>${user.regDate}</td>
	        `;
			tableBody.appendChild(row);
		});
	},
    
    showDetailPanel: function(clickedRow) {
        const detailPanel = document.querySelector('#user-management .user-detail-panel');
        if (!detailPanel) return;
        const emptyMessage = detailPanel.querySelector('.empty-message');
        const detailContent = detailPanel.querySelector('.detail-content');
        const currentSelected = document.querySelector('#user-management .user-list-table tbody tr.selected');
        if (currentSelected) currentSelected.classList.remove('selected');
        clickedRow.classList.add('selected');
        detailPanel.classList.remove('is-empty');
        if (emptyMessage) emptyMessage.style.display = 'none';
        if (detailContent) detailContent.style.display = 'flex';
    }
};