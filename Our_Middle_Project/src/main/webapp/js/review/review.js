// [수정] gameHome.jsp에서 로드된 window.userDataCase에서 CURRENT_USER_MEM_NO를 가져옵니다.
const CURRENT_USER_MEM_NO = window.CURRENT_USER_MEM_NO;

// [수정] 전역 변수는 함수 외부에 한 번만 선언합니다.
let userHasReview = false;
let userReviewBoardNo = null;
let currentEditMode = { active: false, boardNo: null };
let files = [];
let formElements = {};

function updateUserWriteButton() {
	if (userHasReview) {
		// 이미 리뷰를 작성했다면: '리뷰 수정'으로 변경
		formElements.composerBtn.textContent = "리뷰 수정";
		formElements.composerBtn.classList.add('btn-update-mode');
	} else {
		// 리뷰를 작성하지 않았다면: '리뷰 작성'으로 유지
		formElements.composerBtn.textContent = "리뷰 작성";
		formElements.composerBtn.classList.remove('btn-update-mode');
	}
}


if (typeof BASE_URL === 'undefined') {
	console.warn("BASE_URL이 아직 정의되지 않았습니다. 동적 로딩 환경 확인 필요.");
}

// 모달을 여는 함수 (전역 노출)
function openReviewModal() {
	const modalElement = document.getElementById('iReviewModal');
	if (!modalElement) {
		console.error("iReviewModal 요소를 찾을 수 없습니다. 초기화 실패.");
		return;
	}
	modalElement.classList.remove('review-modal-off');
	modalElement.classList.add('review-modal-on');
}

// 모달을 닫는 전역 함수
function closeReviewModal() {
	const modalElement = document.getElementById('iReviewModal');
	if (modalElement) {
		modalElement.classList.remove('review-modal-on');
		modalElement.classList.add('review-modal-off');
	}
}


// ===== 유틸 =====
function starString(n) { return '★'.repeat(n) + '☆'.repeat(Math.max(0, 5 - n)); }
function placeholderDataURI(text) {
	var svg = "<svg xmlns='http://www.w3.org/2000/svg' width='240' height='240'>"
		+ "<rect width='100%' height='100%' fill='#f3f6fa'/>"
		+ "<rect x='16' y='16' width='208' height='208' rx='16' fill='#dfe7f3'/>"
		+ "<text x='50%' y='52%' dominant-baseline='middle' text-anchor='middle' font-size='20' font-family='Arial, sans-serif' fill='#394b63'>" + text + "</text>"
		+ "</svg>";
	return "data:image/svg+xml;charset=utf-8," + encodeURIComponent(svg);
}
function notify(title, text, icon) {
	if (window.Swal && Swal.fire) return Swal.fire({ title, text, icon, confirmButtonText: '확인' });
	alert((title ? title + '\n' : '') + (text || ''));
}

/* ===== 작성창 토글(기존 UX 유지) ===== */
const composer = {
	root: null, toggleBtn: null, textarea: null,
	open() { this.root.classList.add('open'); this.toggleBtn.setAttribute('aria-expanded', 'true'); setTimeout(() => this.textarea.focus(), 80); },
	close() {
		this.root.classList.remove('open');
		this.toggleBtn.setAttribute('aria-expanded', 'false');
		resetReviewForm();
	},
	toggle() { this.root.classList.contains('open') ? this.close() : this.open(); }
};


// (★) 폼 초기화 및 리셋 함수
function resetReviewForm() {
	currentEditMode = { active: false, boardNo: null };

	if (formElements.form) formElements.form.reset();
	if (formElements.btnSubmit) {
		formElements.btnSubmit.textContent = '등록';
		formElements.btnSubmit.disabled = true;
	}
	if (formElements.content) formElements.content.value = '';

	files = [];
	if (formElements.input) formElements.input.value = '';
	renderPreview();
	setRating(5);
	updateCounter();

	// [수정] 폼 리셋 시 uploaderRow를 다시 보이게 함
	const uploader = document.getElementById('uploaderRow');
	if (uploader) uploader.style.display = 'grid';
}

