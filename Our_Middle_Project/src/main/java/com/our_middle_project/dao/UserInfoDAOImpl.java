package com.our_middle_project.dao;

import org.apache.ibatis.session.SqlSession;

import com.our_middle_project.dto.UserInfoDTO;

public class UserInfoDAOImpl implements UserInfoDAO {

	private SqlSession sqlSession;

	public UserInfoDAOImpl(SqlSession sqlSession) {
		this.sqlSession = sqlSession;
	}
	
	@Override
	public void JoinUser(UserInfoDTO userInfo) {
		sqlSession.insert("userInfoMapper.joinUser", userInfo);
	}

	@Override
	public UserInfoDTO getIdCheck(UserInfoDTO userInfo) {
		return sqlSession.selectOne("userInfoMapper.idCheck", userInfo);
	}

	@Override
	public UserInfoDTO getIdFind(UserInfoDTO userInfo) {
		return sqlSession.selectOne("userInfoMapper.idFind", userInfo);
	}

	@Override
	public UserInfoDTO getPasswordFind(UserInfoDTO userInfo) {
		return sqlSession.selectOne("userInfoMapper.pwFind", userInfo);
	}

	
}
