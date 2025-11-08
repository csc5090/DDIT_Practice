package com.our_middle_project.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Collections;

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
// [삭제] ActiveUserListener 임포트 삭제

public class AdminServiceImpl implements AdminService {

	private MemberDAO memberDAO = new MemberDAOImpl();
	private AdminReviewDAO reviewDAO = new AdminReviewDAOImpl();
	private GameLogDAO gameLogDAO = new GameLogDAOImpl();

	@Override
	public int getTotalUserCount() {
		return memberDAO.getTotalUserCount();
	}
	
	@Override
	public List<MemberDTO> getUsersByKeyword(String keyword) {
		return memberDAO.selectUsersByKeyword(keyword);
	}

	@Override
	public List<Map<String, Object>> getDailySignupStats() {
		return memberDAO.selectDailySignupStats();
	}

	// 7+3 구조에 맞게 데이터 조회
	@Override
	public Map<String, Object> getDashboardData() {
		Map<String, Object> data = new HashMap<>();
		int chartDays = 14; // 2주 기준
		Map<String, Object> params = Map.of("days", chartDays);

		// --- 1행 카드 ---
		data.put("cardTotalUsers", memberDAO.getTotalUserCount());
		data.put("cardDailyDeleted", memberDAO.getDailyDeletedUserCount());
		data.put("cardDailyNewUsers", memberDAO.getDailyNewUserCount());

		// --- 2행 카드 ---
		data.put("cardTotalGames", gameLogDAO.getTotalGameCount());
		Map<String, Long> gamesByLevel = gameLogDAO.getTotalGamesByLevel();
		if (gamesByLevel != null) {
			data.put("cardEasyGames", gamesByLevel.getOrDefault("LEVEL_1", 0L));
			data.put("cardNormalGames", gamesByLevel.getOrDefault("LEVEL_2", 0L));
			data.put("cardHardGames", gamesByLevel.getOrDefault("LEVEL_3", 0L));
		} else {
			data.put("cardEasyGames", 0L);
			data.put("cardNormalGames", 0L);
			data.put("cardHardGames", 0L);
		}

		// --- A차트 (Bar) ---
		data.put("chartA_TotalUsers", memberDAO.selectDailyCumulativeUserStatsForChart(params));
		data.put("chartA_TotalGames", gameLogDAO.selectDailyCumulativeGameStatsForChart(params));

		// --- B차트 (Bar) ---
		data.put("chartB_NewUsers", memberDAO.selectDailySignupStatsForChart(params));
		data.put("chartB_DeletedUsers", memberDAO.selectDailyDeletedStatsForChart(params));

		// --- C차트 (Line) ---
		data.put("chartC_PlaysByLevel", gameLogDAO.selectDailyPlayCountByLevel(params));

		return data;
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

	// 리뷰 관리
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