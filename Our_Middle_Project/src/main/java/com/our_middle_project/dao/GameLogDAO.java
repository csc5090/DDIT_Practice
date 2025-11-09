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

	// '데이터/통계' - Phase 1
	List<Map<String, Object>> selectGameBalanceReport(Map<String, Object> params);

	// '데이터/통계' - Phase 2
	List<Map<String, Object>> selectDailyActiveUsers(Map<String, Object> params);

	// K-Card: 오늘 총 플레이 수
	int getTodayPlayCount();

	// 리텐션 차트: 재방문 유저 트렌드
	List<Map<String, Object>> getReturningUserTrend(Map<String, Object> params);

	// 히트맵 차트: 주간/시간대별 플레이
	List<Map<String, Object>> getPlaytimeHeatmap(Map<String, Object> params);
}