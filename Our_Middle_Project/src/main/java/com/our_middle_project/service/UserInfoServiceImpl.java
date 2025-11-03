package com.our_middle_project.service;

import java.util.Map;

import org.apache.ibatis.session.SqlSession;

import com.our_middle_project.dao.UserInfoDAO;
import com.our_middle_project.dao.UserInfoDAOImpl;
import com.our_middle_project.dto.UserInfoDTO;
import com.our_middle_project.dto.UserInfoReturnDTO;
import com.our_middle_project.serviceInterface.UserInfoService;
import com.our_middle_project.util.MybatisUtil;

public class UserInfoServiceImpl implements UserInfoService {
	
	@Override
	public void JoinUser(UserInfoDTO userInfo) {
		
		try(SqlSession sqlSession = MybatisUtil.getSqlSession()) {
			UserInfoDAO userInfoDao = new UserInfoDAOImpl(sqlSession);
			userInfoDao.JoinUser(userInfo);
		}
		
	}

	@Override
	public UserInfoDTO getIdCheck(UserInfoDTO userInfo) {
		
		UserInfoDTO result;
		try(SqlSession sqlSession = MybatisUtil.getSqlSession()) {
			UserInfoDAO userInfoDao = new UserInfoDAOImpl(sqlSession);
			result = userInfoDao.getIdCheck(userInfo);
		}
		return result;
		
	}

	@Override
	public UserInfoReturnDTO getIdFind(UserInfoDTO userInfo) {
		
		UserInfoReturnDTO result;
		try(SqlSession sqlSession = MybatisUtil.getSqlSession()) {
			UserInfoDAO userInfoDao = new UserInfoDAOImpl(sqlSession);
			result = userInfoDao.getIdFind(userInfo);
		}
		return result;
		
	}

	@Override
	public UserInfoReturnDTO getPasswordFind(UserInfoDTO userInfo) {
		
		UserInfoReturnDTO result;
		try(SqlSession sqlSession = MybatisUtil.getSqlSession()) {
			UserInfoDAO userInfoDao = new UserInfoDAOImpl(sqlSession);
			result = userInfoDao.getPasswordFind(userInfo);
		}
		return result;
		
	}

	@Override
	public void newPasswordSave(Map<String, Object> pram) {
		try(SqlSession sqlSession = MybatisUtil.getSqlSession()) {
			UserInfoDAO userInfoDao = new UserInfoDAOImpl(sqlSession);
			userInfoDao.newPasswordSave(pram);
		}
	}

}
