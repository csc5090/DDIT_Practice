package com.our_middle_project.dao;

import java.util.List;
import java.util.Map;
import org.apache.ibatis.session.SqlSession;
import com.our_middle_project.dto.AdminReviewDTO;
import com.our_middle_project.util.MybatisUtil;

public class AdminReviewDAOImpl implements AdminReviewDAO {

	private String namespace = "AdminReviewMappers";

	@Override
	public List<AdminReviewDTO> selectAllReviews(String keyword) {
		try (SqlSession session = MybatisUtil.getSqlSession()) {
			return session.selectList(namespace + ".selectAllReviews", keyword);
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}

	@Override
	public int upsertAdminReply(Map<String, Object> params) {
		try (SqlSession session = MybatisUtil.getSqlSession()) {
			return session.update(namespace + ".upsertAdminReply", params);
		} catch (Exception e) {
			e.printStackTrace();
			return 0;
		}
	}

	@Override
	public int deleteReviewImage(int boardNo) {
		try (SqlSession session = MybatisUtil.getSqlSession()) {
			return session.delete(namespace + ".deleteReviewImage", boardNo);
		} catch (Exception e) {
			e.printStackTrace();
			return 0;
		}
	}

	@Override
	public int deleteReview(int boardNo) {
		try (SqlSession session = MybatisUtil.getSqlSession()) {
			return session.update(namespace + ".deleteReview", boardNo);
		} catch (Exception e) {
			e.printStackTrace();
			return 0;
		}
	}
}