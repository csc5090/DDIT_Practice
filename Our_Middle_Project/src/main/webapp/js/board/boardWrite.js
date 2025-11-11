/**
 * =======================================================
 * JavaScript: board_form.js
 * (게시물 작성, 수정, 답글 폼 전용 로직)
 * =======================================================
 * 포함 함수: goBack, validateWrite, validateEdit, validateReply
 */

document.addEventListener('DOMContentLoaded', () => {
    const titleInput = document.getElementById('title');
    const fixedPrefix = "[자유] ";
    const MAX_TITLE_LENGTH = 30; // 최대 글자 수

    // 초기값
    titleInput.value = fixedPrefix;

    // 입력 시 이벤트: 접두사 유지 + 글자수 제한
    titleInput.addEventListener('input', () => {
        // 접두사 유지
        if (!titleInput.value.startsWith(fixedPrefix)) {
            titleInput.value = fixedPrefix;
        }

        // 글자수 제한
        if (titleInput.value.length > MAX_TITLE_LENGTH) {
            titleInput.value = titleInput.value.slice(0, MAX_TITLE_LENGTH);
            Swal.fire({
                icon: 'warning',
                title: '입력 제한',
                text: `제목은 최대 ${MAX_TITLE_LENGTH}자까지 입력 가능합니다.`,
                confirmButtonText: '확인'
            });
        }
    });

    // 커서 위치 제한 (prefix 보호)
    function protectCursor() {
        if (titleInput.selectionStart < fixedPrefix.length) {
            titleInput.setSelectionRange(fixedPrefix.length, fixedPrefix.length);
        }
    }

    titleInput.addEventListener('keydown', protectCursor);
    titleInput.addEventListener('click', protectCursor);
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
    const writer = document.getElementById('writer')?.value.trim() || "";
    const content = document.getElementById('content').value.trim();
    const MAX_TITLE_LENGTH = 50;

    if (title === "" || writer === "" || content === "") {
        Swal.fire({ 
            icon: 'warning', 
            title: '입력 오류', 
            text: '모든 필드를 입력해주세요.', 
            confirmButtonText: '확인' 
        });
        return false;
    }

    if (title.length > MAX_TITLE_LENGTH) {
        Swal.fire({
            icon: 'warning',
            title: '제목 길이 초과',
            text: `제목은 최대 ${MAX_TITLE_LENGTH}자까지 입력 가능합니다.`,
            confirmButtonText: '확인'
        });
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
    const MAX_TITLE_LENGTH = 50;

    if (title === "" || content === "") {
        Swal.fire({ 
            icon: 'warning', 
            title: '입력 오류', 
            text: '모든 필드를 입력해주세요.', 
            confirmButtonText: '확인' 
        });
        return false;
    }

    if (title.length > MAX_TITLE_LENGTH) {
        Swal.fire({
            icon: 'warning',
            title: '제목 길이 초과',
            text: `제목은 최대 ${MAX_TITLE_LENGTH}자까지 입력 가능합니다.`,
            confirmButtonText: '확인'
        });
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
