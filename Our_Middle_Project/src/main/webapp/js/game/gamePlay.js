
let score= 0;
let count = 0;
let comboCount = 0;
let maxCombo = 0;
let gameTimer;
let totalscore = 0;

let pausedTime = null;	//정지시 남은 시간 저장

let scoreElement;
let comboElement;
let maxComboElement;
let timeEl;

// let gameEnded = false;	//게임 종료
let gamePlay = false;


//======페이지 로드
window.onload = () => {

	scoreElement = document.querySelector(".score");	//점수 반영하기 위해서 score클래스 참조
	comboElement = document.querySelector(".combo");
	maxComboElement = document.querySelector(".max-combo");
	timeEl = document.getElementById("timeCount");

	addEventHandle();
}

//======이벤트 핸들러
function addEventHandle() {
	
	let startBtn = document.getElementById('startBtn');
	startBtn.addEventListener('click', (e) => { startGame(e) });
	
	console.log(userDataCase); // GAMEHOME에서 넘어온 값 확인
	const userId = userDataCase.mem_id;
	console.log("게임 플레이 유저 아이디:", userId);
	
	let stopBtn = document.getElementById('stopBtn');
	stopBtn.addEventListener("click", (e) => { handleStop(e) });
	console.log("11111");
	
	let exitBtn = document.getElementById('exitBtn');
	exitBtn.addEventListener("click", (e) => { handleExit(e) });
	
}

//======스타트 버튼 및 게임 시작 로직 
function startGame() {
	console.log('날 눌렀다.');
	
	gameStartTimeStr = new Date().toISOString().slice(0,19).replace("T"," "); // 시작 시간 기록
	
	startBtn.disabled = true;			//버튼 누른 후 다시 버튼 x
	startBtn.style.cursor = 'default';
	/*document.body.appendChild();*/

	if(savedArray == 4 || savedArray == 6 || savedArray == 8) createCard(savedArray);
	countDown(()=>{ 
		startTimer();
	});
}


//=====카드 생성 로직 
let firstCard = null;	//첫 번째 카드 뽑기
let secondCard = null;   //두 번째 카드 뽑기
let lockBoard = false;   //카드 비교 중 보드 잠금

function createCard(value){
	let text = "";

	let emoji = [
	  "🐶","🐱","🐭","🐹","🐰","🦊","🐻","🐼",
	  "🐨","🐯","🦁","🐮","🐷","🐽","🐸","🐵",
	  "🐒","🦍","🦧","🐔","🐧","🐦","🐤","🐣",
	  "🐥","🦆","🦅","🦉","🦇","🐺","🐗","🐴"
	];
	emoji.sort(() => Math.random() - 0.5);			//이모지 랜덤 로직
		
	// 4x4 배열이면 총 16장의 카드. 즉 8쌍 만들기
	let totalCards = value * value;
	let pairCount = totalCards / 2;
	let selectedEmojis = emoji.slice(0, pairCount);           // 8개 선택
	let cardEmojis = [...selectedEmojis, ...selectedEmojis]; // 2배로 만들어 짝 생성
	cardEmojis.sort(() => Math.random() - 0.5);
	
	for(let i = 0 ; i<(value*value); i++){
		text += `
		  <div class="card" >
		    <div class="card-inner">
		      <div class="card-back" onclick="cardChoice(this, event)"></div>
		      <div class="card-front">${cardEmojis[i]}</div>
		    </div>
		  </div>
		`;
	}
		/*=====3초동안 앞면 보여주고 시작=====*/	
	let leftArea = document.getElementById("leftArea") 
	leftArea.innerHTML = text
	leftArea.classList.add(`leftArea-${value}`)
	
	setTimeout(()=>{
		const allCards = leftArea.querySelectorAll(".card"); // querySelectorAll 사용
		allCards.forEach(card => card.classList.add("flip")); // 앞면 보이기
		setTimeout(() => {
			 allCards.forEach(card => card.classList.remove("flip")); // 3초 후 뒤집기
		}, 3000);
	}, 1000);
}

