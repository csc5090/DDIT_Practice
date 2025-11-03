package com.our_middle_project.service;

import org.apache.ibatis.session.SqlSession;

import com.our_middle_project.dao.UserInfoDAO;
import com.our_middle_project.dao.UserInfoDAOImpl;
import com.our_middle_project.dto.UserInfoDTO;
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
	public UserInfoDTO getIdFind(UserInfoDTO userInfo) {
		
		UserInfoDTO result;
		try(SqlSession sqlSession = MybatisUtil.getSqlSession()) {
			UserInfoDAO userInfoDao = new UserInfoDAOImpl(sqlSession);
			result = userInfoDao.getIdFind(userInfo);
		}
		return result;
		
	}

	@Override
	public UserInfoDTO getPasswordFind(UserInfoDTO userInfo) {
		
		UserInfoDTO result;
		try(SqlSession sqlSession = MybatisUtil.getSqlSession()) {
			UserInfoDAO userInfoDao = new UserInfoDAOImpl(sqlSession);
			result = userInfoDao.getPasswordFind(userInfo);
		}
		return result;
		
	}

}
