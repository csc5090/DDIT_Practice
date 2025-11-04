document.addEventListener('DOMContentLoaded', () => {
	
});

// 글쓰기 페이지
function goToWritePage() {
    window.location.href = "boardWrite.do"; 
}


 // 특정 게시물 상세 보기 페이지
 //@param {number} postId - 게시물 ID
function viewPost(postId) {
   window.location.href = "boardCont.do?board_no=" + postId;
}


// 특정 페이지
// @param {number} pageNum - 페이지 번호
 function goToPage(pageNum) {
    window.location.href = "board.do?page=" + pageNum;

}

//검색
function searchPosts() {
    const query = document.getElementById('searchInput').value;

    if (query.trim() === "") {
        alert("검색어를 입력해주세요!");
        return;
    }

    console.log("Searching for: " + query);
    
    // 실제 검색 로직 (서버로 검색어를 전송)
    // 예: window.location.href = 'boardList.jsp?search=' + encodeURIComponent(query);
    
    alert(`'${query}'(으)로 게시물을 검색합니다.`);
}