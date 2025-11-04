
document.addEventListener('DOMContentLoaded', () => {

});


// 이전 페이지 (취소 버튼)
function goBack() {
    console.log("Cancelling and going back.");
    window.history.back();
}


// 글쓰기 
// @returns {boolean} 폼 전송 허용 여부
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


// 게시물 수정 전 유효성 검사를 수행
// @returns {boolean} 폼 전송 허용 여부
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


// 답글 등록 전 유효성 검사를 수행
// @returns {boolean} 폼 전송 허용 여부
function validateReply() {
    return validateWrite();
}
