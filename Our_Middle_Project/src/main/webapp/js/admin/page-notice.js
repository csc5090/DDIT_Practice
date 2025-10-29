// page-notice.js

const NoticePage = {
    init: function() {
        const noticePage = document.getElementById('notice-management');
        if (noticePage) {
            noticePage.addEventListener('click', this.handleClick.bind(this));
        }
    },

    handleClick: function(e) {
        const noticeListView = document.getElementById('notice-list-view');
        const noticeEditorView = document.getElementById('notice-editor-view');

        // '새 글 작성' 버튼을 클릭했는지 확인
        if (e.target.closest('#btn-new-notice')) {
            noticeListView.style.display = 'none';
            noticeEditorView.style.display = 'flex';
        }

        // '목록으로' 버튼을 클릭했는지 확인
        if (e.target.closest('#btn-back-to-list')) {
            noticeEditorView.style.display = 'none';
            noticeListView.style.display = 'flex';
        }
    }
};