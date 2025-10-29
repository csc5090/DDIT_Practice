

window.onload = () => {

	addEventHandle();
	
}

function addEventHandle() {
	
	let findId = document.querySelector('.find-id');
	findId.addEventListener('click', () => { findIdHandle() });
	
	let findPw = document.querySelector('.find-pw');
	findPw.addEventListener('click', () => { findPwHandle() });
	
	let closeBtns = document.querySelectorAll('.close-btn');
	closeBtns.forEach(btn => {
	  btn.addEventListener('click', (e) => { closeModalHandle(e) });
	});

	/*
		조승희 - 
		로그인 주소찾기 버튼
		회원가입 버튼 이벤트 생성
		addEvent +
	*/
	
	let searchAddrBtn = document.getElementById('mem-addr-search');
	searchAddrBtn.addEventListener('click', () => { addrSearchAPI() });
	
	let joinModal = document.getElementById('membershipModal')
	let memJoin = document.querySelector('.member-join');
	memJoin.addEventListener('click', () => { memJoindModalHandle(joinModal) });
	
	let memJoinClose = document.querySelector('.btnBox-left');
	memJoinClose.addEventListener('click', () => { memJoinCloseHandle(joinModal) });
	
	let joinBtn = document.getElementById('joinBtn');
	joinBtn.addEventListener('click', () => { joinHandle() })
	
}

function findIdHandle() {
	let idModal = document.getElementById('idModal');
	idModal.style.display = 'flex';
};

function findPwHandle() {
	let pwModal = document.getElementById('pwModal');
	pwModal.style.display = 'flex';
};

function closeModalHandle(e) {
	let modal = e.target.closest('.modal')
	modal.style.display = 'none';
};