// (★) 별점 세팅 함수
function setRating(val) {
	if (!formElements.ratingHidden || !formElements.starBtns) return;
	const num = Number(val) || 0;
	formElements.ratingHidden.value = String(num);

	formElements.starBtns.forEach(btn => {
		const n = Number(btn.dataset.val);
		btn.setAttribute('aria-checked', n === num ? 'true' : 'false');
		btn.classList.toggle('filled', n <= num);
	});
	validate();
};

// (★) 유효성 검사 함수 (10자 제한 복구)
function validate() {
	if (!formElements.content || !formElements.ratingHidden || !formElements.btnSubmit) return;

	const textOK = formElements.content.value.trim().length >= 10;
	const ratingOK = Number(formElements.ratingHidden.value) >= 1;

	formElements.btnSubmit.disabled = !(textOK && ratingOK);
}

// (★) 글자 수 카운터 함수
const updateCounter = () => {
	if (formElements.cnt && formElements.content) {
		formElements.cnt.textContent = String(formElements.content.value.length);
	}
};

// (★) 파일 미리보기 함수 (파일명 리스트)
const renderPreview = () => {
	if (!formElements.preview || !formElements.fileCount) return;

	formElements.preview.innerHTML = ''; // 미리보기 영역 비우기

	if (files.length === 0) {
		// 파일이 없을 때
		const empty = document.createElement('div');
		empty.className = 'emptyBoxNew';
		empty.dataset.empty = '';
		empty.textContent = '첨부파일 없음';
		formElements.preview.appendChild(empty);

	} else {
		// 파일이 있을 때 (파일명 리스트)
		files.forEach((f, idx) => {
			const wrap = document.createElement('div');
			wrap.className = 'file-row'; // 새 클래스

			const nameSpan = document.createElement('span');
			nameSpan.className = 'file-name';
			nameSpan.textContent = f.name; // 파일명 표시
			wrap.appendChild(nameSpan);

			const rm = document.createElement('button');
			rm.className = 'rmNew';
			rm.type = 'button';
			rm.textContent = '×';

			rm.addEventListener('click', () => {
				files.splice(idx, 1); // 배열에서 해당 파일 제거
				renderPreview(); // 미리보기 다시 렌더링
				validate();
			});
			wrap.appendChild(rm);

			formElements.preview.appendChild(wrap);
		});
	}

	// 파일 카운트 업데이트
	formElements.fileCount.textContent = `${files.length} / ${formElements.MAX_FILES}`;
};


// (★) [ 5단계 ] 삭제 AJAX 함수
async function handleDeleteReview(boardNo) {
	if (!boardNo) return;
	const result = await Swal.fire({
		title: '리뷰를 삭제하시겠습니까?', text: "삭제된 내용은 복구할 수 없습니다.", icon: 'warning',
		showCancelButton: true, confirmButtonColor: '#d33', confirmButtonText: '삭제', cancelButtonText: '취소'
	});

	if (result.isConfirmed) {
		try {
			const params = new URLSearchParams();
			params.append('boardNo', boardNo);

			const response = await axios.post(
				getBaseUrl() + '/reviewDelete.do',
				params
			);

			Swal.fire('삭제 완료', '리뷰가 삭제되었습니다.', 'success');
			const cardToRemove = document.querySelector(`article.rv-card[data-board-no="${boardNo}"]`);
			if (cardToRemove) cardToRemove.remove();

			// [추가] 내 리뷰 삭제 후, 작성 버튼을 '리뷰 작성' 모드로 되돌림
			if (userHasReview && boardNo == userReviewBoardNo) {
				userHasReview = false;
				userReviewBoardNo = null;
				updateUserWriteButton(); // 버튼 UI 업데이트
			}

		} catch (error) {
			console.error('리뷰 삭제 실패:', error);
			const errorMsg = error.response?.data?.message || '삭제에 실패했습니다.';
			Swal.fire('삭제 실패', errorMsg, 'error');
		}
	}
}


