// page-notice.js (정렬 기능 추가됨)

const NoticePage = {
	currentList: [],
	currentDetailNoticeNo: null,
	isEditing: false,

	// [추가] 현재 정렬 상태 (user-page.js 스타일)
	currentSort: {
		key: 'created_date', // 기본 정렬 (최신순)
		order: 'desc'
	},

	// admin-core.js에서 호출됨
	init: function() {
		const noticePage = document.getElementById('notice-management');
		if (!noticePage) return;
		noticePage.addEventListener('click', this.handleClick.bind(this));
		noticePage.addEventListener('dblclick', this.handleDblClick.bind(this));
	},

	// admin-core.js가 메뉴 클릭 시 호출
	Start: function() {
		// [수정] 기본 정렬값 초기화
		this.currentSort.key = 'created_date';
		this.currentSort.order = 'desc';

		this.clearDetailPanel();
		this.loadAndRenderList();
	},

	// --- 이벤트 핸들러 ---

	handleClick: function(e) {

		// [추가] 정렬 헤더 클릭 처리
		const sortHeader = e.target.closest('.sortable');
		if (sortHeader) {
			const clickedKey = sortHeader.dataset.sortKey;
			let newOrder = 'asc';
			if (this.currentSort.key === clickedKey) {
				newOrder = (this.currentSort.order === 'asc' ? 'desc' : 'asc');
			}
			this.currentSort.key = clickedKey;
			this.currentSort.order = newOrder;

			// API 다시 부르지 않고 JS로 정렬 후 렌더링
			this.sortAndRenderList(clickedKey, newOrder);
			return;
		}

		// --- 기존 버튼 핸들러 ---
		if (e.target.closest('#notice-new-btn')) {
			this.handleNewClick();
		}
		else if (e.target.closest('#notice-save-btn')) {
			this.handleSaveOrUpdate();
		}
		else if (e.target.closest('#notice-delete-btn')) {
			this.handleDelete();
		}
		else if (e.target.closest('#notice-cancel-btn')) {
			this.clearDetailPanel();
		}
	},

	handleDblClick: function(e) {
		const clickedRow = e.target.closest('.user-list-table tbody tr');
		if (!clickedRow || !clickedRow.dataset.noticeNo) return;
		this.showDetailPanel(clickedRow);
		const boardNo = clickedRow.dataset.noticeNo;
		this.loadDetails(boardNo);
	},

	// --- 패널 제어 로직 (기존과 동일) ---
	handleNewClick: function() {
		this.clearDetailPanel();
		this.isEditing = false;
		this.currentDetailNoticeNo = null;
		const header = document.querySelector('#notice-management .detail-header');
		if (header) {
			header.classList.add('user-selected');
			document.getElementById('detail-notice-header').textContent = '새 공지사항 작성';
		}
		document.getElementById('notice-save-btn').textContent = '저장하기';
		document.getElementById('notice-delete-btn').style.display = 'none';
	},
	loadDetails: function(boardNo) {
		this.isEditing = true;
		this.currentDetailNoticeNo = boardNo;
		const notice = this.currentList.find(n => n.board_no == boardNo);
		if (notice) {
			const header = document.querySelector('#notice-management .detail-header');
			if (header) {
				header.classList.add('user-selected');
				document.getElementById('detail-notice-header').textContent = `공지사항 수정 (No.${boardNo})`;
			}
			document.getElementById('notice-title').value = notice.board_title || '';
			document.getElementById('notice-content').value = notice.board_content || '';
			document.getElementById('notice-delete-btn').style.display = 'block';
			document.getElementById('notice-save-btn').textContent = '수정 완료';
		} else {
			Swal.fire('오류', '해당 공지사항 정보를 찾을 수 없습니다.', 'error');
			this.clearDetailPanel();
		}
	},
	clearDetailPanel: function() {
		this.currentDetailNoticeNo = null;
		this.isEditing = false;
		const header = document.querySelector('#notice-management .detail-header');
		if (header) {
			header.classList.remove('user-selected');
			document.getElementById('detail-notice-header').textContent = '';
		}
		document.getElementById('notice-title').value = '';
		document.getElementById('notice-content').value = '';
		document.getElementById('notice-save-btn').textContent = '저장하기';
		document.getElementById('notice-delete-btn').style.display = 'none';
		const currentSelected = document.querySelector('#notice-management .user-list-table tbody tr.selected');
		if (currentSelected) currentSelected.classList.remove('selected');
	},
	showDetailPanel: function(clickedRow) {
		const currentSelected = document.querySelector('#notice-management .user-list-table tbody tr.selected');
		if (currentSelected) currentSelected.classList.remove('selected');
		clickedRow.classList.add('selected');
	},

	// --- CRUD 로직 ---

	loadAndRenderList: async function() {
		try {
			this.currentList = await apiClient.post('/getAdminNoticeList.do', null);
			// 불러온 데이터를 기본 정렬값으로 정렬
			this.sortAndRenderList(this.currentSort.key, this.currentSort.order);
		} catch (error) {
			console.error("공지사항 목록 로딩 실패:", error);
			const tableBody = document.querySelector('#notice-management .user-list-table tbody');
			if (tableBody) tableBody.innerHTML = `<tr><td colspan="3" style="text-align:center; padding: 40px;">공지사항 목록을 불러오는 데 실패했습니다.</td></tr>`;
		}
	},

	// 정렬 함수
	sortAndRenderList: function(key, order) {
		if (!this.currentList || this.currentList.length === 0) {
			this.renderList();
			return;
		}

		// JS .sort()
		this.currentList.sort((a, b) => {
			const valA = a[key];
			const valB = b[key];
			let compareResult = 0;

			if (key === 'created_date') {
				// 'YYYY-MM-DD HH24:MI' 형식의 문자열을 Date 객체로 변환
				const dateA = new Date(valA.replace(' ', 'T'));
				const dateB = new Date(valB.replace(' ', 'T'));
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

		this.updateSortIcons(key, order); // 아이콘 업데이트
		this.renderList(); // 다시 렌더링
	},

	// [신규] 아이콘 업데이트 함수 (user-page.js 스타일)
	updateSortIcons: function(key, order) {
		document.querySelectorAll('#notice-management .sortable').forEach(th => {
			const icon = th.querySelector('.sort-icon');
			if (icon) {
				th.dataset.sortOrder = 'none';
				icon.textContent = ''; // 모든 아이콘 초기화
			}
		});
		const activeHeader = document.querySelector(`#notice-management .sortable[data-sort-key="${key}"]`);
		if (activeHeader) {
			const icon = activeHeader.querySelector('.sort-icon');
			if (icon) {
				activeHeader.dataset.sortOrder = order;
				icon.textContent = (order === 'asc' ? ' ▲' : ' ▼'); // 활성 아이콘 표시
			}
		}
	},

	renderList: function() {
		const tableBody = document.querySelector('#notice-management .user-list-table tbody');
		if (!tableBody) return;

		// [수정] this.currentList는 이미 정렬된 상태
		let listToRender = this.currentList;

		tableBody.innerHTML = '';
		if (!listToRender || listToRender.length === 0) {
			tableBody.innerHTML = `<tr><td colspan="3" style="text-align:center; padding: 40px;">등록된 공지사항이 없습니다.</td></tr>`;
			return;
		}

		listToRender.forEach(notice => {
			const row = document.createElement('tr');
			row.dataset.noticeNo = notice.board_no;

			// [추가] 현재 선택된 항목 하이라이트 유지
			if (this.currentDetailNoticeNo && notice.board_no == this.currentDetailNoticeNo) {
				row.classList.add('selected');
			}

			row.innerHTML = `
	                <td>${notice.board_title ?? '[제목 없음]'}</td>
	                <td>운영팀</td> 
	                <td>${notice.created_date}</td>
	            `;
			tableBody.appendChild(row);
		});
	},

	// (이하 CRUD API 호출 함수는 기존과 동일)
	handleSaveOrUpdate: function() {
		const title = document.getElementById('notice-title').value;
		const content = document.getElementById('notice-content').value;
		if (title.trim() === '' || content.trim() === '') {
			Swal.fire('경고', '제목과 내용을 모두 입력해주세요.', 'warning');
			return;
		}
		const data = {
			board_no: this.currentDetailNoticeNo,
			board_title: title,
			board_content: content,
		};
		if (this.isEditing) {
			this.updateNotice(data);
		} else {
			this.saveNotice(data);
		}
	},
	handleDelete: function() {
		if (!this.currentDetailNoticeNo) return;
		Swal.fire({
			title: '정말 삭제하시겠습니까?',
			text: "삭제된 공지사항은 복구할 수 없습니다.",
			icon: 'warning',
			showCancelButton: true,
			confirmButtonColor: '#d33',
			confirmButtonText: '영구 삭제',
			cancelButtonText: '취소'
		}).then((result) => {
			if (result.isConfirmed) {
				this.deleteNotice(this.currentDetailNoticeNo);
			}
		});
	},
	saveNotice: async function(data) {
		try {
			await apiClient.post('/adminNoticeWrite.do', data);
			Swal.fire('성공', '공지사항이 등록되었습니다.', 'success');
			this.clearDetailPanel();
			this.loadAndRenderList();
		} catch (error) { /* apiClient가 처리 */ }
	},
	updateNotice: async function(data) {
		try {
			await apiClient.post('/adminNoticeUpdate.do', data);
			Swal.fire('성공', '공지사항이 수정되었습니다.', 'success');
			this.clearDetailPanel();
			this.loadAndRenderList();
		} catch (error) { /* apiClient가 처리 */ }
	},
	deleteNotice: async function(boardNo) {
		try {
			const data = { board_no: boardNo };
			await apiClient.post('/adminNoticeDelete.do', data);
			Swal.fire('삭제 완료!', '공지사항이 삭제되었습니다.', 'success');
			this.clearDetailPanel();
			this.loadAndRenderList();
		} catch (error) {
			console.error("공지사항 삭제 실패:", error);
		}
	}
};