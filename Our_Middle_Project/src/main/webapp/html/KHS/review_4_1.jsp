<%@ page language="java" contentType="text/html; charset=UTF-8"
	isELIgnored="true" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>리뷰 게시판4</title>

<!-- 부트스트랩 -->
<link rel="stylesheet"
	href="<%=request.getContextPath()%>/js/lib/bootstrap/css/bootstrap.min.css">
<script type="text/javascript"
	src="<%=request.getContextPath()%>/js/lib/bootstrap/js/bootstrap.min.js"></script>

<!-- 스위트어럴트2 -->
<link rel="stylesheet"
	href="<%=request.getContextPath()%>/js/lib/sweetalert2/dist/sweetalert2.min.css">
<script type="text/javascript"
	src="<%=request.getContextPath()%>/js/lib/sweetalert2/dist/sweetalert2.min.js"></script>

<!-- jquery -->
<script type="text/javascript"
	src="<%=request.getContextPath()%>/js/lib/jquery/jquery-3.7.1.min.js"></script>

<!-- axios -->
<script type="text/javascript"
	src="<%=request.getContextPath()%>/js/lib/axios/axios.min.js"></script>

<style>
/* ===== 기본 레이아웃(중앙 버튼) ===== */
* {
	box-sizing: border-box;
}

html, body {
	margin: 0;
	height: 100%;
}

.whiteAll-center {
	display: grid;
	place-items: center;
	height: 100%;
}

/* ===== 모달 ===== */
.reviewModal[hidden] {
	display: none !important;
}

.reviewModal {
	display: grid;
	position: fixed;
	inset: 0;
	place-items: center;
	z-index: 50;
	background: rgba(0, 0, 0, .12);
}

.reviewDialog {
	display: grid;
	width: 45vh;
	min-width: 600px;
	height: 85vh;
	background: #fff;
	border-radius: 18px;
	border: 1px solid #000;
	box-shadow: 0 24px 80px rgba(0, 0, 0, .1);
	grid-template-rows: auto 1fr auto;
	overflow: hidden;
}

/* 헤더 */
.reviewHeader {
	display: flex;
	align-items: center;
	gap: 10px;
	justify-content: space-between;
	padding: 15px;
	border-bottom: 1px solid #ececec;
	background: #fff;
}

.reviewTitle {
	font-weight: 700;
	font-size: 25px;
}

.closeModal, .wrtBtn {
	border: 1px solid #ececec;
	background: #fff;
	color: #000;
	font-size: 14px;
	font-weight: 700;
	border-radius: 10px;
	padding: 6px 12px;
}

#iwrtBtn svg {
	transition: transform 0.25s cubic-bezier(0.45, 0, 0.25, 1);
	transform-origin: center;
}

/* 열림 상태에서 위쪽 화살표로 회전 */
#iwrtBtn[aria-expanded="true"] svg {
	transform: rotate(180deg);
}

/* 모션 최소화 환경 대응 */
@media ( prefers-reduced-motion : reduce) {
	#iwrtBtn svg {
		transition: none;
	}
}

.closeModal:hover, .wrtBtn:hover {
	background: #e8e8e8;
}

/* 목록 영역 */
.innerContent {
	overflow: auto;
	padding: 10px;
}

.innerContent::-webkit-scrollbar {
	display: none;
}

.reviewList {
	display: grid;
	gap: 10px;
}

.card {
	border: 1px solid #ececec;
	border-radius: 16px;
	box-shadow: 0 6px 20px rgba(0, 0, 0, .1);
	background: #fff;
	padding: 15px;
}

.head {
	display: flex;
	align-items: center;
	gap: 10px;
	margin-bottom: 10px;
}

.nickname {
	font-weight: 700;
	font-size: 15px;
}

.stars {
	color: #f7b500;
	font-size: 17px;
	transform: translateY(-3px);
}

.date {
	margin-left: auto;
	color: #656565;
	font-size: 12px;
}

.body {
	padding-left: 18px;
	display: grid;
	gap: 10px;
}