// (★) [ 6단계-수정 ] 수정 AJAX 함수 (URLSearchParams 사용 - 파일 수정 X)
async function handleUpdateReview() {
	if (!currentEditMode.active || !currentEditMode.boardNo) return;

	formElements.btnSubmit.disabled = true;
	formElements.btnSubmit.textContent = '수정 중...';

	try {
		// [수정] FormData -> URLSearchParams로 복구
		const params = new URLSearchParams();
		params.append('boardNo', currentEditMode.boardNo);
		params.append('boardContent', formElements.content.value.trim());
		params.append('star', formElements.ratingHidden.value);

		const response = await axios.post(
			getBaseUrl() + '/reviewUpdate.do',
			params // [수정] formData -> params
		);

		await Swal.fire('수정 완료', '리뷰가 수정되었습니다.', 'success');

		const cardToUpdate = document.querySelector(`article.rv-card[data-board-no="${currentEditMode.boardNo}"]`);
		if (cardToUpdate) {
			// 4-1. 본문 텍스트 변경
			cardToUpdate.querySelector('p.review-content-text').textContent = params.get('boardContent');
			// 4-2. 별점 변경
			const starSpan = cardToUpdate.querySelector('.stars');
			if (starSpan) {
				const starVal = Number(params.get('star'));
				starSpan.innerHTML = '★'.repeat(starVal) + '☆'.repeat(5 - starVal);
				starSpan.setAttribute('aria-label', starVal + '점');
			}
			// 4-3. 날짜 변경 (간단하게 '수정됨' 표시)
			const dateSpan = cardToUpdate.querySelector('.date');
			if (dateSpan) dateSpan.textContent = "방금 전 (수정)";
			// [삭제] 썸네일 업데이트 로직 (파일 수정 안 하므로)
		}

		// 5. (★) 폼 닫기
		composer.close();

	} catch (error) {
		console.error('리뷰 수정 실패:', error);
		const errorMsg = error.response?.data?.message || '수정에 실패했습니다.';
		Swal.fire('수정 실패', errorMsg, 'error');

		formElements.btnSubmit.disabled = false;
		formElements.btnSubmit.textContent = '수정 완료';
	}
}

// (★) [ 6단계-수정 ] 새 글 쓰기(Write) 함수 (FormData 사용)
async function handleWriteReview() {
	formElements.btnSubmit.disabled = true;
	formElements.btnSubmit.textContent = '등록 중...';
	const formData = new FormData();
	formData.append('typeNo', formElements.form.querySelector('input[name="typeNo"]').value);
	formData.append('star', formElements.ratingHidden.value);
	formData.append('boardContent', formElements.content.value.trim());
	files.forEach((file) => {
		formData.append('image', file, file.name);
	});
	try {
		const response = await axios.post(
			getBaseUrl() + '/reviewWriteOK.do',
			formData
		);
		await Swal.fire('등록 완료', '리뷰가 등록되었습니다.', 'success');
		const newReview = response.data.newReview;
		buildNewCard(newReview);
		composer.close();
	} catch (error) {
		console.error('리뷰 등록 실패:', error);
		const errorMsg = error.response?.data?.message || '등록에 실패했습니다.';
		Swal.fire('등록 실패', errorMsg, 'error');
		formElements.btnSubmit.disabled = false;
		formElements.btnSubmit.textContent = '등록';
	}
}

// (★) [ 7단계-신규 ] 새 리뷰 카드를 생성하는 헬퍼 함수
function buildNewCard(r) {
	const list = formElements.list;
	if (!list) return;

	const emptyMsgCard = list.querySelector('.rv-card .rv-body');
	if (emptyMsgCard && emptyMsgCard.textContent.includes('등록된 리뷰가 없습니다')) {
		emptyMsgCard.closest('.rv-card').remove();
	}

	const card = document.createElement('article');
	card.className = 'rv-card';
	card.dataset.boardNo = r.boardNo;
	if (r.memNo) {
		card.dataset.memNo = r.memNo;
	}
	card.id = 'myReviewCard';
	card.dataset.isUserReview = 'true';
	userHasReview = true;
	userReviewBoardNo = r.boardNo; // [추가] 삭제 시 비교할 수 있도록 boardNo 저장
	updateUserWriteButton();

	let thumbHtml = '';
	if (r.thumbUrl) {
		thumbHtml = `<img src="${getBaseUrl()}${r.thumbUrl}" alt="리뷰 이미지">`;
	}

	// [수정] buildNewCard에서도 rv-actions로 감싸기 (수정 버튼 숨김 CSS 적용)
	let actionsHtml = `
		<div class="rv-actions">
			<span class="date">${r.createdDate}</span>
			<button type="button" class="btn btn-outline-info btn-sm ms-auto btn-update-review" data-board-no="${r.boardNo}">수정</button>
			<button type="button" class="btn btn-outline-danger btn-sm ms-auto btn-delete-review" data-board-no="${r.boardNo}">삭제</button>
		</div>
    `;

	card.innerHTML = `
        <div class="rv-head">
            <span class="nickname">${r.nickName}</span>
            <span class="memId">#${r.memId}</span>
            <span class="stars" aria-label="${r.star}점">
                ${'★'.repeat(r.star) + '☆'.repeat(5 - r.star)}
            </span>
            ${actionsHtml}
        </div>
        <div class="rv-body">
            <div class="rv-row">
                <div class="rv-thumb">${thumbHtml}</div>
                <div class="text">
                    <p class="review-content-text">${r.boardContent}</p>
                </div>
            </div>
        </div>
    `;

	list.prepend(card);
	sortReviews('newest');
}


