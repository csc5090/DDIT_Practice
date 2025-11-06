// page-post.js

const PostPage = {
	currentList: [], // API에서 받은 원본 목록
	currentSort: { key: 'created_date', order: 'desc' }, // 기본 정렬 (작성일 내림차순)
	selectedPostNo: null, // 현재 선택된 게시물 번호
	currentComments: [], // 현재 선택된 게시물의 댓글 목록

	init: function() {
		const postPage = document.getElementById('post-management');
		if (!postPage) return;

		// 이벤트 리스너 통합 (클릭, 더블클릭)
		postPage.addEventListener('click', this.handleClick.bind(this));
		postPage.addEventListener('dblclick', this.handleDblClick.bind(this));
	},

	// admin-core.js에서 호출됨
	Start: function() {
		// 페이지가 활성화될 때 목록 로드 및 패널 초기화
		this.clearDetailPanel();
		this.loadAndRender();
	},

	// --- 이벤트 핸들러 ---

	handleClick: function(e) {
		const target = e.target;

		// 1. 정렬 헤더 클릭
		const sortHeader = target.closest('.sortable');
		if (sortHeader) {
			e.preventDefault();
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

		// 2. '삭제' 버튼 (게시물)
		const deleteButton = target.closest('[data-action="delete-post"]');
		if (deleteButton) {
			e.preventDefault();
			const boardNo = deleteButton.dataset.id;
			this.handleDeletePost(boardNo);
			return;
		}

		// 3. '수정' 버튼 (게시물) 또는 제목 클릭
		//  data-action="edit" -> "edit-post"
		const editTrigger = target.closest('[data-action="edit-post"]');
		if (editTrigger) {
			e.preventDefault();
			const boardNo = editTrigger.dataset.id;
			this.showDetailPanel(boardNo);
			return;
		}

		// 4. 오른쪽 패널 '적용' 버튼 (게시물 수정)
		const applyButton = target.closest('#detail-post-apply-btn');
		if (applyButton && this.selectedPostNo) {
			e.preventDefault();
			// [수정] handleUpdate -> handleUpdatePost
			this.handleUpdatePost(this.selectedPostNo);
			return;
		}

		// 5. '삭제' 버튼 (댓글)
		const deleteCommentButton = target.closest('[data-action="delete-comment"]');
		if (deleteCommentButton) {
			e.preventDefault();
			const replyNo = deleteCommentButton.dataset.id;
			this.handleDeleteComment(replyNo);
			return;
		}
	},

	handleDblClick: function(e) {
		// 목록의 행(row)을 더블클릭
		const clickedRow = e.target.closest('.post-list-item');
		if (!clickedRow || clickedRow.classList.contains('no-results-row')) return;

		e.preventDefault();
		const boardNo = clickedRow.dataset.postNo;
		this.showDetailPanel(boardNo);
	},

	// --- 기능별 함수 ---

	loadAndRender: async function() {
		try {
			this.currentList = await apiClient.post('/getAdminPostList.do', null);
			// 기본 정렬(작성일)에 따라 정렬 후 렌더링
			this.sortAndRenderTable(this.currentSort.key, this.currentSort.order);
		} catch (error) {
			console.error("게시물 목록 로딩 실패:", error);
			const tableBody = document.querySelector('#post-list-tbody');
			if (tableBody) tableBody.innerHTML = `<tr class="no-results-row"><td colspan="5" style="text-align:center; padding: 40px;">게시물 목록을 불러오는 데 실패했습니다.</td></tr>`;
		}
	},

	renderList: function() {
		const tableBody = document.querySelector('#post-list-tbody');
		if (!tableBody) return;

		let listToRender = this.currentList; // 정렬된 목록
		tableBody.innerHTML = '';
		if (!listToRender || listToRender.length === 0) {
			tableBody.innerHTML = `<tr class="no-results-row"><td colspan="5" style="text-align:center; padding: 40px;">등록된 게시물이 없습니다.</td></tr>`;
			return;
		}

		const adminGrade = ADMIN_DATA?.nickname ? parseInt(ADMIN_DATA.nickname) : 0;

		listToRender.forEach(post => {
			const row = document.createElement('tr');
			row.className = 'post-list-item';
			row.dataset.postNo = post.board_no;

			if (this.selectedPostNo && post.board_no == this.selectedPostNo) {
				row.classList.add('selected');
			}

			const isDeleted = (post.type_no == 99);
			if (isDeleted) {
				row.classList.add('deleted-post'); // 빨간색 CSS를 위한 클래스
			}

			const canEditDelete = adminGrade >= 1 && adminGrade <= 4;

			// data-action="edit-post", "delete-post"로 변경
			const buttonsHTML = canEditDelete ? `
			                <div class="action-btn-group">
			                    <button class="action-btn" data-action="edit-post" data-id="${post.board_no}" ${isDeleted ? 'disabled' : ''}>수정</button>
			                    <button class="action-btn danger" data-action="delete-post" data-id="${post.board_no}" ${isDeleted ? 'disabled' : ''}>삭제</button>
			                </div>
			            ` : `<span class="text-muted">권한없음</span>`;

			row.innerHTML = `
				                <td>${post.board_no}</td>
				                <td class="cell-title" data-action="edit-post" data-id="${post.board_no}">${post.board_title ?? '[제목 없음]'}</td>
				                <td>${post.nickname} (${post.userId})</td>
				                <td class="cell-date">${post.created_date}</td>
				                <td>${buttonsHTML}</td>
				            `;
			tableBody.appendChild(row);
		});
	},

	sortAndRenderTable: function(key, order) {
		if (!this.currentList || this.currentList.length === 0) {
			this.renderList();
			return;
		}
		this.currentList.sort((a, b) => {
			const valA = a[key];
			const valB = b[key];
			let compareResult = 0;

			if (key === 'board_no') {
				compareResult = valA - valB;
			} else if (key === 'created_date') {
				// 'YYYY-MM-DD HH:MI' 형식을 Date 객체로 변환
				const dateA = new Date(valA.replace(' ', 'T'));
				const dateB = new Date(valB.replace(' ', 'T'));
				compareResult = dateA - dateB;
			} else if (typeof valA === 'string' && typeof valB === 'string') {
				compareResult = valA.localeCompare(valB);
			} else {
				if (valA < valB) compareResult = -1;
				else if (valA > valB) compareResult = 1;
			}
			return (order === 'asc' ? compareResult : compareResult * -1);
		});
		this.updateSortIcons(key, order);
		this.renderList();
	},

	updateSortIcons: function(key, order) {
		document.querySelectorAll('#post-management .sortable').forEach(th => {
			const icon = th.querySelector('.sort-icon');
			if (icon) {
				th.dataset.sortOrder = 'none';
				icon.textContent = '';
			}
		});
		const activeHeader = document.querySelector(`#post-management .sortable[data-sort-key="${key}"]`);
		if (activeHeader) {
			const icon = activeHeader.querySelector('.sort-icon');
			if (icon) {
				activeHeader.dataset.sortOrder = order;
				icon.textContent = (order === 'asc' ? ' ▲' : ' ▼');
			}
		}
	},

	showDetailPanel: function(boardNo) {
		this.selectedPostNo = boardNo;
		const post = this.currentList.find(p => p.board_no == boardNo);

		if (!post) {
			console.error(`게시물 (ID: ${boardNo})을 찾을 수 없습니다.`);
			return;
		}

		const header = document.querySelector('#post-management .detail-header');
		if (header) {
			header.classList.add('user-selected');
			document.getElementById('detail-post-id').textContent = `게시물 No.${post.board_no} 수정`;
		}

		document.getElementById('detail-post-title').value = post.board_title;
		document.getElementById('detail-post-title').readOnly = false;
		document.getElementById('detail-post-content').value = post.board_content;
		document.getElementById('detail-post-content').readOnly = false;
		document.getElementById('detail-post-apply-btn').disabled = false;

		this.loadComments(boardNo); //실제 댓글 로드 API 호출
		this.renderList(); // 선택된 행 하이라이트
	},

	clearDetailPanel: function() {
		this.selectedPostNo = null;
		this.currentComments = []; // 댓글 목록 초기화

		const header = document.querySelector('#post-management .detail-header');
		if (header) {
			header.classList.remove('user-selected');
			document.getElementById('detail-post-id').textContent = '';
		}

		document.getElementById('detail-post-title').value = '';
		document.getElementById('detail-post-title').readOnly = true;
		document.getElementById('detail-post-content').value = '';
		document.getElementById('detail-post-content').readOnly = true;
		document.getElementById('detail-post-apply-btn').disabled = true;

		document.getElementById('post-comment-list').innerHTML =
			'<div class="comment-placeholder">게시물을 선택하면 댓글이 표시됩니다.</div>';

		if (this.currentList.length > 0) {
			this.renderList();
		}
	},

	// --- API 호출 함수들 ---

	// 댓글 로드 기능
	loadComments: async function(boardNo) {
		const commentListEl = document.getElementById('post-comment-list');
		commentListEl.innerHTML = '<div class="comment-placeholder">댓글 로드 중...</div>';

		try {
			// '/getPostComments.do' API 호출
			this.currentComments = await apiClient.post('/getPostComments.do', { board_no: boardNo });

			if (!this.currentComments || this.currentComments.length === 0) {
				commentListEl.innerHTML = '<div class="comment-placeholder">작성된 댓글이 없습니다.</div>';
				return;
			}

			commentListEl.innerHTML = ''; // 목록 초기화
			// DTO 데이터(닉네임, ID)로 렌더링
			this.currentComments.forEach(comment => {
				commentListEl.innerHTML += `
                    <div class="comment-item" id="comment-${comment.reply_no}">
                        <div class="comment-item-content">
                            <span class="comment-item-author">
                                ${comment.nickname} <span>(${comment.userId})</span>
                            </span>
                            <p class="comment-item-text">${comment.reply_content}</p>
                            <div class="comment-item-date">${comment.create_date}</div>
                        </div>
                        <div class="comment-item-action">
                            <button class="action-btn danger" data-action="delete-comment" data-id="${comment.reply_no}">삭제</button>
                        </div>
                    </div>
                `;
			});

		} catch (error) {
			console.error("댓글 로딩 실패:", error);
			commentListEl.innerHTML = '<div class="comment-placeholder" style="color: red;">댓글 로딩 중 오류가 발생했습니다.</div>';
		}
	},

	handleUpdatePost: async function(boardNo) {
		const data = {
			board_no: boardNo,
			board_title: document.getElementById('detail-post-title').value,
			board_content: document.getElementById('detail-post-content').value
		};

		if (!data.board_title.trim()) {
			Swal.fire('경고', '제목을 입력해주세요.', 'warning');
			return;
		}

		try {
			await apiClient.post('/adminPostUpdate.do', data);
			Swal.fire('성공', '게시물이 수정되었습니다.', 'success');

			// 로컬 목록 즉시 업데이트
			const index = this.currentList.findIndex(p => p.board_no == boardNo);
			if (index !== -1) {
				this.currentList[index].board_title = data.board_title;
				this.currentList[index].board_content = data.board_content;
			}
			this.renderList();

		} catch (error) {
			console.error("게시물 수정 실패:", error);
		}
	},

	handleDeletePost: function(boardNo) {
		Swal.fire({
			title: '게시물을 삭제하시겠습니까?',
			text: "",
			icon: 'warning',
			showCancelButton: true,
			confirmButtonColor: '#d33',
			confirmButtonText: '삭제',
			cancelButtonText: '취소'
		}).then((result) => {
			if (result.isConfirmed) {
				this.deletePost(boardNo);
			}
		});
	},

	deletePost: async function(boardNo) {
		try {
			const data = { board_no: boardNo };
			await apiClient.post('/adminPostDelete.do', data);

			Swal.fire('삭제 완료!', '게시물이 삭제 처리되었습니다.', 'success');

			if (this.selectedPostNo == boardNo) {
				this.clearDetailPanel();
			}

			// 로컬 목록에서 제거
			this.currentList = this.currentList.filter(p => p.board_no != boardNo);
			const index = this.currentList.findIndex(p => p.board_no == boardNo);
			if (index !== -1) {
				this.currentList[index].type_no = 99;
			} this.renderList();
		} catch (error) {
			console.error("게시물 삭제 실패:", error);
		}
	},

	// 댓글 삭제 핸들러
	handleDeleteComment: function(replyNo) {
		Swal.fire({
			title: '댓글을 삭제하시겠습니까?',
			text: "삭제된 댓글은 복구할 수 없습니다.",
			icon: 'warning',
			showCancelButton: true,
			confirmButtonColor: '#d33',
			confirmButtonText: '삭제',
			cancelButtonText: '취소'
		}).then((result) => {
			if (result.isConfirmed) {
				this.deleteComment(replyNo);
			}
		});
	},

	// 댓글 삭제 API 호출
	deleteComment: async function(replyNo) {
		try {
			const data = { reply_no: replyNo };
			await apiClient.post('/adminDeleteComment.do', data);

			Swal.fire('삭제 완료!', '댓글이 삭제되었습니다.', 'success');

			// 로컬 목록(UI)에서 즉시 제거
			const commentEl = document.getElementById(`comment-${replyNo}`);
			if (commentEl) {
				commentEl.remove();
			}

			// 데이터 배열에서도 제거
			this.currentComments = this.currentComments.filter(c => c.reply_no != replyNo);
			if (this.currentComments.length === 0) {
				document.getElementById('post-comment-list').innerHTML =
					'<div class="comment-placeholder">작성된 댓글이 없습니다.</div>';
			}

		} catch (error) {
			console.error("댓글 삭제 실패:", error);
		}
	}
};