.row {
	display: grid;
	grid-template-columns: 85px 1fr;
	gap: 12px;
	align-items: start;
}

.thumb {
	width: 10vh;
	min-width: 85px;
	height: 10vh;
	border-radius: 10px;
	border: 1px solid #ececec;
	overflow: hidden;
	background: #fafafa;
	position: relative;
}

.thumb img {
	width: 100%;
	height: 100%;
	object-fit: cover;
	display: block;
}

.text {
	white-space: pre-wrap;
}

.reply {
	margin-top: 4px;
	padding-left: 16px;
	border-left: 3px solid #eef3ff;
	background: #f7faff;
	color: #2b3a55;
	border-radius: 8px;
	padding: 10px 12px;
	font-size: 14px;
}

/* ===== 작성창(열기/닫기 전환) ===== */
.wrtReview {
	height: 7vh;
	border-top: 1px solid #ececec;
	background: #fff;
	transition: height .25s ease;
	display: grid;
	grid-template-rows: auto 1fr;
}

.wrtReview.open {
	height: 34vh;
}

.bottomBar {
	display: flex;
	align-items: center;
	justify-content: flex-end;
	gap: 10px;
	padding: 15px;
}

.wrtlabel {
	font-weight: 700;
	color: #000;
	font-size: 17px;
}

.wrtBody--new {
	display: grid;
	grid-template-columns: 280px 1fr;
	gap: 14px;
	padding: 0 12px 12px;
	opacity: 0;
	pointer-events: none;
	transition: opacity .2s ease;
}

.wrtReview.open .wrtBody--new {
	opacity: 1;
	pointer-events: auto;
}

.wrtColLeftNew {
	display: grid;
	gap: 10px;
	align-content: start;
	min-width: 240px;
}

.wrtColRightNew {
	display: flex;
	 flex-direction: column;
	gap: 0px;
}

.rowNew {
	display: grid;
	gap: 8px;
	align-items: start;
}

.wrtReviewLabel {
	font-size: 13px;
	color: #6b7280;
}

/* 별점 */
.starsNew {
	display: flex;
	gap: 8px;
	flex-wrap: wrap;
}

/* 기본 별 색상과 전환 효과 */
.starsNew .starBtn span {
	color: #c9ced6; /* 기본 회색 톤 */
	transition: color .22s ease, text-shadow .22s ease, transform .12s ease;
}

/* 선택한 값 이하(채워진) 모든 별에 파란 테두리 & 글로우 */
.starsNew .starBtn.filled {
  border-color: #00bcd4;
  box-shadow: 0 0 16px rgba(0, 188, 212, .2), inset 0 0 10px rgba(0, 188, 212, .08);
}

/* hover가 회색 테두리로 덮어쓰지 않도록 보정 */
.starsNew .starBtn.filled:hover {
  border-color: #00bcd4;
}

/* 채워진(선택된 값 이하) 별 */
.starsNew .starBtn.filled span {
	color: #f7b500; /* 금색 */
	text-shadow: 0 0 8px rgba(247, 181, 0, .45);
}

/* 클릭 순간(눌림) */
.starsNew .starBtn:active span {
	transform: scale(0.9);
}

/* 마우스오버 미리보기(선택 전 가벼운 강조) — 선택 사항 */
.starsNew .starBtn:hover span {
	color: #ffd86b;
	text-shadow: 0 0 6px rgba(255, 216, 107, .55);
}

/* ★ 권장 1: flex 중앙정렬 + 라인 높이 리셋 (교체용) */
.starBtn {
	width: 30px;
	height: 30px;
	border-radius: 10px;
	border: 1px solid #ececec;
	background: #fff;
	display: flex; /* grid → flex */
	align-items: center; /* 세로 중앙 */
	justify-content: center; /* 가로 중앙 */
	padding: 0; /* 기본 패딩 제거 */
	line-height: 0; /* 라인박스 영향 제거 */
	box-sizing: border-box;
	-webkit-appearance: none; /* 브라우저 기본 버튼 스타일 제거 */
	appearance: none;
	cursor: pointer;
	transition: transform .08s ease, box-shadow .15s ease, border-color .15s
		ease;
}

