package com.our_middle_project.dao;

import java.util.HashMap;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;

import com.our_middle_project.dto.FileImageDTO;
import com.our_middle_project.dto.ReviewDTO;

public class ReviewDAOImpl implements ReviewDAO {
	
	private static final String NS = "mappers.reviewMapper.";
    private final SqlSessionFactory factory;

    public ReviewDAOImpl(SqlSessionFactory factory) {
        this.factory = factory;
    }

    @Override
    public int insertBoard(ReviewDTO dto) {
        try (SqlSession s = factory.openSession(true)) {
            return s.insert(NS + "insertBoard", dto);
        }
    }

    @Override
    public int insertImage(FileImageDTO img) {
        try (SqlSession s = factory.openSession(true)) {
            return s.insert(NS + "insertImage", img);
        }
    }

    @Override
    public int mergeAuthorStar(int boardNo, int memNo, int star) {
        try (SqlSession s = factory.openSession(true)) {
            Map<String, Object> p = new HashMap<>();
            p.put("boardNo", boardNo);
            p.put("memNo", memNo);
            p.put("star", star);
            return s.update(NS + "mergeAuthorStar", p);
        }
    }
}