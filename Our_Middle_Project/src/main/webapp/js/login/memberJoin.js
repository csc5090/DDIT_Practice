
function memJoindModalHandle(obj) {
	obj.className = 'mem-modal-on'
}

function memJoinCloseHandle(obj) {
	obj.className = 'mem-modal-off'
}

const userInfoCase = {
	idCheck: false,
	userInfo: {}
};

async function joinHandle() {
	
	let userInfo = userInfoCase.userInfo;
	
	let userInfoElement = document.getElementsByClassName('joinInfo')
	for(let i=0 ; i<userInfoElement.length ; i++) {
		let key = userInfoElement[i].getAttribute('name');
		
		switch(key) {
			case "mem_gender":
				
				if(userInfoElement[i].checked) {
					userInfo[key] = userInfoElement[i].getAttribute("value")
				}
				else {
					
					if(userInfo[key]) {
						if(userInfo[key] == '') {
							userInfo[key] = userInfoElement[i].getAttribute("value")
						}
					}
					else {
						userInfo[key] = ''
					}
					
				}
				
				break;
				
			case "mem_add1":
				let idValue = userInfoElement[i].getAttribute('id');
				if(idValue == 'user_addres') {
					userInfo[key] = userInfoElement[i].value;
				}
				else {
					userInfo[key] += userInfoElement[i].value;
				}
				break; 
				
			default :
				userInfo[key] = userInfoElement[i].value;
				break;
		}
		
	}
	
	let loginValue = true;
	for(let key in userInfo) {
		
		if(userInfo[key] == '') {
			loginValue = false;
		}
		
	}
	
	if(userInfoCase.idCheck) {
		
		if(!loginValue) {
			
			onlyCheckAlert("error", "모든 내용을 작성해주세요.");
			
		}
		else {
			joinDBAdd(userInfo);
			
			for(let i=0 ; i<userInfoElement.length ; i++) {
				let key = userInfoElement[i].getAttribute('name');
						
				switch(key) {
					case "mem_gender":
						userInfoElement[i].checked = false;
						break;
						
					default :
						userInfoElement[i].value = "";
						break;
				}
			}
			
			let value = await onlyCheckAlert("success", "회원가입을 성공했습니다. \n 로그인을 시도해주세요.")
			if(value) {
				let joinModal = document.getElementById('membershipModal');
				memJoinCloseHandle(joinModal);
			}
			
		}
		
	}
	else {

		onlyCheckAlert("error", "아이디 중복값을 확인해주세요.");
		
	}
	
}

async function idInputChangeHandle(e) {
	let target = e.target;
	let fillerValue = target.value.replace(/[^a-zA-Z0-9]/g, '');
	target.value = fillerValue;

	let idCheckMent = document.getElementById("mem_id_check");
	if(target.value.length < 3 || target.value.length > 20) {
		
		idCheckMent.className = "check-no";
		idCheckMent.textContent = "ID는 3 ~ 20 글자의 영어와 숫자조합이 필요합니다.";
		
	}
	else {
		
		let json = {
			mem_id: fillerValue
		};

		let result = await idCheckToDB(json);
		
		if(result) {
			
			idCheckMent.className = "check-ok";
			idCheckMent.textContent = "생성이 가능한 아이디 입니다.";
			userInfoCase.idCheck = true;
			
		}
		else{
			
			idCheckMent.className = "check-no";
			idCheckMent.textContent = "생성이 불가능한 아이디 입니다.";
			userInfoCase.idCheck = false;
			
		}
		
	}
	
	
}

function mailInputChangeHandle(e) {
	
	let target = e.target;
	let mailCheckMent = document.getElementById("mem_mail_check");
	let pattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
	if (pattern.test(target.value)) {
		
		mailCheckMent.className = "check";
		mailCheckMent.textContent = "";
		
	}
	else {
		
		mailCheckMent.className = "check-no";
		mailCheckMent.textContent = "이메일의 형식을 지켜주세요.";
		target.value = "";
			
	}
	
}

