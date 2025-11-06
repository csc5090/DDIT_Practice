// page-post.js

const PostPage = {
	currentList: [],
    
    // admin-main.js에서 호출됨
	init: function() {
		this.addEventHandlers();
	},

    // admin-core.js에서 호출됨
	Start: function() {
		this.loadAndRender();
	},

    addEventHandlers: function() {
        const postPage = document.getElementById('post-management');
        if (!postPage) return;

        // 목록 테이블 이벤트 (삭제 버튼 클릭 감지)
        postPage.addEventListener('click', this.handleListClick.bind(this));
    },
    
    // 목록 테이블 클릭 핸들러 (삭제 버튼 감지)
    handleListClick: function(e) {
        const deleteButton = e.target.closest('[data-action="delete"]');
        if (deleteButton) {
            e.preventDefault();
            const boardNo = deleteButton.dataset.id;
            this.handleDelete(boardNo);
        }
    },
    
    // --- API 호출 함수들 ---

	loadAndRender: async function() {
		try {
            // [API 호출] /getAdminPostList.do (TYPE_NO=3 목록)
			this.currentList = await apiClient.post('/getAdminPostList.do', null); 
			this.renderList();
		} catch (error) {
			console.error("게시물 목록 로딩 실패:", error);
			const tableBody = document.querySelector('#post-management-list tbody');
			if (tableBody) tableBody.innerHTML = `<tr><td colspan="5" style="text-align:center; padding: 40px;">게시물 목록을 불러오는 데 실패했습니다.</td></tr>`;
		}
	},

	renderList: function() {
        // [JSP 연동] layout.jsp에 만들 테이블 ID
		const tableBody = document.querySelector('#post-management-list tbody');
		if (!tableBody) return;

		let listToRender = this.currentList;

		tableBody.innerHTML = '';
		if (!listToRender || listToRender.length === 0) {
			tableBody.innerHTML = `<tr><td colspan="5" style="text-align:center; padding: 40px;">등록된 게시물이 없습니다.</td></tr>`;
			return;
		}
        
        // layout.jsp의 ADMIN_DATA에서 닉네임(등급) 추출
        const adminGrade = ADMIN_DATA?.nickname ? parseInt(ADMIN_DATA.nickname) : 0; 
        
		listToRender.forEach(post => {
			const row = document.createElement('tr');
			row.className = 'post-list-item';
			row.dataset.postNo = post.board_no;

            // 권한 검사 (1~4등급 모두 허용)
            const canDelete = adminGrade >= 1 && adminGrade <= 4; 
            const deleteButtonHTML = canDelete ? `<button class="action-btn danger" data-action="delete" data-id="${post.board_no}">삭제</button>` : `<span class="text-muted">권한없음</span>`;
            
			// DTO 필드를 사용해 테이블 행 구성
            // (board.jsp의 '번호, 제목, 작성자, 작성일' 컬럼 참고)
			row.innerHTML = `
	                <td>${post.board_no}</td>
	                <td>${post.board_title ?? '[제목 없음]'}</td>
	                <td>${post.mem_no}</td> <%-- DTO에 mem_no만 있으므로 일단 표시 --%>
	                <td>${post.created_date}</td>
	                <td>${deleteButtonHTML}</td>
	            `;
			tableBody.appendChild(row);
		});
	},
    
    // 게시물 삭제 (D) 핸들러
    handleDelete: function(boardNo) {
        Swal.fire({
            title: '게시물을 삭제하시겠습니까?',
            text: "게시물 삭제는 DB에서 영구 삭제됩니다.",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#d33',
            confirmButtonText: '영구 삭제',
            cancelButtonText: '취소'
        }).then((result) => {
            if (result.isConfirmed) {
                this.deletePost(boardNo);
            }
        });
    },
    
    // [API 호출] /adminPostDelete.do
    deletePost: async function(boardNo) {
        try {
            const data = { board_no: boardNo }; // 삭제할 게시물 번호
            await apiClient.post('/adminPostDelete.do', data);
            
            Swal.fire('삭제 완료!', '게시물이 완전히 삭제되었습니다.', 'success');
            this.loadAndRender(); // 목록 새로고침
        } catch (error) {
             console.error("게시물 삭제 실패:", error);
        }
    }
};