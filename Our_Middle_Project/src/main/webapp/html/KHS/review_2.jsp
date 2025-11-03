<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>리뷰 작성 뷰</title>
<title>리뷰 작성 뷰</title>

  <style>
    :root{
      /* Layout */
      --page-max: 820px;
      --gap: 14px;
      --radius: 16px;
      --shadow: 0 12px 40px rgba(0,0,0,.18);
      --border: #2a2a2a;
      --muted: #9aa3ad;
      --text: #e6ecf3;
      --bg: #0b0c10;
      --panel: #11131a;
      --panel-2: #0e1016;
      /* Neon theme */
      --brand: #00e0ff;
      --brand-2: #8a2be2;
      --danger: #ff4d6d;
      --ok: #33d69f;
    }

    *{ box-sizing: border-box; }
    html, body{ height:100%; }
    html{ background: radial-gradient(1200px 800px at 10% -20%, rgba(138,43,226,.28), transparent 60%),
                     radial-gradient(900px 600px at 120% 120%, rgba(0,224,255,.22), transparent 60%), var(--bg); }
    body{
      margin:0; color:var(--text);
      font-family: system-ui, -apple-system, Segoe UI, Roboto, Helvetica, Arial,
                   "Apple SD Gothic Neo", "Noto Sans KR", "맑은 고딕", sans-serif;
      display:grid; place-items:start center; padding: 6vh 16px;
    }

    .card{
      width:min(100%, var(--page-max));
      background: linear-gradient(180deg, var(--panel), var(--panel-2));
      border:1px solid var(--border);
      border-radius: 20px;
      box-shadow: var(--shadow);
      overflow:hidden;
    }

    .cardHeader{ display:flex; align-items:center; gap:12px; padding:18px 22px; border-bottom:1px solid var(--border); }
    .cardTitle{ font-size:20px; font-weight:700; letter-spacing:.2px; }
    .badge{ font-size:12px; padding:4px 8px; border-radius:999px; border:1px solid #2b2b2b; color:#9fb1ff; background:rgba(159,177,255,.08); }

    .cardBody{ padding:22px; display:grid; gap:20px; }

    /* Row */
    .row{ display:grid; gap:10px; }
    .row.inline{ grid-template-columns: 130px 1fr; align-items:start; }
    .label{ font-size:14px; color:var(--muted); }

    /* Star rating */
    .stars{ display:flex; gap:8px; }
    .starBtn{
      width:44px; height:44px; border-radius:10px; border:1px solid var(--border);
      background: #12141c; display:grid; place-items:center; cursor:pointer;
      font-size:22px; line-height:1; transition: transform .08s ease, box-shadow .15s ease, border-color .15s ease;
      box-shadow:0 0 0px rgba(0,224,255,0);
    }
    .starBtn:hover{ transform: translateY(-1px); border-color:#334155; }
    .starBtn[aria-checked="true"]{
      border-color: rgba(0,224,255,.55);
      box-shadow: 0 0 22px rgba(0,224,255,.25), inset 0 0 18px rgba(0,224,255,.12);
    }
    .starEm{ filter: drop-shadow(0 0 6px rgba(0,224,255,.7)); }

    /* Image uploader */
    .uploader{ border:1px dashed #374151; border-radius:14px; padding:14px; background: #0f1218; }
    .upTop{ display:flex; gap:12px; align-items:center; justify-content:space-between; margin-bottom:12px; }
    .fileButton{ position:relative; display:inline-flex; align-items:center; gap:8px; padding:10px 14px; border-radius:10px; border:1px solid var(--border); background:#12141c; cursor:pointer; user-select:none; }
    .fileButton:hover{ border-color:#334155; }
    .fileButton input{ position:absolute; inset:0; opacity:0; cursor:pointer; }
    .fileHint{ font-size:12px; color:var(--muted); }
    .fileCount{ font-size:12px; color:#a7f3d0; }

    .previewGrid{ display:grid; grid-template-columns: repeat(6, 1fr); gap:10px; }
    @media (max-width: 1024px){ .previewGrid{ grid-template-columns: repeat(5, 1fr);} }
    @media (max-width: 780px){ .previewGrid{ grid-template-columns: repeat(4, 1fr);} }
    @media (max-width: 560px){ .previewGrid{ grid-template-columns: repeat(3, 1fr);} }

    .thumb, .emptyBox{
      aspect-ratio: 1/1; width:100%; border-radius:12px; overflow:hidden; position:relative; border:1px solid var(--border);
      background:#0e1117; display:grid; place-items:center;
    }
    .thumb img{ width:100%; height:100%; object-fit:cover; display:block; }
    .rm{ position:absolute; top:6px; right:6px; width:26px; height:26px; border-radius:8px; border:1px solid #3b3b3b; background:#151923; color:#e5e7eb; cursor:pointer; display:grid; place-items:center; font-size:16px; line-height:1; }
    .rm:hover{ background:#1b2030; }
    .emptyTxt{ font-size:12px; color:#94a3b8; }

    /* Review body */
    .textareaWrap{ position:relative; }
    .textarea{ width:100%; min-height: 140px; max-height: 40vh; resize: vertical; padding:14px; border-radius:12px; border:1px solid var(--border); background:#0f1218; color:var(--text); line-height:1.6; }
    .textarea:focus{ outline:none; border-color: rgba(0,224,255,.45); box-shadow:0 0 0 3px rgba(0,224,255,.15); }
    .counter{ position:absolute; right:10px; bottom:8px; font-size:12px; color:var(--muted); }

    /* Footer */
    .cardFooter{ padding:18px 22px; border-top:1px solid var(--border); display:flex; justify-content:space-between; align-items:center; gap:12px; }
    .tips{ font-size:12px; color:#94a3b8; }

    .btnRow{ display:flex; gap:10px; }
    .btn{ padding:12px 18px; border-radius:12px; border:1px solid var(--border); background:#12141c; color:var(--text); cursor:pointer; font-weight:600; }
    .btn[disabled]{ opacity:.6; cursor:not-allowed; }
    .btn.primary{ border-color: rgba(0,224,255,.55); background: linear-gradient(180deg, rgba(0,224,255,.16), rgba(0,224,255,.05)); box-shadow: inset 0 0 18px rgba(0,224,255,.12); }
    .btn.primary:hover{ filter: brightness(1.1); }
    .btn.ghost:hover{ background:#171a24; }

    /* Small helpers */
    .glow{ text-shadow: 0 0 8px rgba(0,224,255,.55), 0 0 14px rgba(138,43,226,.35); }
  </style>
</head>
<body>

  <main class="card" aria-labelledby="pageTitle">
    <header class="cardHeader">
      <h1 id="pageTitle" class="cardTitle glow">리뷰 작성</h1>
      <span class="badge">Review</span>
    </header>

    <section class="cardBody" id="reviewForm" aria-describedby="formHelp">
      <!-- 별점 -->
      <div class="row inline" role="radiogroup" aria-label="별점" id="starsGroup">
        <div class="label">별점 등록</div>
        <div class="stars">
          <button class="starBtn" type="button" role="radio" aria-checked="false" data-val="1" aria-label="1점"><span class="starEm">★</span></button>
          <button class="starBtn" type="button" role="radio" aria-checked="false" data-val="2" aria-label="2점"><span class="starEm">★</span></button>
          <button class="starBtn" type="button" role="radio" aria-checked="false" data-val="3" aria-label="3점"><span class="starEm">★</span></button>
          <button class="starBtn" type="button" role="radio" aria-checked="false" data-val="4" aria-label="4점"><span class="starEm">★</span></button>
          <button class="starBtn" type="button" role="radio" aria-checked="false" data-val="5" aria-label="5점"><span class="starEm">★</span></button>
        </div>
      </div>

      <!-- 이미지 첨부 -->
      <div class="row">
        <div class="label">이미지 첨부</div>
        <div class="uploader" id="uploader">
          <div class="upTop">
            <label class="fileButton" id="fileBtn">
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" aria-hidden="true">
                <path d="M12 5v14m-7-7h14" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
              </svg>
              파일 선택
              <input id="imageInput" type="file" accept="image/*" multiple aria-label="이미지 파일 선택" />
            </label>
            <div class="fileHint">최대 8장 · JPG/PNG/GIF</div>
            <div class="fileCount" id="fileCount">0 / 8</div>
          </div>
          <div class="previewGrid" id="previewGrid" aria-live="polite">
            <div class="emptyBox" data-empty>
              <span class="emptyTxt">이미지 없음</span>
            </div>
          </div>
        </div>
      </div>

      <!-- 본문 -->
      <div class="row">
        <div class="label">리뷰 본문</div>
        <div class="textareaWrap">
          <textarea id="content" class="textarea" maxlength="1000" placeholder="리뷰를 작성해주세요 (최소 10자)&#10;제품/서비스의 장단점, 추천 여부 등을 자유롭게 적어주세요."></textarea>
          <div class="counter"><span id="cnt">0</span>/1000</div>
        </div>
      </div>
    </section>

    <footer class="cardFooter">
      <div id="formHelp" class="tips">별점과 10자 이상의 본문이 필요합니다.</div>
      <div class="btnRow">
        <button id="btnCancel" class="btn ghost" type="button">취소</button>
        <button id="btnSubmit" class="btn primary" type="button" disabled>리뷰 등록</button>
      </div>
    </footer>
  </main>

  <!-- 숨김 입력(실서버 연동 시 사용) -->
  <input type="hidden" id="ratingVal" value="0" />

  <script>
  window.onload = () => {
    const starGroup = document.getElementById('starsGroup');
    const starButtons = Array.from(starGroup.querySelectorAll('.starBtn'));
    const ratingHidden = document.getElementById('ratingVal');

    const input = document.getElementById('imageInput');
    const preview = document.getElementById('previewGrid');
    const fileCount = document.getElementById('fileCount');

    const content = document.getElementById('content');
    const counter = document.getElementById('cnt');

    const btnSubmit = document.getElementById('btnSubmit');
    const btnCancel = document.getElementById('btnCancel');

    const MAX_FILES = 8;

    let files = []; // in-memory list

    /* ====== 별점 ====== */
    const setRating = (val) => {
      ratingHidden.value = String(val);
      starButtons.forEach(btn => btn.setAttribute('aria-checked', btn.dataset.val == val ? 'true' : 'false'));
      validate();
    };

    starButtons.forEach((btn, i) => {
      btn.addEventListener('click', () => setRating(i+1));
      btn.addEventListener('keydown', (e) => {
        // Arrow navigation for accessibility
        if (e.key === 'ArrowRight' || e.key === 'ArrowUp') { e.preventDefault(); const n = Math.min(5, (Number(ratingHidden.value)||0)+1); setRating(n); starButtons[n-1].focus(); }
        if (e.key === 'ArrowLeft' || e.key === 'ArrowDown') { e.preventDefault(); const n = Math.max(1, (Number(ratingHidden.value)||0)-1); setRating(n); starButtons[n-1].focus(); }
      });
    });

    /* ====== 이미지 첨부 & 미리보기 ====== */
    const refreshCount = () => { fileCount.textContent = `${files.length} / ${MAX_FILES}`; };

    const renderPreview = () => {
      preview.innerHTML = '';
      if (files.length === 0){
        const empty = document.createElement('div');
        empty.className = 'emptyBox';
        empty.dataset.empty = '';
        empty.innerHTML = '<span class="emptyTxt">이미지 없음</span>';
        preview.appendChild(empty);
        refreshCount();
        return;
      }
      files.forEach((file, idx) => {
        const wrap = document.createElement('div');
        wrap.className = 'thumb';
        const img = document.createElement('img');
        img.alt = `첨부 이미지 ${idx+1}`;
        wrap.appendChild(img);

        const rm = document.createElement('button');
        rm.className = 'rm';
        rm.type = 'button';
        rm.setAttribute('aria-label', `이미지 ${idx+1} 삭제`);
        rm.textContent = '×';
        rm.addEventListener('click', () => { files.splice(idx, 1); renderPreview(); validate(); });
        wrap.appendChild(rm);

        const reader = new FileReader();
        reader.onload = e => { img.src = e.target.result; };
        reader.readAsDataURL(file);

        preview.appendChild(wrap);
      });
      refreshCount();
    };

    input.addEventListener('change', (e) => {
      const incoming = Array.from(e.target.files || []);
      const remaining = MAX_FILES - files.length;
      if (incoming.length > remaining){
        alert(`이미지는 최대 ${MAX_FILES}장까지 가능합니다. (추가 가능: ${remaining}장)`);
      }
      const allowed = incoming.slice(0, Math.max(0, remaining));
      // filter invalid or 0 bytes
      const valid = allowed.filter(f => /^image\//.test(f.type) && f.size > 0);
      files = files.concat(valid);
      renderPreview();
      validate();
      // reset input value so selecting same file again re-triggers change
      input.value = '';
    });

    /* ====== 본문 입력 & 카운터 ====== */
    const updateCounter = () => { counter.textContent = String(content.value.length); };
    content.addEventListener('input', () => { updateCounter(); validate(); });
    updateCounter();

    /* ====== 유효성 ====== */
    function validate(){
      const ratingOK = Number(ratingHidden.value) >= 1;
      const textOK = content.value.trim().length >= 10;
      btnSubmit.disabled = !(ratingOK && textOK);
    }

    /* ====== 제출/취소 ====== */
    btnSubmit.addEventListener('click', () => {
      // Demo: build FormData and log. Replace with real submit (fetch) in production.
      const fd = new FormData();
      fd.set('rating', ratingHidden.value);
      fd.set('content', content.value.trim());
      files.forEach((f, i) => fd.append('images', f, f.name));

      // Example submit (commented):
      // fetch('/review/create', { method:'POST', body: fd })
      //   .then(r => r.ok ? r.json() : Promise.reject(r))
      //   .then(data => { alert('등록되었습니다.'); /* location.href = '/review/'+data.id; */ })
      //   .catch(err => { alert('등록 실패'); console.error(err); });

      // For this standalone view, just show a summary.
      const summary = `별점: ${ratingHidden.value}\n이미지: ${files.length}개\n본문: ${content.value.trim().slice(0,140)}${content.value.trim().length>140?'…':''}`;
      alert('샘플 제출\n\n'+summary);
    });

    btnCancel.addEventListener('click', () => {
      if (confirm('작성 중인 내용을 모두 지우시겠어요?')){
        setRating(0);
        files = []; renderPreview(); refreshCount();
        content.value = ''; updateCounter();
        validate();
      }
    });

    // init
    setRating(0);
    renderPreview();
    validate();
  };
  </script>
</body>
</html>
</html>