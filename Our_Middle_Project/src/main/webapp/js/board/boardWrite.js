/**
 * =======================================================
 * JavaScript: board_form.js
 * (게시물 작성, 수정, 답글 폼 전용 로직)
 * =======================================================
 * 포함 함수: goBack, validateWrite, validateEdit, validateReply
 */

document.addEventListener('DOMContentLoaded', () => {
    console.log("Board Form Script Loaded!");
});

/**
 * 이전 페이지로 돌아갑니다. (취소 버튼)
 */
function goBack() {
    window.history.back();
}

/**
 * 새 글 등록 전 유효성 검사를 수행합니다. (boardWrite.jsp에서 사용)
 * @returns {boolean} 폼 전송 허용 여부
 */
function validateWrite() {
    const title = document.getElementById('title').value.trim();
    const writer = document.getElementById('writer').value.trim();
    const content = document.getElementById('content').value.trim();
    const password = document.getElementById('password').value.trim();

    if (title === "" || writer === "" || content === "" || password === "") {
        Swal.fire({ icon: 'warning', title: '입력 오류', text: '모든 필드를 입력해주세요.', confirmButtonText: '확인' });
        return false;
    }
    
    console.log("New post validation successful.");
    return true; 
}

/**
 * 게시물 수정 전 유효성 검사를 수행합니다. (boardEdit.jsp에서 사용)
 * @returns {boolean} 폼 전송 허용 여부
 */
function validateEdit() {
    const title = document.getElementById('title').value.trim();
    const content = document.getElementById('content').value.trim();
    const password = document.getElementById('password').value.trim();
    
    if (title === "" || content === "" || password === "") {
        Swal.fire({ icon: 'warning', title: '입력 오류', text: '제목, 내용, 비밀번호를 모두 입력해주세요.', confirmButtonText: '확인' });
        return false;
    }
    
    console.log("Edit form validation successful.");
    return true; 
}

/**
 * 답글 등록 전 유효성 검사를 수행합니다. (boardReply.jsp에서 사용)
 * @returns {boolean} 폼 전송 허용 여부
 */
function validateReply() {
    return validateWrite(); // 답글은 기본적으로 글쓰기와 동일한 유효성 검사
}
