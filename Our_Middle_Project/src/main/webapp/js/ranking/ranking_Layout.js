// 메인페이지 이동
function goHome() {
    window.location.href = "gameHome.do"; 
}

lucide.createIcons();

// 모든 점수, 콤보, 시간 등 숫자 컬럼 선택
const numberColumns = document.querySelectorAll('.ranking-column.score, .ranking-column.combo');

// 숫자에 콤마 추가
numberColumns.forEach(col => {
    let value = col.textContent.trim();
    if(!isNaN(value)) { // 숫자인 경우만
        col.textContent = Number(value).toLocaleString();
    }
});


// ================================================
// 유틸: 랜덤 정수
function randomInt(min, max) {
    return Math.floor(Math.random() * (max - min + 1)) + min;
}

// ================================================
// 난이도 리스트 ID
const difficultyIds = ['rankingList-1','rankingList-2','rankingList-3']; // eazy, normal, hard

difficultyIds.forEach(listId => {
    const listDiv = document.getElementById(listId);

    // 기존 헤더 저장
    const header = listDiv.querySelector('.ranking-header');

    // 기존 내용 초기화
    listDiv.innerHTML = '';
    listDiv.appendChild(header);

    // 4등부터 100등까지 생성
    for (let i = 4; i <= 100; i++) {
        const item = document.createElement('div');
        item.classList.add('ranking-item');

        // 난수 데이터 생성
        const nickname = `플레이어${i}`;
        const userId = `ID${1000 + i}`;
        const combo = randomInt(10, 300);
        const clearTime = `${randomInt(1, 10)}분 ${randomInt(0, 59)}초`;
        const maxScore = randomInt(1000, 10000);

        // 컬럼 생성
        item.innerHTML = `
            <div class="ranking-column">#${i}</div>
            <div class="ranking-column">${nickname}</div>
            <div class="ranking-column">${userId}</div>
            <div class="ranking-column">${combo}</div>
            <div class="ranking-column">${clearTime}</div>
            <div class="ranking-column">${maxScore}</div>
        `;

        listDiv.appendChild(item);
    }
});


// 상단/중앙 슬라이드 요소
const topSlide = document.getElementById('topwidth500');
const centerSlide = document.getElementById('centerWidth500');

// 난이도 버튼 ID 배열
const buttons = ['btnEasy', 'btnNormal', 'btnHard', 'btnVs', 'btnTotal'];
const totalSlides = buttons.length;

let currentIndex = 0; // 현재 슬라이드 인덱스

// ============================================
// 슬라이드 이동 함수
function moveSlide(index) {
    if (index < 0) index = 0;
    if (index >= totalSlides) index = totalSlides - 1;

    currentIndex = index;
    const offset = -20 * index; // 각 칸 20%
    topSlide.style.transform = `translateX(${offset}%)`;
    centerSlide.style.transform = `translateX(${offset}%)`;

    // 좌/우 버튼 표시 여부
    if(prevBtn) prevBtn.style.display = currentIndex === 0 ? 'none' : 'flex';
    if(nextBtn) nextBtn.style.display = currentIndex === totalSlides - 1 ? 'none' : 'flex';
}

// ============================================
// 난이도 버튼 이벤트 연결
buttons.forEach((btnId, i) => {
    const btn = document.getElementById(btnId);
    if(btn) {
        btn.addEventListener('click', () => moveSlide(i));
    }
});

// ============================================
// 양쪽 화살표 버튼 이벤트
const prevBtn = document.getElementById('prevSlide');
const nextBtn = document.getElementById('nextSlide');

if(prevBtn) {
    prevBtn.addEventListener('click', () => {
        if(!prevBtn.classList.contains('disabled')) moveSlide(currentIndex - 1);
    });
}

if(nextBtn) {
    nextBtn.addEventListener('click', () => {
        if(!nextBtn.classList.contains('disabled')) moveSlide(currentIndex + 1);
    });
}
// ============================================
// 초기 슬라이드 위치
moveSlide(0);


//======================================
//하단 버튼 위치 시각적 표현
function moveSlide(index) {
    if (index < 0) index = 0;
    if (index >= totalSlides) index = totalSlides - 1;

    currentIndex = index;
    const offset = -20 * index;
    topSlide.style.transform = `translateX(${offset}%)`;
    centerSlide.style.transform = `translateX(${offset}%)`;

    // 좌/우 버튼 disabled 처리
    if(prevBtn) {
        if(currentIndex === 0) prevBtn.classList.add('disabled');
        else prevBtn.classList.remove('disabled');
    }
    if(nextBtn) {
        if(currentIndex === totalSlides - 1) nextBtn.classList.add('disabled');
        else nextBtn.classList.remove('disabled');
    }

    // 하단 버튼 active 표시
    buttons.forEach((btnId, i) => {
        const btn = document.getElementById(btnId);
        if(btn) {
            if(i === currentIndex) btn.classList.add('active');
            else btn.classList.remove('active');
        }
    });
}


//======================================
// vs, total coming soon
document.querySelectorAll('#rankingList-4, #rankingList-5').forEach(el => {
    el.textContent = 'COMING SOON';
});

