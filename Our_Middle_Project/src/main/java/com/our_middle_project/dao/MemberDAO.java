package com.our_middle_project.dao;

import java.util.List;
import java.util.Map;

import com.our_middle_project.dto.MemberDTO;

public interface MemberDAO {
	public int getTotalUserCount();
	public int getNewUserCountToday();
	List<MemberDTO> selectUsersByKeyword(String keyword);
	public List<Map<String, Object>> selectDailySignupStats();
	public List<Map<String, Object>> selectDailySignupStatsForChart(Map<String, Object> params);
	public List<Map<String, Object>> selectDailyCumulativeUserStatsForChart(Map<String, Object> params);
	public int updateUser(MemberDTO memberDTO);
	public MemberDTO selectUserDetails(String memberId);
}
