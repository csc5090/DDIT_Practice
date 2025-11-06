package com.our_middle_project.serviceInterface;

import java.util.List;
import java.util.Map;

import com.our_middle_project.dto.MemberDTO;
import com.our_middle_project.dto.AdminReviewDTO;

public interface AdminService {
	public int getTotalUserCount();
	public int getNewUserCountToday();
	public List<MemberDTO> getUsersByKeyword(String keyword);
	List<Map<String, Object>> getDailySignupStats();
	public boolean updateUser(MemberDTO memberDTO);
	public MemberDTO getUserDetails(String memberId);

	public List<AdminReviewDTO> getReviewList(String keyword);
	public boolean updateAdminReply(int boardNo, int adminMemNo, String replyContent);
	public boolean deleteReviewImage(int boardNo);
	public boolean deleteReview(int boardNo);
}