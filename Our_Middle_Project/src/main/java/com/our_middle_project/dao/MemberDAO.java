package com.our_middle_project.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;

import com.our_middle_project.dto.MemberDTO;
import com.our_middle_project.mybatis.MyBatisConnection;

public class MemberDAO {
	
	private static MemberDAO instance = new MemberDAO();
	private MemberDAO() {}
	public static MemberDAO getInstance() {
		return instance;
	}
	
	private final SqlSessionFactory factory = MyBatisConnection.getSqlSessionFactory();
	
	public List<MemberDTO> getMemberList(String query){
		try (SqlSession sqlSession = factory.openSession()){
			return sqlSession.selectList("com.our_middle_project.dao.MemberDAO.getMemberList", query);
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}

	
	public int getTotalUserCount() {
	    try (SqlSession sqlSession = factory.openSession()) {
	        return sqlSession.selectOne("com.our_middle_project.dao.MemberDAO.getTotalUserCount");
	    }
	}
	public int getTodayUserCount() {
	    try (SqlSession sqlSession = factory.openSession()) {
	        return sqlSession.selectOne("com.our_middle_project.dao.MemberDAO.getTodayUserCount");
	    }
	}
	
	
	
	
}

