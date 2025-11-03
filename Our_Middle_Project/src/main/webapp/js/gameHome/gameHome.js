//========== 버튼 클릭 시 이동 로직======

//게시판 이동
function goBoard() {
    window.location.href = "board.do"; 
}
//리뷰 이동
function goReview() {
    window.location.href = "review.do"; 
}
//랭킹 이동
function goRanking() {
    window.location.href = "ranking.do"; 
}

//====================================
//마이페이지 이동
function goMyPage() {
    window.location.href = "myPage.do"; 
}
//로그인창 이동
function goExit() {
    window.location.href = "login.do"; 
}
//=====================================

//게임시작 난이도별
// 전역 변수로 난이도 저장
/*let level = 4;*/

// 난이도 선택 후 게임 시작
function startGameLevel(selectedLevel) {
    /*level = selectedLevel; // 난이도 설정*/
    console.log(`선택한 난이도: ${level}x${level}`);

    modal.style.display = 'none';   // 모달 닫기
    singleMode.style.display = 'none';

    // 실제 게임 시작
    startGame(); // 기존 startGame() 호출
}
//로그인창 이동

function startGameWithLevel(obj) {
	console.log(obj)
	
	let target = obj
	let userInfo = {
		mem_id: "test",
		level_name: target.getAttribute("value")
	}
	
	gameLevelSaveToDB(userInfo);
	
    /*window.location.href = `gamePlay.do`;*/
}

//function gameStart6() {
//    window.location.href = "gamePlay.do"; 
//}
//function gameStart8() {
//    window.location.href = "gamePlay.do"; 
//}


//=========우측 상단 톱니바퀴 로직=========
const menuBtn = document.getElementById('menuBtn');
const menuItems = document.getElementById('menuItems');

menuBtn.addEventListener('click', () => {
    menuItems.classList.toggle('show');
});

// 외부 클릭 시 메뉴 닫기
document.addEventListener('click', (e) => {
    if(!menuBtn.contains(e.target) && !menuItems.contains(e.target)) {
        menuItems.classList.remove('show');
    }
});
//============마우스 오버 로직==========

//const cards = document.querySelectorAll(".card");
//
//cards.forEach(card => {
////  const front = card.querySelector(".card-front");
////	const back = card.querySelector(".card-back");
//	const inner = card.querySelector(".card-inner");
//
//    // 마우스 오버
//    card.addEventListener("mouseenter", () => {
//		inner.classList.add("flipped");
////        front.style.opacity = "1";
////		back.style.opacity = "0";
//    });
//
//    // 마우스 아웃
//    card.addEventListener("mouseleave", () => {
//		inner.classList.remove("flipped");
////        front.style.opacity = "0";
////		back.style.opacity = "1";
//    });
//});


const cards = document.querySelectorAll(".card");

cards.forEach(card => {


    // 마우스 오버
    card.addEventListener("mouseenter", () => {
        card.classList.add("flipped"); // ← 여기 card에 추가
    });

    // 마우스 아웃
    card.addEventListener("mouseleave", () => {
        card.classList.remove("flipped"); // ← 여기 card에서 제거
    });
});

//======================================================
// 모달 요소
const modal = document.getElementById("gameModal");
const modeSelect = document.getElementById('modeSelect');
const singleMode = document.getElementById('singleMode');
const pvpMode = document.getElementById('pvpMode');
const closeModalBtn = document.getElementById('closeModal');
const backToModeBtn = document.getElementById('backToMode');
const backToMode2Btn = document.getElementById('backToMode2');
const gameStartBtn = document.getElementById("gameStart");
const modalContent = document.getElementById("modalContent");

// 모달 열기
function goGameStart() {
    modal.style.display = "flex";
    singleMode.style.display = 'block'; // 싱글 난이도 바로 표시
}

// 모달 닫기
closeModalBtn.addEventListener('click', () => {
    modal.style.display = 'none';
});
//// 모달 외부 클릭 (화면 나머지 영역)
//document.addEventListener('click', (e) => {
//    // 모달이 열려 있고, 클릭한 곳이 모달 내부(#modalContent)가 아니면 닫기
//    if (modal.style.display === 'flex' && !modalContent.contains(e.target)) {
//        modal.style.display = 'none';
//    }
//});
// 모달 초기화 함수
function resetModal() {
    singleMode.style.display = 'none';
    pvpMode.style.display = 'none';
}

// 모드 선택
function selectSingleMode() {
    modeSelect.style.display = 'none';
    singleMode.style.display = 'block';
}

function selectPvPMode() {
    modeSelect.style.display = 'none';
    pvpMode.style.display = 'block';
}

// 게임 시작 버튼 클릭 시
gameStartBtn.addEventListener("click", goGameStart);
