<%@ page language="java" contentType="text/html; charset=UTF-8"
	isELIgnored="true" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>리뷰 게시판5</title>

<style>

/* 닫기 시 숨김 (무조건) */
.reviewModal[hidden] { display: none !important; }

/* 모달 창 위치, inset 속성을 줘서 화면전체를 덮는 다는 설정(화면 중앙)  */
.reviewModal {
  display: grid;
  position: fixed;
  inset: 0;
  place-items: center;
  z-index: 50;
}

.reviewDialog {
  width: 40vw;
  min-width: 340px;
  height: 85vh;
  background: #fff;
  border-radius: 18px;
  border: 1px solid #ececec;
  box-shadow: 0 24px 80px rgba(0, 0, 0, .25);
  display: grid;
  grid-template-rows: auto 1fr auto;
  overflow: hidden;
}

.reviewHeader {
  display: flex;
  align-items: center;
  gap: 10px;
  justify-content: space-between;
  padding: 12px 16px;
  border-bottom: 1px solid #ececec;        /* var(--border) */
  background: #fff;
}

.reviewTitle { font-weight: 700; }

.muted {
  color: #656565; /* var(--muted) */
  font-size: 13px;
}

/* 공통 버튼 스타일 (닫기 / 열기 / 리뷰작성) */
.closeModal,
.wrtReviewBtn {
  border: 1px solid #ececec;               /* var(--border) */
  background: #f9f9f9;
  color: #333;
  font-size: 14px;
  font-weight: 600;
  border-radius: 10px;
  padding: 6px 12px;
  cursor: pointer;
  transition: background 0.2s ease, transform 0.1s ease;
}

.closeModal:hover,
.wrtReviewBtn:hover { background: #e8e8e8; }

.closeModal:active,
.wrtReviewBtn:active { transform: scale(0.97); }

/* Content area */
.innerContent {
  overflow: auto;
  padding: 14px 14px 10px 14px;
}

.innerContent::-webkit-scrollbar { display: none; }

.reviewList {
  display: grid;
  gap: 14px; /* var(--gap) */
}

.card {
  border: 1px solid #ececec;               /* var(--border) */
  border-radius: 16px;                      /* var(--radius) */
  box-shadow: 0 6px 20px rgba(0, 0, 0, .08);/* var(--shadow) */
  background: #fff;
  padding: 14px 16px 16px;
}

.head {
  display: flex;
  align-items: center;
  gap: 12px;
  margin-bottom: 10px;
}

.nickname { font-weight: 700; }

.stars {
  color: #f7b500;
  font-size: 15px;
}

.date {
  margin-left: auto;
  color: #656565; /* var(--muted) */
  font-size: 12px;
}

.body {
  padding-left: 18px; /* var(--indent) */
  display: grid;
  gap: 10px;
}

.row {
  display: grid;
  grid-template-columns: 84px 1fr;
  gap: 12px;
  align-items: start;
}

.thumb {
  width: 84px;
  height: 84px;
  border-radius: 10px;
  border: 1px solid #ececec;               /* var(--border) */
  overflow: hidden;
  background: #fafafa;
}

.thumb img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
}

.text { white-space: pre-wrap; }

.reply {
  margin-top: 4px;
  padding-left: 16px; /* calc(34px - 18px) → var(--indent-2) - var(--indent) */
  border-left: 3px solid #eef3ff;
  background: #f7faff;
  color: #2b3a55;
  border-radius: 8px;
  padding: 10px 12px;
  font-size: 14px;
}

/* Writer (composer) */
.wrtReview {
  height: 64px;                             /* var(--composer-h) */
  border-top: 1px solid #ececec;            /* var(--border) */
  background: #fff;
  transition: height .25s ease;
  display: grid;
  grid-template-rows: auto 1fr;
}

.wrtReview.open { height: 42vh; }           /* var(--composer-open-h) */

.bottomBar {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 8px 12px;
}

.wrtlabel { font-weight: 700; }

