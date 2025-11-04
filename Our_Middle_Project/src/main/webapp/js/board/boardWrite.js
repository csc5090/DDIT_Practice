document.addEventListener('DOMContentLoaded', () => {
    console.log("Neon Board Script Loaded!");
});

/**
 * 게시물 목록 페이지로 이동합니다.
 */
function goToList() {
    window.location.href = "board.do";
}

/**
 * 특정 게시물 상세 보기 페이지로 이동합니다. (boardList.jsp에서 사용)
 * @param {number} postId - 게시물 ID
 */
function viewPost(postId) {
    console.log("Viewing Post ID: " + postId);
    alert(postId + "번 게시물 상세 페이지로 이동합니다.");
}

/**
 * 글쓰기 페이지로 이동합니다. (board.jsp에서 사용)
 */
function goToWritePage() {
    window.location.href = 'boardWrite.do';
}

/**
 * 이전 페이지(목록/상세)로 돌아갑니다. (boardWrite, boardEdit, boardReply에서 '취소' 버튼)
 */
function goBack() {
    window.history.back();
}

// --- boardEdit.jsp 전용 함수 ---

/**
 * 게시물 수정 전 유효성 검사를 수행합니다.
 * @returns {boolean} 폼 전송 허용 여부
 */
function validateEdit() {
    const title = document.getElementById('title').value.trim();
    const content = document.getElementById('content').value.trim();
    const password = document.getElementById('password').value.trim();

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

    return true;
}

/**
 * 게시물 수정 페이지로 이동합니다.
 * @param {number} postId - 게시물 ID
 */
function goToEditPage(postId) {
    console.log("Moving to Edit Page for Post ID: " + postId);
    alert(postId + "번 게시물을 수정 페이지로 이동합니다.");
}

/**
 * 게시물을 삭제합니다.
 * @param {number} postId - 게시물 ID
 */
function deletePost(postId) {
    if (confirm("정말로 " + postId + "번 게시물을 삭제하시겠습니까?")) {
        console.log("Deleting Post ID: " + postId);
        alert(postId + "번 게시물이 삭제되었습니다. (로직 미구현)");
        goToList();
    }
}
