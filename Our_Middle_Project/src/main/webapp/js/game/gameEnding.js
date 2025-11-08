
let endingValue = true;
let endingInfo = {
	score: 1120,
	plusTime: 100,
	combo: 10,
	cardCount: 15

}
		

function endGame() {
	console.log('게임종료')
	
	let eM = document.getElementById("endingModal")
	eM.style.top = "0px";
	
	setTimeout(() => {
		endingTextHandle();
		endingInfoHandle();
		endingBtnHandle();
	}, 1100)
}


function endingTextHandle() {
	let eT = document.getElementById("endingText")
	
	if(endingValue) {
		eT.innerHTML = "GAME CLEAR"
	}
	else {
		eT.innerHTML = "GAME OVER"
	}
}

function endingInfoHandle() {
	let infos = document.getElementsByClassName('ending-info');
	for(let i=0 ; i<infos.length ; i++) {
		infos[i].style.opacity = 1;
		infos[i].style.transition = '1s';
		let valueBox = infos[i].getElementsByClassName('value')[0]; 	
		let value = valueBox.getAttribute('data-info');
		
		setTimeout(() => {
			window["endingInfoInterval" + i] = setInterval(() => {
				valueBox.innerHTML = Number(valueBox.innerHTML) + 1;
				if(valueBox.innerHTML == endingInfo[value]) {
					clearInterval(window["endingInfoInterval" + i]);
				}
			}, 1)				
		}, 1000)
		
	}
}

function endingBtnHandle() {
	let btns = document.getElementsByClassName('ending-right-box-btn');
	for(let i=0 ; i<btns.length ; i++) {
		btns[i].style.opacity = 1;
		btns[i].style.transition = '1s';
		
		btns[i].addEventListener('click', (event) => { endingBtnClick(event.currentTarget) })
	}
}

function endingBtnClick(obj) {
	console.log(obj);
}

function endingBtnClick(obj) {
    const v = obj.getAttribute('data-value');

    if(v === "try"){
        // 새로고침
        location.reload();
    }
    else if(v === "home"){
        // 홈으로 이동
        location.href = "/Our_Middle_Project/gameHome.do";
    }
}

