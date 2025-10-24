
window.onload = () => {

    const idModal = document.getElementById('idModal');
    const pwModal = document.getElementById('pwModal');
    const findId = document.querySelector('.find-id');
    const findPw = document.querySelector('.find-pw');

	findId.addEventListener('click', (e) => { findIdHandle(e) });
	findPw.addEventListener('click', (e) => { findPwHandle(e) });

	function findIdHandle(e) {
		idModal.style.display = 'flex';
	};

	function findPwHandle(e) {
		pwModal.style.display = 'flex';
	};

}

function closeModal(id) {
	document.getElementById(id).style.display = 'none';
}