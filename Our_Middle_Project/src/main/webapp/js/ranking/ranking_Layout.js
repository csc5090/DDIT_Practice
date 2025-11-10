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
    if (!isNaN(value) && value !== '') { // 숫자인 경우만 (빈 문자열 제외)
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
const difficultyIds = ['rankingList-1', 'rankingList-2', 'rankingList-3']; // eazy, normal, hard

// **[중복 코드 제거됨]** 4등부터 100등까지 더미 데이터 생성 (기존 로직 유지)
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
// 슬라이드 이동 함수 (하단 버튼 active 및 화살표 disabled 로직 포함)
function moveSlide(index) {
    if (index < 0) index = 0;
    if (index >= totalSlides) index = totalSlides - 1;

    currentIndex = index;
    const offset = -20 * index;
    topSlide.style.transform = `translateX(${offset}%)`;
    centerSlide.style.transform = `translateX(${offset}%)`;

    // 좌/우 버튼 disabled 처리
    const prevBtn = document.getElementById('prevSlide');
    const nextBtn = document.getElementById('nextSlide');
    
    if (prevBtn) {
        if (currentIndex === 0) prevBtn.classList.add('disabled');
        else prevBtn.classList.remove('disabled');
    }
    if (nextBtn) {
        if (currentIndex === totalSlides - 1) nextBtn.classList.add('disabled');
        else nextBtn.classList.remove('disabled');
    }

    // 하단 버튼 active 표시
    buttons.forEach((btnId, i) => {
        const btn = document.getElementById(btnId);
        if (btn) {
            if (i === currentIndex) btn.classList.add('active');
            else btn.classList.remove('active');
        }
    });
}

// ============================================
// 난이도 버튼 이벤트 연결
buttons.forEach((btnId, i) => {
    const btn = document.getElementById(btnId);
    if (btn) {
        btn.addEventListener('click', () => moveSlide(i));
    }
});

// ============================================
// 양쪽 화살표 버튼 이벤트
const prevBtn = document.getElementById('prevSlide');
const nextBtn = document.getElementById('nextSlide');

if (prevBtn) {
    prevBtn.addEventListener('click', () => {
        if (!prevBtn.classList.contains('disabled')) moveSlide(currentIndex - 1);
    });
}

if (nextBtn) {
    nextBtn.addEventListener('click', () => {
        if (!nextBtn.classList.contains('disabled')) moveSlide(currentIndex + 1);
    });
}
// ============================================
// 초기 슬라이드 위치
moveSlide(0);


//======================================
// vs, total coming soon
document.querySelectorAll('#rankingList-4, #rankingList-5').forEach(el => {
    el.textContent = 'COMING SOON';
});

// ================================================
// **[통합 함수]** 난이도별 랭킹 데이터 처리 함수 (1~3등 상단 및 4~50등 목록)
function updateRankingData(rankingData, difficultyIndex) {
    const listId = difficultyIndex + 1; // 1: easy, 2: normal, 3: hard
    const listDiv = document.getElementById(`rankingList-${listId}`);

    // --- 1. 상단 1~3등 데이터 바인딩 ---
    for (let i = 0; i < 3; i++) {
        const data = rankingData[i];
        if (!data) continue; // 데이터가 3개 미만일 경우 처리

        const rankId = `#rankingTop${i + 1}-${listId}`;
        const rankElement = document.querySelector(rankId);

        if (rankElement) {
            // nickname
            rankElement.querySelector('.ranking-column.nickname .span2').textContent = data.nickname;
            // mem_id
            rankElement.querySelector('.ranking-column.userId .span2').textContent = data.mem_id;
            // combo
            rankElement.querySelector('.ranking-column.combo .span2').textContent = Number(data.combo).toLocaleString();
            // clear_time
            rankElement.querySelector('.ranking-column.time .span2').textContent = data.clear_time + "초";
            // score_best
            // score에 콤마 추가 적용을 위해 toLocaleString 사용
            rankElement.querySelector('.ranking-column.score').textContent = Number(data.score_best).toLocaleString();
        }
    }

    // --- 2. 4~50등 목록 데이터 바인딩 ---
    // 헤더 유지 (중앙 리스트에서)
    const header = listDiv.querySelector('.ranking-header');
    
    // 4등 이상부터 생성할 것이므로, 더미 데이터는 이미 위에서 생성되었지만,
    // 실제 데이터로 덮어쓰기 위해 다시 초기화 (헤더만 남김)
    listDiv.innerHTML = '';
    listDiv.appendChild(header);

    // 실제 데이터 4등(인덱스 3)부터 50등까지 표시
    for (let i = 3; i < Math.min(50, rankingData.length); i++) {
        const data = rankingData[i];

        const item = document.createElement('div');
        item.classList.add('ranking-item');

        item.innerHTML = `
            <div class="ranking-column-main-1">#${i + 1}</div>
            <div class="ranking-column-main-2">${data.nickname}</div>
            <div class="ranking-column-main-3">${data.mem_id}</div>
            <div class="ranking-column-main-4">${Number(data.combo).toLocaleString()}</div>
            <div class="ranking-column-main-5">${data.clear_time}초</div>
            <div class="ranking-column-main-6">${Number(data.score_best).toLocaleString()}</div>
        `;

        listDiv.appendChild(item);
    }
}


// **[통합된 함수 호출]**

// easyRanking
updateRankingData(easyRanking, 0);

// normalRanking
updateRankingData(normalRanking, 1);

// hardRanking
updateRankingData(hardRanking, 2);