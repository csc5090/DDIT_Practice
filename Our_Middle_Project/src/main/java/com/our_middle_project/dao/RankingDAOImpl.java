package com.our_middle_project.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;

import com.our_middle_project.dto.RankingDTO;

public class RankingDAOImpl implements RankingDAO {

    private SqlSessionFactory sqlSessionFactory;

    public RankingDAOImpl(SqlSessionFactory sqlSessionFactory) {
        this.sqlSessionFactory = sqlSessionFactory;
    }

    @Override
    public List<RankingDTO> selectRankingByLevel(Map<String, Object> param) {
        try (SqlSession session = sqlSessionFactory.openSession()) {
            return session.selectList("com.our_middle_project.mapper.RankingMapper.selectRankingByLevel", param);
        }
    }
}	
