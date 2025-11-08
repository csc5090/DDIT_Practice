

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
	  btn.addEventListener('click', (e) => { closeModalHandle(e, "default") });
	});

	/*
		조승희 - 
		로그인 주소찾기 버튼
		회원가입 버튼 이벤트 생성
		addEvent +
	*/
	
	window.addEventListener('keydown', pressSpaceHandle );
	window.addEventListener('pageshow', pageshow );
	
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
		/*logininputs[i].addEventListener('change', (e) => { loginInfoSaveHandle(e) })*/
		logininputs[i].addEventListener('input', (e) => { loginInfoSaveHandle(e) })
	}
		
	let loginBtn = document.getElementById('loginBtn');
	loginBtn.addEventListener('click', (e) => { loginCheckHandle(e) })
	
	let idSearchInput = document.getElementById('idSearchInput');
	idSearchInput.addEventListener('change', (e) => { idSearchInputHandle(e) })
	
	let pwSearchInputs = document.getElementsByClassName('pwSearchInputs');
	for(let i=0 ; i<pwSearchInputs.length ; i++) {
		pwSearchInputs[i].addEventListener('change', (e) => { pwSearchInputsHandle(e) })
	}
	
	let searchBtns = document.getElementsByClassName('search-btns')
	for(let i=0 ; i<searchBtns.length ; i++) {
		searchBtns[i].addEventListener('click', (e) => { searchHandle(e) })
	}
	
}

function findIdHandle() {
	let idModal = document.getElementById('idModal');
	idModal.className = "modal-on";
};

function findPwHandle() {
	let pwModal = document.getElementById('pwModal');
	pwModal.className = "modal-on";
};

/* 조승희 수정 20251103 */
let searchValue = {
	type: '',
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
		
		searchValue.email = value
		
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

		let type = target.getAttribute('data-type');
		if(type === 'id') {
			searchValue.id = value
		}
		else {
			searchValue.email = value
		}
		
	}
	
}

async function searchHandle(e) {
	
	let target = e.target;
	let type = target.getAttribute('data-type'); 

	searchValue.type = type;
	if(type === 'id') {
		if(searchValue.email === '') {
			onlyCheckAlert('error', '이메일을 입력해주세요.');
			return;
		}
	}
	else {
		if(searchValue.id === '' || searchValue.email === '') {
			onlyCheckAlert('error', '모든 정보를 입력해주세요.');
			return;
		}
	}
	
	let result = await searchToDB(searchValue);
	console.log(result)
	
	if(type === 'id') {
		if(result === null) {
			onlyCheckAlert('error', '입력한 E-mail의 회원 정보가 없습니다.');
		}
		else {
			onlyCheckAlert('success', result.mem_id);
			let piInput = document.getElementById('inputId')
			piInput.value = result.mem_id
		}
	}
	else {
		if(result === null) {
			onlyCheckAlert('error', '입력한 회원의 정보가 없습니다.');
		}
		else {
			onlyCheckAlert('success', '입력한 E-Mail로 임시 비밀번호를 전송했습니다.');
		}
	}
	
	closeModalHandle("none", "auto");
	
}


function closeModalHandle(e, action) {
	
	let modal;
	if(action === "default") {
		modal = e.target.closest('.modal-on');
	}
	else {
		modal = document.getElementsByClassName('modal-on')[0]
	}
	
	modal.className = "modal-off";
	
	searchValue = {
		type: '',
		id: '',
		email: ''
	}
	
	let searchInputs = document.getElementsByClassName('searchInputs')
	for(let i=0 ; i<searchInputs.length ; i++) {
		searchInputs[i].value = ''
	}
	
};


/* 조승희 수정 20251102 */
function pressSpaceHandle(e) {
	
	let target = e.code;
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
			}
		}, 500);
	  
	}
	else if(target === "Enter" || target === "NumpadEnter") {
		e.preventDefault();
		let focusElement = document.activeElement
		let value = focusElement.getAttribute('id')
		
		if(value === 'inputPw') {
			loginCheckHandle();
		}
		
	}
	
}

let loginInfo = {
	mem_id: "",
	mem_pass: ""
}

function loginInfoSaveHandle(e) {
	
	let target = e.target
	let value = target.value
	let type = target.type
	
	let loginBtn = document.getElementById('loginBtn')
	
	type == "text" ? loginInfo.mem_id = value : loginInfo.mem_pass = value;
			
	let loginId = loginInfo.mem_id
	let loginPw = loginInfo.mem_pass
	
	
	if(loginId != "" && loginPw != "") {
		loginBtn.className = "login-btn-active"
	}

}

async function loginCheckHandle() {
	
	let loginId = loginInfo.mem_id
	let loginPw = loginInfo.mem_pass
	
	
	let pattern = /\s/
	if(pattern.test(loginId) || pattern.test(loginPw)) {

		onlyCheckAlert("error", "공백 없이 입력해주세요.")
		loginBtn.className = "login-btn"
		
	}
	else {
		
		let bText = document.getElementById('b-text');
		bText.style.display = 'none';
		console.log("b-text none")
		
		let result = await loginCheckToDB(loginInfo)
		adminUserCheck(result)
		
	}
	
}

function adminUserCheck(obj) {
	console.log(obj)
	let value = obj.role
	
	
	
	if(value === "undefined") {
		onlyCheckAlert("error", "존재하지 아이디 입니다.")
	}
	else if(value === "null") {
		onlyCheckAlert("error", "권한이 없는 아이디 입니다. <br> 관리자에게 문의 해주세요.")
	}
	else if(value === "USER") {
		
		if(obj.pwCheck === false) {
			onlyCheckAlert("error", "비밀번호를 틀렸습니다.")
		}
		else {
			window.scrollTo({
				top: 0,
				behavior: 'smooth'
			});
			
			setTimeout(() => {
				window.location.href = obj.url		
			}, 1000)			
		}
		
	}
	else if(value === "ADMIN") {
		
		if(obj.pwCheck === false) {
			onlyCheckAlert("error", "비밀번호를 틀렸습니다.")
		}
		else {
			window.location.href = obj.url				
		}
	}
	
}

function pageshow(event) {
	
	if (event.persisted) {	
		location.reload(); // 캐시된 페이지 방지용
	}
	
}




