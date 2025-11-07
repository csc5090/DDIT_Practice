<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isELIgnored="true" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>리뷰 게시판</title>

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

.memId {
  color: #aaa;
  font-size: 0.9em;
  margin-left: 4px;
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
				<section id="iReviewList" class="reviewList">

				</section>
			</div> <!-- DB데이터 불러오기 (select) -->

         <aside id="iWrtReview" class="wrtReview">
            <div class="bottomBar" id="iBottomBar">
               <button id="iwrtBtn" class="wrtBtn btn btn-outline-secondary"
                  type="button" aria-expanded="false">
                  <!-- 닫힌 상태에서 위쪽을 가리키게(chevron-up) -->
                  <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-chevron-up" viewBox="0 0 16 16">
                        <path fill-rule="evenodd" d="M7.646 4.646a.5.5 0 0 1 .708 0l6 6a.5.5 0 0 1-.708.708L8 5.707 1.354 11.354a.5.5 0 1 1-.708-.708l6-6z" />
                        </svg>
               </button>
            </div>

            <form id="iReviewForm" action="<%=request.getContextPath()%>/reviewWriteOK.do" method="post" enctype="multipart/form-data"
                onsubmit="return iSubmit(this)">
                <input type="hidden" name="typeNo" value="2">
                <input type="hidden" name="memNo" value="10">
                
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
                     
                     <input type="hidden" name="star" value="1">
                     
                  </div>

                  <div class="rowNew">

                     <div class="uploaderNew">
                        <button id="fileBtn" class="fileButtonNew" type="button">파일 선택</button>
                        <input id="imageInput" name="image" type="file" accept="image/*" multiple hidden>
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
                        <textarea id="content" name="boardContent" class="textareaNew" required maxlength="1000"
                           placeholder="리뷰를 작성해주세요 (최소 10자)&#10;게임/서비스의 장단점, 추천 여부 등을 자유롭게 적어주세요."></textarea>
                        <div class="counterNew">
                           <span id="cnt">0</span>/1000
                        </div>
                     </div>
                  </div>

                  <div class="btnRowNew">
                     <button id="btnSubmit" name="btnSubmit" class="submitBtnNew" type="submit"
                        disabled>등록</button>
                  </div>
               </div>
            </div>
			
            </form>
            
            
         </aside>
      </div>
   </div>

   <script>   
   
// ===== 유틸 =====
function starString(n){ return '★'.repeat(n) + '☆'.repeat(Math.max(0, 5-n)); }
function placeholderDataURI(text){
  var svg = "<svg xmlns='http://www.w3.org/2000/svg' width='240' height='240'>"
    + "<rect width='100%' height='100%' fill='#f3f6fa'/>"
    + "<rect x='16' y='16' width='208' height='208' rx='16' fill='#dfe7f3'/>"
    + "<text x='50%' y='52%' dominant-baseline='middle' text-anchor='middle' font-size='20' font-family='Arial, sans-serif' fill='#394b63'>"+ text +"</text>"
    + "</svg>";
  return "data:image/svg+xml;charset=utf-8," + encodeURIComponent(svg);
}
function notify(title, text, icon){
  if (window.Swal && Swal.fire) return Swal.fire({title, text, icon, confirmButtonText:'확인'});
  alert((title?title+'\n':'')+(text||''));
}

/* 
function renderList(listEl, data){
  listEl.innerHTML = "";
  for (const item of data){
    const el = document.createElement('article');
    el.className = 'card';
    el.innerHTML =
      '<div class="head">'
        + '<span class="nickname">'+ item.nickname +'</span>'
        + '<span class="stars" aria-label="'+ item.stars +'점">'+ starString(item.stars) +'</span>'
        + '<span class="date">'+ item.date +'</span>'
      +'</div>'
      +'<div class="body">'
        +'<div class="row">'
          +'<div class="thumb"><img src="'+ item.img +'" alt="리뷰 이미지 '+ item.id +'"></div>'
          +'<div class="text">'+ item.text +'</div>'
        +'</div>'
        +'<div class="reply">'+ item.adminReply +'</div>'
      +'</div>';
    listEl.appendChild(el);
  }
}
*/

/* ===== 작성창 토글(기존 UX 유지) ===== */
const composer = { root:null, toggleBtn:null, textarea:null,
  open(){ this.root.classList.add('open'); this.toggleBtn.setAttribute('aria-expanded','true'); setTimeout(()=>this.textarea.focus(), 80); },
  close(){ this.root.classList.remove('open'); this.toggleBtn.setAttribute('aria-expanded','false'); },
  toggle(){ this.root.classList.contains('open') ? this.close() : this.open(); }
};


  let files = [];

window.onload = () => {
  // 목록 렌더
  const list = document.getElementById('iReviewList');
  
  // 모달 열고 닫기
  const modalEl = document.getElementById('iReviewModal');
  document.getElementById('iOpenModal').addEventListener('click', ()=> modalEl.hidden = false);
  document.getElementById('iCloseModal').addEventListener('click', ()=> modalEl.hidden = true);

  // 작성창 연결
  composer.root = document.getElementById('iWrtReview');
  composer.toggleBtn = document.getElementById('iwrtBtn');
  composer.textarea = document.getElementById('content');
  composer.toggleBtn.addEventListener('click', ()=>{
     composer.toggle();
     if (composer.root.classList.contains('open')) {
          const cur = Number(document.getElementById('ratingVal').value) || 0;
          if (cur === 0) setRating(5);
        }
   });

  // ===== 별점 =====
  const starsGroup = document.getElementById('starsGroup');
  const starBtns = Array.from(starsGroup.querySelectorAll('.starBtn'));
  const ratingHidden = document.getElementById('ratingVal');

  const setRating = (val) => {
	  ratingHidden.value = String(val); // 기존: #ratingVal (폼 밖)
	  // ★ 폼 안의 name="star"도 동기화
	  const starHiddenInForm = document.querySelector('#iReviewForm input[name="star"]');
	  if (starHiddenInForm) starHiddenInForm.value = String(val);

	  const num = Number(val) || 0;
	  starBtns.forEach(btn => {
	    const n = Number(btn.dataset.val);
	    btn.setAttribute('aria-checked', n === num ? 'true' : 'false');
	    btn.classList.toggle('filled', n <= num);
	  });
	  validate();
	};
  
  starBtns.forEach((btn, i) => {
    btn.addEventListener('click', () => setRating(i+1));
    btn.addEventListener('keydown', (e) => {
      const cur = Number(ratingHidden.value)||0;
      if(e.key==='ArrowRight'||e.key==='ArrowUp'){ e.preventDefault(); const n=Math.min(5,cur+1); setRating(n); starBtns[n-1].focus(); }
      if(e.key==='ArrowLeft'||e.key==='ArrowDown'){ e.preventDefault(); const n=Math.max(1,cur-1); setRating(n); starBtns[n-1].focus(); }
    });
  });

  // ===== 이미지 첨부 & 미리보기 =====
  // 첨부파일 2개로 제한
  const MAX_FILES = 2;
  const fileBtn   = document.getElementById('fileBtn');
  const input     = document.getElementById('imageInput');
  const preview   = document.getElementById('previewGrid');
  const fileCount = document.getElementById('fileCount');

  const refreshCount = () => { fileCount.textContent = `${files.length} / ${MAX_FILES}`; };
  const renderPreview = () => {
    preview.innerHTML = '';
    if (files.length === 0){
      const empty = document.createElement('div');
      empty.className = 'emptyBoxNew'; empty.dataset.empty = ''; empty.textContent = '이미지 없음';
      preview.appendChild(empty);
      refreshCount(); return;
    }
    files.forEach((f, idx) => {
      const wrap = document.createElement('div'); wrap.className = 'thumbNew';
      const img = document.createElement('img'); img.alt = `첨부 이미지 ${idx+1}`; wrap.appendChild(img);
      const rm = document.createElement('button'); rm.className = 'rmNew'; rm.type='button'; rm.textContent = '×';
      rm.addEventListener('click', () => { files.splice(idx,1); renderPreview(); validate(); });
      wrap.appendChild(rm);
      const reader = new FileReader(); reader.onload = e => { img.src = e.target.result; }; reader.readAsDataURL(f);
      preview.appendChild(wrap);
    });
    refreshCount();
  };
  fileBtn.addEventListener('click', ()=> input.click());
  input.addEventListener('change', (e)=>{
    const incoming = Array.from(e.target.files || []);
    const remain = MAX_FILES - files.length;
    if(incoming.length > remain) notify('이미지 제한', `이미지는 최대 ${MAX_FILES}장까지 첨부할 수 있어요. (추가 가능: ${remain}장)`, 'info');
    const pick = incoming.slice(0, Math.max(0, remain)).filter(f => /^image\//.test(f.type) && f.size > 0);
    files = files.concat(pick);
    input.value = '';
    renderPreview(); validate();
  });

  // ===== 본문 & 유효성 =====
  const content = document.getElementById('content');
  const cnt = document.getElementById('cnt');
  const btnSubmit = document.getElementById('btnSubmit');

  const updateCounter = () => { cnt.textContent = String(content.value.length); };
  function validate(){
    const textOK = content.value.trim().length >= 10;
    const ratingOK = Number(ratingHidden.value) >= 1;
    btnSubmit.disabled = !(textOK && ratingOK);
   }
  content.addEventListener('input', ()=>{ updateCounter(); validate(); });
  updateCounter(); validate(); setRating(5); renderPreview();

<%--
  // ===== 제출 (FormData 예시) =====
  btnSubmit.addEventListener('click', async ()=>{
    if(btnSubmit.disabled) return;

    const fd = new FormData();
    fd.set('rating', ratingHidden.value);
    fd.set('content', content.value.trim());
    files.forEach((f) => fd.append('images', f, f.name));

    try{
      // 실제 서버 엔드포인트로 교체하세요.
      // const res = await axios.post('<%=request.getContextPath()%>/review/create.do', fd, { headers:{ 'Content-Type':'multipart/form-data' } });

      // 데모: 목록 갱신만
      DEMO.unshift({
        id: DEMO.length+1,
        nickname: '게스트'+(DEMO.length+1),
        stars: Number(ratingHidden.value)||0,
        date: new Date().toISOString().slice(0,10),
        img: files[0] ? URL.createObjectURL(files[0]) : placeholderDataURI('NEW'),
        text: content.value.trim(),
        adminReply: '관리자: 등록 감사합니다.'
      });
      renderList(list, DEMO);
      notify('등록 완료', '리뷰가 등록되었습니다.', 'success');

      // 초기화 + 닫기
      setRating(0); files = []; renderPreview();
      content.value=''; updateCounter(); validate();
      composer.close(); 
      list.parentElement.scrollTop = 0;
    }catch(err){
      console.error(err);
      notify('등록 실패', '잠시 후 다시 시도해 주세요.', 'error');
    }
  });
--%>  
  
}; // wimdow.onload  
/////////////////////////////////////////////////////////////////////

// 리뷰 등록
function iSubmit(form){
  // 1) 별점(name="star")에 값 밀어넣기
  let starHidden = form.querySelector('input[name="star"]');
  let ratingValEl = document.getElementById('ratingVal'); // JS가 관리하던 값(폼 밖)
  if(!starHidden || !ratingValEl){
    notify('제출 오류', '별점 입력 요소를 찾을 수 없습니다.', 'error');
    return false;
  }
  if(!(Number(ratingValEl.value) >= 1)){
    notify('안내', '별점을 선택해 주세요.', 'info');
    return false;
  }
  starHidden.value = ratingValEl.value;

  // 2) files[] → 실제 input.files에 되돌리기
  const input = document.getElementById('imageInput');
  if (Array.isArray(files) && files.length > 0 && input){
    const dt = new DataTransfer();
    files.forEach(f => dt.items.add(f));
    input.files = dt.files;
  }
  
  // 3) 최종 검증(본문 최소 길이)
  const content = document.getElementById('content');
  if(!content || content.value.trim().length < 10){
    notify('안내', '본문은 최소 10자 이상 입력하세요.', 'info');
    return false;
  }

  return true; // 폼 제출 진행
}

//////  DB 데이터를 REVIEW 게시판에 출력 (ReviewListController)  //////

// 별점 계산
// n을 숫자로 반환하고 실패하면 0 => n개 만큼 ★ 반복(최대 5개) 나머지 개수만큼 ☆ 반복
function starString(n){ 
	n = Number(n)||0;
	return '★'.repeat(Math.max(0,Math.min(5,n))) + '☆'.repeat(Math.max(0,5-n)); 
}

function esc(s){ 
	return (s||'').replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;'); 
}

async function loadReviews(limit){
  const cp = '<%=request.getContextPath()%>';
  const url = cp + '/reviewList.do?limit=' + encodeURIComponent(limit);
  const res = await axios.get(url);
  if(!res.data || res.data.ok !== true) throw new Error('API 실패');
  return res.data.items || [];
}

function renderReviews(list){
  const $list = document.getElementById('iReviewList');
  $list.innerHTML = '';
  if(!list.length){	
    $list.innerHTML = '<div class="card"><div class="body">등록된 리뷰가 없습니다.</div></div>';
    return;
  }
  for(const r of list){
    const html = `
      <article class="card" data-board-no="${r.boardNo}">
        <div class="head">
          <span class="nickname">${esc(r.nickName)}</span>
          <span class="memId">#${esc(r.memId)}</span>
          <span class="stars" aria-label="${r.star}점">${starString(r.star)}</span>
          <span class="date">${esc(r.updatedDate)}</span>
        </div>
        <div class="body">
          <div class="row">
            <div class="thumb">${imgHTML}</div>
            </div>
            <div class="text">${esc(r.boardContent)}</div>
          </div>
        </div>
      </article>`;
    $list.insertAdjacentHTML('beforeend', html);
  }
}

window.addEventListener('DOMContentLoaded', async () => {
  try{
    const items = await loadReviews(200); // 리뷰 표시 수
    renderReviews(items);
  }catch(err){
    console.error(err);
    document.getElementById('iReviewList').innerHTML =
      '<div class="card"><div class="body">목록을 불러오는 중 오류가 발생했습니다.</div></div>';
  }
});

////////////////////////////////////////////////////////////



</script>

</body>
</html>
