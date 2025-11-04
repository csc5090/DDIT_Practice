
// 게시물 상세 페이지 전용 JavaScript

document.addEventListener('DOMContentLoaded', () => {

});


// 게시물 수정
// @param {number} postId - 게시물 ID
function goToEditPage(postId) {
     window.location.href = "boardEdit.do"
}


 // 게시물 삭제
 // @param {number} postId - 게시물 ID
function deletePost(postId) {
    if (confirm("정말로 " + postId + "번 게시물을 삭제하시겠습니까?")) {

        goToList(); // 삭제 후 목록 페이지로 이동
    }
}


// 목록 페이지로 이동

function goToList() {

    window.location.href = 'board.do';

}