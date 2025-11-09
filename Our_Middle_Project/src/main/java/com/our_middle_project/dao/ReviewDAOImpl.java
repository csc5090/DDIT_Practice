package com.our_middle_project.dao;

import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;

import com.our_middle_project.dto.FileImageDTO;
import com.our_middle_project.dto.ReviewDTO;
import com.our_middle_project.util.MybatisUtil;

public class ReviewDAOImpl implements ReviewDAO {

	public ReviewDAOImpl() {
	} // 기본 생성자

	// 리뷰 게시글 insert
	@Override
	public int insertBoard(ReviewDTO dto) {
		try (SqlSession session = MybatisUtil.getSqlSession()) {
			int result = session.insert("mappers.reviewMapper.insertBoard", dto);
			session.commit(); // auto-commit=false라면 반드시 commit
			return result;
		} catch (Exception e) {
			e.printStackTrace();
			return 0;
		}
	}

	// 이미지 insert
	@Override
	public int insertImage(FileImageDTO img) {
		try (SqlSession session = MybatisUtil.getSqlSession()) {
			int result = session.insert("mappers.reviewMapper.insertImage", img);
			session.commit();
			return result;
		} catch (Exception e) {
			e.printStackTrace();
			return 0;
		}
	}

	// 작성자 별점 insert
	@Override
	public int insertAuthorStar(int boardNo, int memNo, int star) {
		try (SqlSession session = MybatisUtil.getSqlSession()) {
			Map<String, Object> param = new HashMap<>();
			param.put("boardNo", boardNo);
			param.put("memNo", memNo);
			param.put("star", star);
			int result = session.insert("mappers.reviewMapper.insertAuthorStar", param);
			session.commit();
			return result;
		} catch (Exception e) {
			e.printStackTrace();
			return 0;
		}
	}

	// Review 목록 조회 (select)
	@Override
	public List<ReviewDTO> selectReview() {
		try (SqlSession session = MybatisUtil.getSqlSession()) {
			return session.selectList("mappers.reviewMapper.selectReview");
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}

	@Override
	public int getTodayReviewCount() {
		try (SqlSession sqlSession = MybatisUtil.getSqlSession()) {
			return sqlSession.selectOne("mappers.reviewMapper.getTodayReviewCount");
		} catch (Exception e) {
			e.printStackTrace();
			return 0;
		}
	}

	@Override
	public List<Map<String, Object>> getRatingDistribution() {
		try (SqlSession sqlSession = MybatisUtil.getSqlSession()) {
			return sqlSession.selectList("mappers.reviewMapper.getRatingDistribution");
		} catch (Exception e) {
			e.printStackTrace();
			return Collections.emptyList();
		}
	}
}