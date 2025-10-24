
window.onload = () => {

    const idModal = document.getElementById('idModal');
    const pwModal = document.getElementById('pwModal');
    const findId = document.querySelector('.find-id');
    const findPw = document.querySelector('.find-pw');

    findId.addEventListener('click', () => idModal.style.display = 'block');
    findPw.addEventListener('click', () => pwModal.style.display = 'block');

    window.addEventListener('click', (e) => {
        if (e.target === idModal) idModal.style.display = 'none';
        if (e.target === pwModal) pwModal.style.display = 'none';
    });
}

function closeModal(id) {
    document.getElementById(id).style.display = 'none';
}