//=====카드 클릭 시 이벤트 
function cardChoice(obj, e) {
	console.log(obj)
	
	const card = e.target.closest(".card");
		
		if(!card || lockBoard) return; // 비교 중이면 클릭 무시
		if(card == firstCard) return;  // 같은 카드 클릭 방지
		
		card.classList.add("flip");		//뒤집기
		
		if(!firstCard){
			firstCard = card;			//첫번째 카드 선택
			return;
		}	
		secondCard = card;				//두번째 카드 선택
		
		//카드 비교 로직		==> 첫번째 선택 카드 // 두번째 선택 카드 
		const firstEmoji = firstCard.querySelector(".card-front").textContent;
		const secondEmoji = secondCard.querySelector(".card-front").textContent;
		
		if(firstEmoji == secondEmoji){ //카드 짝이 맞다면 그대로 유지
			firstCard = null;
			secondCard = null;	
			
			score += 100;							//점수 부여 
			count += 1;	
			comboCount ++;							//몇개 맞춘지
			
			if(comboCount > maxCombo){
				maxCombo = comboCount;		//최고 콤보 업데이트
			}
			
			totalscore = score + (comboCount-1)*100;	//100점에 콤보 숫자만큼 곱
								//콤보 카운트
			
			// 모든 카드 맞출 시 ★ 종료 시점 ★
			let endCard = (savedArray * savedArray) / 2;
			if(count == endCard){
			/*	================종료 로직 테스트중========================== */
				dataSave();
				return;
				}
			} else {	//카드 짝이 틀리다면 => 0.x초 후 다시 뒤집기
			
			comboCount = 0;  // 콤보 초기화
			
			lockBoard = true;
			setTimeout(()=>{
				firstCard.classList.remove("flip"); 	//첫번째 카드를 다시 되돌리다
				secondCard.classList.remove("flip");	//두번째 카드를 다시 되돌리다
				firstCard = null;		//되돌린 상태에서 유지
				secondCard = null;
				lockBoard = false;
			},600);
		}
		
		scoreElement.textContent = totalscore;
		comboElement.textContent = comboCount;
		maxComboElement.textContent = maxCombo;
	}

//======카운트 다운 로직 
function countDown(callback){
		
	const countEl = document.getElementById("countDown");
	const countEl_in = document.getElementById("countDown-in");
//	countEl.style.display = "flex"; // 버튼 클릭 후 표시

	let count = 3;

	const timer = setInterval(() => {
		countEl_in.textContent = count > 0 ? count : "GO!";
		count--;

		if (count < 0) {
		    clearInterval(timer);
		    countEl.remove();  // 끝나면 제거
			
			if(callback) callback();
		}
	}, 1000);
}	

//======레벨별 기본 시간
function getDefaultTimeByLevel() {
    console.log("콘솔", savedArray, typeof savedArray); // 타입 확인
    const level = Number(savedArray); // 문자열이면 숫자로 변환
    switch(level) {
        case 4: return 30.9;
        case 6: return 180.9;
        case 8: return 300.9;
        default: return 4.9;
    }
}

//=======레벨 남은 시간 타이머 로직
function startTimer(initialTime) {
	// 🔹 초 대신 0.1초 단위로 timeCount 관리
	let timeCount = initialTime !== undefined ? initialTime : getDefaultTimeByLevel();
	timeCount = timeCount * 10; // 10배로 만들어 0.1초 단위

	const timeEl = document.getElementById("timeCount");

    // 기존 타이머가 있으면 제거
	if(gameTimer) clearInterval(gameTimer);

	// 🔹 0.1초 단위로 업데이트
	gameTimer = setInterval(() => {
	    if(timeCount >= 0){	
	        const totalSeconds = Math.floor(timeCount / 10); // 초 단위
	        const min = Math.floor(totalSeconds / 60).toString().padStart(2,'0');
	        const sec = (totalSeconds % 60).toString().padStart(2,'0');
	        // 🔹 눈에는 안보이므로 소수점은 표시하지 않음
	        timeEl.textContent = `${min} : ${sec}`;
	        timeCount--;
	    } else { 	//★종료시점2★
	        clearInterval(gameTimer);
	        lockBoard = true;

			
			// ✅🔥 시간이 0이 되면 종료 처리
			dataSave();
	    }
	}, 100); // 🔹 100ms 단위
	
	setTimeout(() => {
		gamePlay = true;	
	}, 200)
}

//======일시정지 버튼로직
function handleStop(){
	if(gamePlay){
		console.log("게임중");
		if(pausedTime === null) { // 일시정지 상태가 아니면
		    // 1. 타이머 일시정지
		    clearInterval(gameTimer);
		
		    // 2. 카드 클릭 잠금
		    lockBoard = true;
		
		    // 3. 남은 시간 계산 (🔹 0.1초 단위)
		    const [min, sec] = document.getElementById("timeCount").textContent.split(" : ");
		    pausedTime = (parseInt(min) * 60 + parseInt(sec)) * 10; // 🔹 0.1초 단위로 저장
		
		    // 버튼 텍스트 변경 (재개)
		    stopBtn.textContent = "재개";
		
		} else { // 이미 일시정지 상태면 -> 재개
		    lockBoard = false; // 카드 클릭 허용
		    startTimer(pausedTime / 10); // 🔹 0.1초 단위를 다시 초 단위로 변환
		    pausedTime = null; // 일시정지 상태 초기화
		    stopBtn.textContent = "일시정지"; // 버튼 텍스트 복구
	    }
	}else{
		console.log("1243");
	}
	
}

