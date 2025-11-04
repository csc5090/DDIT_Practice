
window.onload = async () => {
	
	const boardDBList = await boardListCallDB();
	boardListMake(boardDBList)
	
}

function boardListMake(Lists) {
	console.log(Lists);
	
	let newElement = ``;
	for(let i=0 ; i<Lists.length ; i++) {
		
		newElement += `
			<tr class="board-row" data-board-no="${ Lists[i].boardNo }">
	            <td>${ Lists[i].boardNo }</td>
	            <td class="post-title">${ Lists[i].boardTitle }</td>
	            <td>${ Lists[i].memId }</td>
	            <td>${ Lists[i].createdDate }</td>
	            <td>${ Lists[i].viewCount }</td>
	        </tr>
		`;
		
	} 
	
	console.log(document.getElementsByClassName('board-row'))
	let boardTableBody = document.getElementById('boardTableBody');
	boardTableBody.innerHTML = newElement;
	
	
	let newBoardRow = document.getElementsByClassName('board-row')
	for(let i=0 ; i<newBoardRow.length ; i++) {
		newBoardRow[i].addEventListener('click', (e) =>		{
				let boardNo = e.currentTarget.dataset.boardNo;
				viewPost(boardNo);
			})
		}
	}
	
async function boardListCallDB() {
	let result;
	
	await axios({
		baseURL: BASE_URL,
		url: 'boardFree.do',
		method: 'post',
		headers: {
			"Content-Type": "application/json; charset=UTF-8"
		},
		responseType: 'json'
	})
	.then(function (response) {
		console.log(response)
		result = response.data
	})
	.catch(function (err) {
    	console.error(err);	// errror
	});
	
	return result;
}


/**
 * 특정 게시물 상세 보기 페이지로 이동합니다.
 * @param {number} boardNo - 클릭한 게시물의 고유 번호
 */
function viewPost(boardNo) {
    if(!boardNo){
        Swal.fire({ icon: 'error', title: '오류', text: '게시물 정보를 찾을 수 없습니다.', confirmButtonText: '확인' });
        return;
    }
    window.location.href = `boardCont.do?boardNo=${boardNo}&state=cont`;
}


// 글쓰기 페이지로 이동합니다. ('글쓰기' 버튼)
function goToWritePage() {
	window.location.href = "boardWrite.do";

}

 // 페이징 이동 함수 (페이지 번호 클릭)
 function goToPage(pageNum) {
     window.location.href = "board.do?page=" + pageNum;
 }

// 목록 페이지로 이동합니다. ('전체목록' 버튼)
function goToList() {
	window.location.href = "board.do";
}

 // 게시물 검색 기능을 수행합니다. ('검색' 버튼)
function searchPosts() {
	const query = document.getElementById('searchInput').value;
	const searchType = document.getElementById('searchType').value; // 검색 유형이 있다면 사용

	if (query.trim() === "") {
		Swal.fire({ icon: 'warning', title: '검색', text: '검색어를 입력해주세요!', confirmButtonText: '확인' });
		return;
	}

	console.log("Searching for: " + query);
	window.location.href = `/board.do?searchType=${searchType}&searchKeyword=${encodeURIComponent(query)}`;
	//window.location.href = "/board.do?searchType=" + searchType + "&searchKeyword=" + encodeURIComponent(query);
}

//홈 버튼
document.getElementById("homeBtn").addEventListener("click", () => {
    window.location.href = "gameHome.do";  
});

