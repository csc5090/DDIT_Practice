package com.our_middle_project.dao;

import org.apache.ibatis.session.SqlSession;

public class MemberDAOImpl implements MemberDAO {

    private SqlSession sqlSession;

    // 이 클래스는 SqlSession을 받아야만 일할 수 있음.
    public MemberDAOImpl(SqlSession sqlSession) {
        this.sqlSession = sqlSession;
    }

    @Override
    public int getTotalUserCount() {
        // Mapper XML의 namespace와 id를 "네임스페이스.id" 형태로 직접 호출.
        return sqlSession.selectOne("com.our_middle_project.dao.MemberDAO.getTotalUserCount");
    }
}