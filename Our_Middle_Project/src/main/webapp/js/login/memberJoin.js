
function memJoindModalHandle(obj) {
	obj.className = 'mem-modal-on'
}

function memJoinCloseHandle(obj) {
	obj.className = 'mem-modal-off'
}

function joinHandle() {
	
	joinDBAdd();
	
	let userInfo = {};
	
	let userInfoElement = document.getElementsByClassName('joinInfo')
	for(let i=0 ; i<userInfoElement.length ; i++) {
		let key = userInfoElement[i].getAttribute('name')
		
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
	
	let loginValue = true
	for(let key in userInfo) {
		
		if(userInfo[key] == '') {
			loginValue = false
		}
		
	}
	
	if(!loginValue) {
		
		Swal.fire({
			icon: 'error',
			text: '모든 내용을 작성해주세요.',
			confirmButtonText: '확인',
			allowOutsideClick: false,
			customClass: {
				popup: 'non-join-Modal-back',
				confirmButton: 'non-join-btn'
			}
		});
	}
	else {
		joinDBAdd(userInfo);
	}
	
}

function idInputChangeHandle(e) {
	console.log(e.target.value)
	
	let json = {
		mem_id: e.target.value
	}
	
	let result = idCheckToDB(json);
	
}


























