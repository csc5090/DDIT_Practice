<%@ page language="java" contentType="text/html; charset=UTF-8"
    isELIgnored="true" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>리뷰 게시판2</title>

<style>
/* ===== 공통 ===== */
*{ box-sizing: border-box; }
html, body{ margin:0; height:100%; }
.whiteAll-center{ height:100%; display:grid; place-items:center; }

/* ===== 모달 ===== */
.reviewModal[hidden]{ display:none !important; }
.reviewModal{
  display:grid; position:fixed; inset:0; place-items:center; z-index:50;
}
.reviewDialog{
  display:grid; width:40vw; min-width:340px; height:85vh;
  background:#fff; border-radius:18px; border:1px solid #000;
  box-shadow:0 24px 80px rgba(0,0,0,.1);
  grid-template-rows:auto 1fr auto; overflow:hidden;
}
/* 헤더 */
.reviewHeader{
  display:flex; align-items:center; gap:10px; justify-content:space-between;
  padding:15px; border-bottom:1px solid #ececec; background:#fff;
}
.reviewTitle{ font-weight:700; font-size:25px; }
.closeModal,.wrtBtn{
  border:1px solid #ececec; background:#fff; color:#000;
  font-size:14px; font-weight:700; border-radius:10px; padding:6px 12px; cursor:pointer;
}
.closeModal:hover,.wrtBtn:hover{ background:#e8e8e8; }

/* 콘텐츠 스크롤 영역 */
.innerContent{ overflow:auto; padding:10px; }
.innerContent::-webkit-scrollbar{ display:none; }

/* 리뷰 카드 리스트 */
.reviewList{ display:grid; gap:10px; }
.card{
  border:1px solid #ececec; border-radius:16px;
  box-shadow:0 6px 20px rgba(0,0,0,.1); background:#fff; padding:15px;
}
.head{ display:flex; align-items:center; gap:10px; margin-bottom:10px; }
.nickname{ font-weight:700; font-size:15px; }
.stars{ color:#f7b500; font-size:17px; transform:translateY(-3px); }
.date{ margin-left:auto; color:#656565; font-size:12px; }
.body{ padding-left:18px; display:grid; gap:10px; }
.row{ display:grid; grid-template-columns:85px 1fr; gap:12px; align-items:start; }
.thumb{
  width:10vh; min-width:85px; height:10vh; border-radius:10px;
  border:1px solid #ececec; overflow:hidden; background:#fafafa;
}
.thumb img{ width:100%; height:100%; object-fit:cover; display:block; }
.text{ white-space:pre-wrap; }
.reply{
  margin-top:4px; padding-left:16px; border-left:3px solid #eef3ff;
  background:#f7faff; color:#2b3a55; border-radius:8px; padding:10px 12px; font-size:14px;
}

/* ===== 작성창(composer) ===== */
.wrtReview{
  height:7vh; border-top:1px solid #ececec; background:#fff;
  transition:height .25s ease; display:grid; grid-template-rows:auto 1fr;
}
.wrtReview.open{ height:42vh; }

/* 상단 바 */
.bottomBar{
  display:flex; align-items:center; justify-content:space-between;
  gap:10px; padding:15px;
}
.wrtlabel{ font-weight:700; color:#000; font-size:17px; }

/* 본문(2열) */
.wrtBody--twoCols{
  display:grid; grid-template-columns:minmax(220px,32%) 1fr;
  gap:16px; padding:0 12px 12px 12px;
  opacity:0; pointer-events:none; transition:opacity .2s ease;
}
.wrtReview.open .wrtBody--twoCols{ opacity:1; pointer-events:auto; }

/* 칼럼 공통 */
.wrtColLeft,.wrtColRight{ display:grid; gap:12px; }
.wrtRow{ display:grid; gap:8px; }
.wrtReviewLabel{ font-weight:700; font-size:14px; color:#333; }

/* 별점 입력 */
.starPoint{
  display:inline-flex; align-items:center; gap:6px; padding:4px 6px 6px 6px;
}
.starPoint .star{
  font-size:20px; line-height:1; border:1px solid #ececec; background:#fff;
  width:34px; height:34px; border-radius:10px; cursor:pointer;
  display:grid; place-items:center; transition:transform .05s ease, box-shadow .2s ease;
}
.starPoint .star:hover{ box-shadow:0 4px 14px rgba(0,0,0,.08); }
.starPoint .star:active{ transform:translateY(1px) scale(.98); }
.starPoint .star.filled{ color:#f7b500; }

/* 텍스트 입력 */
textarea#iReviewText{
  width:100%; min-height:150px; resize:vertical;
  border:1px solid #ececec; border-radius:12px; padding:12px; font:inherit; outline:none;
}

/* 버튼들 */
.wrtBtns{ display:flex; gap:10px; }
.wrtBtns--rowEnd{ display:flex; justify-content:flex-end; }
.submitBtn{
  border:none; background:#0a84ff; color:#fff; padding:10px 16px;
  border-radius:12px; cursor:pointer; font-weight:600;
}

/* 파일 선택(커스텀 버튼) */
.fileSelectWrap{ display:grid; gap:8px; }
#iImageInput{ /* 기본 파일 인풋은 숨겨 '선택된 파일 없음' 문구 제거 */
  position:absolute; width:1px; height:1px; padding:0; margin:-1px;
  overflow:hidden; clip:rect(0 0 0 0); white-space:nowrap; border:0;
}
.fileSelectBtn{
  border:1px solid #ececec; background:#fff; padding:10px 16px;
  border-radius:12px; cursor:pointer; text-align:center; font-weight:600;
}
.fileSelectBtn:hover{ background:#f4f4f4; }

/* 이미지 미리보기 */
.previewGrid{
  display:grid; grid-template-columns:repeat(auto-fill, minmax(90px, 1fr));
  gap:10px; padding:6px 0;
}
.noImageMsg{
  display:grid; place-items:center; height:80px; border:1px dashed #ccc;
  border-radius:10px; color:#999; font-size:14px; background:#fafafa;
}
.previewGrid.hasImages .noImageMsg{ display:none; }
.previewItem{
  position:relative; border:1px solid #ececec; border-radius:10px;
  overflow:hidden; background:#fafafa; aspect-ratio:1/1;
}
.previewItem img{ width:100%; height:100%; object-fit:cover; display:block; }
.previewRemove{
  position:absolute; top:6px; right:6px; border:none; border-radius:8px;
  padding:2px 6px; font-size:12px; color:#fff; background:rgba(0,0,0,.6); cursor:pointer;
}

/* 드래그&드롭 하이라이트 */
.wrtColLeft.dropping{ outline:2px dashed #0a84ff; outline-offset:6px; border-radius:12px; }

/* 반응형 */
@media (max-width:760px){
  .reviewDialog{ width:min(92vw, 620px); height:88vh; }
  .row{ grid-template-columns:70px 1fr; }
  .wrtBody--twoCols{ grid-template-columns:1fr; }
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
          <button id="iwrtBtn" class="wrtBtn" type="button"
                  aria-expanded="false" aria-controls="iWrtReview">열기</button>
        </div>

        <!-- 2열 본문 -->
        <div class="wrtBody--twoCols">
          <!-- 좌측: 별점 / 파일선택 버튼 / 미리보기 -->
          <div class="wrtColLeft">
            <div class="wrtRow">
              <label for="iStarPoint" class="wrtReviewLabel">별점</label>
              <div id="iStarPoint" class="starPoint" role="radiogroup" aria-label="리뷰 별점 선택">
                <button class="star" type="button" data-val="1" role="radio" aria-checked="false">★</button>
                <button class="star" type="button" data-val="2" role="radio" aria-checked="false">★</button>
                <button class="star" type="button" data-val="3" role="radio" aria-checked="false">★</button>
                <button class="star" type="button" data-val="4" role="radio" aria-checked="false">★</button>
                <button class="star" type="button" data-val="5" role="radio" aria-checked="false">★</button>
              </div>
            </div>

            <!-- 파일선택 버튼 1개만 노출 -->
            <div class="wrtRow fileSelectWrap">
              <input id="iImageInput" type="file" accept="image/*" multiple>
              <label for="iImageInput" class="fileSelectBtn">파일 선택</label>
            </div>

            <div class="wrtRow">
              <label class="wrtReviewLabel">미리보기</label>
              <div id="iPreview" class="previewGrid">
                <div class="noImageMsg">이미지 없음</div>
              </div>
            </div>
          </div>

          <!-- 우측: 텍스트 / 등록 버튼 -->
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
  </div>

<script>
/* ===== 유틸 ===== */
function starString(n){ return '★'.repeat(n) + '☆'.repeat(Math.max(0, 5-n)); }
function placeholderDataURI(text){
  var svg = "<svg xmlns='http://www.w3.org/2000/svg' width='240' height='240'>"
    + "<rect width='100%' height='100%' fill='#f3f6fa'/>"
    + "<rect x='16' y='16' width='208' height='208' rx='16' fill='#dfe7f3'/>"
    + "<text x='50%' y='52%' dominant-baseline='middle' text-anchor='middle' font-size='20' font-family='Arial, sans-serif' fill='#394b63'>" + text + "</text>"
    + "</svg>";
  return "data:image/svg+xml;charset=utf-8," + encodeURIComponent(svg);
}

/* ===== 더미 데이터(DEMO) ===== */
const DEMO = Array.from({length:10}).map((_,i)=>({
  id:i+1,
  nickname:["네온고양이","사이버펑크","데이터러버","블루칩","픽셀러","광자","알파","베타","감마","델타"][i],
  stars:[5,4,3,5,2,4,5,3,4,5][i],
  date:["2025-10-12","2025-10-13","2025-10-14","2025-10-15","2025-10-16","2025-10-17","2025-10-18","2025-10-19","2025-10-20","2025-10-21"][i],
  img:placeholderDataURI("REVIEW "+(i+1)),
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

/* ===== 렌더링 ===== */
function renderList(listEl, data){
  listEl.innerHTML = "";
  for (const item of data){
    const el = document.createElement('article');
    el.className = 'card';
    el.innerHTML =
      '<div class="head">'
        + '<span class="nickname">' + item.nickname + '</span>'
        + '<span class="stars" aria-label="' + item.stars + '점">' + starString(item.stars) + '</span>'
        + '<span class="date">' + item.date + '</span>'
      + '</div>'
      + '<div class="body">'
        + '<div class="row">'
          + '<div class="thumb"><img src="' + item.img + '" alt="리뷰 이미지 ' + item.id + '"></div>'
          + '<div class="text">' + item.text + '</div>'
        + '</div>'
        + '<div class="reply">' + item.adminReply + '</div>'
      + '</div>';
    listEl.appendChild(el);
  }
}

/* ===== 엘리먼트 참조 ===== */
const modalEl  = document.getElementById('iReviewModal');
const openBtn  = document.getElementById('iOpenModal');
const closeBtn = document.getElementById('iCloseModal');

const composer = {
  root:null, toggleBtn:null, textarea:null,
  open(){ this.root.classList.add('open'); this.toggleBtn.setAttribute('aria-expanded','true'); setTimeout(()=>this.textarea.focus(),100); },
  close(){ this.root.classList.remove('open'); this.toggleBtn.setAttribute('aria-expanded','false'); },
  toggle(){ this.root.classList.contains('open') ? this.close() : this.open(); }
};

window.onload = () => {
  /* 목록 렌더 */
  const list = document.getElementById('iReviewList');
  renderList(list, DEMO);

  /* 모달 열기/닫기 */
  openBtn.addEventListener('click', ()=>{ modalEl.hidden = false; });
  closeBtn.addEventListener('click', ()=>{ modalEl.hidden = true; });

  /* 작성창 연결 */
  composer.root = document.getElementById('iWrtReview');
  composer.toggleBtn = document.getElementById('iwrtBtn');
  composer.textarea = document.getElementById('iReviewText');
  composer.toggleBtn.addEventListener('click', ()=>{
    composer.toggle();
    composer.toggleBtn.textContent = composer.root.classList.contains('open') ? '닫기' : '열기';
  });

  /* 별점 컨트롤러 */
  let currentRating = 5;
  const ratingEl = document.getElementById('iStarPoint');
  const starButtons = Array.prototype.slice.call(ratingEl.querySelectorAll('.star'));

  function applyRatingVisual(temp){
    const val = temp != null ? temp : currentRating;
    starButtons.forEach(btn=>{
      const n = parseInt(btn.getAttribute('data-val'), 10);
      btn.classList.toggle('filled', n <= val);
      btn.setAttribute('aria-checked', String(n === val));
    });
  }
  applyRatingVisual();

  ratingEl.addEventListener('click', (e)=>{
    const btn = e.target.closest('.star'); if(!btn) return;
    currentRating = parseInt(btn.getAttribute('data-val'), 10);
    applyRatingVisual();
  });
  ratingEl.addEventListener('mousemove', (e)=>{
    const btn = e.target.closest('.star'); if(!btn) return;
    applyRatingVisual(parseInt(btn.getAttribute('data-val'), 10));
  });
  ratingEl.addEventListener('mouseleave', ()=>applyRatingVisual());

  /* 이미지 선택/미리보기 — 커스텀 ‘파일 선택’ 버튼만 사용 */
  const imageInput  = document.getElementById('iImageInput');
  const previewGrid = document.getElementById('iPreview');
  const dropZone    = document.querySelector('.wrtColLeft');

  let selectedFiles = []; // { id, file, url }
  const MAX_FILES = 5;
  const MAX_SIZE_MB = 5;

  function appendFiles(fileList){
    const incoming = Array.from(fileList || []);
    if(!incoming.length) return;

    const valids = [];
    for(const f of incoming){
      if(!f.type.startsWith('image/')){ alert('이미지 파일만 업로드할 수 있습니다.'); continue; }
      if(f.size > MAX_SIZE_MB*1024*1024){ alert(`파일 용량 초과: ${f.name} (최대 ${MAX_SIZE_MB}MB)`); continue; }
      if(selectedFiles.length + valids.length >= MAX_FILES){ alert(`이미지는 최대 ${MAX_FILES}개까지 첨부 가능`); break; }
      valids.push(f);
    }

    valids.forEach(file=>{
      const reader = new FileReader();
      reader.onload = e=>{
        selectedFiles.push({
          id: (crypto.randomUUID && crypto.randomUUID()) || String(Date.now() + Math.random()),
          file, url: e.target.result
        });
        renderPreview();
      };
      reader.readAsDataURL(file);
    });
  }

  function renderPreview(){
    previewGrid.innerHTML = '';
    if(selectedFiles.length === 0){
      previewGrid.innerHTML = '<div class="noImageMsg">이미지 없음</div>';
      previewGrid.classList.remove('hasImages');
      return;
    }
    previewGrid.classList.add('hasImages');
    selectedFiles.forEach(item=>{
      const cell = document.createElement('div');
      cell.className = 'previewItem';
      cell.innerHTML = `
        <img src="${item.url}" alt="선택한 이미지 미리보기">
        <button class="previewRemove" type="button" data-id="${item.id}">삭제</button>
      `;
      previewGrid.appendChild(cell);
    });
  }

  previewGrid.addEventListener('click', (e)=>{
    const btn = e.target.closest('.previewRemove'); if(!btn) return;
    const id = btn.getAttribute('data-id');
    selectedFiles = selectedFiles.filter(x=>x.id !== id);
    renderPreview();
  });

  imageInput.addEventListener('change', (e)=>{
    appendFiles(e.target.files);
    e.target.value = ''; // 같은 파일 재선택 허용
  });

  /* 드래그&드롭 (유지) */
  ['dragenter','dragover'].forEach(evt=>{
    dropZone.addEventListener(evt, (e)=>{
      e.preventDefault(); e.stopPropagation();
      dropZone.classList.add('dropping');
    });
  });
  ['dragleave','drop'].forEach(evt=>{
    dropZone.addEventListener(evt, (e)=>{
      e.preventDefault(); e.stopPropagation();
      dropZone.classList.remove('dropping');
    });
  });
  dropZone.addEventListener('drop', (e)=>{
    const dt = e.dataTransfer; if(!dt || !dt.files) return;
    appendFiles(dt.files);
  });

  /* 리뷰 등록(DEMO) */
  document.getElementById('iSubmitBtn').addEventListener('click', ()=>{
    const value = composer.textarea.value.trim();
    if(!value){ alert('리뷰 내용을 입력하세요.'); return; }

    const newItem = {
      id: DEMO.length+1,
      nickname: '게스트'+(DEMO.length+1),
      stars: currentRating,
      date: new Date().toISOString().slice(0,10),
      img: placeholderDataURI('NEW'),
      text: value,
      adminReply: '관리자: 등록 감사합니다.'
    };

    DEMO.unshift(newItem);
    renderList(list, DEMO);
    composer.textarea.value = '';
    selectedFiles = [];
    renderPreview();
    composer.close();
    document.getElementById('iwrtBtn').textContent = '열기';
    list.parentElement.scrollTop = 0;

    // 실제 업로드 시:
    // const form = new FormData();
    // form.append('stars', String(currentRating));
    // form.append('text', value);
    // selectedFiles.forEach(f=>form.append('images', f.file, f.file.name));
    // await axios.post('/api/reviews', form, { headers:{'Content-Type':'multipart/form-data'} });
  });
}; // window.onload
</script>
</body>
</html>