.wrtBody {
  display: grid;
  grid-template-columns: 1fr auto;
  gap: 10px;
  padding: 0 12px 12px 12px;
  opacity: 0;
  pointer-events: none;
  transition: opacity .2s ease;
}

.wrtReview.open .wrtBody {
  opacity: 1;
  pointer-events: auto;
}

textarea#iReviewText {
  width: 100%;
  height: 100%;
  resize: none;
  border: 1px solid #ececec;                /* var(--border) */
  border-radius: 12px;
  padding: 12px;
  font: inherit;
  outline: none;
}

.wrtBtns {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.submitBtn {
  border: none;
  background: #0a84ff;                      /* var(--brand) */
  color: #fff;
  padding: 10px 16px;
  border-radius: 12px;
  cursor: pointer;
  font-weight: 600;
}

.addImageBtn {
  border: 1px solid #ececec;                /* var(--border) */
  background: #fff;
  padding: 10px 16px;
  border-radius: 12px;
  cursor: pointer;
}

/* Rating input */
.starPoint {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  padding: 4px 6px 6px 6px;
}

.starPoint .star {
  font-size: 20px;
  line-height: 1;
  border: 1px solid #ececec;                /* var(--border) */
  background: #fff;
  width: 34px;
  height: 34px;
  border-radius: 10px;
  cursor: pointer;
  display: grid;
  place-items: center;
  transition: transform .05s ease, box-shadow .2s ease;
}

.starPoint .star:hover {
  box-shadow: 0 4px 14px rgba(0, 0, 0, .08);
}

.starPoint .star:active {
  transform: translateY(1px) scale(.98);
}

.starPoint .star.filled { color: #f7b500; }

@media (max-width: 760px) {
  .reviewDialog {
    width: min(92vw, 620px);
    height: 88vh;
  }
  .row { grid-template-columns: 70px 1fr; }
}


</style>

</head>
<body>

	<div class="whiteAll-center">
		<button id="iOpenModal" class="openModal" type="button">Review Board</button>
	</div>

	<div id="iReviewModal" class="reviewModal" hidden>
		<div class="reviewDialog">
			<div class="reviewHeader">
				<div class="reviewTitle">Review</div>
				<button id="iCloseModal" class="closeModal" type="button">닫기</button>
			</div>

			<div class="innerContent">
				<section id="iReviewList" class="reviewList"></section>
			</div>

			<aside id="iWrtReview" class="wrtReview">
				<div class="bottomBar">
					<div class="wrtlabel">Review 작성</div>
					<button id="iwrtReviewBtn" class="wrtReviewBtn" type="button">열기</button>
				</div>

				<div class="wrtBody">
					<div class="wrtLeft">
						<div class="wrtRow">
							<label class="wrtFieldLabel" for="iStarPoint">별점</label>
							<div id="iStarPoint" class="starPoint" role="radiogroup">
								<button class="star" type="button" data-val="1" role="radio">★</button>
								<button class="star" type="button" data-val="2" role="radio">★</button>
								<button class="star" type="button" data-val="3" role="radio">★</button>
								<button class="star" type="button" data-val="4" role="radio">★</button>
								<button class="star" type="button" data-val="5" role="radio">★</button>
							</div>
						</div>

						<div class="wrtRow wrtRow-text">
							<label class="wrtFieldLabel" for="iReviewText">내용</label>
							<textarea id="iReviewText" placeholder="이미지(선택)와 함께 리뷰를 작성해 주세요."></textarea>
						</div>
					</div>

					<div class="wrtRight">
						<button id="iAddImageBtn" class="addImageBtn" type="button">이미지 추가</button>
						<button id="iSubmitBtn" class="submitBtn" type="button">리뷰 등록</button>
					</div>
				</div>
			</aside>

		</div> <!-- reviewDialog -->
	</div> <!-- 리뷰작성 모달창 -->

	<script>
  /* 유틸 */
  function starString(n){ return '★'.repeat(n) + '☆'.repeat(Math.max(0, 5-n)); }
  function placeholderDataURI(text){
    var svg = "<svg xmlns='http://www.w3.org/2000/svg' width='240' height='240'>"
      + "<rect width='100%' height='100%' fill='#f3f6fa'/>"
      + "<rect x='16' y='16' width='208' height='208' rx='16' fill='#dfe7f3'/>"
      + "<text x='50%' y='52%' dominant-baseline='middle' text-anchor='middle' font-size='20' font-family='Arial, sans-serif' fill='#394b63'>" + text + "</text>"
      + "</svg>";
    return "data:image/svg+xml;charset=utf-8," + encodeURIComponent(svg);
  }

  /* 더미 데이터 */
  const DEMO = Array.from({length: 10}).map((_,i)=>({ 
    id: i+1,
    nickname:["네온고양이","사이버펑크","데이터러버","블루칩","픽셀러","광자","알파","베타","감마","델타"][i],
    stars:[5,4,3,5,2,4,5,3,4,5][i],
    date:["2025-10-12","2025-10-13","2025-10-14","2025-10-15","2025-10-16","2025-10-17","2025-10-18","2025-10-19","2025-10-20","2025-10-21"][i],
    img: placeholderDataURI("REVIEW "+(i+1)),
    text:[
      "빛나는 네온이 분위기 끝판왕입니다. UI가 군더더기 없이 깔끔해서 별 다섯개 남깁니다!",
      "고정된 작성창 아이디어 좋네요. 클릭하면 위로 자연스럽게 펼쳐져서 사용하기 편합니다.",
      "별점만 남기는 간결한 방식이 좋아요. 제목/좋아요/싫어요가 없어도 충분히 명확해요.",
      "닉네임 기준으로 아래 컨텐츠 들여쓰기가 깔끔해요.",
      "스크롤바가 안 보여서 화면이 더 차분합니다. 접근성도 좋아요.",
      "모달 폭이 1/3이라 집중해서 보기 좋아요.",
      "관리자 댓글 블록이 구분되어 가독성 좋아요.",
      "더미 데이터로 전체 동작을 테스트했습니다.",
      "반응형에서도 폭 조정이 자연스럽습니다.",
      "전반적으로 미니멀하고 모던합니다."
    ][i],
    adminReply:[
      "관리자: 좋은 피드백 감사합니다! 다음 업데이트에 반영하겠습니다.",
      "관리자: 성능 최적화도 함께 진행 중이에요.",
      "관리자: 별점 외 메타정보는 옵션으로 검토하겠습니다.",
      "관리자: 레이아웃은 카드형 유지 예정입니다.",
      "관리자: 접근성 ARIA 라벨을 더 보강하겠습니다.",
      "관리자: 네비게이션 개선 검토 중입니다.",
      "관리자: 색 대비 향상 작업 진행.",
      "관리자: 더미 항목 수를 늘려 테스트하겠습니다.",
      "관리자: 모바일 터치 타겟 개선 진행.",
      "관리자: 감사합니다!"
    ][i]
  }));

  function renderList(listEl, data){
	  listEl.innerHTML = "";
	  for (const item of data){
	    const el = document.createElement('article');
	    el.className = 'card';

	    el.innerHTML =
	      '<div class="head">' +
	        '<span class="nickname">' + item.nickname + '</span>' +
	        '<span class="stars" aria-label="' + item.stars + '점">' + starString(item.stars) + '</span>' +
	        '<span class="date">' + item.date + '</span>' +
	      '</div>' +
	      '<div class="body">' +
	        '<div class="row">' +
	          '<div class="thumb"><img src="' + item.img + '" alt="리뷰 이미지 ' + item.id + '"></div>' +
	          '<div class="text">' + item.text + '</div>' +
	        '</div>' +
	        '<div class="reply">' + item.adminReply + '</div>' +
	      '</div>';

	    listEl.appendChild(el);
	  }
	}

  /* 엘리먼트 참조 */
  const modalEl   = document.getElementById('iReviewModal');
  const openBtn   = document.getElementById('iOpenModal');
  const closeBtn  = document.getElementById('iCloseModal');

  const composer = {
    root: null, toggleBtn: null, textarea: null,
    open(){ 
      this.root.classList.add('open'); 
      this.toggleBtn.setAttribute('aria-expanded','true'); 
      setTimeout(()=>this.textarea.focus(), 100); 
    },
    close(){ 
      this.root.classList.remove('open'); 
      this.toggleBtn.setAttribute('aria-expanded','false'); 
    },
    toggle(){ this.root.classList.contains('open') ? this.close() : this.open(); }
  };

  window.onload = () => {
    const list = document.getElementById('iReviewList');
    renderList(list, DEMO);

    /* 모달 열기/닫기 (hidden 토글) */
    openBtn.addEventListener('click', ()=>{
      modalEl.hidden = false;
      modalEl.removeAttribute('aria-hidden');
    });
    closeBtn.addEventListener('click', ()=>{
      modalEl.hidden = true;
      modalEl.setAttribute('aria-hidden','true');
    });

    /* 작성창 연결 */
    composer.root = document.getElementById('iWrtReview');
    composer.toggleBtn = document.getElementById('iwrtReviewBtn');
    composer.textarea = document.getElementById('iReviewText');
    composer.toggleBtn.addEventListener('click', ()=>{
    	  	 composer.toggle();
    	  // 버튼 텍스트 토글
    	     composer.toggleBtn.textContent = composer.root.classList.contains('open') ? '닫기' : '열기';
    });
    composer.root.querySelector('.bottomBar').addEventListener('click', (e)=>{
      if(!e.target.closest('button')) composer.open();
    });

    /* 별점 컨트롤러 */
    var currentRating = 5;
    var ratingEl = document.getElementById('iStarPoint');
    var starButtons = Array.prototype.slice.call(ratingEl.querySelectorAll('.star'));

    function applyRatingVisual(temp){
      var val = temp != null ? temp : currentRating;
      starButtons.forEach(function(btn){
        var n = parseInt(btn.getAttribute('data-val'), 10);
        btn.classList.toggle('filled', n <= val);
        btn.setAttribute('aria-checked', String(n === val));
      });
    }
    applyRatingVisual();

    // mouse click
    ratingEl.addEventListener('click', function(e){
      var btn = e.target.closest('.star');
      if(!btn) return;
      currentRating = parseInt(btn.getAttribute('data-val'), 10);
      applyRatingVisual();
    });

    // hover preview
    ratingEl.addEventListener('mousemove', function(e){
      var btn = e.target.closest('.star');
      if(!btn) return;
      var val = parseInt(btn.getAttribute('data-val'), 10);
      applyRatingVisual(val);
    });
    ratingEl.addEventListener('mouseleave', function(){ applyRatingVisual(); });

    // keyboard support
    ratingEl.addEventListener('keydown', function(e){
      if(e.key === 'ArrowLeft' || e.key === 'ArrowDown'){ currentRating = Math.max(1, currentRating - 1); applyRatingVisual(); e.preventDefault(); }
      if(e.key === 'ArrowRight' || e.key === 'ArrowUp'){ currentRating = Math.min(5, currentRating + 1); applyRatingVisual(); e.preventDefault(); }
    });
    ratingEl.tabIndex = 0;

    /* 리뷰 등록 */
    document.getElementById('iSubmitBtn').addEventListener('click', ()=>{
      const value = composer.textarea.value.trim();
      if(!value){ alert('리뷰 내용을 입력하세요.'); return; }
      const newItem = {
        id: DEMO.length+1, nickname: '게스트'+(DEMO.length+1), stars: currentRating,
        date: new Date().toISOString().slice(0,10), img: placeholderDataURI('NEW'),
        text: value, adminReply: '관리자: 등록 감사합니다.'
      };
      DEMO.unshift(newItem);
      renderList(list, DEMO);
      composer.textarea.value = '';
      composer.close();
      list.parentElement.scrollTop = 0;
    });

    /* 이미지 추가(데모) */
    document.getElementById('iAddImageBtn').addEventListener('click', ()=>{
      alert('데모 모드: 이미지 업로드 대신 플레이스홀더를 사용합니다.');
    });
  };
</script>

</body>
</html>