/* span은 인라인 베이스라인 영향 제거 + 글자 크기만 */
.starBtn span {
	display: block;
	line-height: 1; /* 글리프 균형 */
	font-size: 18px; /* 필요 시 16~18px로 미세조정 */
	transform: translateY(-3px);
	
}

.starBtn:hover {
	transform: translateY(-1px);
	border-color: #d0d5dd;
}

.starBtn[aria-checked="true"] {
	border-color: #00bcd4;
	box-shadow: 0 0 16px rgba(0, 188, 212, .2), inset 0 0 10px
		rgba(0, 188, 212, .08);
}

.uploaderNew {
	display: flex;
	align-items: center;
	gap: 10px;
	flex-wrap: wrap;
}

.fileButtonNew {
	border: 1px solid #ececec;
	background: #fff;
	padding: 8px 14px;
	border-radius: 10px;
	cursor: pointer;
}

.fileButtonNew:hover {
	background: #f5f5f5;
}

.fileHintNew {
	font-size: 12px;
	color: #6b7280;
}

.fileCountNew {
	font-size: 12px;
	color: #10b981;
}

input#imageInput[hidden] {
	display: none !important;
}

/* 미리보기 — 최대 2장에 맞춰 2열 그리드 */
.previewGridNew {
	display: grid;
	grid-template-columns: repeat(2, 1fr);
	gap: 10px;
	min-height: 88px;
	border: 1px dashed #e2e8f0;
	border-radius: 12px;
	padding: 10px;
	background: #fafcff;
}

.thumbNew, .emptyBoxNew {
	aspect-ratio: 1/1;
	width: 100%;
	border-radius: 12px;
	overflow: hidden;
	border: 1px solid #ececec;
	background: #fff;
	display: grid;
	place-items: center;
	position: relative;
}

.thumbNew img {
	width: 100%;
	height: 100%;
	object-fit: cover;
	display: block;
}

.rmNew {
	position: absolute;
	top: 6px;
	right: 6px;
	width: 26px;
	height: 26px;
	border-radius: 8px;
	border: 1px solid #ddd;
	background: #fff;
	cursor: pointer;
	display: grid;
	place-items: center;
	font-size: 16px;
	line-height: 1;
}

.rmNew:hover {
	background: #f2f2f2;
}

.textareaWrapNew {
	position: relative;
}

.textareaNew {
	width: 100%;
	min-height: 21vh;
	max-height: 46vh;
	resize: none;
	border: 1px solid #ececec;
	border-radius: 12px;
	padding: 12px;
	background: #fff;
	line-height: 1.6;
	font: inherit;
}

.textareaNew:focus {
	outline: none;
	border-color: #00bcd4;
	box-shadow: 0 0 0 3px rgba(0, 188, 212, .12);
}

.counterNew {
	position: absolute;
	right: 10px;
	bottom: 8px;
	font-size: 12px;
	color: #6b7280;
}

/* 제출버튼 */
.btnRowNew {
	display: flex;
	justify-content: flex-end;
	transform: translateY(2px);
}

.submitBtnNew {
	width: 100%;
	height: 4vh;
	border: none;
	background: #0a84ff;
	color: #fff;
	border-radius: 12px;
	font-weight: 600;
	cursor: pointer;
}

