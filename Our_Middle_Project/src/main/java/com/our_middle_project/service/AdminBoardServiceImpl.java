package com.our_middle_project.service;

import java.util.Collections;
import java.util.List;

import com.our_middle_project.dao.AdminBoardDAO;
import com.our_middle_project.dao.AdminBoardDAOImpl;
import com.our_middle_project.dto.AdminBoardDTO;
import com.our_middle_project.dto.AdminCommentDTO; // [추가]
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
	public List<AdminBoardDTO> getAdminPostList() {
		try {
			List<AdminBoardDTO> postList = adminBoardDAO.getAdminPostList();
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

	// 댓글 관리

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
		return adminBoardDAO.hardDeletePost(board_no) > 0;
	}

}