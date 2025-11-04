/**
 * JavaScript: boardEdit.js
 * 게시물 수정 전용 로직
 */

document.addEventListener('DOMContentLoaded', () => {
    console.log("Board Edit Script Loaded!");
});

/**
 * 이전 페이지로 돌아갑니다. (취소 버튼)
 */
function goBack() {
    window.history.back();
}

/**
 * 게시물 수정 전 유효성 검사를 수행합니다.
 * @returns {boolean} 폼 전송 허용 여부
 */
function validateEdit() {
    const title = document.getElementById('title').value.trim();
    const content = document.getElementById('content').value.trim();

    if (title === "" || content === "") {
        Swal.fire({ 
            icon: 'warning', 
            title: '입력 오류', 
            text: '제목과 내용을 모두 입력해주세요.', 
            confirmButtonText: '확인' 
        });
        return false;
    }
    
    console.log("Edit form validation successful.");
    return true; 
}
