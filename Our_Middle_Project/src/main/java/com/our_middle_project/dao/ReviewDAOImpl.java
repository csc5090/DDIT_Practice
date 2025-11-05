package com.our_middle_project.dao;

import java.util.HashMap;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;

import com.our_middle_project.dto.FileImageDTO;
import com.our_middle_project.dto.ReviewDTO;
import com.our_middle_project.util.MybatisUtil;

public class ReviewDAOImpl implements ReviewDAO {

	private static final String NS = "mappers.reviewMapper.";

    @Override
    public int insertBoard(ReviewDTO dto) {
        try (SqlSession session = MybatisUtil.getSqlSession()) {
            int result = session.insert(NS + "insertBoard", dto);
            session.commit(); // auto-commit=false 이므로 반드시 commit
            return result;
        }
    }

    @Override
    public int insertImage(FileImageDTO img) {
        try (SqlSession session = MybatisUtil.getSqlSession()) {
            int result = session.insert(NS + "insertImage", img);
            session.commit();
            return result;
        }
    }

    @Override
    public int insertAuthorStar(int boardNo, int memNo, int star) {
        try (SqlSession session = MybatisUtil.getSqlSession()) {
            Map<String, Object> param = new HashMap<>();
            param.put("boardNo", boardNo);
            param.put("memNo", memNo);
            param.put("star", star);
            int result = session.insert(NS + "insertAuthorStar", param);
            session.commit();
            return result;
        }
    }
}