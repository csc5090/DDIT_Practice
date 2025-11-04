<%@ page language="java" contentType="text/html; charset=UTF-8"
	isELIgnored="true" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>리뷰 게시판2</title>

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

/* 닫기 시 숨김 (무조건) */
.reviewModal[hidden] {
	display: none !important;
}

/* 모달 창 위치, inset 속성을 줘서 화면전체를 덮는 다는 설정(화면 중앙)  */
.reviewModal {
	display: grid;
	position: fixed;
	inset: 0;
	place-items: center;
	z-index: 50;
}

.reviewDialog {
	display: grid;
	width: 40vw;
	min-width: 340px;
	height: 85vh;
	background: white;
	border-radius: 18px;
	border: 1px solid black;
	box-shadow: 0 24px 80px rgba(0, 0, 0, .1);
	grid-template-rows: auto 1fr auto;
	overflow: hidden;
}

/* 모달창 상단 (수평, 좌우끝으로 )*/
.reviewHeader {
	display: flex;
	align-items: center;
	gap: 10px;
	justify-content: space-between;
	padding: 15px;
	border-bottom: 1px solid #ececec;
	background: white;
}

.reviewTitle {
	font-weight: 700;
	font-size: 25px;
}

/* 리뷰 모달창 닫기 버튼, 리뷰작성 열기 버튼 */
.closeModal, .wrtBtn {
	border: 1px solid #ececec;
	background: white;
	color: black;
	font-size: 14px;
	font-weight: 700;
	border-radius: 10px;
	padding: 6px 12px;
}

/* 마우스 호버 시 발생하는 효과 (기본) */
.closeModal:hover, .wrtBtn:hover {
	background: #e8e8e8;
}

/* reviewDialog 내부의 중간영역인 innerContent (스크롤 가능) */
.innerContent {
	overflow: auto;
	padding: 10px;
}

/* innerContent 스크롤 숨김 */
.innerContent::-webkit-scrollbar {
	display: none;
}

/* card(각 review) 정렬 */
.reviewList {
	display: grid;
	gap: 10px;
}

/* card, head, nickname, stars, date, body, row, thumb, text, reply */
.card {
	border: 1px solid #ececec;
	border-radius: 16px;
	box-shadow: 0 6px 20px rgba(0, 0, 0, .1);
	background: white;
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

/* 금색 */
.stars {
	color: #f7b500;
	font-size: 17px;
	transform: translateY(-3px);
}

/* 연하게 */
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

/* thumb(이미지)와 text(리뷰본문) */
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
}

.thumb img {
	width: 100%;
	height: 100%;
	object-fit: cover;
	display: block;
}

/* 리뷰 본문 */
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

/* 리뷰 작성창 (닫혀 있을때) 열고 닫을 때 에니메이션 포함 */
.wrtReview {
	height: 7vh;
	border-top: 1px solid #ececec;
	background: white;
	transition: height .25s ease;
	display: grid;
	grid-template-rows: auto 1fr;
}

/* 리뷰 작성창 열었을 때 높이 */
.wrtReview.open {
	height: 42vh;
}

.bottomBar {
	display: flex;
	align-items: center;
	justify-content: space-between;
	gap: 10px;
	padding: 15px;
}

/* Riview 작성 라벨 글자 */
.wrtlabel {
	font-weight: 700;
	color: black;
	font-size: 17px;
}

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
	border: 1px solid #ececec;
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
	background: #0a84ff;
	color: #fff;
	padding: 10px 16px;
	border-radius: 12px;
	cursor: pointer;
	font-weight: 600;
}

