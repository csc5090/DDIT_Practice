const UserPage = {

	// 💡 상태 관리 변수: 현재 표시 중인 리스트와 정렬 기준을 저장
	currentList: [],
	currentSort: {
		key: 'role', // 기본 정렬 키
		order: 'asc'   // 기본 정렬 방향
	},

	currentDetailUserId: null,
	
	
	init: function() {
		const userManagementPage = document.getElementById('user-management');
		if (userManagementPage) {
			userManagementPage.addEventListener('click', this.handleClick.bind(this));
			userManagementPage.addEventListener('dblclick', this.handleDblClick.bind(this));
			this.getList(); // 초기 목록 로드
		}
	},

	handleClick: function(e) {
		// 1. 검색 버튼 클릭 로직
		if (e.target.closest('#user-search-btn')) {
			const keyword = document.getElementById('user-search-input').value;
			this.getList(keyword);
			return; // 이벤트 처리 후 종료
		}

		// 2. 💡 정렬 헤더 클릭 로직
		const sortHeader = e.target.closest('.sortable');
		if (sortHeader) {
			const clickedKey = sortHeader.dataset.sortKey;

			// 정렬 방향 결정 로직 (토글)
			let newOrder = 'asc';
			if (this.currentSort.key === clickedKey) {
				newOrder = (this.currentSort.order === 'asc' ? 'desc' : 'asc');
			}

			// 정렬 상태 업데이트
			this.currentSort.key = clickedKey;
			this.currentSort.order = newOrder;

			// 정렬 및 렌더링 함수 호출
			this.sortAndRenderTable(clickedKey, newOrder);
			return; // 이벤트 처리 후 종료
		}

		// 3. 상세 정보 적용 버튼 클릭 로직
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
			// API 호출 및 응답 데이터 수신
			const userList = await apiClient.post('/getUserList.do', null, { params });

			// 💡 1. 데이터 저장: 서버에서 받은 데이터를 currentList에 저장
			this.currentList = userList;

			// 💡 2. 정렬 함수 호출: 저장된 데이터를 현재 정렬 상태에 따라 정렬하고 렌더링
			this.sortAndRenderTable(this.currentSort.key, this.currentSort.order);

		} catch (error) {
			// 오류 처리
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

		// 💡 배열 정렬 로직 수정
		this.currentList.sort((a, b) => {
			const valA = a[key];
			const valB = b[key];
			let compareResult = 0; // 비교 결과 저장 변수

			// 🚨 'userId' 정렬 시 특별 처리: 숫자 부분만 추출하여 비교
			if (key === 'userId' || key === 'nickname' || key === 'userMail') {

				const partA = (key === 'userMail') ? valA.split('@')[0] : valA;
				const partB = (key === 'userMail') ? valB.split('@')[0] : valB;

				// 정규 표현식으로 문자열 뒤의 숫자만 추출. (예: "USER12" -> 12)
				const numA = parseInt(valA.replace(/[^0-9]/g, '') || 0);
				const numB = parseInt(valB.replace(/[^0-9]/g, '') || 0);

				if (numA < numB) compareResult = -1;
				else if (numA > numB) compareResult = 1;

			} else if (key === 'regDate') {
				// "MM월 DD, YYYY" 형식의 문자열을 Date 객체로 변환하여 비교.
				const dateA = new Date(valA.replace('월', '').replace(',', ''));
				const dateB = new Date(valB.replace('월', '').replace(',', ''));

				if (dateA < dateB) compareResult = -1;
				else if (dateA > dateB) compareResult = 1;

			}

			else if (typeof valA === 'string' && typeof valB === 'string') {
				// 일반적인 문자열 (닉네임, 이름 등) 비교
				compareResult = valA.localeCompare(valB);

			} else {
				// 숫자/날짜 비교 (숫자가 크면 1, 작으면 -1)
				if (valA < valB) compareResult = -1;
				else if (valA > valB) compareResult = 1;
			}

			// 최종 결과를 정렬 방향(order)에 따라 뒤집거나 그대로 반환
			return (order === 'asc' ? compareResult : compareResult * -1);
		});

		this.updateSortIcons(key, order);
		this.renderTable(this.currentList);
	},

	// 💡 추가된 정렬 아이콘 업데이트 함수
	updateSortIcons: function(key, order) {
		document.querySelectorAll('.sortable').forEach(th => {
			const icon = th.querySelector('.sort-icon');
			th.dataset.sortOrder = 'none';
			icon.textContent = '';
		});

		const activeHeader = document.querySelector(`.sortable[data-sort-key="${key}"]`);
		if (activeHeader) {
			activeHeader.dataset.sortOrder = order;
			const icon = activeHeader.querySelector('.sort-icon');
			icon.textContent = (order === 'asc' ? ' ▲' : ' ▼');
		}
	},


	getDetails: async function(userId) {
		try {
			const user = await apiClient.post('/getUserDetails.do', { userId: userId });
			document.getElementById('detail-user-id').textContent = user.userId;
			document.getElementById('detail-nickname').value = user.nickname;
			document.getElementById('detail-status').value = user.status;
			document.getElementById('detail-role').value = user.role || 'USER';
			document.getElementById('detail-email').value = user.userMail || '정보 없음';
			document.getElementById('detail-gender').value = (user.gender === 'M' ? '남성' : user.gender === 'F' ? '여성' : '미정');
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

	//유저 정보 업데이트 창
	updateDetails: async function() {
		const userData = {
			userId: document.getElementById('detail-user-id').textContent,
			nickname: document.getElementById('detail-nickname').value,
			status: document.getElementById('detail-status').value,
			role: document.getElementById('detail-role').value
		};


		try {
			const response = await apiClient.post('/updateUser.do', userData);

			if (response.status === 'success') {
				await Swal.fire('성공', '사용자 정보가 성공적으로 업데이트되었습니다.', 'success');
				this.getList();
			} else {
				throw new Error(response.data.message || '업데이트에 실패했습니다.');
			}
		} catch (error) {
			console.error('사용자 정보 업데이트 에러:', error);
			console.error('사용자 정보 업데이트 에러:', error);
			Swal.fire('오류', error.message, 'error');
		}
	},

	renderTable: function(userList) {
		const tableBody = document.getElementById('user-list-tbody');
		if (!tableBody) return;
		tableBody.innerHTML = '';

		if (!userList || userList.length === 0) {
			tableBody.innerHTML = `<tr class="no-results-row"><td colspan="5">표시할 사용자가 없습니다.</td></tr>`; // 💡 colspan 6으로 변경 (컬럼 개수 맞춤)
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

};