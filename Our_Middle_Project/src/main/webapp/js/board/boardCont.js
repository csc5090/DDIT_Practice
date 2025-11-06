/**
 * =======================================================
 * JavaScript: board_cont.js
 * (게시물 상세 페이지 전용 로직)
 * =======================================================
 * 포함 함수: goToList, goToEditPage, deletePost
 */

document.addEventListener('DOMContentLoaded', () => {

	writerCheck()
	
});

// 목록 페이지 이동
function goToList() {
    window.location.href = "board.do";
}


 //게시물 수정 페이지로 이동합니다. ('수정' 버튼)

 function goToEditPage(boardNo) {
     window.location.href = "boardEdit.do?boardNo=" + boardNo + "&state=form";
 }

 
 /**
  * =======================================================
  * JavaScript: board_cont.js
  * (게시물 상세 페이지 전용 로직)
  * =======================================================
  * 포함 함수: goToList, goToEditPage, deletePost
  */

 document.addEventListener('DOMContentLoaded', () => {

 	writerCheck()
 	
 });

 // 목록 페이지 이동
 function goToList() {
     window.location.href = "board.do";
 }


  //게시물 수정 페이지로 이동합니다. ('수정' 버튼)

  function goToEditPage(boardNo) {
      window.location.href = "boardEdit.do?boardNo=" + boardNo + "&state=form";
  }

  
 //게시물을 삭제합니다. ('삭제' 버튼)

async function deletePost(e, obj, postId) {
	e.preventDefault();

	let text = "삭제 하시겠습니까? <br> 삭제된 내용은 복구되지 않습니다."
	let deleteCheck = await yesOrNoAlert("question", text, "삭제", "취소");
	console.log(deleteCheck)
	if (deleteCheck) {
//		document.egetElementById("boardTarget").setAtrribute("value")
		console.log(`Deleting Post ID: ${postId}`);
		setTimeout(() => {
			
			obj.submit();
			
		}, 1000)
	}
}
 		 

/*axios.post('<%=request.getContextPath()%>/boardDel.do', { boardNo: postId })
		.then(res => {
			if (res.data.result === "OK") {
				Swal.fire('삭제 완료', '게시물이 성공적으로 삭제되었습니다.', 'success')
				.then(() => {
					window.location.href = '<%=request.getContextPath()%>/board.do';
				});
			}
		});*/

 	    // Controller 호출
 		
 	   /* fetch(`${contextPath}/board/delete?boardNo=${postId}`, {
 	        method: 'POST' 
 		 })
 	    .then(res => res.json())
 	    .then(data => {
 	        if(data.result === "OK") {
 	            Swal.fire('삭제 완료', '게시물이 성공적으로 삭제되었습니다.', 'success')
 	                .then(() => goToList());
 					console.log(성공);
 	        } else {
 	            Swal.fire('삭제 실패', '게시물 삭제에 실패했습니다.', 'error');
 				console.log(실패);
 	        }
 	    })
 	    .catch(err => {
 	        console.error(err);
 	        Swal.fire('삭제 실패', '서버 요청 중 오류가 발생했습니다.', 'error');
 	    });*/


function writerCheck() {
	console.log(userDataCase)
	let userDataID = userDataCase.mem_id
	console.log(userDataID)

	let choiceBoard = document.getElementById("writerUser");
	let writerID = choiceBoard.getAttribute("data-writer")

	if (userDataID === writerID) {
		console.log("작성자임")
		let editBtns = document.getElementsByClassName("edit-btns");
		for (let i = 0 ; i<editBtns.length ; i++) {
			editBtns[i].style.display = "block";
		}
	}
	else {
		console.log("작성자가 아닙니다.")
	}

}
