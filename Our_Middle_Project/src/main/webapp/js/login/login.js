

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
	
	let joinModal = document.getElementById('membershipModal');
	let memJoin = document.querySelector('.member-join');
	memJoin.addEventListener('click', () => { memJoindModalHandle(joinModal) });
	
	let memJoinClose = document.querySelector('.btnBox-left');
	memJoinClose.addEventListener('click', () => { memJoinCloseHandle(joinModal) });
	
	let joinBtn = document.getElementById('joinBtn');
	joinBtn.addEventListener('click', () => { joinHandle() });
	
	let memIdInput = document.getElementById('mem_id');
	memIdInput.addEventListener('change', (e) => { idInputChangeHandle(e) });
	
	let memMailInput = document.getElementById('mem_mail');
	memMailInput.addEventListener('change', (e) => { mailInputChangeHandle(e) });
	
	let pc = document.getElementById('password_controll');
	pc.addEventListener('click', (e) => { passwordControllHandle(e) });
	
	let memHpInput = document.getElementById('mem_hp');
	memHpInput.addEventListener('change', (e) => { hpInputHandle(e) });
	
/*	let memBirthInput = document.getElementById('mem_birth');
	memBirthInput.addEventListener('change', (e) => { birthInputHandle(e) });*/

	// input 태그 수정 작업 필요
	
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

