package com.our_middle_project.dao;

import java.util.List;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import com.our_middle_project.dto.StatsDTO;
import com.our_middle_project.mybatis.MyBatisConnection;

public class StatsDAO {

	private static StatsDAO instance = new StatsDAO();
	
    private StatsDAO() {}
    
    public static StatsDAO getInstance() {
        return instance;
    }

    private final SqlSessionFactory factory = MyBatisConnection.getSqlSessionFactory();
	
    public List<StatsDTO> getDailySignupStats() {
        try (SqlSession sqlSession = factory.openSession()) {
            return sqlSession.selectList("com.our_middle_project.dao.StatsDAO.getDailySignupStats");
        }
    }
    
	
}
