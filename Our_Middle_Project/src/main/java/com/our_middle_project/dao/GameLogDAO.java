package com.our_middle_project.dao;

import java.util.List;
import java.util.Map;

import com.our_middle_project.dto.GameLogDTO;

public interface GameLogDAO {

	void insertGameLog(GameLogDTO gameLog);

	int getTotalGameCount();

	// 5,6,7번 카드
	Map<String, Long> getTotalGamesByLevel();

	// A차트
	List<Map<String, Object>> selectDailyCumulativeGameStatsForChart(Map<String, Object> params);

	// C차트
	List<Map<String, Object>> selectDailyPlayCountByLevel(Map<String, Object> params);
}