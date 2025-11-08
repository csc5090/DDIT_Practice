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
// [삭제] ActiveUserListener 임포트 삭제
import com.our_middle_project.util.SendMail;

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

		// 1. 유저의 현재 정보 (이메일, 옛날 닉네임)를 DB에서 조회
		MemberDTO currentUserData = memberDAO.selectUserDetails(memberDTO.getUserId());
		if (currentUserData == null) {
			System.err.println("updateUser 실패: " + memberDTO.getUserId() + " 유저를 찾을 수 없음(업데이트 할 유저가 존재하지 않음)");
			return false; // 업데이트할 유저가 없음
		}

		String oldNickname = currentUserData.getNickname();
		String newNickname = memberDTO.getNickname();
		String userEmail = currentUserData.getUserMail();

		// 닉네임 변경 여부 확인
		boolean isNicknameChanged = !oldNickname.equals(newNickname);

		// 2. 'USER' 역할 처리
		if ("USER".equals(memberDTO.getRole())) {
			memberDTO.setRole(null);
		}

		// 3. DB 업데이트 실행
		int result = memberDAO.updateUser(memberDTO);

		// 4. 업데이트 성공 & 닉네임이 변경되었다면 메일 발송
		if (result > 0 && isNicknameChanged) {
			System.out.println("닉네임 변경 감지. 메일 발송 시도...");

			String subject = "[Twin Cards Game] 회원님의 닉네임이 변경되었습니다.";
			String content = String.format(
					"안녕하세요, %s님.\n\n" + "회원님의 닉네임이 관리자에 의해 다음과 같이 변경되었습니다.\n\n" + "이전 닉네임: %s\n" + "새 닉네임: %s\n\n"
							+ "감사합니다.\n" + "Twin Cards Game 팀 드림",
					oldNickname, // 메일 내용에는 옛날 닉네임으로 부르는 것이 자연스러움
					oldNickname, newNickname);

			// SendMail 유틸리티 호출
			try {
				SendMail.sendMail(userEmail, subject, content);
			} catch (Exception e) {
				e.printStackTrace();
				System.err.println("DB 업데이트는 성공했으나 메일 발송에 실패했습니다. 유저 ID: " + memberDTO.getUserId());
			}
		}

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