function passwordControllHandle(e) {
	let target = e.currentTarget;
	
	let pwInput = document.getElementById('mem_pass');
	let pwCheckMent = document.getElementById('mem-password_check');
	
	let value = target.getAttribute("data-pass");
	if(value == "on") {
		target.innerHTML = `
			<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16">
				<path d="M13.359 11.238C15.06 9.72 16 8 16 8s-3-5.5-8-5.5a7 7 0 0 0-2.79.588l.77.771A6 6 0 0 1 8 3.5c2.12 0 3.879 1.168 5.168 2.457A13 13 0 0 1 14.828 8q-.086.13-.195.288c-.335.48-.83 1.12-1.465 1.755q-.247.248-.517.486z"/>
				<path d="M11.297 9.176a3.5 3.5 0 0 0-4.474-4.474l.823.823a2.5 2.5 0 0 1 2.829 2.829zm-2.943 1.299.822.822a3.5 3.5 0 0 1-4.474-4.474l.823.823a2.5 2.5 0 0 0 2.829 2.829"/>
				<path d="M3.35 5.47q-.27.24-.518.487A13 13 0 0 0 1.172 8l.195.288c.335.48.83 1.12 1.465 1.755C4.121 11.332 5.881 12.5 8 12.5c.716 0 1.39-.133 2.02-.36l.77.772A7 7 0 0 1 8 13.5C3 13.5 0 8 0 8s.939-1.721 2.641-3.238l.708.709zm10.296 8.884-12-12 .708-.708 12 12z"/>
			</svg>
		`;
		target.setAttribute("data-pass", "off");
		pwInput.type = "password";
		
		pwCheckMent.className = "check";
		pwCheckMent.textContent = "";
	}
	else {
		target.innerHTML = `
			<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16">
				<path d="M16 8s-3-5.5-8-5.5S0 8 0 8s3 5.5 8 5.5S16 8 16 8M1.173 8a13 13 0 0 1 1.66-2.043C4.12 4.668 5.88 3.5 8 3.5s3.879 1.168 5.168 2.457A13 13 0 0 1 14.828 8q-.086.13-.195.288c-.335.48-.83 1.12-1.465 1.755C11.879 11.332 10.119 12.5 8 12.5s-3.879-1.168-5.168-2.457A13 13 0 0 1 1.172 8z"/>
				<path d="M8 5.5a2.5 2.5 0 1 0 0 5 2.5 2.5 0 0 0 0-5M4.5 8a3.5 3.5 0 1 1 7 0 3.5 3.5 0 0 1-7 0"/>
			</svg>
		`;
		target.setAttribute("data-pass", "on");
		pwInput.type = "text";
		
		pwCheckMent.className = "check-no";
		pwCheckMent.textContent = "비밀번호는 보안상 보이지 않게 해주세요.";
	}
}

function hpInputHandle(e) {
	
	let target = e.target;
	let hpCheckMent = document.getElementById("mem_hp_check");
	let pattern = /^010\d{8}$/;
	if (pattern.test(target.value)) {
		
		hpCheckMent.className = "check";
		hpCheckMent.textContent = "";
		
		target.value = target.value.replace(/^(\d{3})(\d{4})(\d{4})$/, "$1-$2-$3");
		
	}
	else {
		
		hpCheckMent.className = "check-no";
		hpCheckMent.textContent = "(-) 없이 입력해주세요.";
		target.value = "";
			
	}
	
}
/*
function birthInputHandle(e) {
	
	let target = e.target;
	let hpCheckMent = document.getElementById("mem_hp_check");
	let pattern = /^\d{4}-\d{2}-\d{2}$/;
	if (pattern.test(target.value)) {
		
		hpCheckMent.className = "check";
		hpCheckMent.textContent = "";
		
	}
	else {
		
		hpCheckMent.className = "check-no";
		hpCheckMent.textContent = "생년월일 입력방식: YYYY-MM-DD";
		target.value = "";
			
	}
	
}

*/
















