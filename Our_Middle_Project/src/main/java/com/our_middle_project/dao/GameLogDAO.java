package com.our_middle_project.dao;

import java.util.List;
import java.util.Map;

import com.our_middle_project.dto.GameLogDTO;

public interface GameLogDAO {

	void insertGameLog(GameLogDTO gameLog);

	int getTotalGameCount();
	
	List<Map<String, Object>> selectDailyPlayCountByLevel(Map<String, Object> params);
}