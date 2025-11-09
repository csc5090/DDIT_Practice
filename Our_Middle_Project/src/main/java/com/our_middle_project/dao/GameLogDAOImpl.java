package com.our_middle_project.dao;

import java.util.Collections;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;

import com.our_middle_project.dto.GameLogDTO;
import com.our_middle_project.util.MybatisUtil;

public class GameLogDAOImpl implements GameLogDAO {

	public GameLogDAOImpl() {
	}

	private SqlSessionFactory sqlSessionFactory;

	public GameLogDAOImpl(SqlSessionFactory sqlSessionFactory) {
		this.sqlSessionFactory = sqlSessionFactory;
	}

	@Override
	public void insertGameLog(GameLogDTO gameLog) {
		try (SqlSession session = MybatisUtil.getSqlSession()) {
			session.insert("gameLogMapper.insertGameLog", gameLog);
			session.commit();
		}
	}

	@Override
	public int getTotalGameCount() {
		try (SqlSession session = MybatisUtil.getSqlSession()) {
			return session.selectOne("gameLogMapper.getTotalGameCount");
		} catch (Exception e) {
			e.printStackTrace();
			return 0;
		}
	}

	// 5,6,7번 카드
	@Override
	public Map<String, Long> getTotalGamesByLevel() {
		try (SqlSession session = MybatisUtil.getSqlSession()) {
			return session.selectOne("gameLogMapper.getTotalGamesByLevel");
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}

	// A차트
	@Override
	public List<Map<String, Object>> selectDailyCumulativeGameStatsForChart(Map<String, Object> params) {
		try (SqlSession session = MybatisUtil.getSqlSession()) {
			return session.selectList("gameLogMapper.getDailyCumulativeGameStatsForChart", params);
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}

	// C차트
	@Override
	public List<Map<String, Object>> selectDailyPlayCountByLevel(Map<String, Object> params) {
		try (SqlSession session = MybatisUtil.getSqlSession()) {
			return session.selectList("gameLogMapper.getDailyPlayCountByLevel", params);
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}

	@Override
	public List<Map<String, Object>> selectGameBalanceReport(Map<String, Object> params) {
		try (SqlSession session = MybatisUtil.getSqlSession()) {
			return session.selectList("gameLogMapper.selectGameBalanceReport", params);
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}

	@Override
	public List<Map<String, Object>> selectDailyActiveUsers(Map<String, Object> params) {
		try (SqlSession session = MybatisUtil.getSqlSession()) {
			return session.selectList("gameLogMapper.selectDailyActiveUsers", params);
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}

	@Override
	public int getTodayPlayCount() {
		try (SqlSession sqlSession = MybatisUtil.getSqlSession()) {
			return sqlSession.selectOne("gameLogMapper.getTodayPlayCount");
		} catch (Exception e) {
			e.printStackTrace();
			return 0;
		}
	}

	@Override
	public List<Map<String, Object>> getReturningUserTrend(Map<String, Object> params) {
		try (SqlSession sqlSession = MybatisUtil.getSqlSession()) {
			return sqlSession.selectList("gameLogMapper.getReturningUserTrend", params);
		} catch (Exception e) {
			e.printStackTrace();
			return Collections.emptyList();
		}
	}

	@Override
	public List<Map<String, Object>> getPlaytimeHeatmap(Map<String, Object> params) {
		try (SqlSession sqlSession = MybatisUtil.getSqlSession()) {
			return sqlSession.selectList("gameLogMapper.getPlaytimeHeatmap", params);
		} catch (Exception e) {
			e.printStackTrace();
			return Collections.emptyList();
		}
	}
}