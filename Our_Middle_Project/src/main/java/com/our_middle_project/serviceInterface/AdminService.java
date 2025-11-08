package com.our_middle_project.serviceInterface;

import java.util.List;
import java.util.Map;

import com.our_middle_project.dto.AdminBoardImageDTO;
import com.our_middle_project.dto.AdminReviewDTO;
import com.our_middle_project.dto.MemberDTO;

public interface AdminService {

	public int getTotalUserCount(); // (유지)

	public List<MemberDTO> getUsersByKeyword(String keyword);

	List<Map<String, Object>> getDailySignupStats(); // (유지)

	// 새 대시보드 데이터를 한 번에 반환
	public Map<String, Object> getDashboardData();

	public boolean updateUser(MemberDTO memberDTO);

	public MemberDTO getUserDetails(String memberId);

	// 리뷰 관리
	public List<AdminReviewDTO> getReviewList(String keyword);

	public boolean updateAdminReply(int boardNo, int adminMemNo, String replyContent);

	public boolean deleteReview(int boardNo);

	public List<AdminBoardImageDTO> getReviewImages(int boardNo);

	boolean deleteReviewImageByFileNo(int fileNo);

	boolean deleteReviewImagesByFileNos(List<Integer> fileNos);
}