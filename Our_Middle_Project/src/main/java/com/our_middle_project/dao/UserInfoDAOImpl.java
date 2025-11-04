package com.our_middle_project.dao;

import java.util.HashMap;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;

import com.our_middle_project.dto.UserInfoDTO;
import com.our_middle_project.dto.UserInfoReturnDTO;

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
	public UserInfoReturnDTO getIdFind(UserInfoDTO userInfo) {
		return sqlSession.selectOne("userInfoMapper.idFind", userInfo);
	}

	@Override
	public UserInfoReturnDTO getPasswordFind(UserInfoDTO userInfo) {
		return sqlSession.selectOne("userInfoMapper.pwFind", userInfo);
	}

	@Override
	public void newPasswordSave(Map<String, Object> pram) {
		sqlSession.update("userInfoMapper.newPasswordSave", pram);
	}

	@Override
	public UserInfoDTO loginCheck(UserInfoDTO userInfo) {
		return sqlSession.selectOne("userInfoMapper.loginCheck", userInfo);
	}

	
}
