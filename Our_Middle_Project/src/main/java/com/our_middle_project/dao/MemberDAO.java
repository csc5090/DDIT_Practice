package com.our_middle_project.dao;

import java.util.List;
import java.util.Map;

import com.our_middle_project.dto.MemberDTO;

public interface MemberDAO {
	public int getTotalUserCount();
	public int getNewUserCountToday();
	List<MemberDTO> selectUsersByKeyword(String keyword);
	public List<Map<String, Object>> selectDailySignupStats();
}
