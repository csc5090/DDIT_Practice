/**
 * =======================================================
 * JavaScript: board_cont.js
 * (게시물 상세 페이지 전용 로직)
 * =======================================================
 * 포함 함수: goToList, goToEditPage, deletePost
 */

document.addEventListener('DOMContentLoaded', () => {
    console.log("Board Detail Script Loaded!");
});

/**
 * 목록 페이지로 이동합니다. ('목록으로' 버튼)
 */
function goToList() {
    console.log("Moving back to List Page...");
    window.location.href = "board.do";
}

/**
 * 게시물 수정 페이지로 이동합니다. ('수정' 버튼)
 * @param {number} postId - 게시물 ID
 */
function goToEditPage(postId) {
    console.log("Moving to Edit Page for Post ID: " + postId);
    window.location.href = "boardEdit.do";
}

/**
 * 게시물을 삭제합니다. ('삭제' 버튼)
 * @param {number} postId - 게시물 ID
 */
function deletePost(postId) {
    Swal.fire({
        title: '정말 삭제하시겠습니까?',
        text: "삭제된 게시물은 복구할 수 없습니다.",
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#ff66a9',
        cancelButtonColor: '#888',
        confirmButtonText: '삭제',
        cancelButtonText: '취소'
    }).then((result) => {
        if (result.isConfirmed) {
            console.log(`Deleting Post ID: ${postId}`);
            
            // TODO: 서버측 삭제 요청
            
            Swal.fire('삭제 완료', '게시물이 성공적으로 삭제되었습니다.', 'success').then(() => {
                goToList();
            });
        }
    });
}
