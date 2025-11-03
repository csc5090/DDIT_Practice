package com.our_middle_project.serviceInterface;

import java.util.List;
import java.util.Map;

import com.our_middle_project.dto.MemberDTO;
import com.our_middle_project.dto.ReviewDTO;

public interface AdminService {
	public int getTotalUserCount();
	public int getNewUserCountToday();
	public List<MemberDTO> getUsersByKeyword(String keyword);
	List<Map<String, Object>> getDailySignupStats();
	public boolean updateUser(MemberDTO memberDTO);
	public MemberDTO getUserDetails(String memberId);
	public List<ReviewDTO> getReviewList();
}
