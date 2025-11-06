package com.our_middle_project.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.our_middle_project.dao.AdminReviewDAO;
import com.our_middle_project.dao.AdminReviewDAOImpl;
import com.our_middle_project.dao.MemberDAO;
import com.our_middle_project.dao.MemberDAOImpl;
import com.our_middle_project.dto.AdminReviewDTO;
import com.our_middle_project.dto.MemberDTO;
import com.our_middle_project.serviceInterface.AdminService;

public class AdminServiceImpl implements AdminService {

	// [수정] DAO가 MybatisUtil을 사용하도록 new()로 생성
	private MemberDAO memberDAO = new MemberDAOImpl();
	private AdminReviewDAO reviewDAO = new AdminReviewDAOImpl();

	@Override
	public int getTotalUserCount() {
		// [수정] try-with-resources 제거
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

	// ▼▼▼ [추가] 3개 메소드 구현 ▼▼▼

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
		return reviewDAO.deleteReviewImage(boardNo) > 0;
	}

	@Override
	public boolean deleteReview(int boardNo) {
		// (소프트 삭제 99)
		return reviewDAO.deleteReview(boardNo) > 0;
	}
}