package com.our_middle_project.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.our_middle_project.dao.AdminBoardDAOImpl;
import com.our_middle_project.dao.AdminReviewDAO;
import com.our_middle_project.dao.AdminReviewDAOImpl;
import com.our_middle_project.dao.GameLogDAO;
import com.our_middle_project.dao.GameLogDAOImpl;
import com.our_middle_project.dao.MemberDAO;
import com.our_middle_project.dao.MemberDAOImpl;
import com.our_middle_project.dto.AdminBoardImageDTO;
import com.our_middle_project.dto.AdminReviewDTO;
import com.our_middle_project.dto.MemberDTO;
import com.our_middle_project.serviceInterface.AdminService;
import com.our_middle_project.util.ActiveUserListener;

public class AdminServiceImpl implements AdminService {

	private MemberDAO memberDAO = new MemberDAOImpl();
	private AdminReviewDAO reviewDAO = new AdminReviewDAOImpl();
	private GameLogDAO gameLogDAO = new GameLogDAOImpl();

	@Override
	public int getTotalUserCount() {
		return memberDAO.getTotalUserCount();
	}

	@Override
	public int getNewUserCountToday() {
		return memberDAO.getNewUserCountToday();
	}

	@Override
	public int getTotalGameCount() {
		return gameLogDAO.getTotalGameCount();
	}

	//  A차트: 실시간 접속자 수 반환
	@Override
	public int getActiveUserCount() {
		return ActiveUserListener.getActiveUserCount();
	}

	@Override
	public List<MemberDTO> getUsersByKeyword(String keyword) {
		return memberDAO.selectUsersByKeyword(keyword);
	}

	@Override
	public List<Map<String, Object>> getDailySignupStats() {
		return memberDAO.selectDailySignupStats();
	}

	//  A, B 차트용 데이터를 모두 조회
	@Override
	public Map<String, Object> getDashboardData() {
		Map<String, Object> dashboardData = new HashMap<>();

		// --- A차트 (Bar) 데이터 ---
		dashboardData.put("totalUsers", getTotalUserCount());
		dashboardData.put("activeUsers", getActiveUserCount());

		// --- B차트 (Line) 데이터 ---
		int days = 14; // 2주 기준
		Map<String, Object> params = Map.of("days", days);

		List<Map<String, Object>> playCountByLevel = gameLogDAO.selectDailyPlayCountByLevel(params);
		dashboardData.put("playCountByLevel", playCountByLevel);

		// --- 상단 카드 데이터 ---
		dashboardData.put("totalGames", getTotalGameCount());
		dashboardData.put("newUsersToday", getNewUserCountToday());

		return dashboardData;
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

	// 리뷰 관리 로직
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
	public boolean deleteReviewImageByFileNo(int fileNo) {
		return reviewDAO.deleteReviewImageByFileNo(fileNo) > 0;
	}

	@Override
	public boolean deleteReviewImagesByFileNos(List<Integer> fileNos) {
		return reviewDAO.deleteReviewImagesByFileNos(fileNos) > 0;
	}

	@Override
	public boolean deleteReview(int boardNo) {
		try {
			reviewDAO.deleteReviewStars(boardNo);
			reviewDAO.deleteReviewReplies(boardNo);
			reviewDAO.deleteAllReviewImagesByBoardNo(boardNo);
			new AdminBoardDAOImpl().deleteBoardLikes(boardNo);
			reviewDAO.deleteBoardDislikes(boardNo);
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