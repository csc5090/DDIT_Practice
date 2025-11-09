package com.our_middle_project.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;

import com.our_middle_project.dto.GameLogDTO;
import com.our_middle_project.dto.RankingDTO;
import com.our_middle_project.dto.UserInfoDTO;

public class MyPageDAOImpl implements MyPageDAO {

	private SqlSession sqlSession;
	
	public MyPageDAOImpl(SqlSession sqlSession) {
		this.sqlSession = sqlSession;
	}

	@Override
	public UserInfoDTO getMyUserData(UserInfoDTO loingUser) {
		return sqlSession.selectOne("myPageMapper.loingUserInfo", loingUser);
	}

	@Override
	public List<RankingDTO> getMyRankingData(UserInfoDTO loingUser) {
		return sqlSession.selectList("myPageMapper.loingUserRanking", loingUser);
	}

	@Override
	public List<GameLogDTO> getMyGameLogData(UserInfoDTO loingUser) {
		return sqlSession.selectList("myPageMapper.loingUserGmaeLog", loingUser);
	}

}