// 리뷰 정렬 함수
function sortReviews(sortType) {
	const list = formElements.list;
	if (!list) return;

	const cards = Array.from(list.querySelectorAll('article.rv-card'));

	cards.sort((a, b) => {
		const boardNoA = parseInt(a.dataset.boardNo);
		const boardNoB = parseInt(b.dataset.boardNo);
		const memNoA = parseInt(a.dataset.memNo);
		const memNoB = parseInt(b.dataset.memNo);

		if (!CURRENT_USER_MEM_NO || isNaN(CURRENT_USER_MEM_NO)) {
			if (sortType === 'newest') {
				return boardNoB - boardNoA;
			} else {
				return boardNoA - boardNoB;
			}
		}
		const isUserAReview = memNoA === CURRENT_USER_MEM_NO;
		const isUserBReview = memNoB === CURRENT_USER_MEM_NO;
		if (isUserAReview && !isUserBReview) return -1;
		if (!isUserAReview && isUserBReview) return 1;
		if (sortType === 'newest') {
			return boardNoB - boardNoA;
		} else {
			return boardNoA - boardNoB;
		}
	});

	const fragment = document.createDocumentFragment();
	cards.forEach(card => fragment.appendChild(card));
	while (list.firstChild) {
		list.removeChild(list.firstChild);
	}
	list.appendChild(fragment);

	const sortBtns = formElements.sortBtns;
	sortBtns.forEach(btn => {
		btn.classList.remove('active');
		if (btn.dataset.sort === sortType) {
			btn.classList.add('active');
		}
	});
}


/////////////////////////////////////////////////////////////////////
// (★) window.onload 로직을 initReviewElements()로 분리
/////////////////////////////////////////////////////////////////////

