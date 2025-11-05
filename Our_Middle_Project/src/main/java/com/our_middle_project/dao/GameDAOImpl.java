package com.our_middle_project.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;

import com.our_middle_project.dto.GameLevelDTO;

public class GameDAOImpl implements GameDAO {

	private SqlSession sqlSession;
	
	public GameDAOImpl(SqlSession sqlSession) {
		this.sqlSession = sqlSession;
	}

	@Override
	public List<GameLevelDTO> getLevelInfo() {
		return sqlSession.selectList("gameMapper.getLevelInfo");
	}


	
}
