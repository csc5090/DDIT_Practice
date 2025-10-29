package com.our_middle_project.dao;

import org.apache.ibatis.session.SqlSession;

public class MemberDAOImpl implements MemberDAO {
	
    private SqlSession sqlSession;

    // 이 클래스는 SqlSession을 받아야만 일할 수 있음.
    public MemberDAOImpl(SqlSession sqlSession) {
        this.sqlSession = sqlSession;
    }
    
    // selectOne : 쿼리 결과가 **반드시 한 개(1 row) 또는 없는 것(0 row)**이 확실할 때 사용
    // selectList() : 2개 이상일 때.

    @Override
    public int getTotalUserCount() {
        // Mapper XML의 namespace와 id를 "네임스페이스.id" 형태로 직접 호출.
        return sqlSession.selectOne("com.our_middle_project.dao.MemberDAO.getTotalUserCount");
    }

	@Override
	public int getNewUserCountToday() {
		return sqlSession.selectOne("com.our_middle_project.dao.MemberDAO.getNewUserCountToday");
	}
}