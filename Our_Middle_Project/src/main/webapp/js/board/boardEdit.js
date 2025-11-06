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
	                    color: #ff66a9;
	                    text-shadow: 0 0 5px #ff66a9, 0 0 10px #ff66a9, 0 0 20px #ff66a9;">
	                    &#10003; <!-- 체크 표시 -->
	               </div>
	               <p>게시물이 반영되었습니다.</p>`,
	        showConfirmButton: true,
	        confirmButtonText: "확인",
	        color: "#ff66a9",
	        background: "rgba(12,0,28,0.8) url('../../images/logins/loginBack.png') no-repeat center center",
	        didOpen: (popup) => {
	            popup.style.backgroundSize = "cover";
	            popup.style.border = "2px solid #ff66a9";
	            popup.style.borderRadius = "15px";
	            popup.style.boxShadow = "0 0 10px #ff66a9, 0 0 20px #ff66a9, 0 0 40px #ff66a9";
	            popup.style.backdropFilter = "blur(5px)";

	            const button = popup.querySelector('.swal2-confirm');
	            if(button){
	                button.style.backgroundColor = "#ff66a9";
	                button.style.color = "#0c001c";
	                button.style.textShadow = "0 0 5px #fff";
	                button.style.boxShadow = "0 0 10px #ff66a9, 0 0 20px #ff66a9";
	                button.style.border = "none";
	                button.style.fontWeight = "bold";
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
function goBack() {
    window.history.back();
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

