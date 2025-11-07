package com.our_middle_project.service;

import java.util.List;

import org.apache.ibatis.session.SqlSession;

import com.our_middle_project.dao.RankingDAO;
import com.our_middle_project.dao.RankingDAOImpl;
import com.our_middle_project.dto.RankingDTO;
import com.our_middle_project.serviceInterface.RankingService;
import com.our_middle_project.util.MybatisUtil;

public class RankingServiceImpl implements RankingService {

	@Override
	public List<RankingDTO> getRankingList() {
		List<RankingDTO> result;
		try(SqlSession sqlsession = MybatisUtil.getSqlSession()) {
			RankingDAO rankingDAO = new RankingDAOImpl(sqlsession);
			result = rankingDAO.getRankingList();
		}
		return result;
	}

}
