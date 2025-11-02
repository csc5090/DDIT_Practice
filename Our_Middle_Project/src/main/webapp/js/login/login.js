

window.onload = () => {

	addEventHandle();
	/*window.scrollTo(0, 0);*/
	
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
	
	window.addEventListener('keydown', (e) => { pressSpaceHandle(e) });
	
	let searchAddrBtn = document.getElementById('mem-addr-search');
	searchAddrBtn.addEventListener('click', () => { addrSearchAPI() });
	
	let joinModal = document.getElementById('membershipModal');
	let memJoin = document.querySelector('.member-join');
	memJoin.addEventListener('click', () => { memJoindModalOpenHandle(joinModal) });
	
	let memJoinClose = document.querySelector('.btnBox-left');
	memJoinClose.addEventListener('click', () => { memJoinModalCloseHandle(joinModal) });
	
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
	
	let memBirth = document.getElementById('mem_birth')
	memBirth.addEventListener('keydown', e => e.preventDefault());
	memBirth.addEventListener('paste', e => e.preventDefault());

	let birthIcon = document.getElementById('birthIcon')
	birthIcon.addEventListener('click', (e) => { birthBtnHandle(e, memBirth) })
		
	/* date 타입의 input 제어 */
	document.querySelectorAll('input[type="date"]').forEach(el => {
	  el.addEventListener('selectstart', e => e.preventDefault());
	});
	
	let logininputs = document.getElementsByClassName('logininputs')
	for(let i=0 ; i<logininputs.length ; i++) {
		logininputs[i].addEventListener('change', (e) => { loginInfoSaveHandle(e) })
	}
		
	let loginBtn = document.getElementById('loginBtn');
	loginBtn.addEventListener('click', (e) => { loginCheckHandle(e) })
	
	let idSearchInput = document.getElementById('idSearchInput');
	idSearchInput.addEventListener('change', (e) => { idSearchInputHandle(e) })
	
	let pwSearchInputs = document.getElementsByClassName('pwSearchInputs');
	for(let i=0 ; i<pwSearchInputs.length ; i++) {
		pwSearchInputs[i].addEventListener('change', (e) => { pwSearchInputsHandle(e) })
	}
	
}

function findIdHandle() {
	let idModal = document.getElementById('idModal');
	idModal.className = "modal-on";
};

/* 조승희 수정 20251103 */
let searchValue = {
	id: '',
	email: ''
}

function idSearchInputHandle(e) {
	let target = e.target;
	let value = target.value;
	
	let pattern = /\s/
	if(pattern.test(value)) {
		onlyCheckAlert("error", "공백 없이 입력해주세요.")
	}
	else {
		
		searchValue.id = value
		
	}
	
}

function pwSearchInputsHandle(e) {
	
	let target = e.target;
	let value = target.value;
	
	let pattern = /\s/
	if(pattern.test(value)) {
		onlyCheckAlert("error", "공백 없이 입력해주세요.")
	}
	else {
		
		let type = value.getAttribute('data-type');
		if(type === 'id') {
			searchValue.id = value
		}
		else {
			searchValue.email = value
		}
		
	}
	
}

function findPwHandle() {
	let pwModal = document.getElementById('pwModal');
	pwModal.className = "modal-on";
};

function closeModalHandle(e) {
	let modal = e.target.closest('.modal-on');
	modal.className = "modal-off";
};


/* 조승희 수정 20251102 */
function pressSpaceHandle(e) {
	let target = e.code;
	
	console.log(target)
	
	if(target === 'Space') {
		window.scrollBy({
			top: document.body.scrollHeight,
			behavior: 'smooth'
		});
	}
	else if(target === 'F11') {
		
	  setTimeout(() => {
		if(window.scrollX === 0 && window.scrollY === 0) {
			// pass
		} 
		else {
			if(window.innerHeight === screen.height) {
				window.scrollBy({
					top: document.body.scrollHeight,
					behavior: 'smooth'
				});
		    } 
			else {
		      console.log('F11 전체화면 해제');
		    }
		}
	  }, 500);
	  
	}
	
}

let loginInfo = {
	id: "",
	pw: ""
}

function loginInfoSaveHandle(e) {
	
	let target = e.target
	let value = target.value
	let type = target.type
	let pattern = /\s/
	if(pattern.test(value)) {
		onlyCheckAlert("error", "공백 없이 입력해주세요.")
	}
	else {
		
		type == "text" ? loginInfo.id = value : loginInfo.pw = value;
		
		let loginId = loginInfo.id
		let loginPw = loginInfo.pw
		
		let loginBtn = document.getElementById('loginBtn')
		if(loginId != "" && loginPw != "") {
			loginBtn.className = "login-btn-active"
		}
		else {
			loginBtn.className = "login-btn"
		}
		
	}

}

function loginCheckHandle() {
	
	let loginId = loginInfo.id
	let loginPw = loginInfo.pw
	
	if(loginId.trim() == "" || loginPw.trim() == "") {
		// pass
	}
	else {
		loginCheckToDB(loginInfo)
	}
	
}

