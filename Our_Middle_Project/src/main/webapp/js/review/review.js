   
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

/* ===== 작성창 토글(기존 UX 유지) ===== */
const composer = { root:null, toggleBtn:null, textarea:null,
  open(){ this.root.classList.add('open'); this.toggleBtn.setAttribute('aria-expanded','true'); setTimeout(()=>this.textarea.focus(), 80); },
  close(){ 
      this.root.classList.remove('open'); 
      this.toggleBtn.setAttribute('aria-expanded','false');
      resetReviewForm();
  },
  toggle(){ this.root.classList.contains('open') ? this.close() : this.open(); }
};

let currentEditMode = { active: false, boardNo: null };
let files = []; 
let formElements = {};

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

// (★) 유효성 검사 함수
function validate(){
    if (!formElements.content || !formElements.ratingHidden || !formElements.btnSubmit) return;
    const textOK = formElements.content.value.trim().length >= 10;
    const ratingOK = Number(formElements.ratingHidden.value) >= 1;
    formElements.btnSubmit.disabled = !(textOK && ratingOK);
}

// (★) 글자 수 카운터 함수
const updateCounter = () => { 
    if(formElements.cnt && formElements.content) {
        formElements.cnt.textContent = String(formElements.content.value.length); 
    }
};

// (★) 파일 미리보기 함수
const renderPreview = () => {
    if (!formElements.preview || !formElements.fileCount) return;
    formElements.preview.innerHTML = '';
    if (files.length === 0){
      const empty = document.createElement('div');
      empty.className = 'emptyBoxNew'; empty.dataset.empty = ''; empty.textContent = '이미지 없음';
      formElements.preview.appendChild(empty);
      formElements.fileCount.textContent = `0 / ${formElements.MAX_FILES}`;
      return;
    }
    files.forEach((f, idx) => {
      const wrap = document.createElement('div'); wrap.className = 'thumbNew';
      const img = document.createElement('img'); img.alt = `첨부 이미지 ${idx+1}`; wrap.appendChild(img);
      const rm = document.createElement('button'); rm.className = 'rmNew'; rm.type='button'; rm.textContent = '×';
      rm.addEventListener('click', () => { files.splice(idx,1); renderPreview(); validate(); });
      wrap.appendChild(rm);
      const reader = new FileReader(); reader.onload = e => { img.src = e.target.result; }; reader.readAsDataURL(f);
      formElements.preview.appendChild(wrap);
    });
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
            
            // (★) axios 기본 인스턴스 사용
            const response = await axios.post(
                '<%=request.getContextPath()%>/reviewDelete.do',
                params 
            );

            Swal.fire('삭제 완료', '리뷰가 삭제되었습니다.', 'success');
            const cardToRemove = document.querySelector(`article.card[data-board-no="${boardNo}"]`);
            if (cardToRemove) cardToRemove.remove();
        } catch (error) {
            console.error('리뷰 삭제 실패:', error);
            const errorMsg = error.response?.data?.message || '삭제에 실패했습니다.';
            Swal.fire('삭제 실패', errorMsg, 'error');
        }
    }
}


