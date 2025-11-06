
/* 조승희 수정 251105 */

// 모달 요소
let modal;
let modeSelect
let pvpMode
let backToModeBtn
let backToMode2Btn
let gameStartBtn
let modalContent

window.onload = () => {
	
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
	
	// 모달 요소 객체반영
	modeSelect = document.getElementById('modeSelect');
	pvpMode = document.getElementById('pvpMode');
	backToModeBtn = document.getElementById('backToMode');
	backToMode2Btn = document.getElementById('backToMode2');
	gameStartBtn = document.getElementById("gameStart");
	modalContent = document.getElementById("modalContent");
	
	// 게임 시작 버튼 클릭 시
	gameStartBtn.addEventListener("click", goGameStart);
	
	let closeModalBtn = document.getElementById('closeModal');
	closeModalBtn.addEventListener("click", (e) => { modalClose(e) })
	
	setTimeout(() => {
		window.scrollBy({
			top: document.body.scrollHeight,
			behavior: 'smooth'
		});
		
	}, 300)
}

function modalClose(e) {
	document.getElementById("gameModal").className = "level-modal-off"
}

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
function startGameLevel() {
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




//======================================================


// 모달 열기
function goGameStart() {
	
	/*
    modal.style.display = "flex";
    singleMode.style.display = 'block'; // 싱글 난이도 바로 표시
	*/

	const modal = document.getElementById('gameModal');
	const container = document.getElementById('modalContent');
	const cards = document.querySelectorAll('.level-card-box');
	const containerRect = container.getBoundingClientRect();
	const containerWidth = containerRect.width;
	const containerHeight = containerRect.height;

	modal.className = "level-modal-on"

	const placedCards = [];

	/* 🎯 중앙 근처로 모이되 왼쪽/위쪽 편향 없이 자연스러운 가우시안 랜덤 */
	function centeredRandomPos(max, axis = 'x') {
		// 중심 비율 (0.5 = 완전 중앙)
		let centerBias = axis === 'y' ? 0.55 : 0.5;

		// spread: 값이 작을수록 중앙에 모이고, 클수록 퍼짐
		const spread = 0.25;

		// Box–Muller transform으로 가우시안 분포 생성 (-1 ~ +1 범위)
		let u = 0, v = 0;
		while (u === 0) u = Math.random();
		while (v === 0) v = Math.random();
		const gaussian = Math.sqrt(-2.0 * Math.log(u)) * Math.cos(2.0 * Math.PI * v);

		// 가우시안 결과를 0~1 범위로 변환 후 중심 오프셋 적용
		const value = centerBias + gaussian * spread;

		// 0~1 범위로 제한 (넘어가면 컷)
		const clamped = Math.max(0, Math.min(1, value));

		return clamped * max;
	}

	/* 🔍 겹침 영역 계산 (너무 겹치면 배치 거부) */
	function getOverlapArea(x1, y1, w1, h1, x2, y2, w2, h2) {
		const overlapX = Math.max(0, Math.min(x1 + w1, x2 + w2) - Math.max(x1, x2));
		const overlapY = Math.max(0, Math.min(y1 + h1, y2 + h2) - Math.max(y1, y2));
		return overlapX * overlapY;
	}

	/* 📐 회전 후 실제 bounding box 크기 계산 */
	function getRotatedBoundingBoxSize(width, height, angleDeg) {
		const rad = Math.abs(angleDeg) * Math.PI / 180;
		const rotatedWidth = Math.abs(width * Math.cos(rad)) + Math.abs(height * Math.sin(rad));
		const rotatedHeight = Math.abs(width * Math.sin(rad)) + Math.abs(height * Math.cos(rad));
		return { rotatedWidth, rotatedHeight };
	}

	/* 🃏 카드 배치 */
	cards.forEach((card, index) => {
		const cardRect = card.getBoundingClientRect();
		const cardWidth = cardRect.width;
		const cardHeight = cardRect.height;

		// 도착 후 랜덤 회전 (-25° ~ +25°)
		const finalRotate = (Math.random() - 0.5) * 50;
		const { rotatedWidth, rotatedHeight } = getRotatedBoundingBoxSize(cardWidth, cardHeight, finalRotate);

		const maxX = containerWidth - rotatedWidth;
		const maxY = containerHeight - rotatedHeight;

		let x, y, tryCount = 0;
		let overlapOK = false;

		/* 🎯 최종 도착 위치 계산 (중앙 집중 + 겹침 최소화 + 거리 보정) */
		do {
			tryCount++;
			x = centeredRandomPos(maxX, 'x');
			y = centeredRandomPos(maxY, 'y');

			overlapOK = placedCards.every(prev => {
				const overlapArea = getOverlapArea(x, y, rotatedWidth, rotatedHeight, prev.x, prev.y, prev.w, prev.h);
				const overlapRatio = overlapArea / (rotatedWidth * rotatedHeight);

				// 카드 간 거리 계산
				const dx = Math.abs(prev.x - x);
				const dy = Math.abs(prev.y - y);
				const tooClose = dx < cardWidth * 0.7 && dy < cardHeight * 0.7;

				// 1/2 이상 겹치거나 너무 가까우면 배치 거부
				return overlapRatio <= 0.5 && !tooClose;
			});
		} while (!overlapOK && tryCount < 250);

		const finalX = x;
		const finalY = y;

		/* 🌀 출발 위치 (왼쪽 / 왼쪽 아래 대각선 랜덤) */
		const side = Math.random();
		let startX, startY;

		if (side < 0.6) {
			startX = -cardWidth * (1 + Math.random());
			startY = Math.random() * containerHeight * 0.8;
		} else {
			startX = -cardWidth * (0.5 + Math.random());
			startY = containerHeight + Math.random() * cardHeight * 2;
		}

		/* 🪄 초기 상태 */
		card.style.left = `${startX}px`;
		card.style.top = `${startY}px`;
		card.style.transform = `rotate(${Math.random() * -60}deg) scale(0.6)`;
		card.style.transition = '0';
		card.style.opacity = 0;

		/* ✨ 애니메이션 (카드가 날아와 자리 잡음) */
		setTimeout(() => {
			setTimeout(() => {
				card.style.transition = 'all 1.2s cubic-bezier(0.22, 1, 0.36, 1)';
				card.style.left = `${finalX}px`;
				card.style.top = `${finalY}px`;
				card.style.transform = `rotate(${finalRotate}deg) scale(1)`;
				card.style.opacity = 1;
				card.style.visibility = "visible";
			}, 300 * index + Math.random() * 250);
		}, 500);

		placedCards.push({ x, y, w: rotatedWidth, h: rotatedHeight });
	});
	
}


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



