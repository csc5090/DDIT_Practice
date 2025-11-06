// page-notice.js

const Notice = {
	currentList: [],
	selectedNoticeNo: null, // 선택된 공지사항 번호
	isEditing: false, // 현재 수정 모드인지 확인
    
    // admin-core.js에서 호출됨
	init: function() {
		this.addEventHandlers();
	},

	Start: function() {
        this.clearEditorView();
		this.loadAndRender();
	},

    addEventHandlers: function() {
        const noticePage = document.getElementById('notice-management');
        if (!noticePage) return;

        // 1. 새 글 작성 버튼 이벤트
        const newNoticeBtn = document.getElementById('btn-new-notice');
        if (newNoticeBtn) {
            newNoticeBtn.addEventListener('click', this.openEditorForNew.bind(this));
        }

        // 2. 목록으로 돌아가기 버튼 이벤트
        const backToListBtn = document.getElementById('btn-back-to-list');
        if (backToListBtn) {
            backToListBtn.addEventListener('click', this.closeEditorView.bind(this));
        }
        
        // 3. 저장/수정 버튼 이벤트
        const saveNoticeBtn = document.getElementById('btn-save-notice');
        if (saveNoticeBtn) {
            saveNoticeBtn.addEventListener('click', this.handleSaveOrUpdate.bind(this));
        }
        
        // ▼▼▼ [추가] 4. 삭제 버튼 이벤트 ▼▼▼
        const deleteNoticeBtn = document.getElementById('btn-delete-notice');
        if (deleteNoticeBtn) {
            deleteNoticeBtn.addEventListener('click', this.handleDelete.bind(this));
        }

        // 5. 목록 테이블 이벤트 (수정 버튼 클릭)
        noticePage.addEventListener('click', this.handleListClick.bind(this));
    },
    
    // 목록 테이블 클릭 핸들러 (수정 버튼 감지)
    handleListClick: function(e) {
        const editButton = e.target.closest('[data-action="edit"]');
        if (editButton) {
            e.preventDefault();
            const boardNo = editButton.dataset.id;
            this.openEditorForEdit(boardNo);
        }
    },
    
    // 새 글 작성 버튼 클릭 시 편집기 열기
    openEditorForNew: function() {
        this.isEditing = false;
        this.selectedNoticeNo = null;
        this.clearEditorInputs();
        document.getElementById('notice-editor-view').querySelector('h1').textContent = '새 공지사항 작성';
        
        // ▼▼▼ [수정] 새 글 작성 모드: 삭제 버튼 숨김, 저장 버튼 텍스트 변경
        document.getElementById('btn-delete-notice').style.display = 'none';
        document.getElementById('btn-save-notice').textContent = '저장하기';
        
        this.toggleView('editor');
    },

    // 수정 버튼 클릭 시 편집기 열기
    openEditorForEdit: function(boardNo) {
        this.isEditing = true;
        this.selectedNoticeNo = boardNo;
        
        const notice = this.currentList.find(n => n.board_no == boardNo);
        if (notice) {
            document.getElementById('notice-title').value = notice.board_title || '';
            document.getElementById('notice-content').value = notice.board_content || '';
            
            // ▼▼▼ [수정] 수정 모드: 삭제 버튼 표시, 저장 버튼 텍스트 변경
            document.getElementById('btn-delete-notice').style.display = 'block';
            document.getElementById('btn-save-notice').textContent = '수정 완료';
            
            document.getElementById('notice-editor-view').querySelector('h1').textContent = `공지사항 수정 (No.${boardNo})`;
            this.toggleView('editor');
        } else {
             Swal.fire('오류', '해당 공지사항 정보를 찾을 수 없습니다.', 'error');
        }
    },
    
    // 뷰 전환 (목록 <=> 편집기)
    toggleView: function(target) {
        document.getElementById('notice-list-view').style.display = (target === 'list' ? 'block' : 'none');
        document.getElementById('notice-editor-view').style.display = (target === 'editor' ? 'block' : 'none');
    },

    closeEditorView: function() {
        this.toggleView('list');
        this.clearEditorView();
    },
    
    clearEditorView: function() {
        this.clearEditorInputs();
        document.getElementById('btn-save-notice').textContent = '저장하기';
        document.getElementById('btn-delete-notice').style.display = 'none'; // 목록으로 갈 때 삭제 버튼 숨김
        this.toggleView('list');
    },

    clearEditorInputs: function() {
        document.getElementById('notice-title').value = '';
        document.getElementById('notice-content').value = '';
    },
    
    // 저장 및 수정 로직 분기
    handleSaveOrUpdate: function() {
        const title = document.getElementById('notice-title').value;
        const content = document.getElementById('notice-content').value;
        
        if (title.trim() === '' || content.trim() === '') {
            Swal.fire('경고', '제목과 내용을 모두 입력해주세요.', 'warning');
            return;
        }

        const data = {
            board_no: this.selectedNoticeNo,
            board_title: title,
            board_content: content,
        };

        if (this.isEditing) {
            this.updateNotice(data); // 수정 API 호출
        } else {
            this.saveNotice(data); // 저장 API 호출
        }
    },
    
    // ▼▼▼ [추가] 삭제 버튼 클릭 핸들러 ▼▼▼
    handleDelete: function() {
        if (!this.selectedNoticeNo) return;

        Swal.fire({
            title: '정말 삭제하시겠습니까?',
            text: "삭제된 공지사항은 복구할 수 없으며, DB에서 완전히 삭제됩니다.",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#d33',
            confirmButtonText: '영구 삭제',
            cancelButtonText: '취소'
        }).then((result) => {
            if (result.isConfirmed) {
                this.deleteNotice(this.selectedNoticeNo);
            }
        });
    },
    
    // --- API 호출 함수들 ---

	loadAndRender: async function() {
		try {
			this.currentList = await apiClient.post('/getAdminNoticeList.do', null);
			this.renderList();
		} catch (error) {
			console.error("공지사항 목록 로딩 실패:", error);
			const tableBody = document.querySelector('#notice-list-view tbody');
			if (tableBody) tableBody.innerHTML = `<tr><td colspan="4" style="text-align:center; padding: 40px;">공지사항 목록을 불러오는 데 실패했습니다.</td></tr>`;
		}
	},

	renderList: function() {
		const tableBody = document.querySelector('#notice-list-view tbody');
		if (!tableBody) return;

		let listToRender = this.currentList;

		tableBody.innerHTML = '';
		if (!listToRender || listToRender.length === 0) {
			tableBody.innerHTML = `<tr><td colspan="4" style="text-align:center; padding: 40px;">등록된 공지사항이 없습니다.</td></tr>`;
			return;
		}
        
        const adminGrade = ADMIN_DATA?.nickname ? parseInt(ADMIN_DATA.nickname) : 0;
        
		listToRender.forEach(notice => {
			const row = document.createElement('tr');
			row.className = 'notice-list-item';
			row.dataset.noticeNo = notice.board_no;

            // 수정/삭제 권한 검사 (1~4등급 모두 허용)
            // (권한 로직은 Service에 구현되어 있지만, 여기서는 버튼 표시 여부만 결정)
            const canEdit = adminGrade >= 1 && adminGrade <= 4; 
            const editButtonHTML = canEdit ? `<button class="action-btn" data-action="edit" data-id="${notice.board_no}">수정/삭제</button>` : `<span class="text-muted">권한없음</span>`;
            
			// DTO 필드를 사용해 테이블 행 구성
			row.innerHTML = `
	                <td>${notice.board_title ?? '[제목 없음]'}</td>
	                <td>운영팀</td> 
	                <td>${notice.created_date}</td>
	                <td>${editButtonHTML}</td>
	            `;
			tableBody.appendChild(row);
		});
	},
    
    // 공지사항 작성 (C)
    saveNotice: async function(data) {
        try {
            await apiClient.post('/adminNoticeWrite.do', data);
            Swal.fire('성공', '공지사항이 등록되었습니다.', 'success');
            this.clearEditorView();
            this.loadAndRender();
        } catch (error) {
            // AdminAjaxController에서 권한 에러(403) 등을 처리함
        }
    },
    
    // 공지사항 수정 (U)
    updateNotice: async function(data) {
        try {
            await apiClient.post('/adminNoticeUpdate.do', data);
            Swal.fire('성공', '공지사항이 수정되었습니다.', 'success');
            this.clearEditorView();
            this.loadAndRender();
        } catch (error) {
             // AdminAjaxController에서 권한 에러(403) 등을 처리함
        }
    },
    
    deleteNotice: async function(boardNo) {
        try {
            const data = { board_no: boardNo }; // 삭제할 게시물 번호를 담아 전송
            await apiClient.post('/adminNoticeDelete.do', data);
            
            Swal.fire('삭제 완료!', '공지사항이 완전히 삭제되었습니다.', 'success');
            this.clearEditorView(); // 삭제 후 목록으로 돌아가기
            this.loadAndRender(); // 목록 새로고침
        } catch (error) {
             // AdminAjaxController에서 권한 에러(403) 등을 처리함
             console.error("공지사항 삭제 실패:", error);
        }
    }
};