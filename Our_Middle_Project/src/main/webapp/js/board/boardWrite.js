

document.addEventListener('DOMContentLoaded', () => {

});


// 게시물 목록 페이지
function goToList() {
    // window.location.href = 'boardList.jsp';
}


// 특정 게시물 상세 보기 페이지로 이동합니다. (boardList.jsp에서 사용)
// @param {number} postId - 게시물 ID

function viewPost(postId) {
    // window.location.href = 'boardCont.jsp?id=' + postId; 
}


// 글쓰기 페이지로 이동합니다. (boardList.jsp에서 사용)
function goToWritePage() {
    // window.location.href = 'boardWrite.jsp'; 
}


// 이전 페이지(목록/상세)로 
function goBack() {
    window.history.back(); // 브라우저 히스토리 한 단계 뒤로 이동
}


// --- boardEdit.jsp 전용 함수 ---


// 게시물 수정 전 유효성 검사를 수행합니다.
// @returns {boolean} 폼 전송 허용 여부
function validateEdit() {
    const title = document.getElementById('title').value.trim();
    const content = document.getElementById('content').value.trim();
    const password = document.getElementById('password').value.trim();
    
    // (작성자는 readonly이므로 생략)

    if (title === "") {
        alert("제목을 입력해주세요.");
        return false;
    }
    if (content === "") {
        alert("내용을 입력해주세요.");
        return false;
    }
    if (password === "") {
        alert("비밀번호를 입력해주세요.");
        return false;
    }
    
    console.log("Editing post...");
    alert("게시물 수정을 완료합니다!");
    
    // 실제 서버로 수정 액션 전송
    return true; 
}


// --- boardCont.jsp 전용 함수 ---


// 게시물 수정 페이지로 이동합니다.
// @param {number} postId - 게시물 ID
function goToEditPage(postId) {
    // window.location.href = 'boardEdit.jsp?id=' + postId;
}


// 게시물을 삭제
// @param {number} postId - 게시물 ID
function deletePost(postId) {
    if (confirm("정말로 " + postId + "번 게시물을 삭제하시겠습니까?")) {
        goToList(); // 삭제 성공 후 목록 페이지로 이동
    }
}