//======================================
// easyRanking 1~3등
for (let i = 0; i <= 2; i++) {
    const data = easyRanking[i];
    const rankId = `#rankingTop${i + 1}-1`; // easy 1~3등은 -1

    // nickname
    document.querySelector(`${rankId} .ranking-column.nickname .span2`).textContent = data.nickname;
    // mem_id
    document.querySelector(`${rankId} .ranking-column.userId .span2`).textContent = data.mem_id;
    // combo
    document.querySelector(`${rankId} .ranking-column.combo .span2`).textContent = data.combo;
    // clear_time
    document.querySelector(`${rankId} .ranking-column.time .span2`).textContent = data.clear_time + "초";
    // score_best
    document.querySelector(`${rankId} .ranking-column.score`).textContent = data.score_best;
}
// NORMAL
for (let i = 0; i <= 2; i++) {
    const data = normalRanking[i];
    const rankId = `#rankingTop${i + 1}-2`; // normal 1~3등
    document.querySelector(`${rankId} .ranking-column.nickname .span2`).textContent = data.nickname;
    document.querySelector(`${rankId} .ranking-column.userId .span2`).textContent = data.mem_id;
    document.querySelector(`${rankId} .ranking-column.combo .span2`).textContent = data.combo;
    document.querySelector(`${rankId} .ranking-column.time .span2`).textContent = data.clear_time + "초";
    document.querySelector(`${rankId} .ranking-column.score`).textContent = data.score_best;
}
// HARD
for (let i = 0; i <= 2; i++) {
    const data = hardRanking[i];
    const rankId = `#rankingTop${i + 1}-3`; // hard 1~3등
    document.querySelector(`${rankId} .ranking-column.nickname .span2`).textContent = data.nickname;
    document.querySelector(`${rankId} .ranking-column.userId .span2`).textContent = data.mem_id;
    document.querySelector(`${rankId} .ranking-column.combo .span2`).textContent = data.combo;
    document.querySelector(`${rankId} .ranking-column.time .span2`).textContent = data.clear_time + "초";
    document.querySelector(`${rankId} .ranking-column.score`).textContent = data.score_best;
}


//=======================================easy 4~50===================
const easyRankingData = easyRanking; 

const easyListDiv = document.getElementById('rankingList-1');

// 헤더 유지
const header = easyListDiv.querySelector('.ranking-header');

// 기존 내용 초기화 후 헤더만 남김
easyListDiv.innerHTML = '';
easyListDiv.appendChild(header);

// 실제 데이터 1~50등 표시
for (let i = 3; i < Math.min(50, easyRankingData.length); i++) {
    const data = easyRankingData[i];

    const item = document.createElement('div');
    item.classList.add('ranking-item');

    item.innerHTML = `
        <div class="ranking-column-main-1">#${i + 1}</div>
        <div class="ranking-column-main-2">${data.nickname}</div>
        <div class="ranking-column-main-3">${data.mem_id}</div>
        <div class="ranking-column-main-4">${data.combo}</div>
        <div class="ranking-column-main-5">${data.clear_time}초</div>
        <div class="ranking-column-main-6">${data.score_best}</div>
    `;

    easyListDiv.appendChild(item);
}
// =============================normal 4~50등=======================
const normalRankingData = normalRanking;

const normalListDiv = document.getElementById('rankingList-2');

// 헤더 유지
const headerNormal = normalListDiv.querySelector('.ranking-header');

// 기존 내용 초기화 후 헤더만 남김
normalListDiv.innerHTML = '';
normalListDiv.appendChild(headerNormal);


for (let i = 3; i < Math.min(50, normalRankingData.length); i++) {
    const data = normalRankingData[i];

    const item = document.createElement('div');
    item.classList.add('ranking-item');

    item.innerHTML = `
        <div class="ranking-column-main-1">#${i + 1}</div>
        <div class="ranking-column-main-2">${data.nickname}</div>
        <div class="ranking-column-main-3">${data.mem_id}</div>
        <div class="ranking-column-main-4">${data.combo}</div>
        <div class="ranking-column-main-5">${data.clear_time}초</div>
        <div class="ranking-column-main-6">${data.score_best}</div>
    `;

    normalListDiv.appendChild(item);
}
// =============================hard 4~50등=======================
const hardRankingData = hardRanking; // 이미 JSP에서 선언된 변수

const hardListDiv = document.getElementById('rankingList-3');

// 헤더 유지
const headerHard = hardListDiv.querySelector('.ranking-header');

// 기존 내용 초기화 후 헤더만 남김
hardListDiv.innerHTML = '';
hardListDiv.appendChild(headerHard);


for (let i = 3; i < Math.min(50, hardRankingData.length); i++) {
    const data = hardRankingData[i];

    const item = document.createElement('div');
    item.classList.add('ranking-item');

    item.innerHTML = `
        <div class="ranking-column-main-1">#${i + 1}</div>
        <div class="ranking-column-main-2">${data.nickname}</div>
        <div class="ranking-column-main-3">${data.mem_id}</div>
        <div class="ranking-column-main-4">${data.combo}</div>
        <div class="ranking-column-main-5">${data.clear_time}초</div>
        <div class="ranking-column-main-6">${data.score_best}</div>
    `;

    hardListDiv.appendChild(item);
}
