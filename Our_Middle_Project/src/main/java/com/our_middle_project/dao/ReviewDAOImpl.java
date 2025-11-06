package com.our_middle_project.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;

import com.our_middle_project.dto.FileImageDTO;
import com.our_middle_project.dto.ReviewDTO;
import com.our_middle_project.util.MybatisUtil;

public class ReviewDAOImpl implements ReviewDAO {

	// MyBatis가 내부적으로 Mapper XML의 id를 찾아 실행
	private static final String NS = "mappers.reviewMapper.";

	// insert
	// try (SqlSession session = MybatisUtil.getSqlSession()) { … }
	// => try-with-resources 문으로 auto-close 기능
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
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
	}

	// select
	@Override
	public List<ReviewDTO> selectReview(int limit) {
		try (SqlSession session = MybatisUtil.getSqlSession()) {
			Map<String, Object> p = new HashMap<>();
			p.put("limit", limit);
			return session.selectList(NS + "selectReview", p);
		}
	}

	@Override
	public List<ReviewDTO> selectMoreReview(int ltBoardNo, int limit) {
		try (SqlSession session = MybatisUtil.getSqlSession()) {
			Map<String, Object> p = new HashMap<>();
			p.put("ltBoardNo", ltBoardNo);
			p.put("limit",     limit);
			return session.selectList(NS + "selectMoreReview", p);
		}
	}

	@Override
	public List<FileImageDTO> selectImagesByBoard(int boardNo) {
		try (SqlSession session = MybatisUtil.getSqlSession()) {
			return session.selectList(NS + "selectImagesByBoard", boardNo);
		}
	}
}