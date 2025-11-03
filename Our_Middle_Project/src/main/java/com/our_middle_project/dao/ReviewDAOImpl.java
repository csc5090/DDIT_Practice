package com.our_middle_project.dao;

import java.util.List;
import org.apache.ibatis.session.SqlSession;
import com.our_middle_project.dto.ReviewDTO;

public class ReviewDAOImpl implements ReviewDAO {
    private final SqlSession sqlSession;

    public ReviewDAOImpl(SqlSession sqlSession) {
        this.sqlSession = sqlSession;
    }

    @Override
    public List<ReviewDTO> selectAllReviews() {
        return sqlSession.selectList("reviewMapper.selectAllReviews");
    }
}