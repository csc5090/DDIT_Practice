package com.our_middle_project.service;

import org.apache.ibatis.session.SqlSession;

import com.our_middle_project.dao.MemberDAO;
import com.our_middle_project.dao.MemberDAOImpl;
import com.our_middle_project.serviceInterface.AdminService;
import com.our_middle_project.util.MybatisUtil;

public class AdminServiceImpl implements AdminService {

	@Override
	public int getTotalUserCount() {
        // try-with-resources: 이 블록이 끝나면 sqlSession이 자동으로 닫힘.
        try (SqlSession sqlSession = MybatisUtil.getSqlSession()) {
            // 1. DAO 작업자(Impl)를 생성하고, 일할 도구(sqlSession)를 준다.
            MemberDAO memberDAO = new MemberDAOImpl(sqlSession);
            
            // 2. 작업자에게 일을 시키고 결과를 받는다.
            return memberDAO.getTotalUserCount();
        } 
	}
}