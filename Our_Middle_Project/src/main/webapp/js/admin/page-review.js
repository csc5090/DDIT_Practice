// page-review.js

const ReviewPage = {
	currentList: [],
	currentSort: { key: 'createdDate', order: 'desc' },
	selectedReviewNo: null,
	currentImageList: [],
	selectedImageFileNos: new Set(),

	init: function() {
		const reviewPage = document.getElementById('review-management');
		if (reviewPage) {
			reviewPage.addEventListener('click', this.handleClick.bind(this));

			// 이벤트 리스너를 tbody로 변경
			const listTbody = document.getElementById('admin-review-list-tbody');
			if (listTbody) {
				listTbody.addEventListener('dblclick', this.handleDblClick.bind(this));
			}
		}

		const searchBtn = document.getElementById('review-search-btn');
		const searchInput = document.getElementById('review-search-input');

		if (searchBtn) {
			searchBtn.addEventListener('click', () => this.handleSearch());
		}
		if (searchInput) {
			searchInput.addEventListener('keydown', (e) => {
				if (e.key === 'Enter') {
					e.preventDefault();
					this.handleSearch();
				}
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
			const payload = keyword ? { keyword: keyword } : null;
			this.currentList = await apiClient.post('/getReviewList.do', payload);
			this.sortAndRenderTable(this.currentSort.key, this.currentSort.order);
		} catch (error) {
			console.error("리뷰 목록 로딩 실패:", error);
			// 셀렉터 변경
			const tableBody = document.querySelector('#admin-review-list-tbody');
			if (tableBody) tableBody.innerHTML = `<tr><td colspan="6" style="text-align:center; padding: 40px;">리뷰 목록을 불러오는 데 실패했습니다.</td></tr>`;
		}
	},

	renderList: function() {
		// 셀렉터 변경
		const tableBody = document.querySelector('#admin-review-list-tbody');
		if (!tableBody) return;

		let listToRender = this.currentList;

		tableBody.innerHTML = '';
		if (!listToRender || listToRender.length === 0) {
			tableBody.innerHTML = `<tr><td colspan="6" style="text-align:center; padding: 40px;">표시할 리뷰가 없습니다.</td></tr>`;
			return;
		}

		listToRender.forEach(review => {
			const row = document.createElement('tr');
			row.className = 'review-list-item'; // 이 클래스는 CSS에서 사용될 수 있으므로 유지
			row.dataset.reviewNo = review.boardNo;

			const starsHTML = `<span class="stars-filled">${'★'.repeat(review.stars)}</span><span class="stars-empty">${'☆'.repeat(5 - review.stars)}</span>`;
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
		// (정렬 로직은 변경 없음)
		if (!this.currentList || this.currentList.length === 0) {
			this.renderList();
			return;
		}
		this.currentList.sort((a, b) => {
			const valA = a[key];
			const valB = b[key];
			let compare = 0;
			const replyA = valA || '';
			const replyB = valB || '';

			if (typeof valA === 'string' || typeof valB === 'string') {
				compare = replyA.localeCompare(replyB);
			} else {
				if (valA < valB) compare = -1;
				if (valA > valB) compare = 1;
			}
			return order === 'asc' ? compare : compare * -1;
		});
		this.updateSortIcons(key, order);
		this.renderList();
	},

	updateSortIcons: function(key, order) {
		// (아이콘 업데이트 로직은 변경 없음)
		document.querySelectorAll('#review-management .sortable').forEach(th => {
			const icon = th.querySelector('.sort-icon');
			if (icon) {
				th.dataset.sortOrder = 'none';
				icon.textContent = '';
			}
		});
		const activeHeader = document.querySelector(`#review-management .sortable[data-sort-key="${key}"]`);
		if (activeHeader) {
			const icon = activeHeader.querySelector('.sort-icon');
			if (icon) {
				activeHeader.dataset.sortOrder = order;
				icon.textContent = (order === 'asc' ? ' ▲' : ' ▼');
			}
		}
	},

	clearDetailViews: function() {
		// 1. 플레이스홀더 표시, 푸터(버튼) 숨김
		document.getElementById('review-detail-placeholder').style.display = 'block';
		document.getElementById('review-detail-footer').style.display = 'none';

		// 2. 상단 타이틀 초기화 및 헤더 클래스 제거
		document.getElementById('detail-review-selected-title').textContent = '';
		document.querySelector('#review-management .detail-header').classList.remove('user-selected');
		this.selectedReviewNo = null;

		// 3. 폼 필드 내용 비우기
		document.getElementById('detail-review-nickname-input').value = '';
		document.getElementById('detail-review-date-input').value = '';
		document.getElementById('detail-review-stars-input').value = '';
		document.getElementById('detail-review-content-textarea').value = '';

		// [수정] 이미지 표시 영역 초기화
		document.getElementById('detail-review-image-display').innerHTML = '<span>-</span>';
		this.currentImageList = [];
		this.selectedImageFileNos.clear();


		document.getElementById('admin-reply-date').textContent = '미작성';
		document.getElementById('admin-reply-textarea').value = '';
		document.getElementById('admin-reply-textarea').disabled = true;

		// 4. 선택된 항목 하이라이트 제거
		const currentSelected = document.querySelector('.review-list-item.selected');
		if (currentSelected) currentSelected.classList.remove('selected');
	},

	populateDetailViews: async function(reviewNo) {
		const review = this.currentList.find(r => r.boardNo == reviewNo);
		if (!review) return;

		// 1. 플레이스홀더 숨김, 푸터(버튼) 표시
		document.getElementById('review-detail-placeholder').style.display = 'none';
		document.getElementById('review-detail-footer').style.display = 'flex';
		``
		// 2. 헤더 클래스 추가 (제목을 보이게 함)
		document.querySelector('#review-management .detail-header').classList.add('user-selected');
		this.selectedReviewNo = review.boardNo;

		// --- 3. 데이터 채우기 ---
		document.getElementById('detail-review-selected-title').textContent = review.boardTitle ?? '[제목 없음]';

		document.getElementById('detail-review-nickname-input').value = review.nickname;
		document.getElementById('detail-review-date-input').value = review.createdDate;

		const starsText = '★'.repeat(review.stars) + '☆'.repeat(5 - review.stars);
		document.getElementById('detail-review-stars-input').value = starsText;

		const contentTextArea = document.getElementById('detail-review-content-textarea');
		contentTextArea.value = review.boardContent;
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

					const toolbarHTML = `
		        <div class="image-toolbar" id="image-toolbar">
		          <button type="button" id="btn-select-all">전체선택</button>
		          <button type="button" id="btn-clear">선택해제</button>
		          <button type="button" id="btn-del-selected" class="danger">선택 삭제</button>
		        </div>
		      `;
					const gridHTML = `
		        <div class="image-grid" id="image-grid">
		          ${imageList.map(img => {
						const src = `${CONTEXT_PATH}${img.filePath}${encodeURIComponent(img.fileName)}`;
						return `
		              <label class="imgItem">
		                <input type="checkbox" class="imgChk" value="${img.fileNo}">
		                <img loading="lazy" src="${src}" alt="리뷰 이미지 ${img.fileNo}">
		              </label>
		            `;
					}).join('')}
		        </div>
		      `;
					imageDisplay.innerHTML = toolbarHTML + gridHTML;
					this.updateImageActions();

					document.querySelectorAll('#image-grid img').forEach(img => {
						img.addEventListener('click', () => {
							const overlay = document.createElement('div');
							overlay.className = 'image-modal-overlay';
							overlay.innerHTML = `
					      <span class="image-modal-close" style="position:absolute;top:12px;right:16px;font-size:28px;cursor:pointer;color:#fff;">&times;</span>
					      <img class="image-modal-content" src="${img.src}" alt="" style="max-width:90vw;max-height:90vh;border-radius:8px;box-shadow:0 10px 30px rgba(0,0,0,.5);" />
					    `;
							Object.assign(overlay.style, {
								position: 'fixed', inset: '0', background: 'rgba(0,0,0,.7)', display: 'flex',
								alignItems: 'center', justifyContent: 'center', zIndex: '9999'
							});
							document.body.appendChild(overlay);
							overlay.addEventListener('click', (e) => {
								if (e.target === overlay || e.target.classList.contains('image-modal-close')) {
									overlay.remove();
								}
							});
						});
					});

					// 체크 상태 관리
					const grid = document.getElementById('image-grid');
					grid.addEventListener('change', (ev) => {
						const chk = ev.target.closest('.imgChk');
						if (!chk) return;
						const no = parseInt(chk.value, 10);
						if (chk.checked) this.selectedImageFileNos.add(no);
						else this.selectedImageFileNos.delete(no);
						this.updateImageActions();
					});

					// 툴바 버튼
					document.getElementById('btn-select-all').onclick = () => {
						grid.querySelectorAll('.imgChk').forEach(c => { c.checked = true; this.selectedImageFileNos.add(parseInt(c.value, 10)); });
						this.updateImageActions();
					};
					document.getElementById('btn-clear').onclick = () => {
						grid.querySelectorAll('.imgChk').forEach(c => { c.checked = false; });
						this.selectedImageFileNos.clear();
						this.updateImageActions();
					};
					document.getElementById('btn-del-selected').onclick = () => this.deleteSelectedImages();

				} else {
					imageDisplay.innerHTML = '<span>이미지 없음 (데이터 오류)</span>';
				}
			} catch (error) {
				console.error("이미지 로딩 실패:", error);
				imageDisplay.innerHTML = '<span>이미지 로딩 실패</span>';
			}
		} else {
			imageDisplay.innerHTML = '<span>이미지 없음</span>';
		}
		// --- 여기까지 수정 ---

		document.getElementById('admin-reply-date').textContent = review.adminReplyDate || '미작성';
		document.getElementById('admin-reply-textarea').value = review.adminReply || '';
		document.getElementById('admin-reply-textarea').disabled = false;

		// --- 4. 버튼 상태 제어 ---
		document.querySelector('#review-detail-footer .action-btn[data-action="save-reply"]').disabled = false;
		document.querySelector('#review-detail-footer .action-btn[data-action="delete-review"]').disabled = false;

		const deleteImageBtn = document.querySelector('#review-detail-footer .action-btn[data-action="delete-image"]');
		if (deleteImageBtn) {
			if (hasImageFile) {
				deleteImageBtn.classList.add('image-active');
				deleteImageBtn.classList.remove('secondary');
				deleteImageBtn.disabled = false;
			} else {
				deleteImageBtn.classList.remove('image-active');
				deleteImageBtn.classList.add('secondary');
				deleteImageBtn.disabled = true;
			}
		}
	},

	handleClick: function(e) {
		// (정렬 헤더 클릭 로직은 변경 없음)
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

		// 버튼 셀렉터가 .detail-footer 내부를 보도록 함
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
		// 셀렉터 변경 (tbody 기준)
		const reviewItem = e.target.closest('tr[data-review-no]');
		if (reviewItem) {
			// 'selected' 클래스 관리
			document.querySelectorAll('#admin-review-list-tbody tr').forEach(item => item.classList.remove('selected'));
			reviewItem.classList.add('selected');
			this.populateDetailViews(reviewItem.dataset.reviewNo);
		}
	},

	deleteReview: async function(reviewNo) {
		const result = await Swal.fire({ title: '정말 삭제하시겠습니까?', text: "삭제된 리뷰는 복구할 수 없습니다.", icon: 'warning', showCancelButton: true, confirmButtonText: '삭제', cancelButtonText: '취소' });
		if (result.isConfirmed) {
			try {
				await apiClient.post('/deleteReview.do', { reviewNo: reviewNo });
				Swal.fire('삭제 완료!', '리뷰가 성공적으로 삭제되었습니다.', 'success');
				this.loadAndRender();
			} catch (error) { }
		}
	},

	saveReply: async function(reviewNo, replyText) {
		try {
			await apiClient.post('/updateAdminReply.do', { reviewNo: reviewNo, replyContent: replyText });
			Swal.fire('저장 완료!', '관리자 댓글이 저장되었습니다.', 'success');
			this.loadAndRender();
		} catch (error) { }
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
			await this.populateDetailViews(this.selectedReviewNo);
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