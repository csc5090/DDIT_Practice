<%@ page language="java" contentType="text/html; charset=UTF-8"
     isELIgnored="true" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>리뷰 게시판</title>

<style>
/* ========== 기본 레이아웃 ========== */
html, body { margin:0; height:100%; overflow:hidden; }

.whiteAll-center{
  display:grid;
  place-items:center;
  height:100%;
}

.openModal{
  border:1px solid black;
  padding:10px 14px;
  background:#fff;
  cursor:pointer;
}

/* ========== 모달 표시/중앙 정렬 ========== */
.reviewModal[hidden]{ display:none !important; }

.reviewModal{
  display:grid;
  position:fixed; inset:0;
  place-items:center;
}

/* ========== 모달 박스 ========== */
.reviewDialog{
  display:grid;
  width:70vw; min-width:300px;
  height:85vh;
  background:white;
  border:1px solid black;
  border-radius:18px;
  box-sizing:border-box;

  grid-template-rows:auto 1fr auto;
  overflow:hidden;
}

/* ========== 헤더 ========== */
.reviewHeader{
  display:flex;
  align-items:center; justify-content:space-between; gap:10px;
  padding:15px;
  border-bottom:1px solid #ccc;
}
.reviewTitle{ font-weight:700; }

/* 공통 버튼 */
.closeModal, .wrtReviewBtn{
  padding:10px;
  border-radius:10px;
  border:1px solid #ccc;
  background:white;
  cursor:pointer;
}

/* ========== 콘텐츠 리스트(스크롤 + 스크롤바 숨김) ========== */
.innerContent{
  overflow:auto;
  padding:14px;
  -ms-overflow-style:none;   /* IE/Edge(레거시) */
  scrollbar-width:none;      /* Firefox */
}
.innerContent::-webkit-scrollbar{ width:0; height:0; }

.reviewList{ display:grid; gap:14px; }
.card{
  border:1px solid #ccc;
  border-radius:16px;
  padding:14px 16px 16px;
  background:#fff;
}
.head{ display:flex; align-items:center; gap:12px; margin-bottom:10px; }
.nickname{ font-weight:700; }
.stars { color:#f7b500; font-size:14px; }
.date{ margin-left:auto; }

.body{ padding-left:18px; display:grid; gap:10px; }
.row{
  display:grid;
  grid-template-columns:84px 1fr;
  gap:12px; align-items:start;
}
.thumb{
  width:84px; height:84px;
  border:1px solid #ccc;
  border-radius:10px;
  overflow:hidden;
  background:#fff;
}
.thumb img{ width:100%; height:100%; object-fit:cover; display:block; }

.reply{
  margin-top:4px;
  border-left:3px solid green;
  padding:10px;
  border-radius:8px;
}

/* ========== 작성 영역(Composer) ========== */
.wrtReview{
  height:7vh;
  border-top:1px solid #ccc;
  background:#fff;
  display:grid; grid-template-rows:auto 1fr;
}
.wrtReview.open{ height:32vh; }

.bottomBar{
  display:flex;
  align-items:center; gap:10px;
  padding:10px;
}
.wrtlabel{ font-weight:700; }


.wrtBody{
  display:grid;
  grid-template-columns:  minmax(0, 52%) minmax(0, 48%); 
  gap:10px;
  padding:0 16px 16px 16px;
  opacity:0; pointer-events:none;

  overflow:auto;
  -ms-overflow-style:none;
  scrollbar-width:none;
}
.wrtBody::-webkit-scrollbar{ width:0; height:0; }
.wrtReview.open .wrtBody{ opacity:1; pointer-events:auto; }

/* 좌측: 별점 + 이미지 */
.wrtLeft{
  display:grid; grid-template-rows:auto auto; gap:10px; min-width:0;
}

/* 라벨-필드 2열 */
.wrtRow{
  display:grid; grid-template-columns:72px 1fr; gap:10px; align-items:center;
}
.wrtRow-text{ align-items:stretch; }

.wrtFieldLabel{ font-size:13px; }

/* 별점 버튼 */
.starPoint{ display:inline-flex; align-items:center; gap:6px; }
.starPoint .star{
  width:34px; height:34px;
  border:1px solid #ccc; border-radius:10px;
  background:#fff; cursor:pointer;
  display:grid; place-items:center;
}
.starPoint .star.filled{
  background:#f5f5f5; color:#f7b500; border-color:#bbb;
}

/* 이미지 미리보기 + 컨트롤 (작게/낮게) */
.imgArea{ display:grid; gap:8px; }
.imgControls{
  display:flex; gap:8px;
  flex-wrap:wrap;                 
}

.imgPreview{
  display:grid;
  grid-template-columns: repeat(auto-fill, minmax(56px, 1fr)); 
  gap:8px;
  width: 20vh;
  height: 50vh;
  min-height:56px;
  max-height:112px;
  overflow:auto;
  border:1px solid #ccc; border-radius:8px; padding:8px;
  background:#fff;

  -ms-overflow-style:none;
  scrollbar-width:none;
}
.imgPreview::-webkit-scrollbar{ width:0; height:0; }
.imgItem{
  width:100%; aspect-ratio:1/1;
  border:1px solid #ccc; border-radius:8px; overflow:hidden;
  background:#f5f5f5; display:block;
}
.imgItem img{ width:100%; height:100%; object-fit:cover; display:block; }

/* 우측: 내용 + 등록 버튼 (세로 정렬, 버튼 잘림 방지) */
.wrtRight{
  display:grid; grid-template-rows:auto 1fr auto; gap:10px; min-width:0;
  align-content:start;
}

/* 입력창(더 넓게, 높이 여유) */
textarea#iReviewText{
  width:100%; height:100%;
  min-height:150px;               /* 기존 120 -> 150 */
  resize:none;
  border:1px solid #ccc; border-radius:12px;
  padding:12px;
  font:inherit; outline:none;
}