.submitBtnNew[disabled] {
	opacity: .6;
	cursor: not-allowed;
}
</style>
</head>
<body>

	<div class="whiteAll-center">
		<button id="iOpenModal" class="openModal btn btn-outline-dark"
			type="button">Review Board</button>
	</div>

	<div id="iReviewModal" class="reviewModal" hidden>
		<div class="reviewDialog">
			<!-- 헤더 -->
			<div class="reviewHeader">
				<div class="reviewTitle">Review</div>
				<button id="iCloseModal" class="closeModal" type="button">닫기</button>
			</div>

			<!-- 목록 -->
			<div class="innerContent">
				<section id="iReviewList" class="reviewList"></section>
			</div>

			<aside id="iWrtReview" class="wrtReview">
				<div class="bottomBar">
					<button id="iwrtBtn" class="wrtBtn btn btn-outline-secondary"
						type="button" aria-expanded="false">
						<!-- 닫힌 상태에서 위쪽을 가리키게(chevron-up) -->
						<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-chevron-up" viewBox="0 0 16 16">
                        <path fill-rule="evenodd" d="M7.646 4.646a.5.5 0 0 1 .708 0l6 6a.5.5 0 0 1-.708.708L8 5.707 1.354 11.354a.5.5 0 1 1-.708-.708l6-6z" />
                        </svg>
					</button>
				</div>

				<div class="wrtBody wrtBody--new" aria-live="polite">
					<!-- 좌: 별점 + 파일선택 + 미리보기 -->
					<div class="wrtColLeftNew">
						<div class="rowNew">

							<div id="starsGroup" class="starsNew" role="radiogroup"
								aria-label="별점">
								<button class="starBtn" type="button" role="radio" data-val="1"> <span>★</span>
								</button>
								<button class="starBtn" type="button" role="radio" data-val="2"> <span>★</span>
								</button>
								<button class="starBtn" type="button" role="radio"
									aria-checked="false" data-val="3">
									<span>★</span>
								</button>
								<button class="starBtn" type="button" role="radio"
									aria-checked="false" data-val="4">
									<span>★</span>
								</button>
								<button class="starBtn" type="button" role="radio"
									aria-checked="false" data-val="5">
									<span>★</span>
								</button>
							</div>
						</div>

						<div class="rowNew">

							<div class="uploaderNew">
								<button id="fileBtn" class="fileButtonNew" type="button">파일 선택</button>
								<input id="imageInput" type="file" accept="image/*" multiple hidden>
								<div class="fileHintNew">최대 2장 · JPG/PNG/GIF</div>
								<div class="fileCountNew" id="fileCount">0 / 2</div>
							</div>
						</div>

						<div class="rowNew">
						
							<div id="previewGrid" class="previewGridNew">
								<div class="emptyBoxNew" data-empty>이미지 없음</div>
							</div>
						</div>
					</div>

					<!-- 우: 본문 + 제출 (넓게) -->
					<div class="wrtColRightNew">
						<div class="rowNew">
							<div class="textareaWrapNew">
								<textarea id="content" class="textareaNew" maxlength="1000"
									placeholder="리뷰를 작성해주세요 (최소 10자)&#10;게임/서비스의 장단점, 추천 여부 등을 자유롭게 적어주세요."></textarea>
								<div class="counterNew">
									<span id="cnt">0</span>/1000
								</div>
							</div>
						</div>

						<div class="btnRowNew">
							<button id="btnSubmit" class="submitBtnNew" type="button"
								disabled>등록</button>
						</div>
					</div>
				</div>

				<input type="hidden" id="ratingVal" value="0">
			</aside>
		</div>
	</div>