// (★) [ 6단계-수정 ] 수정 AJAX 함수 (location.reload() 제거)
async function handleUpdateReview() {
    if (!currentEditMode.active || !currentEditMode.boardNo) return;

    formElements.btnSubmit.disabled = true;
    formElements.btnSubmit.textContent = '수정 중...';

    try {
        const params = new URLSearchParams();
        params.append('boardNo', currentEditMode.boardNo);
        params.append('boardContent', formElements.content.value.trim());
        params.append('star', formElements.ratingHidden.value);
        
        const response = await axios.post(
            '<%=request.getContextPath()%>/reviewUpdate.do',
            params
        );
        
        // (★) 4. 성공 시: DOM을 직접 수정
        await Swal.fire('수정 완료', '리뷰가 수정되었습니다.', 'success');
        
        const cardToUpdate = document.querySelector(`article.card[data-board-no="${currentEditMode.boardNo}"]`);
        if (cardToUpdate) {
            // 4-1. 본문 텍스트 변경
            cardToUpdate.querySelector('p.review-content-text').textContent = params.get('boardContent');
            
            // 4-2. 별점 변경
            const starSpan = cardToUpdate.querySelector('.stars');
            if(starSpan) {
                const starVal = Number(params.get('star'));
                starSpan.innerHTML = '★'.repeat(starVal) + '☆'.repeat(5 - starVal);
                starSpan.setAttribute('aria-label', starVal + '점');
            }
            // 4-3. 날짜 변경 (간단하게 '수정됨' 표시)
            const dateSpan = cardToUpdate.querySelector('.date');
            if (dateSpan) dateSpan.textContent = "방금 전 (수정)";
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

// (★) [ 6단계-수정 ] 새 글 쓰기(Write) 함수 (form.submit() -> FormData + axios)
async function handleWriteReview() {
    
    formElements.btnSubmit.disabled = true;
    formElements.btnSubmit.textContent = '등록 중...';

    // (★) 1. FormData 객체 생성
    const formData = new FormData();
    
    // (★) 2. 폼 필드 추가
    formData.append('typeNo', formElements.form.querySelector('input[name="typeNo"]').value);
    formData.append('star', formElements.ratingHidden.value);
    formData.append('boardContent', formElements.content.value.trim());
    
    // (★) 3. 파일 추가 (JS 전역 변수 files 사용)
    files.forEach((file) => {
        formData.append('image', file, file.name); // 'image'는 컨트롤러의 getParts("image")와 일치
    });
    
    try {
        // (★) 4. axios로 FormData 전송 (주의: Content-Type 헤더 설정 X)
        // axios가 FormData를 감지하고 'multipart/form-data'로 자동 설정
        const response = await axios.post(
            '<%=request.getContextPath()%>/reviewWriteOK.do',
            formData
        );
        
        // (★) 5. 성공 시 (Controller가 newReview 객체를 반환)
        await Swal.fire('등록 완료', '리뷰가 등록되었습니다.', 'success');
        
        const newReview = response.data.newReview; // (★) 1단계에서 반환하도록 만든 객체
        
        // (★) 6. 새 리뷰 카드를 동적으로 생성하여 목록 맨 위에 추가
        buildNewCard(newReview);
        
        // 7. 폼 닫기
        composer.close();

    } catch (error) {
        // 8. 실패 시
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
    
    // 1. "등록된 리뷰가 없습니다" 메시지 제거
    const emptyMsgCard = list.querySelector('.card .body');
    if (emptyMsgCard && emptyMsgCard.textContent.includes('등록된 리뷰가 없습니다')) {
        emptyMsgCard.closest('.card').remove();
    }
    
    // 2. 새 <article> 요소 생성
    const card = document.createElement('article');
    card.className = 'card';
    card.dataset.boardNo = r.boardNo;
    
    // (★) 썸네일 HTML 생성
    let thumbHtml = '';
    if (r.thumbUrl) {
        // (★) 썸네일 경로는 contextPath를 포함해야 합니다.
        thumbHtml = `<img src="<%=request.getContextPath()%>${r.thumbUrl}" alt="리뷰 이미지">`;
    }

    // (★) 삭제/수정 버튼 HTML 생성
    // (새로 등록한 글은 무조건 본인 글이므로 버튼을 추가합니다)
    let buttonsHtml = `
        <button type="button" class="btn btn-outline-info btn-sm ms-auto btn-update-review" data-board-no="${r.boardNo}">수정</button>
        <button type="button" class="btn btn-outline-danger btn-sm btn-delete-review" data-board-no="${r.boardNo}">삭제</button>
    `;
    
    // 3. 카드 내부 HTML 조립
    card.innerHTML = `
        <div class="head">
            <span class="nickname">${r.nickName}</span>
            <span class="memId">#${r.memId}</span>
            <span class="stars" aria-label="${r.star}점">
                ${'★'.repeat(r.star) + '☆'.repeat(5 - r.star)}
            </span>
            <span class="date">${r.createdDate}</span>
            ${buttonsHtml}
        </div>
        <div class="body">
            <div class="row">
                <div class="thumb">${thumbHtml}</div>
                <div class="text">
                    <p class="review-content-text">${r.boardContent}</p>
                </div>
            </div>
            <%-- 관리자 댓글은 새로 등록 시 없으므로 빈 div (혹은 c:if로) --%>
        </div>
    `;
    
    // 4. 목록(list)의 맨 위에 추가
    list.prepend(card);
}


/////////////////////////////////////////////////////////////////////
// (★) window.onload (기존 코드와 동일)
/////////////////////////////////////////////////////////////////////
window.onload = () => {
  
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
      cnt: document.getElementById('cnt')
  };
  
  // 2. 모달 열고 닫기
  document.getElementById('iOpenModal').addEventListener('click', ()=> formElements.modal.hidden = false);
  document.getElementById('iCloseModal').addEventListener('click', ()=> formElements.modal.hidden = true);

  // 3. 작성창 연결
  composer.root = formElements.composerRoot;
  composer.toggleBtn = formElements.composerBtn;
  composer.textarea = formElements.content;
  composer.toggleBtn.addEventListener('click', () => {
     composer.toggle();
     if (composer.root.classList.contains('open') && !currentEditMode.active) {
          // (★) 오류 수정: ratingHidden을 사용
          const cur = Number(formElements.ratingHidden.value) || 0;
          if (cur === 0) setRating(5);
     }
  });

  // 4. 별점 이벤트
  formElements.starBtns.forEach((btn, i) => {
    btn.addEventListener('click', () => setRating(i+1));
    btn.addEventListener('keydown', (e) => {
      let cur = Number(formElements.ratingHidden.value) || 0;
      if(e.key==='ArrowRight'||e.key==='ArrowUp'){ e.preventDefault(); const n=Math.min(5,cur+1); setRating(n); formElements.starBtns[n-1].focus(); }
      if(e.key==='ArrowLeft'||e.key==='ArrowDown'){ e.preventDefault(); const n=Math.max(1,cur-1); setRating(n); formElements.starBtns[n-1].focus(); }
    });
  });

  // 5. 이미지 첨부
  formElements.fileBtn.addEventListener('click', ()=> formElements.input.click());
  formElements.input.addEventListener('change', (e)=>{
    const incoming = Array.from(e.target.files || []);
    const remain = formElements.MAX_FILES - files.length;
    if(incoming.length > remain) notify('이미지 제한', `이미지는 최대 ${formElements.MAX_FILES}장까지 첨부할 수 있어요. (추가 가능: ${remain}장)`, 'info');
    const pick = incoming.slice(0, Math.max(0, remain)).filter(f => /^image\//.test(f.type) && f.size > 0);
    files = files.concat(pick);
    formElements.input.value = ''; 
    renderPreview(); validate();
  });

  // 6. 본문 & 유효성
  formElements.content.addEventListener('input', ()=>{ updateCounter(); validate(); });
  
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
              const card = e.target.closest('article.card');
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

  // 8. (★) 초기화
  resetReviewForm(); 

}; // window.onload 끝