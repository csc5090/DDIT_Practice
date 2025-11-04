package com.our_middle_project.dao;

import java.util.List;
import org.apache.ibatis.session.SqlSession;
import com.our_middle_project.dto.AdminReviewDTO;

public class AdminReviewDAOImpl implements AdminReviewDAO {
    private final SqlSession sqlSession;

    public AdminReviewDAOImpl(SqlSession sqlSession) {
        this.sqlSession = sqlSession;
    }

    @Override
    public List<AdminReviewDTO> selectAllReviews() {
        return sqlSession.selectList("AdminReviewMappers.selectAllReviews");
    }
}