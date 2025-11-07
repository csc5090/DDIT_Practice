package com.our_middle_project.dao;

import java.util.List;

import com.our_middle_project.dto.AdminBoardDTO;
import com.our_middle_project.dto.AdminCommentDTO;

public interface AdminBoardDAO {

	// 공지사항
	List<AdminBoardDTO> getAdminBoardList();

	int insertNotice(AdminBoardDTO dto);

	int updateNotice(AdminBoardDTO dto);

	int deleteNotice(int board_no);

	// 게시물
	List<AdminBoardDTO> getAdminPostList(String keyword);

	int deletePost(int board_no);

	int updatePost(AdminBoardDTO dto);

	// 댓글, 사진 등
	List<AdminCommentDTO> getPostComments(int board_no);

	int deleteComment(int reply_no);
	int deleteBoardImage(int boardNo);
	int deleteBoardStars(int boardNo);
	int deleteBoardReplies(int boardNo);
	int restorePost(int board_no);
    int hardDeletePost(int board_no);
}