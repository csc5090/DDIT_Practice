package com.our_middle_project.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.our_middle_project.dao.AdminReviewDAO;
import com.our_middle_project.dao.AdminReviewDAOImpl;
import com.our_middle_project.dao.MemberDAO;
import com.our_middle_project.dao.MemberDAOImpl;
import com.our_middle_project.dto.AdminBoardImageDTO;
import com.our_middle_project.dto.AdminReviewDTO;
import com.our_middle_project.dto.MemberDTO;
import com.our_middle_project.serviceInterface.AdminService;

public class AdminServiceImpl implements AdminService {

	private MemberDAO memberDAO = new MemberDAOImpl();
	private AdminReviewDAO reviewDAO = new AdminReviewDAOImpl();

	@Override
	public int getTotalUserCount() {
		return memberDAO.getTotalUserCount();
	}

	@Override
	public int getNewUserCountToday() {
		return memberDAO.getNewUserCountToday();
	}

	@Override
	public List<MemberDTO> getUsersByKeyword(String keyword) {
		return memberDAO.selectUsersByKeyword(keyword);
	}

	@Override
	public List<Map<String, Object>> getDailySignupStats() {
		return memberDAO.selectDailySignupStats();
	}

	@Override
	public MemberDTO getUserDetails(String memberId) {
		return memberDAO.selectUserDetails(memberId);
	}

	@Override
	public boolean updateUser(MemberDTO memberDTO) {
		if ("USER".equals(memberDTO.getRole())) {
			memberDTO.setRole(null);
		}
		int result = memberDAO.updateUser(memberDTO);
		return result > 0;
	}

	// --- 리뷰 관리 ---

	@Override
	public List<AdminReviewDTO> getReviewList(String keyword) {
		return reviewDAO.selectAllReviews(keyword);
	}

	@Override
	public boolean updateAdminReply(int boardNo, int adminMemNo, String replyContent) {
		Map<String, Object> params = new HashMap<>();
		params.put("boardNo", boardNo);
		params.put("adminMemNo", adminMemNo);
		params.put("replyContent", replyContent);

		return reviewDAO.upsertAdminReply(params) > 0;
	}

	@Override
	public boolean deleteReviewImage(int boardNo) {
		// ▼▼▼ [수정] 이 메소드는 오직 '이미지 삭제'만 수행해야 합니다. ▼▼▼
		return reviewDAO.deleteReviewImage(boardNo) > 0;
	}

	@Override
	public boolean deleteReview(int boardNo) {
		try {
			// ▼▼▼ [수정] '리뷰 삭제'가 모든 자식 레코드를 삭제해야 합니다. ▼▼▼

			// 1. 별점 삭제 (FK_STAR_BOARD 해결)
			reviewDAO.deleteReviewStars(boardNo);

			// 2. 댓글 삭제 (FK_REPLY_BOARD 해결)
			reviewDAO.deleteReviewReplies(boardNo);

			// 3. 이미지 삭제 (FK_IMAGE_BOARD 해결)
			reviewDAO.deleteReviewImage(boardNo);

			// 4. 리뷰(부모) 삭제
			int result = reviewDAO.deleteReview(boardNo);

			return result > 0;
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
	}

	@Override
	public List<AdminBoardImageDTO> getReviewImages(int boardNo) {
		return reviewDAO.selectReviewImages(boardNo);
	}
}