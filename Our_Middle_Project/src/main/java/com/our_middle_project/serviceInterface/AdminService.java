package com.our_middle_project.serviceInterface;

import java.util.List;
import java.util.Map;

import com.our_middle_project.dto.AdminBoardImageDTO;
import com.our_middle_project.dto.AdminReviewDTO;
import com.our_middle_project.dto.MemberDTO;

public interface AdminService {
	public int getTotalUserCount();

	public int getNewUserCountToday();

	public int getTotalGameCount();

	//  A차트: 실시간 접속자
	public int getActiveUserCount();

	public List<MemberDTO> getUsersByKeyword(String keyword);

	List<Map<String, Object>> getDailySignupStats(); // (기존 7일차트 - 유지)

	//  A, B 차트 데이터를 한번에 반환하는 새 메소드
	public Map<String, Object> getDashboardData();

	public boolean updateUser(MemberDTO memberDTO);

	public MemberDTO getUserDetails(String memberId);

	// (기존 리뷰 관리)
	public List<AdminReviewDTO> getReviewList(String keyword);

	public boolean updateAdminReply(int boardNo, int adminMemNo, String replyContent);

	public boolean deleteReview(int boardNo);

	public List<AdminBoardImageDTO> getReviewImages(int boardNo);

	boolean deleteReviewImageByFileNo(int fileNo);

	boolean deleteReviewImagesByFileNos(List<Integer> fileNos);
}