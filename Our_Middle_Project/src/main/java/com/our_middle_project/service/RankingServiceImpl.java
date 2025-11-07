package com.our_middle_project.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.our_middle_project.dao.RankingDAO;
import com.our_middle_project.dto.RankingDTO;
import com.our_middle_project.serviceInterface.RankingService;

public class RankingServiceImpl implements RankingService {
	
	 private RankingDAO rankingDAO;

	    // 생성자 주입
	    public RankingServiceImpl(RankingDAO rankingDAO) {
	        this.rankingDAO = rankingDAO;
	    }

	    @Override
	    public List<RankingDTO> getRankingByLevel(int levelNo, int limit) {
	        Map<String, Object> param = new HashMap<>();
	        param.put("levelNo", levelNo);
	        param.put("limit", limit);
	        
	        return rankingDAO.selectRankingByLevel(param);
	    }
	}