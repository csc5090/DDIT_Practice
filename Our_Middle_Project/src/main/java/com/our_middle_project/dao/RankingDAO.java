package com.our_middle_project.dao;

import java.util.List;
import java.util.Map;

import com.our_middle_project.dto.RankingDTO;

public interface RankingDAO {
	// 레벨별(이지 노말 하드) 랭킹 조회
	List<RankingDTO> selectRankingByLevel(Map<String, Object> param);
}
