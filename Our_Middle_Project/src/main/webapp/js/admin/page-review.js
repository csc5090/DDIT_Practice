// page-review.js

const ReviewPage = {
	currentList: [],
	currentSort: { key: 'createdDate', order: 'desc' },
	selectedReviewNo: null,

	init: function() {
		const reviewPage = document.getElementById('review-management');
		if (reviewPage) {
			reviewPage.addEventListener('click', this.handleClick.bind(this));
			const listContainer = document.getElementById('admin-review-list');
			if (listContainer) {
				listContainer.addEventListener('dblclick', this.handleDblClick.bind(this));
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
			const tableBody = document.querySelector('#admin-review-list tbody');
			if (tableBody) tableBody.innerHTML = `<tr><td colspan="6" style="text-align:center; padding: 40px;">리뷰 목록을 불러오는 데 실패했습니다.</td></tr>`;
		}
	},

	renderList: function() {
		const tableBody = document.querySelector('#admin-review-list tbody');
		if (!tableBody) return;

		let listToRender = this.currentList;

		tableBody.innerHTML = '';
		if (!listToRender || listToRender.length === 0) {
			tableBody.innerHTML = `<tr><td colspan="6" style="text-align:center; padding: 40px;">표시할 리뷰가 없습니다.</td></tr>`;
			return;
		}

		listToRender.forEach(review => {
			const row = document.createElement('tr');
			row.className = 'review-list-item';
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
		document.querySelector('.review-detail-placeholder').style.display = 'flex';
		document.querySelector('.review-detail-content').style.display = 'none';
		this.selectedReviewNo = null;

		const currentSelected = document.querySelector('.review-list-item.selected');
		if (currentSelected) currentSelected.classList.remove('selected');
	},

	populateDetailViews: function(reviewNo) {
		const review = this.currentList.find(r => r.boardNo == reviewNo);
		if (!review) return;

		document.querySelector('.review-detail-placeholder').style.display = 'none';
		document.querySelector('.review-detail-content').style.display = 'block';

		this.selectedReviewNo = review.boardNo;
		document.getElementById('detail-review-title').textContent = review.boardTitle ?? '[제목 없음]';
		document.getElementById('detail-review-nickname').textContent = review.nickname;
		document.getElementById('detail-review-date').textContent = review.createdDate;

		const starsHTML = `<span class="stars-filled">${'★'.repeat(review.stars)}</span><span class="stars-empty">${'☆'.repeat(5 - review.stars)}</span>`;
		document.getElementById('detail-review-stars').innerHTML = starsHTML;

		document.getElementById('detail-review-image').innerHTML = review.hasImage === 'Y' ? `<img src="/path/to/image/${review.boardNo}" alt="리뷰 이미지">` : '<span>이미지 없음</span>';
		document.getElementById('detail-review-content').textContent = review.boardContent;
		document.getElementById('admin-reply-date').textContent = review.adminReplyDate || '미작성';
		document.getElementById('admin-reply-textarea').value = review.adminReply || '';
		document.getElementById('detail-review-image').innerHTML = review.hasImage === 'Y' 
		    ? `<img src="${CONTEXT_PATH}/uploads/review_${review.boardNo}.jpg" alt="리뷰 이미지">` // (경로는 예시입니다)
		    : '<span>이미지 없음</span>';
		const deleteImageBtn = document.querySelector('.review-crud-panel .action-btn[data-action="delete-image"]');
		if (deleteImageBtn) {
			if (review.hasImage === 'Y') {
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

		const button = e.target.closest('.action-btn');
		if (!button) return;

		const action = button.dataset.action;
		if (!this.selectedReviewNo) {
			Swal.fire('알림', '먼저 왼쪽 목록에서 리뷰를 더블클릭하여 선택해주세요.', 'info');
			return;
		}

		if (action === 'save-reply') {
			const replyText = document.getElementById('admin-reply-textarea').value;
			this.saveReply(this.selectedReviewNo, replyText);
		} else if (action === 'delete-image') {
			this.deleteImage(this.selectedReviewNo);
		} else if (action === 'delete-review') {
			this.deleteReview(this.selectedReviewNo);
		}
	},

	handleDblClick: function(e) {
		const reviewItem = e.target.closest('[data-review-no]');
		if (reviewItem) {
			document.querySelectorAll('.review-list-item').forEach(item => item.classList.remove('selected'));
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

	deleteImage: async function(reviewNo) {
		const result = await Swal.fire({ title: '이미지를 삭제하시겠습니까?', text: "삭제된 이미지는 복구할 수 없습니다.", icon: 'warning', showCancelButton: true, confirmButtonText: '삭제', cancelButtonText: '취소' });
		if (result.isConfirmed) {
			try {
				await apiClient.post('/deleteReviewImage.do', { reviewNo: reviewNo });
				Swal.fire('삭제 완료!', '이미지가 성공적으로 삭제되었습니다.', 'success');
				this.loadAndRender();
			} catch (error) { }
		}
	}
};