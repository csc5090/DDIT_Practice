package com.our_middle_project.service;

import java.util.List;

import org.apache.ibatis.session.SqlSession;

import com.our_middle_project.dao.GameDAO;
import com.our_middle_project.dao.GameDAOImpl;
import com.our_middle_project.dto.GameLevelDTO;
import com.our_middle_project.serviceInterface.GameService;
import com.our_middle_project.util.MybatisUtil;

public class GameServiceImpl implements GameService {

	@Override
	public List<GameLevelDTO> getLevelInfo() {
		
		 List<GameLevelDTO> result = null;
		 try(SqlSession sqlSession = MybatisUtil.getSqlSession()) {
			 GameDAO gameDAO = new GameDAOImpl(sqlSession);
			 result = gameDAO.getLevelInfo();
		 }
		return result;
	}

}
