package com.our_middle_project.serviceInterface;

import java.util.List;

import com.our_middle_project.dto.AdminBoardDTO;
import com.our_middle_project.dto.AdminCommentDTO;

public interface AdminBoardService {

    // 공지사항
    List<AdminBoardDTO> getAdminBoardList();
    boolean insertNotice(AdminBoardDTO dto, int adminMemNo);
    boolean updateNotice(AdminBoardDTO dto);
    boolean deleteNotice(int board_no);
    boolean canCreateNotice(String nickname);
    boolean canEditDeleteNotice(String nickname);

    // 게시물
    List<AdminBoardDTO> getAdminPostList(String keyword);
    boolean deletePost(int board_no);
    boolean updatePost(AdminBoardDTO dto); 
    
    // 댓글
    List<AdminCommentDTO> getPostComments(int board_no);
    boolean deleteComment(int reply_no);
    
    // 게시물 복원/완전삭제
    boolean restorePost(int board_no);
    boolean hardDeletePost(int board_no);
    
    //리뷰 관리 API 메소드 3개
    public boolean updateAdminReply(int boardNo, int adminMemNo, String replyContent);
    public boolean deleteReviewImage(int boardNo);
    public boolean deleteReview(int boardNo);
}