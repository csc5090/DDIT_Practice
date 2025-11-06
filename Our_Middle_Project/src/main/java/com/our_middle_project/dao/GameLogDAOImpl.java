package com.our_middle_project.dao;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import com.our_middle_project.dto.GameLogDTO;

public class GameLogDAOImpl implements GameLogDAO {

    private SqlSessionFactory sqlSessionFactory;

    public GameLogDAOImpl(SqlSessionFactory sqlSessionFactory) {
        this.sqlSessionFactory = sqlSessionFactory;
    }
	    
	@Override
	public void insertGameLog(GameLogDTO gameLog) {
		try (SqlSession session = sqlSessionFactory.openSession(true)) {
            session.insert("GameLog.insertGameLog", gameLog);
        }
	}
}