.addImageBtn {
	border: 1px solid #ececec;
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
	border: 1px solid #ececec;
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

.starPoint .star.filled {
	color: #f7b500;
}

@media ( max-width : 760px) {
	.reviewDialog {
		width: min(92vw, 620px);
		height: 88vh;
	}
	.row {
		grid-template-columns: 70px 1fr;
	}
}
</style>

</head>
<body>

	<div class="whiteAll-center">
		<button id="iOpenModal" class="openModal" type="button">Review
			Board</button>
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
					<button id="iwrtBtn" class="wrtBtn" type="button">열기</button>
				</div>

				<div class="wrtBody wrtBody--twoCols">
					<!-- 좌측: 좁게 (별점 + 이미지) -->
					<div class="wrtColLeft">
						<!-- 별점 -->
						<div class="wrtRow">
							<label for="iStarPoint" class="wrtReviewLabel">별점</label>
							<div id="iStarPoint" class="starPoint" role="radiogroup"
								aria-label="리뷰 별점 선택">
								<button class="star" type="button" data-val="1" role="radio"
									aria-checked="false">★</button>
								<button class="star" type="button" data-val="2" role="radio"
									aria-checked="false">★</button>
								<button class="star" type="button" data-val="3" role="radio"
									aria-checked="false">★</button>
								<button class="star" type="button" data-val="4" role="radio"
									aria-checked="false">★</button>
								<button class="star" type="button" data-val="5" role="radio"
									aria-checked="false">★</button>
							</div>
						</div>

						<div class="wrtRow">
							<label class="wrtReviewLabel">이미지 미리보기</label>
							<div class="previewGrid" id="iPreview"></div>
							<div class="noImageMsg">이미지 없음</div>
						</div>

						<div class="wrtRow">
							<label for="iImageInput" class="wrtReviewLabel">이미지 선택</label> <input
								id="iImageInput" type="file" accept="image/*" multiple>
							<button id="iAddImageBtn" class="addImageBtn" type="button">이미지
								추가</button>
						</div>
					</div>

					<div class="wrtColRight">
						<div class="wrtRow">
							<label for="iReviewText" class="wrtReviewLabel">리뷰 내용</label>
							<textarea id="iReviewText" placeholder="이미지(선택)와 함께 리뷰를 작성해 주세요."></textarea>
						</div>

						<div class="wrtBtns wrtBtns--rowEnd">
							<button id="iSubmitBtn" class="submitBtn" type="button">리뷰 등록</button>
						</div>
					</div>
				</div>
			</aside>

		</div>
		<!-- reviewDialog -->
	</div>
	<!-- 리뷰작성 모달창 -->

	<script>
  /* 더미 데이이터를 넣기 위한 함수 (별점, 리뷰본문)  */
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

  /* 리뷰를 작성하면 각 card(각 리뷰)에 등록되고 innerContent를 구성하는 랜더링 메서드 */
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
	/* 더미 데이터 */
    const list = document.getElementById('iReviewList');
    renderList(list, DEMO);

    /* 모달 열기버튼 닫기버튼 */
    openBtn.addEventListener('click', ()=>{
      modalEl.hidden = false;
    });
    closeBtn.addEventListener('click', ()=>{
      modalEl.hidden = true;
    });
   
    /* 작성창 연결 */
    composer.root = document.getElementById('iWrtReview');
    composer.toggleBtn = document.getElementById('iwrtBtn');
    composer.textarea = document.getElementById('iReviewText');
    composer.toggleBtn.addEventListener('click', ()=>{
    	  	 composer.toggle();
    	  // 버튼 텍스트 토글
    	     composer.toggleBtn.textContent = composer.root.classList.contains('open') ? '닫기' : '열기';
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

    /* 별점 마우스 클릭 시 몇번째 별인지 읽어서 그 값을 1~5로 저장하고 별채움 */
    ratingEl.addEventListener('click', function(e){
      var btn = e.target.closest('.star');
      if(!btn) return;
      currentRating = parseInt(btn.getAttribute('data-val'), 10);
      applyRatingVisual();
    });

    /* 별점 마우스 호버 시 미리보기 */
    ratingEl.addEventListener('mousemove', function(e){
      var btn = e.target.closest('.star');
      if(!btn) return;
      var val = parseInt(btn.getAttribute('data-val'), 10);
      applyRatingVisual(val);
    });
    ratingEl.addEventListener('mouseleave', function(){ applyRatingVisual(); });

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
    
} //window.onload

</script>

</body>
</html>