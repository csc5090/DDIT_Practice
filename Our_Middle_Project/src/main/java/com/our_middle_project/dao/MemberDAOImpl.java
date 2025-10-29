package com.our_middle_project.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;

import com.our_middle_project.dto.MemberDTO;

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
        return sqlSession.selectOne("memberMapper.getTotalUserCount");
    }

	@Override
	public int getNewUserCountToday() {
		return sqlSession.selectOne("memberMapper.getNewUserCountToday");
	}

	@Override
	public List<MemberDTO> selectUsersByKeyword(String keyword) {
		return this.sqlSession.selectList("memberMapper.selectUsersByKeyword", keyword);
	}
	
	@Override
    public List<Map<String, Object>> selectDailySignupStats() {
        return this.sqlSession.selectList("memberMapper.getDailySignupStatsForLast7Days");
    }
	
	
	
}