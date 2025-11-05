/**
 * =======================================================
 * JavaScript: board_form.js
 * (게시물 작성, 수정, 답글 폼 전용 로직)
 * =======================================================
 * 포함 함수: goBack, validateWrite, validateEdit, validateReply
 */

document.addEventListener('DOMContentLoaded', () => {
  
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

    
	if (title === "" || writer === "" || content === "") {
	    Swal.fire({ icon: 'warning', title: '입력 오류', text: '모든 필드를 입력해주세요.', confirmButtonText: '확인' });
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
    return validateWrite(); 
}

const titleInput = document.getElementById('title');
const fixedPrefix = "[자유] ";

// 초기값
titleInput.value = fixedPrefix;

// 입력 시 접두사 삭제 방지
titleInput.addEventListener('input', () => {
    if (!titleInput.value.startsWith(fixedPrefix)) {
        titleInput.value = fixedPrefix;
    }
});

// 커서 위치 제한
titleInput.addEventListener('keydown', (e) => {
    if (titleInput.selectionStart < fixedPrefix.length) {
        titleInput.setSelectionRange(fixedPrefix.length, fixedPrefix.length);
    }
});

titleInput.addEventListener('click', () => {
    if (titleInput.selectionStart < fixedPrefix.length) {
        titleInput.setSelectionRange(fixedPrefix.length, fixedPrefix.length);
    }
});
