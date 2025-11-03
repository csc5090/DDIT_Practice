
document.addEventListener('DOMContentLoaded', () => {
    // 페이지 로드 후 초기화 작업 (필요한 경우)
    console.log("Neon Board Script Loaded!");
});

/**
 * 글쓰기 페이지로 이동합니다.
 */
function goToWritePage() {
    // 실제로는 'boardWrite.jsp' 등으로 이동합니다.
    console.log("Moving to Write Page...");
    // window.location.href = 'boardWrite.jsp'; 
    alert("글쓰기 페이지로 이동합니다.");
}

/**
 * 특정 게시물 상세 보기 페이지로 이동합니다.
 * @param {number} postId - 게시물 ID
 */
function viewPost(postId) {
    // 실제로는 'boardDetail.jsp?id=' + postId 등으로 이동합니다.
    console.log("Viewing Post ID: " + postId);
    // window.location.href = 'boardDetail.jsp?id=' + postId; 
    alert(postId + "번 게시물 상세 페이지로 이동합니다.");
}

/**
 * 특정 페이지로 이동합니다.
 * @param {number} pageNum - 페이지 번호
 */
function goToPage(pageNum) {
    // 실제로는 목록을 다시 로드하는 로직 (예: AJAX 호출 또는 window.location.href 변경)
    console.log("Moving to Page: " + pageNum);
    // window.location.href = 'boardList.jsp?page=' + pageNum; 
    alert(pageNum + "페이지로 이동합니다.");
}