//=====나가기 버튼
function handleExit(){
	
	if(gamePlay) {
		console.log("게임중일때 누른 게임 나가기")
		// 1. 현재 남은 시간 저장
		  const [min, sec] = timeEl.textContent.split(" : ");
		  pausedTime = (parseInt(min) * 60 + parseInt(sec)) * 10;
	
		  // 2. 카드 클릭 잠금
		  lockBoard = true;
	
		  // 3. sweetalert 모달창
		  Swal.fire({
		      
		      icon: 'warning',				//아이콘
		      showCancelButton: true,		//취소 버튼 활성화
		      confirmButtonText: '종료',		//확인 및 설정 경로 페이지 이동 등
		      cancelButtonText: '취소',		
		      allowOutsideClick: false,		//모달 창 외 마우스 금지
		      allowEscapeKey: false,		//esc키 비활성화
			  
			  background: '#1e1e2f',   //  배경
			  color: '#fff',            // 글자색
			  iconColor: '#39ff14',     // 아이콘 색 
			  
			  //css 커스텀 클래스 생성
			  customClass: {
			  	popup: 'my-popup',          // 모달
				title: 'my-title',          // 타이틀
				content: 'my-content',      // 내용
				confirmButton: 'my-btn',    // 확인 버튼
				cancelButton: 'my-btn'      // 취소 버튼
			  },
			     text: '게임을 나가면 진행중인 내용이 저장되지 않습니다.', // 멘트 내용
		  }).then((result) => {
		      if(result.isConfirmed){
				  gameOut();
		      } else {
				  if(gamePlay) {
			          // 취소: 타이머 재시작
			          startTimer(pausedTime / 10);
			          lockBoard = false;				
				  }
				  else {
					console.log('--')
				  }
		      }
		  });
		  clearInterval(gameTimer);//타이머 일시정지
		
	}
	else {
		console.log("게임중이 아닐때 누른 게임 나가기")
		gameOut();
	}
	
}

//======종료 로직 

function gameOut() {
	window.location.href = "gameHome.do";  // 확인(종료)클릭 시
} 

//=====재시작 로직
function gameReStart() {
	location.reload()
	console.log("게임을 다시 시작합니다")
}

//===========post방식으로 저장 

function dataSave() {
    console.log("게임 데이터를 저장합니다.");
    console.log("점수: " + totalscore)
    console.log("맞춘갯수 : " + count);
    console.log("최고콤보 : " + maxCombo);

    clearInterval(gameTimer); // 타이머 초기화
    lockBoard = true;         // 카드 잠금

    // ===== POST 전송 =====
	const levelNo = parseInt(savedNo);
//    const score = totalscore;
      const combo = maxCombo;


	
	
    const startTimeStr = gameStartTimeStr || new Date().toISOString().slice(0, 19).replace("T", " ");
    const endTimeStr = new Date().toISOString().slice(0, 19).replace("T", " ");
	
	const start = new Date(startTimeStr);
	const end   = new Date(endTimeStr);
	const clearTime = Math.floor((end - start) / 1000);
	console.log("몇초걸렸냐?",clearTime);
	
	let timeBonus = Math.round((getDefaultTimeByLevel() - clearTime) * 100); 
	if (timeBonus < 0) timeBonus = 0;  //아무것도 안누르면 확실하게 0점 부여

	totalscore = totalscore + timeBonus; 
	

	
    // 세션에서 가져온 유저 번호
    const memNo = userDataCase.mem_no;
//	const memNo = 81;

    const jsonData = { memNo, levelNo, score: totalscore, combo, clearTime, startTimeStr, endTimeStr };
    console.log("서버로 보낼 JSON:", JSON.stringify(jsonData));

	gameLogToDB(jsonData);
	
	endingInfo = {
	       score: totalscore,
	       plusTime: clearTime,
	       combo: maxCombo,
	       cardCount: count
	   };
	   
	   console.log("endingInfo", endingInfo);
	   
    endGame();
}