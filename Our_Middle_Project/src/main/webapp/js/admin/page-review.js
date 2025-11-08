// page-review.js

const ReviewPage = {
	currentList: [],
	currentSort: { key: 'createdDate', order: 'desc' },
	selectedReviewNo: null,
	currentImageList: [],
	selectedImageFileNos: new Set(),

	// ---- 업로드 경로 정규화 ----
	normalizePath(p) {
		let fp = String(p || '/uploads/').replace(/\\/g, '/');
		if (typeof CONTEXT_PATH === 'string' && CONTEXT_PATH && fp.startsWith(CONTEXT_PATH)) {
			fp = fp.slice(CONTEXT_PATH.length);
		}
		fp = fp.replace(/^\/?images\//, '/uploads/')
			.replace(/^\/?upload\//, '/uploads/')
			.replace(/^\/?uploads\//, '/uploads/');
		if (!fp.startsWith('/')) fp = '/' + fp;
		if (!fp.endsWith('/')) fp += '/';
		return fp;
	},

	init: function() {
		const reviewPage = document.getElementById('review-management');
		if (reviewPage) {
			reviewPage.addEventListener('click', this.handleClick.bind(this));
			const listTbody = document.getElementById('admin-review-list-tbody');
			if (listTbody) listTbody.addEventListener('dblclick', this.handleDblClick.bind(this));
		}

		const searchBtn = document.getElementById('review-search-btn');
		const searchInput = document.getElementById('review-search-input');
		if (searchBtn) searchBtn.addEventListener('click', () => this.handleSearch());
		if (searchInput) {
			searchInput.addEventListener('keydown', (e) => {
				if (e.key === 'Enter') { e.preventDefault(); this.handleSearch(); }
			});
		}
	},

	handleSearch: function() {
		const keyword = document.getElementById('review-search-input').value;
		this.loadAndRender(keyword.trim());
	},

	loadAndRender: async function(keyword = null) {
		this.clearDetailViews();
		try {
			const payload = keyword ? { keyword } : null;
			this.currentList = await apiClient.post('/getReviewList.do', payload);
			this.sortAndRenderTable(this.currentSort.key, this.currentSort.order);
		} catch (error) {
			console.error('리뷰 목록 로딩 실패:', error);
			const tableBody = document.querySelector('#admin-review-list-tbody');
			if (tableBody) {
				tableBody.innerHTML =
					`<tr><td colspan="6" style="text-align:center; padding: 40px;">리뷰 목록을 불러오는 데 실패했습니다.</td></tr>`;
			}
		}
	},

	renderList: function() {
		const tableBody = document.querySelector('#admin-review-list-tbody');
		if (!tableBody) return;

		const listToRender = this.currentList || [];
		tableBody.innerHTML = '';

		if (listToRender.length === 0) {
			tableBody.innerHTML =
				`<tr><td colspan="6" style="text-align:center; padding: 40px;">표시할 리뷰가 없습니다.</td></tr>`;
			return;
		}

		listToRender.forEach(review => {
			const row = document.createElement('tr');
			row.className = 'review-list-item';
			row.dataset.reviewNo = review.boardNo;

			const starsHTML =
				`<span class="stars-filled">${'★'.repeat(review.stars)}</span><span class="stars-empty">${'☆'.repeat(5 - review.stars)}</span>`;
			const imageIcon = review.hasImage === 'Y' ? 'O' : 'X';
			const adminReplyStatus = review.adminReply ? 'O' : 'X';

			row.innerHTML = `
        <td>${review.boardTitle ?? '[제목 없음]'}</td>
        <td>${review.nickname}</td>
        <td>${starsHTML}</td>
        <td>${imageIcon}</td>
        <td>${adminReplyStatus}</td>
        <td>${review.createdDate}</td>
      `;
			tableBody.appendChild(row);
		});
	},

	sortAndRenderTable: function(key, order) {
		if (!this.currentList || this.currentList.length === 0) { this.renderList(); return; }
		this.currentList.sort((a, b) => {
			const valA = a[key]; const valB = b[key];
			let compare = 0;
			const replyA = valA || ''; const replyB = valB || '';
			if (typeof valA === 'string' || typeof valB === 'string') {
				compare = replyA.localeCompare(replyB);
			} else {
				if (valA < valB) compare = -1;
				if (valA > valB) compare = 1;
			}
			return this.currentSort.order === 'asc' ? compare : compare * -1;
		});
		this.updateSortIcons(key, order);
		this.renderList();
	},

	updateSortIcons: function(key, order) {
		document.querySelectorAll('#review-management .sortable').forEach(th => {
			const icon = th.querySelector('.sort-icon');
			if (icon) { th.dataset.sortOrder = 'none'; icon.textContent = ''; }
		});
		const activeHeader = document.querySelector(`#review-management .sortable[data-sort-key="${key}"]`);
		if (activeHeader) {
			const icon = activeHeader.querySelector('.sort-icon');
			if (icon) { activeHeader.dataset.sortOrder = order; icon.textContent = (order === 'asc' ? ' ▲' : ' ▼'); }
		}
	},

	clearDetailViews: function() {
		document.getElementById('review-detail-placeholder').style.display = 'block';
		document.getElementById('review-detail-footer').style.display = 'none';

		document.getElementById('detail-review-selected-title').textContent = '';
		document.querySelector('#review-management .detail-header').classList.remove('user-selected');
		this.selectedReviewNo = null;

		document.getElementById('detail-review-nickname-input').value = '';
		document.getElementById('detail-review-date-input').value = '';
		document.getElementById('detail-review-stars-input').value = '';
		document.getElementById('detail-review-content-textarea').value = '';

		document.getElementById('detail-review-image-display').innerHTML = '<span>-</span>';
		this.currentImageList = [];
		this.selectedImageFileNos.clear();

		document.getElementById('admin-reply-date').textContent = '미작성';
		document.getElementById('admin-reply-textarea').value = '';
		document.getElementById('admin-reply-textarea').disabled = true;

		const currentSelected = document.querySelector('.review-list-item.selected');
		if (currentSelected) currentSelected.classList.remove('selected');
	},

	populateDetailViews: async function(reviewNo) {
		const review = this.currentList.find(r => r.boardNo == reviewNo);
		if (!review) return;

		document.getElementById('review-detail-placeholder').style.display = 'none';
		document.getElementById('review-detail-footer').style.display = 'flex';

		document.querySelector('#review-management .detail-header').classList.add('user-selected');
		this.selectedReviewNo = review.boardNo;

		document.getElementById('detail-review-selected-title').textContent = review.boardTitle ?? '[제목 없음]';
		document.getElementById('detail-review-nickname-input').value = review.nickname;
		document.getElementById('detail-review-date-input').value = review.createdDate;
		document.getElementById('detail-review-stars-input').value =
			'★'.repeat(review.stars) + '☆'.repeat(5 - review.stars);

		const contentTextArea = document.getElementById('detail-review-content-textarea');
		let content = review.boardContent;

		// 목록에 본문이 없으면 서버에서 상세를 한 번 더 가져옴
		if (content == null || content === '') {
			try {
				const detail = await apiClient.post('/getReviewDetail.do', { boardNo: review.boardNo });
				// 서버에서 반환하는 필드명이 boardContent 라고 가정 (다르면 여기만 맞춰주세요)
				content = detail?.boardContent ?? '';
			} catch (e) {
				console.warn('리뷰 상세 로딩 실패:', e);
			}
		}
		
		contentTextArea.value = content || '';
		contentTextArea.readOnly = true;

		const imageDisplay = document.getElementById('detail-review-image-display');
		imageDisplay.innerHTML = '<span>불러오는 중...</span>';

		this.currentImageList = [];
		this.selectedImageFileNos.clear();

		let hasImageFile = false;

		if (review.hasImage === 'Y') {
			try {
				const imageList = await apiClient.post('/getReviewImages.do', { boardNo: review.boardNo });

				if (imageList && imageList.length > 0) {
					this.currentImageList = imageList;
					hasImageFile = true;

					// 툴바(삭제는 하단 버튼 사용, 이곳에서는 선택만)
					const toolbarHTML = `
            <div class="image-toolbar" id="image-toolbar">
              <button type="button" id="btn-select-all" class="imgbar-btn">전체선택</button>
              <button type="button" id="btn-clear" class="imgbar-btn">선택해제</button>
            </div>
          `;

					// 라벨 안에 체크박스+이미지 → 이미지/라벨을 클릭해도 체크만 토글됨(모달 없음)
					const gridHTML = `
            <div class="image-grid" id="image-grid">
              ${imageList.map(img => {
						const base = `${CONTEXT_PATH}${this.normalizePath(img.filePath)}`;
						const src = `${base}${encodeURIComponent(img.fileName)}`;
						return `
                  <label class="imgItem" title="${img.fileName}">
                    <input type="checkbox" class="imgChk" value="${img.fileNo}">
                    <img src="${src}" alt="리뷰 이미지 ${img.fileNo}"
                         onerror="this.closest('.imgItem').classList.add('load-error');">
                  </label>
                `;
					}).join('')}
            </div>
          `;
					imageDisplay.innerHTML = toolbarHTML + gridHTML;

					// 상태 바인딩
					const grid = imageDisplay.querySelector('#image-grid');
					const btnSelectAll = document.getElementById('btn-select-all');
					const btnClear = document.getElementById('btn-clear');

					if (grid) {
						grid.addEventListener('change', (ev) => {
							const chk = ev.target.closest('.imgChk');
							if (!chk) return;
							const no = parseInt(chk.value, 10);
							if (chk.checked) this.selectedImageFileNos.add(no);
							else this.selectedImageFileNos.delete(no);
							this.updateImageActions();
						});
					}
					if (btnSelectAll && grid) {
						btnSelectAll.onclick = () => {
							grid.querySelectorAll('.imgChk').forEach(c => {
								c.checked = true;
								this.selectedImageFileNos.add(parseInt(c.value, 10));
							});
							this.updateImageActions();
						};
					}
					if (btnClear && grid) {
						btnClear.onclick = () => {
							grid.querySelectorAll('.imgChk').forEach(c => { c.checked = false; });
							this.selectedImageFileNos.clear();
							this.updateImageActions();
						};
					}

					this.updateImageActions();

				} else {
					imageDisplay.innerHTML = '<span>이미지 없음</span>';
					hasImageFile = false;
					this.selectedImageFileNos.clear();
					this.updateImageActions();
				}
			} catch (error) {
				console.error('이미지 로딩 실패:', error);
				imageDisplay.innerHTML = '<span>이미지 로딩 실패</span>';
			}
		} else {
			imageDisplay.innerHTML = '<span>이미지 없음</span>';
			hasImageFile = false;
			this.selectedImageFileNos.clear();
			this.updateImageActions();
		}

		document.getElementById('admin-reply-date').textContent = review.adminReplyDate || '미작성';
		document.getElementById('admin-reply-textarea').value = review.adminReply || '';
		document.getElementById('admin-reply-textarea').disabled = false;

		document.querySelector('#review-detail-footer .action-btn[data-action="save-reply"]').disabled = false;
		document.querySelector('#review-detail-footer .action-btn[data-action="delete-review"]').disabled = false;

		const deleteImageBtn = document.querySelector('#review-detail-footer .action-btn[data-action="delete-image"]');
		if (deleteImageBtn) {
			if (hasImageFile) {
				deleteImageBtn.classList.add('image-active');
				deleteImageBtn.classList.remove('secondary');
				deleteImageBtn.disabled = (this.selectedImageFileNos.size === 0);
			} else {
				deleteImageBtn.classList.remove('image-active');
				deleteImageBtn.classList.add('secondary');
				deleteImageBtn.disabled = true;
			}
		}
	},

	handleClick: function(e) {
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

		const button = e.target.closest('#review-detail-footer .action-btn');
		if (!button) return;

		const action = button.dataset.action;
		if (!this.selectedReviewNo) {
			Swal.fire('알림', '편집할 리뷰를 더블클릭하세요.', 'info');
			return;
		}

		if (action === 'save-reply') {
			const replyText = document.getElementById('admin-reply-textarea').value;
			this.saveReply(this.selectedReviewNo, replyText);
		} else if (action === 'delete-image') {
			this.deleteSelectedImages();
		} else if (action === 'delete-review') {
			this.deleteReview(this.selectedReviewNo);
		}
	},

	handleDblClick: function(e) {
		const reviewItem = e.target.closest('tr[data-review-no]');
		if (reviewItem) {
			document.querySelectorAll('#admin-review-list-tbody tr').forEach(item => item.classList.remove('selected'));
			reviewItem.classList.add('selected');
			this.populateDetailViews(reviewItem.dataset.reviewNo);
		}
	},

	deleteReview: async function(reviewNo) {
		const result = await Swal.fire({
			title: '정말 삭제하시겠습니까?',
			text: '삭제된 리뷰는 복구할 수 없습니다.',
			icon: 'warning',
			showCancelButton: true,
			confirmButtonText: '삭제',
			cancelButtonText: '취소'
		});
		if (result.isConfirmed) {
			try {
				await apiClient.post('/deleteReview.do', { reviewNo });
				Swal.fire('삭제 완료!', '리뷰가 성공적으로 삭제되었습니다.', 'success');
				this.loadAndRender();
			} catch (error) { /* noop */ }
		}
	},

	saveReply: async function(reviewNo, replyText) {
		try {
			await apiClient.post('/updateAdminReply.do', { reviewNo, replyContent: replyText });
			Swal.fire('저장 완료!', '관리자 댓글이 저장되었습니다.', 'success');
			this.loadAndRender();
		} catch (error) { /* noop */ }
	},

	deleteSelectedImages: async function() {
		const fileNos = Array.from(this.selectedImageFileNos);
		if (fileNos.length === 0) {
			Swal.fire('알림', '삭제할 이미지를 선택하세요.', 'info');
			return;
		}

		const result = await Swal.fire({
			title: '선택한 이미지를 삭제하시겠습니까?',
			text: '삭제된 이미지는 복구할 수 없습니다.',
			icon: 'warning',
			showCancelButton: true,
			confirmButtonText: '삭제',
			cancelButtonText: '취소'
		});
		if (!result.isConfirmed) return;

		try {
			if (fileNos.length === 1) {
				await apiClient.post('/deleteReviewImage.do', { fileNo: fileNos[0] });
			} else {
				await apiClient.post('/deleteReviewImages.do', { fileNos });
			}
			Swal.fire('삭제 완료!', '선택한 이미지가 삭제되었습니다.', 'success');

			// 상세만 재랜더링 (전체 리로드 X)
			await this.populateDetailViews(this.selectedReviewNo);

			// 목록의 사진 아이콘(O/X) 즉시 반영
			const has = (this.currentImageList && this.currentImageList.length > 0);
			const idx = this.currentList.findIndex(r => r.boardNo == this.selectedReviewNo);
			if (idx !== -1) this.currentList[idx].hasImage = has ? 'Y' : 'N';
			const row = document.querySelector(`#admin-review-list-tbody tr[data-review-no="${this.selectedReviewNo}"]`);
			if (row && row.children[3]) row.children[3].textContent = has ? 'O' : 'X';

		} catch (error) {
			console.error(error);
			Swal.fire('오류', '이미지 삭제에 실패했습니다.', 'error');
		}
	},

	updateImageActions: function() {
		const n = this.selectedImageFileNos.size;
		const total = this.currentImageList.length || 0;
		const delBtn = document.querySelector('#review-detail-footer .action-btn[data-action="delete-image"]');
		if (!delBtn) return;
		delBtn.disabled = (n === 0);
		if (n === 0) delBtn.textContent = '이미지 삭제';
		else if (n === total) delBtn.textContent = `전체 삭제 (${n})`;
		else delBtn.textContent = `선택 삭제 (${n})`;
	}
};

document.addEventListener('DOMContentLoaded', () => ReviewPage.init());
