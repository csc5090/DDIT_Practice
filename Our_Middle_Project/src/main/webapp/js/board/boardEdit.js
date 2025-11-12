/**
 * =======================================================
 * JavaScript: board_form.js
 * (게시물 작성, 수정, 답글 폼 전용 로직)
 * =======================================================
 * 포함 함수: goBack, validateWrite, validateEdit, validateReply
 */

document.addEventListener('DOMContentLoaded', () => {
    console.log("Board Form Script Loaded!");
	
	document.getElementById("editForm").addEventListener("submit", function(e){
	    e.preventDefault();

		Swal.fire({
		    title: "수정 완료",
		    html: `<div style="
		                font-size: 50px;
		                color: #001f3f;
		                text-shadow: none;">
		                &#10003;
		           </div>
		           <p style="color:#000;">게시물이 반영되었습니다.</p>`,
		    showConfirmButton: true,
		    confirmButtonText: "확인",
		    color: "#000000", // 텍스트 색
		    background: "#ffffff", // alert 내부 박스 배경색 (흰색)
		    didOpen: (popup) => {
		        // SweetAlert2 팝업 전체 스타일
		        popup.style.backgroundColor = "#ffffff"; // 흰색 박스
		        popup.style.border = "2px solid #001f3f"; // 남색 테두리
		        popup.style.borderRadius = "12px";
		        popup.style.boxShadow = "0 0 20px #001f3f, 0 0 40px #001f3f";
		        popup.style.backdropFilter = "none";

		        // SweetAlert2 배경 (모달 바깥 영역)
		        const swalContainer = document.querySelector('.swal2-container');
		        if (swalContainer) swalContainer.style.backgroundColor = "rgba(0,0,0,0.9)"; // 검정 배경

		        // 확인 버튼 스타일
		        const button = popup.querySelector('.swal2-confirm');
		        if (button) {
		            button.style.backgroundColor = "#001f3f"; // 남색 버튼
		            button.style.color = "#ffffff";           // 흰색 글씨
		            button.style.border = "none";
		            button.style.borderRadius = "6px";
		            button.style.padding = "8px 18px";
		            button.style.fontWeight = "600";
		            button.style.boxShadow = "0 0 12px #001f3f";
		        }
		    }
		}).then(() => {
		    this.submit();
		});
	});


});

/**
 * 이전 페이지로 돌아갑니다. (취소 버튼)
 */
function gogoBack() {
    const boardNo = document.querySelector('input[name="boardNo"]').value;
    window.location.href = `boardCont.do?boardNo=${boardNo}&state=cont`;
}

/**
 * 새 글 등록 전 유효성 검사를 수행합니다. (boardWrite.jsp에서 사용)
 * @returns {boolean} 폼 전송 허용 여부
 */
function validateWrite() {
    const title = document.getElementById('title').value.trim();
    const writer = document.getElementById('writer').value.trim();
    const content = document.getElementById('content').value.trim();
// 백업
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

/**
 * 답글 등록 전 유효성 검사를 수행합니다. (boardReply.jsp에서 사용)
 * @returns {boolean} 폼 전송 허용 여부
 */
function validateReply() {
    // 답글은 기본적으로 글쓰기와 동일한 유효성 검사를 사용합니다.
    return validateWrite();
}

