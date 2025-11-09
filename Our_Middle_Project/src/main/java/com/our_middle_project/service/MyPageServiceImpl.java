package com.our_middle_project.service;

import java.util.List;

import org.apache.ibatis.session.SqlSession;

import com.our_middle_project.dao.MyPageDAO;
import com.our_middle_project.dao.MyPageDAOImpl;
import com.our_middle_project.dto.GameLogDTO;
import com.our_middle_project.dto.RankingDTO;
import com.our_middle_project.dto.UserInfoDTO;
import com.our_middle_project.serviceInterface.MyPageService;
import com.our_middle_project.util.MybatisUtil;

public class MyPageServiceImpl implements MyPageService {

	@Override
	public UserInfoDTO getMyUserData(UserInfoDTO loingUser) {
		UserInfoDTO result;
		try(SqlSession sqlSession = MybatisUtil.getSqlSession()) {
			MyPageDAO myPageDAO = new MyPageDAOImpl(sqlSession);
			result = myPageDAO.getMyUserData(loingUser);
		}
		return result;
	}

	@Override
	public List<RankingDTO> getMyRankingData(UserInfoDTO loingUser) {
		List<RankingDTO> result;
		try(SqlSession sqlSession = MybatisUtil.getSqlSession()) {
			MyPageDAO myPageDAO = new MyPageDAOImpl(sqlSession);
			result = myPageDAO.getMyRankingData(loingUser);
		}
		return result;
	}

	@Override
	public List<GameLogDTO> getMyGameLogData(UserInfoDTO loingUser) {
		List<GameLogDTO> result;
		try(SqlSession sqlSession = MybatisUtil.getSqlSession()) {
			MyPageDAO myPageDAO = new MyPageDAOImpl(sqlSession);
			result = myPageDAO.getMyGameLogData(loingUser);
		}
		return result;
	}

}
