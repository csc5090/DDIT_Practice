

window.onload = () => {

	addEventHandle();
	
}

function addEventHandle() {
	
	let findId = document.querySelector('.find-id');
	findId.addEventListener('click', (e) => { findIdHandle(e) });
	
	let findPw = document.querySelector('.find-pw');
	findPw.addEventListener('click', (e) => { findPwHandle(e) });

}

function findIdHandle(e) {
	let idModal = document.getElementById('idModal');
	idModal.style.display = 'flex';
};

function findPwHandle(e) {
	let pwModal = document.getElementById('pwModal');
	pwModal.style.display = 'flex';
};

function closeModal(id) {
	document.getElementById(id).style.display = 'none';
}