<script>
window.onload = () => {
  // ===== 도움 함수 없이, 이벤트 위임만 사용 =====

  // 클릭 위임
  window.addEventListener('click', (e) => {
    // 모달 열기
    let openBtn = e.target.closest('#iOpenModal');
    if (openBtn) {
      let modal = openBtn.closest('body') ? openBtn.closest('body').querySelector('#iReviewModal') : null;
      if (modal) modal.hidden = false;
      return;
    }

    // 모달 닫기
    let closeBtn = e.target.closest('#iCloseModal');
    if (closeBtn) {
      let modal = closeBtn.closest('#iReviewModal');
      if (modal) modal.hidden = true;
      return;
    }

 // 작성창 토글
    let wrtBtn = e.target.closest('#iwrtBtn');
    if (wrtBtn) {
      let wrt = wrtBtn.closest('#iWrtReview');
      if (wrt) {
        // .wrtReview 에 open 클래스 토글 (CSS가 이 상태만 듣습니다)
        let isOpen = wrt.classList.contains('open');
        if (isOpen) {
          wrt.classList.remove('open');
          wrtBtn.setAttribute('aria-expanded', 'false'); // 아이콘 회전 규칙과 연동
          wrtBtn.textContent = (wrtBtn.getAttribute('data-close-text') || '열기');
        } else {
          wrt.classList.add('open');
          wrtBtn.setAttribute('aria-expanded', 'true');
          wrtBtn.textContent = (wrtBtn.getAttribute('data-open-text') || '닫기');
        }
      }
      return;
    }

 // 별점 선택 (.starBtn)
    let star = e.target.closest('.starBtn');
    if (star) {
      let group = star.closest('#starsGroup') || star.parentElement;
      if (group) {
        let chosen = Number(star.getAttribute('data-val') || '0');
        let stars = group.querySelectorAll('.starBtn');

        // (1) 선택된 별에만 aria-checked="true" 부여
        for (let i = 0; i < stars.length; i++) {
          let v = Number(stars[i].getAttribute('data-val') || (i + 1));
          stars[i].setAttribute('aria-checked', v === chosen ? 'true' : 'false');
        }

        // (2) 채워진 별(선택값 이하)에 .filled 클래스 부여 → CSS 효과 연동
        for (let i = 0; i < stars.length; i++) {
          let v = Number(stars[i].getAttribute('data-val') || (i + 1));
          if (v <= chosen) stars[i].classList.add('filled');
          else stars[i].classList.remove('filled');
        }

        // (3) hidden 값 동기화(있을 때)
        let hidden = group.querySelector('#ratingVal');
        if (hidden) hidden.value = String(chosen);

        // (4) 등록 버튼 활성화 여부 갱신
        let root = group.closest('#iWrtReview');
        if (root) updateSubmitState(root);
      }
      return;
    }

    // 파일 선택 트리거
    let fileBtn = e.target.closest('#fileBtn');
    if (fileBtn) {
      let upload = fileBtn.closest('.upload') || fileBtn.parentElement;
      let input  = upload ? upload.querySelector('#imageInput') : null;
      if (input) input.click();
      return;
    }

    // 썸네일 개별 삭제 버튼 (동적 요소)
    let rm = e.target.closest('.rmNew');
    if (rm) {
      let grid = rm.closest('#previewGrid');
      if (grid) {
        // data-idx 기반 삭제
        let idx = rm.getAttribute('data-idx');
        if (idx != null) {
          // 실제 files는 input.files에서 제한/재구성되므로, grid만 재렌더
          let input = grid.closest('#iWrtReview') ? grid.closest('#iWrtReview').querySelector('#imageInput') : null;
          if (input && input.files) {
            // DataTransfer로 files 재구성
            if (window.DataTransfer) {
              let dt = new DataTransfer();
              for (let i = 0; i < input.files.length; i++) {
                if (String(i) !== String(idx)) dt.items.add(input.files[i]);
              }
              input.files = dt.files;
              renderPreview(grid, input.files);
              updateCounter(grid.closest('#iWrtReview'));
            }
          }
        }
      }
      return;
    }

    // 등록 버튼
    let submit = e.target.closest('#btnSubmit');
    if (submit) {
      let root = submit.closest('#iWrtReview');
      if (root) handleSubmit(root);
      return;
    }
  });

//입력 위임: 본문 글자수 카운터
  window.addEventListener('input', (e) => {
    let ta = e.target.closest('#content');
    if (ta) {
      let root = ta.closest('#iWrtReview');
      let cnt = root ? root.querySelector('#cnt') : null;
      if (cnt) cnt.textContent = (ta.value || '').length;

      // ★ 추가: 입력 변화마다 버튼 활성화 상태 갱신
      if (root) updateSubmitState(root);

      return;
    }
  });

  // 변경 위임: 파일 선택
  window.addEventListener('change', (e) => {
    let input = e.target.closest('#imageInput');
    if (!input) return;

    let root = input.closest('#iWrtReview');
    if (!root) return;

    // 최대 2장으로 강제 제한
    let files = input.files || [];
    let max = 2;
    if (files.length > max && window.DataTransfer) {
      let dt = new DataTransfer();
      for (let i = 0; i < Math.min(files.length, max); i++) dt.items.add(files[i]);
      input.files = dt.files;
      files = input.files;
    }

    // 카운터 갱신
    updateCounter(root);

    // 미리보기 렌더
    let grid = root.querySelector('#previewGrid');
    renderPreview(grid, files);
  });

  // ===== 미리보기/카운터/검증/제출(프론트만) 유틸 =====

  let updateSubmitState = (root) => {
  let btn = root.querySelector('#btnSubmit');
  if (!btn) return;

  // 별점 선택 여부
  let chosenBtn = root.querySelector('#starsGroup .starBtn[aria-checked="true"]');
  let starOk = !!chosenBtn;

  // 본문 길이 (10자 이상)
  let content = root.querySelector('#content');
  let txtLen = content ? (content.value || '').trim().length : 0;
  let textOk = txtLen >= 10;

  // 필요하면 파일 개수 제한도 함께 체크 가능 (지금은 별점+본문만 기준)
  let enable = starOk && textOk;

  btn.disabled = !enable;
};	  
	  
  let updateCounter = (root) => {
    let fileCount = root.querySelector('#fileCount');
    let input = root.querySelector('#imageInput');
    if (fileCount && input) fileCount.textContent = ((input.files ? input.files.length : 0) + ' / 2');
  };

  let renderPreview = (grid, files) => {
    if (!grid) return;
    let arr = [];
    files = files || [];
    if (!files.length) {
      arr.push('<div class="empty">이미지 없음</div>');
    } else {
      for (let i = 0; i < files.length; i++) {
        let url = URL.createObjectURL(files[i]);
        // index i를 data-idx로 달아서 개별 삭제 가능
        arr.push(
          '<div class="thumbNew">' +
            '<img alt="첨부 이미지 ' + (i+1) + '" src="' + url + '">' +
            '<button type="button" class="rmNew" data-idx="' + i + '">×</button>' +
          '</div>'
        );
      }
    }
    grid.innerHTML = arr.join('');
  };

  let validate = (root) => {
    let content = root.querySelector('#content');
    let chosenBtn = root.querySelector('#starsGroup .starBtn[aria-checked="true"]');
    let star = chosenBtn ? (chosenBtn.getAttribute('data-val') || '') : '';
    let input = root.querySelector('#imageInput');
    let count = input && input.files ? input.files.length : 0;

    if (!star)  return { ok:false, msg:'별점을 선택해 주세요.' };
    if (!content || (content.value || '').trim().length < 10) return { ok:false, msg:'리뷰를 10자 이상 작성해 주세요.' };
    if (count > 2) return { ok:false, msg:'이미지는 최대 2장까지 업로드할 수 있습니다.' };
    return { ok:true, msg:'' };
  };

  let handleSubmit = (root) => {
    let v = validate(root);
    if (!v.ok) {
      if (window.Swal && window.Swal.fire) window.Swal.fire({ icon:'warning', text:v.msg });
      else alert(v.msg);
      return;
    }

    // 서버 연동은 나중에: 지금은 성공 알림만
    if (window.Swal && window.Swal.fire) window.Swal.fire({ icon:'success', text:'검증 완료! (서버 연동은 추후)' });
    else alert('검증 완료! (서버 연동은 추후)');

    // 초기화
    let content = root.querySelector('#content');
    if (content) content.value = '';
    let stars = root.querySelectorAll('#starsGroup .starBtn');
    for (let i = 0; i < stars.length; i++) stars[i].setAttribute('aria-checked','false');
    let input = root.querySelector('#imageInput');
    if (input && window.DataTransfer) {
      let dt = new DataTransfer();
      input.files = dt.files;
    }
    let grid = root.querySelector('#previewGrid');
    renderPreview(grid, (input ? input.files : []));
    updateCounter(root);
  };
};
</script>


</body>
</html>