/* 버튼들 */
.addImageBtn, .submitBtn{
  padding:10px 12px; border-radius:12px; cursor:pointer; font-weight:600;
}
.addImageBtn{ border:1px solid #ccc; background:#fff; width:auto; } /* 좌측 버튼은 내용폭 */
.submitBtn{ border:1px solid #ccc; background:#fff; width:100%; }   /* 우측 등록 버튼은 가로 100% */

/* 반응형 */
@media (max-width:760px){
  .reviewDialog{ width:min(92vw, 620px); }
  .wrtBody{ grid-template-columns:1fr; }
  .submitBtn{ width:100%; }
}

</style>
</head>
<body>

<div class="whiteAll-center">
  <button id="iOpenModal" class="openModal" type="button">Review Modal</button>
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
        <!-- 좌측: 별점 + 이미지 -->
        <div class="wrtLeft">
          <!-- 별점 -->
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

          <!-- 이미지 미리보기 + 추가 -->
          <div class="wrtRow">
            <label class="wrtFieldLabel">이미지</label>
            <div class="imgArea">
              <div id="iImgPreview" class="imgPreview" aria-live="polite"></div>
              <div class="imgControls">
                <button id="iAddImageBtn" class="addImageBtn" type="button">이미지 추가</button>
                <input id="iImageInput" type="file" accept="image/*" multiple hidden>
              </div>
            </div>
          </div>
        </div>

        <!-- 우측: 내용 + 등록 -->
        <div class="wrtRight">
          <label class="wrtFieldLabel" for="iReviewText">내용</label>
          <textarea id="iReviewText" placeholder="이미지(선택)와 함께 리뷰를 작성해 주세요."></textarea>
          <button id="iSubmitBtn" class="submitBtn" type="button">리뷰 등록</button>
        </div>
      </div>
    </aside>
  </div> <!-- reviewDialog -->
</div> <!-- reviewModal -->

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
    root: null, toggleBtn: null, textarea: null, images: [],
    open(){ 
      this.root.classList.add('open'); 
      this.toggleBtn.setAttribute('aria-expanded','true'); 
      setTimeout(()=>this.textarea.focus(), 100); 
      this.toggleBtn.textContent = '닫기';
    },
    close(){ 
      this.root.classList.remove('open'); 
      this.toggleBtn.setAttribute('aria-expanded','false'); 
      this.toggleBtn.textContent = '열기';
    },
    toggle(){ this.root.classList.contains('open') ? this.close() : this.open(); }
  };

  window.onload = () => {
    const list = document.getElementById('iReviewList');
    renderList(list, DEMO);

    /* 모달 열기/닫기 */
    openBtn.addEventListener('click', ()=>{
      modalEl.hidden = false;
      modalEl.removeAttribute('aria-hidden');
    });
    closeBtn.addEventListener('click', ()=>{
      modalEl.hidden = true;
      modalEl.setAttribute('aria-hidden','true');
      // 미리보기 URL 정리
      cleanupPreviewURLs();
    });

    /* 작성창 연결 */
    composer.root = document.getElementById('iWrtReview');
    composer.toggleBtn = document.getElementById('iwrtReviewBtn');
    composer.textarea = document.getElementById('iReviewText');

    composer.toggleBtn.addEventListener('click', ()=> composer.toggle());
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

    ratingEl.addEventListener('click', function(e){
      var btn = e.target.closest('.star');
      if(!btn) return;
      currentRating = parseInt(btn.getAttribute('data-val'), 10);
      applyRatingVisual();
    });
    ratingEl.addEventListener('mousemove', function(e){
      var btn = e.target.closest('.star');
      if(!btn) return;
      var val = parseInt(btn.getAttribute('data-val'), 10);
      applyRatingVisual(val);
    });
    ratingEl.addEventListener('mouseleave', function(){ applyRatingVisual(); });
    ratingEl.addEventListener('keydown', function(e){
      if(e.key === 'ArrowLeft' || e.key === 'ArrowDown'){ currentRating = Math.max(1, currentRating - 1); applyRatingVisual(); e.preventDefault(); }
      if(e.key === 'ArrowRight' || e.key === 'ArrowUp'){ currentRating = Math.min(5, currentRating + 1); applyRatingVisual(); e.preventDefault(); }
    });
    ratingEl.tabIndex = 0;

    /* 이미지 선택/미리보기 */
    const imgInput   = document.getElementById('iImageInput');
    const imgPreview = document.getElementById('iImgPreview');
    const addImgBtn  = document.getElementById('iAddImageBtn');

    addImgBtn.addEventListener('click', ()=> imgInput.click());

    imgInput.addEventListener('change', ()=>{
      const files = Array.from(imgInput.files || []).filter(f => /^image\//.test(f.type));
      composer.images = (composer.images || []).concat(files).slice(0, 12); // 최대 12장
      renderImagePreview();
    });

    function renderImagePreview(){
      imgPreview.innerHTML = '';
      (composer.images || []).forEach((file, idx)=>{
        const url = URL.createObjectURL(file);
        const a = document.createElement('a');
        a.className = 'imgItem';
        a.href = url; a.target = '_blank'; a.rel = 'noopener';
        a.title = file.name || ('image_'+(idx+1));
        const img = document.createElement('img');
        img.src = url;
        a.appendChild(img);
        imgPreview.appendChild(a);
        // URL은 모달 닫힐 때 일괄 revoke
      });
    }

    function cleanupPreviewURLs(){
      // a[href]로 만들어둔 blob URL 회수
      document.querySelectorAll('#iImgPreview a[href^="blob:"]').forEach(a=>{
        try{ URL.revokeObjectURL(a.href); }catch(e){}
      });
      imgPreview.innerHTML = '';
      if (imgInput) imgInput.value = '';
      composer.images = [];
    }

    /* 리뷰 등록 */
    document.getElementById('iSubmitBtn').addEventListener('click', ()=>{
      const value = composer.textarea.value.trim();
      if(!value){ alert('리뷰 내용을 입력하세요.'); return; }

      // 썸네일: 선택 이미지 있으면 첫 장, 없으면 플레이스홀더
      let imgSrc = placeholderDataURI('NEW');
      if (composer.images && composer.images[0]) {
        imgSrc = URL.createObjectURL(composer.images[0]);
      }

      const newItem = {
        id: DEMO.length+1, nickname: '게스트'+(DEMO.length+1), stars: currentRating,
        date: new Date().toISOString().slice(0,10), img: imgSrc,
        text: value, adminReply: '관리자: 등록 감사합니다.'
      };
      DEMO.unshift(newItem);
      renderList(list, DEMO);

      // 입력 리셋
      composer.textarea.value = '';
      cleanupPreviewURLs();
      composer.close();
      list.parentElement.scrollTop = 0;
    });
  };
</script>

</body>
</html>
