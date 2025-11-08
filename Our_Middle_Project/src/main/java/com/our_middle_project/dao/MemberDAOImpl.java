package com.our_middle_project.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import com.our_middle_project.dto.MemberDTO;
import com.our_middle_project.util.MybatisUtil; 

public class MemberDAOImpl implements MemberDAO {

	public MemberDAOImpl() {
	}

	@Override
	public int getTotalUserCount() {
		try (SqlSession session = MybatisUtil.getSqlSession()) {
			return session.selectOne("memberMapper.getTotalUserCount");
		} catch (Exception e) { e.printStackTrace(); return 0; }
	}

	// 3번 카드
	@Override
	public int getDailyNewUserCount() {
		try (SqlSession session = MybatisUtil.getSqlSession()) {
			return session.selectOne("memberMapper.getDailyNewUserCount");
		} catch (Exception e) { e.printStackTrace(); return 0; }
	}
	
	// 2번 카드
	@Override
	public int getDailyDeletedUserCount() {
		try (SqlSession session = MybatisUtil.getSqlSession()) {
			return session.selectOne("memberMapper.getDailyDeletedUserCount");
		} catch (Exception e) { e.printStackTrace(); return 0; }
	}

	@Override
	public List<MemberDTO> selectUsersByKeyword(String keyword) {
		try (SqlSession session = MybatisUtil.getSqlSession()) {
			return session.selectList("memberMapper.selectUsersByKeyword", keyword);
		} catch (Exception e) { e.printStackTrace(); return null; }
	}

	@Override
	public List<Map<String, Object>> selectDailySignupStats() {
		try (SqlSession session = MybatisUtil.getSqlSession()) {
			return session.selectList("memberMapper.getDailySignupStatsForLast7Days");
		} catch (Exception e) { e.printStackTrace(); return null; }
	}

	// B차트
	@Override
	public List<Map<String, Object>> selectDailySignupStatsForChart(Map<String, Object> params) {
		try (SqlSession session = MybatisUtil.getSqlSession()) {
			return session.selectList("memberMapper.getDailySignupStatsForChart", params);
		} catch (Exception e) { e.printStackTrace(); return null; }
	}
	
	// B차트
	@Override
	public List<Map<String, Object>> selectDailyDeletedStatsForChart(Map<String, Object> params) {
		try (SqlSession session = MybatisUtil.getSqlSession()) {
			return session.selectList("memberMapper.getDailyDeletedStatsForChart", params);
		} catch (Exception e) { e.printStackTrace(); return null; }
	}
	
	// A차트
	@Override
	public List<Map<String, Object>> selectDailyCumulativeUserStatsForChart(Map<String, Object> params) {
		try (SqlSession session = MybatisUtil.getSqlSession()) {
			return session.selectList("memberMapper.getDailyCumulativeUserStatsForChart", params);
		} catch (Exception e) { e.printStackTrace(); return null; }
	}

	@Override
	public int updateUser(MemberDTO memberDTO) {
		try (SqlSession session = MybatisUtil.getSqlSession()) {
			return session.update("memberMapper.updateUser", memberDTO);
		} catch (Exception e) { e.printStackTrace(); return 0; }
	}
	
	@Override
	public MemberDTO selectUserDetails(String memberId) {
		try (SqlSession session = MybatisUtil.getSqlSession()) {
			return session.selectOne("memberMapper.selectUserDetails", memberId);
		} catch (Exception e) { e.printStackTrace(); return null; }
	}
}