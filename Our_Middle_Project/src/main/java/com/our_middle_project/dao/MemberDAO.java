package com.our_middle_project.dao;

import java.util.List;
import java.util.Map;

import com.our_middle_project.dto.MemberDTO;

public interface MemberDAO {
	public int getTotalUserCount(); 
	public int getDailyNewUserCount();
	public int getDailyDeletedUserCount();
	
	List<MemberDTO> selectUsersByKeyword(String keyword);
	public List<Map<String, Object>> selectDailySignupStats();
	
	// B차트
	public List<Map<String, Object>> selectDailySignupStatsForChart(Map<String, Object> params);
	public List<Map<String, Object>> selectDailyDeletedStatsForChart(Map<String, Object> params);
	// A차트 
	public List<Map<String, Object>> selectDailyCumulativeUserStatsForChart(Map<String, Object> params);
	
	public int updateUser(MemberDTO memberDTO);
	public MemberDTO selectUserDetails(String memberId);
}