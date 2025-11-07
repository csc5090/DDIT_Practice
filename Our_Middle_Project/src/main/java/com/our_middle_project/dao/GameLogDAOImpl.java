package com.our_middle_project.dao;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;

import com.our_middle_project.dto.GameLogDTO;
import com.our_middle_project.util.MybatisUtil;

public class GameLogDAOImpl implements GameLogDAO {
	
	public GameLogDAOImpl() {
	    // 기존 insertGameLog에서는 MybatisUtil.getSqlSession()를 사용하므로,
	    // 여기서는 아무것도 하지 않아도 됩니다.
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
}
