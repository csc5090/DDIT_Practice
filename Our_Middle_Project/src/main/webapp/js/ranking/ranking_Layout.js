// 메인페이지 이동
function goHome() {
    // 홈 화면으로 이동 (JSP나 HTML 파일명에 맞게 수정)
    window.location.href = "main.do"; 
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

// ================================================

// ============================================
// 상단/중앙 슬라이드 요소
const topSlide = document.getElementById('topwidth500');
const centerSlide = document.getElementById('centerWidth500');

// 난이도 버튼 ID 배열
const buttons = ['btnEazy', 'btnNormal', 'btnHard', 'btnVs', 'btnTotal'];
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