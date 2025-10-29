<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Cyberpunk Neon Leaderboard</title>
  
  <!--
    Cyberpunk / Neon Leaderboard
    - Dark theme + neon accents
    - Top 1~3 podium highlight (metallic gold/silver/bronze)
    - Rank delta animation (▲▼)
    - Mobile: compact cards (닉네임 + 아바타 + 점수 + 자세히 보기)
    - JS: window.onload entrypoint, no inline on* handlers
    - Accessible modal for player details
  -->
  <style>
    :root{
      /* Color Tokens */
      --bg: #0a0c12;           /* near-black */
      --panel: #10131b;        /* card bg */
      --panel-2: #121623;      /* hover bg */
      --text: #e6f0ff;         /* primary text */
      --muted: #8aa2c0;        /* secondary text */
      --neon-blue: #00d1ff;
      --neon-pink: #ff2fb9;
      --neon-purple: #9b5cff;
      --accent: #00ffa2;       /* success accent */
      --danger: #ff5f6d;       /* danger accent */
      --border: #1f2433;       /* subtle border */
      --shadow: 0 12px 32px rgba(0,0,0,.35);
      --radius: 18px;
      --gap: 14px;
      --pad: 18px;
      /* Gradients */
      --grad-neon: radial-gradient(120% 120% at 0% 0%, rgba(0,209,255,.18), transparent 55%),
                   radial-gradient(120% 120% at 100% 0%, rgba(255,47,185,.14), transparent 50%),
                   radial-gradient(120% 120% at 100% 100%, rgba(155,92,255,.18), transparent 50%);
      --gold: linear-gradient(135deg,#ffde76 0%,#ffd24d 25%,#ffe49a 50%,#ffc941 75%,#fff0b3 100%);
      --silver: linear-gradient(135deg,#e7edf3 0%,#cfd6de 25%,#f7fbff 50%,#c6d0da 75%,#eef3f9 100%);
      --bronze: linear-gradient(135deg,#ffb77a 0%,#e59b5b 30%,#ffc9a1 60%,#d9843d 85%,#ffd2b2 100%);
      /* Sizes */
      --maxw: 1120px;
      --avatar: 44px;          /* desktop avatar size */
    }
    *{ box-sizing: border-box; }
    html, body{ height:100%; }
    body{
      margin:0; background: var(--bg); color: var(--text);
      font-family: ui-sans-serif, system-ui, -apple-system, Segoe UI, Roboto, Helvetica, Arial, "Apple SD Gothic Neo", "Noto Sans KR", "맑은 고딕", sans-serif;
      letter-spacing: .2px; line-height: 1.55;
      background-image: var(--grad-neon);
      background-attachment: fixed; /* subtle parallax feel */
    }

    .wrap{ max-width: var(--maxw); margin: 24px auto 60px; padding: 0 16px; }
    .pageTitle{
      display:flex; align-items:center; gap:10px; margin: 8px 0 18px;
      font-weight: 800; font-size: clamp(22px, 2.2vw, 28px);
      text-shadow: 0 0 12px rgba(0,209,255,.35);
    }
    .logoDot{ width:12px; height:12px; border-radius:50%; background: var(--neon-pink);
      box-shadow: 0 0 16px 6px rgba(255,47,185,.35), 0 0 32px rgba(155,92,255,.25);
    }

    .toolbar{
      display:flex; flex-wrap: wrap; align-items:center; gap:10px;
      margin-bottom: 16px;
    }
    .segmented{
      display:inline-flex; padding:4px; background: #0c101a; border:1px solid var(--border);
      border-radius: 999px; box-shadow: var(--shadow);
    }
    .segmented button{
      appearance: none; border:0; background: transparent; color: var(--muted);
      padding: 8px 14px; border-radius: 999px; cursor:pointer; font-weight:700;
      letter-spacing: .2px;
    }
    .segmented button[aria-pressed="true"]{
      color:#061018; background: linear-gradient(180deg, #00d1ff, #00a4ff);
      box-shadow: 0 0 18px rgba(0,209,255,.55);
    }
    .search{ margin-left:auto; position:relative; }
    .search input{
      width: 240px; max-width: 58vw; background: #0c101a; color: var(--text);
      border:1px solid var(--border); border-radius: 12px; padding: 10px 12px 10px 36px;
      outline: none; box-shadow: var(--shadow);
    }
    .search .icon{ position:absolute; left:10px; top:50%; transform:translateY(-50%); opacity:.6; }

    /* Podium (Top 1~3) */
    .podium{
      display:grid; grid-template-columns: 1.1fr .9fr 1fr; gap: var(--gap);
      margin: 14px 0 18px;
    }
    @media (max-width: 820px){ .podium{ grid-template-columns: 1fr; } }

    .podCard{
      position:relative; background: var(--panel); border:1px solid var(--border); border-radius: var(--radius);
      padding: 18px; box-shadow: var(--shadow); overflow: clip;
      isolation: isolate;
    }
    .podCard::after{
      content:""; position:absolute; inset:-2px; border-radius: calc(var(--radius) + 2px);
      background: conic-gradient(from 120deg, rgba(0,209,255,.22), rgba(255,47,185,.18), rgba(155,92,255,.22), rgba(0,209,255,.22));
      filter: blur(18px); opacity:.55; z-index:-1;
    }
    .medal{ font-weight:900; font-size: 13px; letter-spacing:.6px; display:inline-flex; align-items:center; gap:8px; }
    .medal .dot{ width:10px; height:10px; border-radius:50%; box-shadow: inset 0 0 0 1px rgba(0,0,0,.2), 0 0 16px rgba(255,255,255,.35); }
    .gold{ background: var(--gold); -webkit-background-clip: text; color: transparent; }
    .silver{ background: var(--silver); -webkit-background-clip: text; color: transparent; }
    .bronze{ background: var(--bronze); -webkit-background-clip: text; color: transparent; }
    .dot.gold{ background: #ffd24d; }
    .dot.silver{ background: #d9e2ea; }
    .dot.bronze{ background: #e9a367; }

    .player{
      display:flex; align-items:center; gap:12px; margin-top: 12px;
    }
    .avatar{ width: var(--avatar); height: var(--avatar); border-radius:50%;
      background: linear-gradient(180deg,#0f1522,#0a0f1a); border:1px solid var(--border);
      box-shadow: 0 0 16px rgba(0,209,255,.2);
      overflow: hidden;
    }
    .avatar img{ width:100%; height:100%; object-fit: cover; display:block; }
    .name{ font-weight: 800; }
    .muted{ color: var(--muted); font-size: 13px; }

    .scoreRow{ display:flex; align-items:baseline; justify-content: space-between; margin-top: 10px; }
    .score{ font-size: clamp(22px, 3.2vw, 30px); font-weight: 900; text-shadow: 0 0 14px rgba(0,209,255,.25); }
    .delta{ font-size: 12px; font-weight: 800; letter-spacing:.3px; }
    .delta.up{ color: var(--accent); }
    .delta.down{ color: var(--danger); }

    /* Rank change sparkle */
    @keyframes pulseUp{ 0%{ transform: translateY(2px); filter: drop-shadow(0 0 0 rgba(0,255,161,0)); }
      50%{ transform: translateY(-2px); filter: drop-shadow(0 0 10px rgba(0,255,161,.6)); }
      100%{ transform: translateY(0); filter: drop-shadow(0 0 0 rgba(0,255,161,0)); } }
    @keyframes pulseDown{ 0%{ transform: translateY(-1px); filter: drop-shadow(0 0 0 rgba(255,95,109,0)); }
      50%{ transform: translateY(2px); filter: drop-shadow(0 0 10px rgba(255,95,109,.6)); }
      100%{ transform: translateY(0); filter: drop-shadow(0 0 0 rgba(255,95,109,0)); } }

    .delta.up[data-animate="true"]{ animation: pulseUp .9s ease-out 1; }
    .delta.down[data-animate="true"]{ animation: pulseDown .9s ease-out 1; }

    /* Leader list */
    .list{
      background: var(--panel); border:1px solid var(--border); border-radius: var(--radius);
      box-shadow: var(--shadow); overflow:hidden;
    }
    .row{ display:grid; grid-template-columns: 72px 1fr 140px 120px 108px; align-items:center; gap: 0; border-bottom:1px solid var(--border); }
    .row > div{ padding: 12px var(--pad); }
    .row.header{ background: #0d1220; color: #c6dcff; font-weight:800; font-size: 13px; letter-spacing:.3px; position: sticky; top:0; z-index:1; }
    .row:last-child{ border-bottom:0; }
    .rankCell{ font-weight:900; font-size: 18px; }
    .nameCell{ display:flex; align-items:center; gap:12px; }
    .nameCell .badge{ font-size: 11px; padding: 2px 6px; border-radius: 999px; border:1px solid #1b2030; background:#0b0f1a; color:#9bdcff; }
    .btn, .btnGhost{
      appearance:none; border:0; cursor:pointer; padding: 8px 12px; border-radius: 12px;
      font-weight: 800; letter-spacing: .2px;
    }
    .btn{ background: linear-gradient(180deg, var(--neon-pink), #a71b7a); color:white; box-shadow: 0 8px 18px rgba(255,47,185,.25);
      transition: transform .08s ease; }
    .btn:active{ transform: translateY(1px); }
    .btnGhost{ background:#0c101a; color:#c9d8ff; border:1px solid var(--border); }

    /* Mobile compaction */
    @media (max-width: 880px){
      .row{ grid-template-columns: 62px 1fr 120px 100px 0px; }
      .row > .hide-md{ display:none; }
    }
    @media (max-width: 640px){
      .row.header{ display:none; }
      .row{ grid-template-columns: 56px 1fr 100px; }
      .row > .hide-sm{ display:none; }
      .nameCell .badge{ display:none; }
      .avatar{ --avatar: 38px; }
    }

    /* Glow separators */
    .glowSep{ height: 1px; background: linear-gradient(90deg, transparent, rgba(0,209,255,.35), transparent); margin: 14px 0; filter: blur(.4px); }
    /* Motion safety */
    @media (prefers-reduced-motion: reduce){
      .delta.up[data-animate="true"], .delta.down[data-animate="true"]{ animation: none; }
    }
  </style>
</head>
<body>
  <div class="wrap">
    <h1 class="pageTitle"><span class="logoDot"></span> Leaderboard</h1>
    <div class="toolbar" role="toolbar" aria-label="랭킹 보기 옵션">
      <div class="segmented" role="group" aria-label="기간 선택">
        <button id="btnDaily"  type="button" aria-pressed="false">일간</button>
        <button id="btnWeekly" type="button" aria-pressed="true">주간</button>
        <button id="btnAll"    type="button" aria-pressed="false">전체</button>
      </div>
      <div class="segmented" role="group" aria-label="정렬">
        <button id="sortScore" type="button" aria-pressed="true">점수순</button>
        <button id="sortChange" type="button" aria-pressed="false">변동순</button>
      </div>
      <div class="search" role="search">
        <svg class="icon" width="18" height="18" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M21 21L16.65 16.65" stroke="currentColor" stroke-width="1.8" stroke-linecap="round"/><circle cx="11" cy="11" r="6.2" stroke="currentColor" stroke-width="1.8"/></svg>
        <label class="sr-only" for="iSearch">닉네임 검색</label>
        <input id="iSearch" type="search" placeholder="닉네임 검색" />
      </div>
    </div>

    <!-- Podium (Top 1~3) -->
    <section id="iPodium" class="podium" aria-label="상위 랭커"></section>

    <div class="glowSep" aria-hidden="true"></div>

    <!-- Leader list -->
    <section class="list" aria-label="랭킹 목록">
      <div class="row header" role="row">
        <div role="columnheader">순위</div>
        <div role="columnheader">닉네임</div>
        <div role="columnheader" class="hide-sm">점수</div>
        <div role="columnheader" class="hide-sm">레벨</div>
        <div role="columnheader" class="hide-md">변동</div>
      </div>
      <div id="iList" role="rowgroup"></div>
    </section>
  </div>
  <script>
  // ------------------------------
  // Leaderboard Demo Data & Helpers
  // ------------------------------
  const DemoData = {
    // You will replace this with fetch('/api/ranking?period=weekly') etc.
    weekly: [
      { rank:1,  name:'NeonTiger',     score: 9821, level:'Extreme', delta:+2, avatar:'https://picsum.photos/seed/nt/200' },
      { rank:2,  name:'CyberMina',     score: 9570, level:'Extreme', delta:-1, avatar:'https://picsum.photos/seed/cm/200' },
      { rank:3,  name:'PhotonDash',    score: 9255, level:'Hard',    delta:+4, avatar:'https://picsum.photos/seed/pd/200' },
      { rank:4,  name:'GlitchFox',     score: 8890, level:'Hard',    delta:+1, avatar:'https://picsum.photos/seed/gf/200' },
      { rank:5,  name:'ZeroLag',       score: 8764, level:'Hard',    delta:-3, avatar:'https://picsum.photos/seed/zl/200' },
      { rank:6,  name:'MintSpark',     score: 8602, level:'Normal',  delta:+2, avatar:'https://picsum.photos/seed/ms/200' },
      { rank:7,  name:'ByteBaller',    score: 8410, level:'Normal',  delta: 0, avatar:'https://picsum.photos/seed/bb/200' },
      { rank:8,  name:'PinkNova',      score: 8301, level:'Normal',  delta:+1, avatar:'https://picsum.photos/seed/pn/200' },
      { rank:9,  name:'NightDriver',   score: 8209, level:'Hard',    delta:-2, avatar:'https://picsum.photos/seed/nd/200' },
      { rank:10, name:'ArcRanger',     score: 7998, level:'Hard',    delta:+3, avatar:'https://picsum.photos/seed/ar/200' }
    ],
    daily: [
      { rank:1, name:'CyberMina',   score: 1620, level:'Extreme', delta:+1, avatar:'https://picsum.photos/seed/cm/200' },
      { rank:2, name:'NeonTiger',   score: 1588, level:'Hard',    delta: 0, avatar:'https://picsum.photos/seed/nt/200' },
      { rank:3, name:'PinkNova',    score: 1490, level:'Normal',  delta:+2, avatar:'https://picsum.photos/seed/pn/200' },
      { rank:4, name:'ArcRanger',   score: 1375, level:'Hard',    delta:-1, avatar:'https://picsum.photos/seed/ar/200' }
    ],
    all: [
      { rank:1, name:'NeonTiger',   score: 120_002, level:'Extreme', delta:+1, avatar:'https://picsum.photos/seed/nt/200' },
      { rank:2, name:'PhotonDash',  score: 110_445, level:'Extreme', delta:+2, avatar:'https://picsum.photos/seed/pd/200' },
      { rank:3, name:'ZeroLag',     score: 108_332, level:'Hard',    delta:-1, avatar:'https://picsum.photos/seed/zl/200' },
      { rank:4, name:'CyberMina',   score: 106_800, level:'Extreme', delta:+4, avatar:'https://picsum.photos/seed/cm/200' }
    ]
  };

  // Utility: format number with commas
  const fmt = n => n.toLocaleString('en-US');

  // ------------------------------
  // Renderers
  // ------------------------------
  function renderPodium(data){
    const el = document.getElementById('iPodium');
    const top3 = data.slice(0,3);
    const medalClass = ['gold','silver','bronze'];
    const medalLabel = ['1st','2nd','3rd'];
    el.innerHTML = top3.map((p, i) => `
      <article class="podCard" data-rank="${p.rank}">
        <div class="medal ${medalClass[i]}">
          <span class="dot ${medalClass[i]}"></span>
          <span class="${medalClass[i]}">${medalLabel[i]} • TOP ${p.rank}</span>
        </div>
        <div class="player">
          <div class="avatar" aria-hidden="true"><img src="${p.avatar}" alt=""/></div>
          <div>
            <div class="name">${p.name}</div>
            <div class="muted">레벨 • ${p.level}</div>
          </div>
        </div>
        <div class="scoreRow">
          <div class="score">${fmt(p.score)}</div>
          <div class="delta ${p.delta>=0 ? 'up':'down'}" data-animate="true">${p.delta>=0 ? '▲' : '▼'} ${Math.abs(p.delta)}</div>
        </div>
      </article>
    `).join('');
  }

  function renderList(data){
    const list = document.getElementById('iList');
    list.innerHTML = data.map(p => `
      <div class="row" role="row">
        <div class="rankCell" role="cell">#${p.rank}</div>
        <div class="nameCell" role="cell">
          <div class="avatar" aria-hidden="true"><img src="${p.avatar}" alt=""/></div>
          <div>
            <div class="name">${p.name}</div>
            <div class="muted hide-sm">최근 레벨: ${p.level}</div>
          </div>
          <span class="badge hide-sm">NEON</span>
        </div>
        <div class="hide-sm" role="cell"><strong>${fmt(p.score)}</strong></div>
        <div class="hide-sm" role="cell">${p.level}</div>
        <div class="hide-md" role="cell"><span class="delta ${p.delta>=0?'up':'down'}" data-animate="true">${p.delta>=0 ? '▲':'▼'} ${Math.abs(p.delta)}</span></div>
        </div>
      </div>
    `).join('');
  }
  // ------------------------------
  // App State & Wiring (window.onload)
  // ------------------------------
  window.onload = () => {
    const state = { period:'weekly', sort:'score', query:'' };

    const $ = sel => document.querySelector(sel);
    const btnDaily = $('#btnDaily');
    const btnWeekly = $('#btnWeekly');
    const btnAll = $('#btnAll');
    const sortScore = $('#sortScore');
    const sortChange = $('#sortChange');
    const search = $('#iSearch');
    const list = document.getElementById('iList');

    function setSegPress(el, pressed){ el.setAttribute('aria-pressed', String(pressed)); }

    function getData(){
      // In production, call your API:
      // return fetch(`/ranking/top?period=${state.period}`)
      //   .then(r => r.json());
      const data = state.period==='daily' ? DemoData.daily : state.period==='all' ? DemoData.all : DemoData.weekly;
      // filter by nickname query
      let out = data.filter(p => p.name.toLowerCase().includes(state.query));
      // sort
      if(state.sort==='score') out = out.slice().sort((a,b)=> b.score - a.score);
      else out = out.slice().sort((a,b)=> Math.abs(b.delta) - Math.abs(a.delta));
      // re-rank after sort for display (keep original delta)
      out = out.map((p,i)=> ({...p, rank:i+1}));
      return out;
    }

    function refresh(){
      const data = getData();
      renderPodium(data);
      renderList(data);
    }

    // Initial
    refresh();

    // Period buttons
    btnDaily.addEventListener('click', () => {
      state.period='daily'; setSegPress(btnDaily,true); setSegPress(btnWeekly,false); setSegPress(btnAll,false); refresh();
    });
    btnWeekly.addEventListener('click', () => {
      state.period='weekly'; setSegPress(btnDaily,false); setSegPress(btnWeekly,true); setSegPress(btnAll,false); refresh();
    });
    btnAll.addEventListener('click', () => {
      state.period='all'; setSegPress(btnDaily,false); setSegPress(btnWeekly,false); setSegPress(btnAll,true); refresh();
    });

    // Sort buttons
    sortScore.addEventListener('click', () => {
      state.sort='score'; setSegPress(sortScore,true); setSegPress(sortChange,false); refresh();
    });
    sortChange.addEventListener('click', () => {
      state.sort='change'; setSegPress(sortScore,false); setSegPress(sortChange,true); refresh();
    });

    // Search
    search.addEventListener('input', (e) => { state.query = String(e.target.value || '').trim().toLowerCase(); refresh(); });
    document.addEventListener('keydown', (e)=>{
      if(e.key === 'Escape') closeDetail();
    });
  };
  </script>

  <!--
  =============================
  Backend Integration Notes
  =============================
  1) Controller (Jakarta Servlet 6 / Spring MVC 등)
     - GET /ranking/top?period=weekly|daily|all
       -> returns JSON list: [{rank,name,score,level,delta,avatarUrl}, ...]

  2) Suggested JSON contract
     {
       "period": "weekly",
       "asOf": "2025-10-28T00:00:00Z",
       "items": [
         {"rank":1,"name":"NeonTiger","score":9821,"level":"Extreme","delta":2,"avatar":"/img/avatars/nt.png"}
       ]
     }

  3) DB (Oracle) – minimal ranking tables

     -- GAME_LOG: 개별 플레이 결과 (이미 보유 가정)
     -- FKs / Indexes 생략 (생성 환경에 맞추어 추가)
     CREATE TABLE GAME_LOG (
       GAME_LOG_ID   NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
       MEM_NO        NUMBER(10)       NOT NULL,
       GAME_LEVEL    VARCHAR2(16),    -- Easy/Normal/Hard/Extreme
       SCORE         NUMBER(10)       NOT NULL,
       PLAYED_AT     TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL
     );

     -- RANKING_SNAPSHOT: 기간별 스냅샷(집계 결과 저장)
     CREATE TABLE RANKING_SNAPSHOT (
       SNAPSHOT_ID   NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
       PERIOD        VARCHAR2(8)  CHECK (PERIOD IN ('DAILY','WEEKLY','ALL')),
       SNAPSHOT_AT   TIMESTAMP    DEFAULT SYSTIMESTAMP NOT NULL,
       MEM_NO        NUMBER(10)   NOT NULL,
       SCORE_TOTAL   NUMBER(12)   NOT NULL,
       RANK_NO       NUMBER(10)   NOT NULL,
       RANK_DELTA    NUMBER(5)    DEFAULT 0
     );
     CREATE INDEX IX_RANKING_SNAPSHOT_P ON RANKING_SNAPSHOT (PERIOD, SNAPSHOT_AT DESC, RANK_NO);

     -- 집계 방식 예시 (pseudo SQL)
     -- DAILY: TRUNC(PLAYED_AT) = TRUNC(SYSDATE)
     -- WEEKLY: TRUNC(PLAYED_AT, 'IW') = TRUNC(SYSDATE, 'IW')
     -- ALL: 기간 제한 없음

     -- 스냅샷 리프레시 프로시저 예시 개요
     -- (실사용 시 에러 핸들링, 통계 테이블/인덱스 전략, 병행 제어 보완)
     /*
     CREATE OR REPLACE PROCEDURE REFRESH_RANKING(p_period IN VARCHAR2) AS
     BEGIN
       INSERT INTO RANKING_SNAPSHOT (PERIOD, SNAPSHOT_AT, MEM_NO, SCORE_TOTAL, RANK_NO, RANK_DELTA)
       SELECT p_period,
              SYSTIMESTAMP,
              MEM_NO,
              SUM(SCORE) AS SCORE_TOTAL,
              DENSE_RANK() OVER (ORDER BY SUM(SCORE) DESC) AS RANK_NO,
              0 AS RANK_DELTA  -- 직전 스냅샷과 비교(셀프 조인)하여 계산
       FROM GAME_LOG
       WHERE CASE p_period
             WHEN 'DAILY'  THEN TRUNC(PLAYED_AT) = TRUNC(SYSDATE)
             WHEN 'WEEKLY' THEN TRUNC(PLAYED_AT, 'IW') = TRUNC(SYSDATE, 'IW')
             ELSE 1=1 END
       GROUP BY MEM_NO;

       -- RANK_DELTA 업데이트 (직전 동일 PERIOD 스냅샷과 비교)
       UPDATE RANKING_SNAPSHOT cur
       SET RANK_DELTA = NVL(prev.RANK_NO, cur.RANK_NO) - cur.RANK_NO
       FROM (
         SELECT c.SNAPSHOT_ID, p.RANK_NO
         FROM RANKING_SNAPSHOT c
         JOIN (
           SELECT MEM_NO, RANK_NO
           FROM RANKING_SNAPSHOT
           WHERE PERIOD = p_period
           AND SNAPSHOT_AT = (
             SELECT MAX(SNAPSHOT_AT)
             FROM RANKING_SNAPSHOT
             WHERE PERIOD = p_period
             AND SNAPSHOT_AT < (SELECT MAX(SNAPSHOT_AT) FROM RANKING_SNAPSHOT WHERE PERIOD = p_period)
           )
         ) p ON p.MEM_NO = c.MEM_NO
         WHERE c.PERIOD = p_period
         AND c.SNAPSHOT_AT = (SELECT MAX(SNAPSHOT_AT) FROM RANKING_SNAPSHOT WHERE PERIOD = p_period)
       ) prev
       WHERE cur.SNAPSHOT_ID = prev.SNAPSHOT_ID;
     END;
     */

     -- 운영 전략
     --  * 배치: DAILY/WEEKLY는 스케줄러(DBMS_SCHEDULER)로 매일/매주 리프레시
     --  * 실시간: GAME_LOG INSERT 시 점수 합계를 캐시 테이블(예: RANKING_RT_SUM)로 누적 후, 일정 주기마다 스냅샷 반영
     --  * 조회는 스냅샷 최신 1개만 읽어 성능 확보

  4) 보안/안정성
     - 점수 조작 방지: 서버 측 검증, 세션/토큰 검증, Anti-Cheat 로그
     - API 레이트 리밋, 응답 캐시 (ETag, Cache-Control:
       period=all 같은 고정 데이터에 효과적)
  -->
</body>
</html>
