package com.our_middle_project.service;

import java.util.Collections;
import java.util.List;

import com.our_middle_project.dao.AdminBoardDAO;
import com.our_middle_project.dao.AdminBoardDAOImpl;
import com.our_middle_project.dto.AdminBoardDTO;
import com.our_middle_project.dto.AdminCommentDTO;
import com.our_middle_project.serviceInterface.AdminBoardService;

public class AdminBoardServiceImpl implements AdminBoardService {

	private AdminBoardDAO adminBoardDAO = new AdminBoardDAOImpl();

	@Override
	public List<AdminBoardDTO> getAdminBoardList() {
		try {
			List<AdminBoardDTO> noticeList = adminBoardDAO.getAdminBoardList();
			return noticeList != null ? noticeList : Collections.emptyList();
		} catch (Exception e) {
			e.printStackTrace();
			return Collections.emptyList();
		}
	}

	@Override
	public boolean insertNotice(AdminBoardDTO dto, int adminMemNo) {
		dto.setMem_no(adminMemNo);
		return adminBoardDAO.insertNotice(dto) > 0;
	}

	@Override
	public boolean updateNotice(AdminBoardDTO dto) {
		return adminBoardDAO.updateNotice(dto) > 0;
	}

	@Override
	public boolean deleteNotice(int board_no) {
		return adminBoardDAO.deleteNotice(board_no) > 0;
	}

	@Override
	public boolean canCreateNotice(String nickname) {
		try {
			int grade = Integer.parseInt(nickname);
			return grade >= 1 && grade <= 3;
		} catch (NumberFormatException e) {
			return false;
		}
	}

	@Override
	public boolean canEditDeleteNotice(String nickname) {
		try {
			int grade = Integer.parseInt(nickname);
			return grade >= 1 && grade <= 4;
		} catch (NumberFormatException e) {
			return false;
		}
	}

	// --- 게시물 관리 ---

	@Override
	public List<AdminBoardDTO> getAdminPostList(String keyword) {
		try {
			List<AdminBoardDTO> postList = adminBoardDAO.getAdminPostList(keyword);
			return postList != null ? postList : Collections.emptyList();
		} catch (Exception e) {
			e.printStackTrace();
			return Collections.emptyList();
		}
	}

	@Override
	public boolean deletePost(int board_no) {
		return adminBoardDAO.deletePost(board_no) > 0;
	}

	@Override
	public boolean updatePost(AdminBoardDTO dto) {
		return adminBoardDAO.updatePost(dto) > 0;
	}

	// --- 댓글 관리 ---

	@Override
	public List<AdminCommentDTO> getPostComments(int board_no) {
		try {
			List<AdminCommentDTO> commentList = adminBoardDAO.getPostComments(board_no);
			return commentList != null ? commentList : Collections.emptyList();
		} catch (Exception e) {
			e.printStackTrace();
			return Collections.emptyList();
		}
	}

	@Override
	public boolean deleteComment(int reply_no) {
		return adminBoardDAO.deleteComment(reply_no) > 0;
	}

	@Override
	public boolean restorePost(int board_no) {
		return adminBoardDAO.restorePost(board_no) > 0;
	}

	@Override
	public boolean hardDeletePost(int board_no) {
		try {
			// 1. 이미지 삭제
			adminBoardDAO.deleteBoardImage(board_no);
			// 2. 별점 삭제
			adminBoardDAO.deleteBoardStars(board_no);
			// 3. 댓글 삭제
			adminBoardDAO.deleteBoardReplies(board_no);
			// 4. 좋아요 삭제
			adminBoardDAO.deleteBoardLikes(board_no);
			// 5. 싫어요 삭제 
			adminBoardDAO.deleteBoardDislikes(board_no);

			// 6. 게시물 원본(부모) 완전 삭제
			int result = adminBoardDAO.hardDeletePost(board_no);

			return result > 0;

		} catch (Exception e) {
			e.printStackTrace();
			System.err.println("AdminBoardServiceImpl hardDeletePost() 문제 발생: " + e.getMessage());
			return false;
		}
	}
}