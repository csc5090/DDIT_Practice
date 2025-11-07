package com.our_middle_project.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;

import com.our_middle_project.dto.RankingDTO;

public class RankingDAOImpl implements RankingDAO {

	private SqlSession sqlSession;
	
	public RankingDAOImpl(SqlSession sqlsession) {
		this.sqlSession = sqlsession;
	}

	@Override
	public List<RankingDTO> getRankingList() {
		return sqlSession.selectList("rankingMapper.selectRanking");
	}
	
}