// (★) 동적 로딩 후 gameHome.js에서 수동으로 호출할 초기화 함수
function initReviewElements() {

	// (★) 1. 전역 폼 요소 캐싱
	formElements = {
		form: document.getElementById('iReviewForm'),
		list: document.getElementById('iReviewList'),
		modal: document.getElementById('iReviewModal'),
		composerRoot: document.getElementById('iWrtReview'),
		composerBtn: document.getElementById('iwrtBtn'),
		content: document.getElementById('content'),
		btnSubmit: document.getElementById('btnSubmit'),
		starsGroup: document.getElementById('starsGroup'),
		starBtns: Array.from(document.querySelectorAll('#starsGroup .starBtn')),
		ratingHidden: document.querySelector('#iReviewForm input[name="star"]'),
		MAX_FILES: 2,
		fileBtn: document.getElementById('fileBtn'),
		input: document.getElementById('imageInput'),
		preview: document.getElementById('previewGrid'),
		fileCount: document.getElementById('fileCount'),
		uploaderRow: document.getElementById('uploaderRow'),
		cnt: document.getElementById('cnt'),
		sortBtns: Array.from(document.querySelectorAll('#iReviewToolbar .sortBtn')),
	};

	const myReviewCard = document.getElementById('myReviewCard');
	if (myReviewCard) {
		userHasReview = true;
		userReviewBoardNo = myReviewCard.dataset.boardNo;
	}
	updateUserWriteButton();

	// 2. 모달 열고 닫기
	const closeModalBtn = document.getElementById('iCloseModal');
	if (closeModalBtn) {
		closeModalBtn.addEventListener('click', closeReviewModal);
	}
	if (formElements.modal) {
		formElements.modal.addEventListener('click', (e) => {
			if (e.target === formElements.modal) {
				closeReviewModal();
			}
		});
	}

	// 3. 작성창 연결
	composer.root = formElements.composerRoot;
	composer.toggleBtn = formElements.composerBtn;
	composer.textarea = formElements.content;
	composer.toggleBtn.addEventListener('click', () => {
		if (userHasReview) {
			const myReviewCard = document.getElementById('myReviewCard');
			if (myReviewCard) {
				const updateBtn = myReviewCard.querySelector('.btn-update-review');
				if (updateBtn) {
					updateBtn.click();
					return;
				}
			}
		}
		composer.toggle();
		if (composer.root.classList.contains('open') && !currentEditMode.active) {
			const cur = Number(formElements.ratingHidden.value) || 0;
			if (cur === 0) setRating(5);
		}
	});

	// 4. 별점 이벤트
	formElements.starBtns.forEach((btn, i) => {
		btn.addEventListener('click', () => setRating(i + 1));
		btn.addEventListener('keydown', (e) => {
			let cur = Number(formElements.ratingHidden.value) || 0;
			if (e.key === 'ArrowRight' || e.key === 'ArrowUp') { e.preventDefault(); const n = Math.min(5, cur + 1); setRating(n); formElements.starBtns[n - 1].focus(); }
			if (e.key === 'ArrowLeft' || e.key === 'ArrowDown') { e.preventDefault(); const n = Math.max(1, cur - 1); setRating(n); formElements.starBtns[n - 1].focus(); }
		});
	});

	// 5. 이미지 첨부
	formElements.fileBtn.addEventListener('click', () => formElements.input.click());
	formElements.input.addEventListener('change', (e) => {
		const incoming = Array.from(e.target.files || []);
		const remain = formElements.MAX_FILES - files.length;
		if (incoming.length > remain) notify('이미지 제한', `이미지는 최대 ${formElements.MAX_FILES}장까지 첨부할 수 있어요. (추가 가능: ${remain}장)`, 'info');
		const pick = incoming.slice(0, Math.max(0, remain)).filter(f => /^image\//.test(f.type) && f.size > 0);
		files = files.concat(pick);
		formElements.input.value = '';
		renderPreview(); validate();
	});

	// 6. 본문 & 유효성
	formElements.content.addEventListener('input', () => { updateCounter(); validate(); });

	// 7. (★) 메인 이벤트 리스너 (삭제/수정/제출)
	if (formElements.list) {
		formElements.list.addEventListener('click', function(e) {
			const deleteBtn = e.target.closest('.btn-delete-review');
			const updateBtn = e.target.closest('.btn-update-review');

			if (deleteBtn) {
				e.preventDefault();
				handleDeleteReview(deleteBtn.dataset.boardNo);
			} else if (updateBtn) {
				e.preventDefault();
				const card = e.target.closest('article.rv-card');
				if (!card) return;
				const boardNo = card.dataset.boardNo;
				const content = card.querySelector('p.review-content-text').textContent.trim();
				const starText = card.querySelector('.stars').getAttribute('aria-label');
				const star = parseInt(starText, 10) || 0;

				currentEditMode = { active: true, boardNo: boardNo };
				composer.open();

				setRating(star);
				formElements.content.value = content;
				validate();
				formElements.btnSubmit.textContent = '수정 완료';

				// [추가] 2. 수정 시 파일 업로드 영역 숨김
				const uploader = document.getElementById('uploaderRow');
				if (uploader) uploader.style.display = 'none';
			}
		});
	}

	if (formElements.btnSubmit) {
		formElements.btnSubmit.addEventListener('click', (e) => {
			e.preventDefault();
			if (currentEditMode.active) {
				handleUpdateReview();
			} else {
				handleWriteReview();
			}
		});
	}

	// [추가] 7-2. 정렬 버튼 이벤트 리스너
	formElements.sortBtns.forEach(btn => {
		btn.addEventListener('click', (e) => {
			const sortType = e.currentTarget.dataset.sort;
			sortReviews(sortType);
		});
	});

	// 8. (★) 초기화
	sortReviews('newest');
	resetReviewForm();

}; // initReviewElements 끝