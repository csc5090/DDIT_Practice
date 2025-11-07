package com.our_middle_project.serviceInterface;

import java.util.List;

import com.our_middle_project.dto.RankingDTO;

public interface RankingService {
	
	List<RankingDTO> getRankingByLevel(int levelNo, int limit);

}
