// page-review.js

const ReviewPage = {
	currentList: [],
	currentSort: { key: 'regDate', order: 'desc' },

	init: function() {
		const reviewPage = document.getElementById('review-management');
		if (reviewPage) {
			reviewPage.addEventListener('click', this.handleClick.bind(this));
			
			const sortSelect = document.getElementById('review-sort-select');
			sortSelect.addEventListener('change', this.handleSortChange.bind(this));
		}
	},

	loadAndRender: async function() {
		try {
			// 임시 더미 데이터 (나중에 삭제) ---
			this.currentList = [
				{ reviewNo: 1, nickname: '네온고양이', stars: 5, regDate: '2025-10-12', content: '빛나는 네온이 분위기 끝판왕입니다.', adminReply: '좋은 피드백 감사합니다!' },
				{ reviewNo: 2, nickname: '사이버펑크', stars: 4, regDate: '2025-10-13', content: '고정된 작성창 아이디어가 좋네요.', adminReply: null }
			];
			this.renderList();
		} catch (error) {
			console.error("리뷰 목록 로딩 실패:", error);
			const container = document.getElementById('admin-review-list');
			if (container) container.innerHTML = '<p class="error-message">리뷰 목록을 불러오는 데 실패했습니다.</p>';
		}
	},

	renderList: function() {
		const container = document.getElementById('admin-review-list');
		if (!container) return;
		
		// 정렬 로직
		this.currentList.sort((a, b) => {
			const valA = a[this.currentSort.key];
			const valB = b[this.currentSort.key];
			let compare = 0;
			if (valA < valB) compare = -1;
			if (valA > valB) compare = 1;
			return this.currentSort.order === 'asc' ? compare : compare * -1;
		});

		container.innerHTML = '';
		if (!this.currentList || this.currentList.length === 0) {
			container.innerHTML = '<p>표시할 리뷰가 없습니다.</p>';
			return;
		}

		this.currentList.forEach(review => {
			const card = document.createElement('article');
			card.className = 'review-card';
			card.dataset.reviewNo = review.reviewNo;
			const stars = '★'.repeat(review.stars) + '☆'.repeat(5 - review.stars);

			card.innerHTML = `
                <div class="review-card-header">
                    <span class="review-card-nickname">${review.nickname}</span>
                    <span class="review-card-stars">${stars}</span>
                    <span class="review-card-date">${review.regDate}</span>
                </div>
                <div class="review-card-body">
                    <p class="review-card-content">${review.content}</p>
                    <div class="review-admin-reply">
                        <textarea placeholder="관리자 댓글을 입력하세요...">${review.adminReply || ''}</textarea>
                    </div>
                </div>
                <div class="review-card-actions">
                    <button class="action-btn" data-action="save-reply">댓글 저장</button>
                    <button class="action-btn danger" data-action="delete-review">리뷰 삭제</button>
                </div>
            `;
			container.appendChild(card);
		});
	},

	handleClick: function(e) {
		const reviewCard = e.target.closest('.review-card');
		if (!reviewCard) return;

		const reviewNo = reviewCard.dataset.reviewNo;
		const action = e.target.dataset.action;

		if (action === 'delete-review') {
			this.deleteReview(reviewNo);
		} else if (action === 'save-reply') {
			const replyText = reviewCard.querySelector('.review-admin-reply textarea').value;
			this.saveReply(reviewNo, replyText);
		}
	},

	handleSortChange: function(e) {
		const [key, order] = e.target.value.split('_');
		this.currentSort = { key, order };
		this.renderList();
	},

	deleteReview: async function(reviewNo) {
		const result = await Swal.fire({ title: '정말 삭제하시겠습니까?', text: "삭제된 리뷰는 복구할 수 없습니다.", icon: 'warning', showCancelButton: true, confirmButtonText: '삭제', cancelButtonText: '취소' });
		if (result.isConfirmed) {
			try {
				console.log(`(axios) /deleteReview.do 호출, reviewNo: ${reviewNo}`);
				Swal.fire('삭제 완료!', '리뷰가 성공적으로 삭제되었습니다.', 'success');
				this.loadAndRender();
			} catch (error) {}
		}
	},

	saveReply: async function(reviewNo, replyText) {
		try {
			console.log(`(axios) /updateReviewReply.do 호출, reviewNo: ${reviewNo}, replyText: ${replyText}`);
			Swal.fire('저장 완료!', '관리자 댓글이 저장되었습니다.', 'success');
			this.loadAndRender();
		} catch (error) {}
	}
};