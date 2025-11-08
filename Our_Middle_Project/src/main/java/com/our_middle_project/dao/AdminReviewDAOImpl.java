package com.our_middle_project.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;

import com.our_middle_project.dto.AdminBoardImageDTO;
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
	public int deleteReviewImageByFileNo(int fileNo) {
		try (SqlSession session = MybatisUtil.getSqlSession()) {
			return session.delete(namespace + ".deleteReviewImageByFileNo", fileNo);
		} catch (Exception e) {
			e.printStackTrace();
			return 0;
		}
	}

	@Override
	public int deleteReviewImagesByFileNos(List<Integer> fileNos) {
		if (fileNos == null || fileNos.isEmpty())
			return 0;
		try (SqlSession session = MybatisUtil.getSqlSession()) {
			return session.delete(namespace + ".deleteReviewImagesByFileNos", fileNos);
		} catch (Exception e) {
			e.printStackTrace();
			return 0;
		}
	}

	@Override
	public int deleteAllReviewImagesByBoardNo(int boardNo) {
		try (SqlSession session = MybatisUtil.getSqlSession()) {
			return session.delete(namespace + ".deleteAllReviewImagesByBoardNo", boardNo);
		} catch (Exception e) {
			e.printStackTrace();
			return 0;
		}
	}

	@Override
	public int deleteReviewReplies(int boardNo) {
		try (SqlSession session = MybatisUtil.getSqlSession()) {
			return session.delete(namespace + ".deleteReviewReplies", boardNo);
		} catch (Exception e) {
			e.printStackTrace();
			return 0;
		}
	}

	@Override
	public int deleteReviewStars(int boardNo) {
		try (SqlSession session = MybatisUtil.getSqlSession()) {
			return session.delete(namespace + ".deleteReviewStars", boardNo);
		} catch (Exception e) {
			e.printStackTrace();
			return 0;
		}
	}

	@Override
	public int deleteReview(int boardNo) {
		try (SqlSession session = MybatisUtil.getSqlSession()) {
			return session.delete(namespace + ".deleteReview", boardNo);
		} catch (Exception e) {
			e.printStackTrace();
			return 0;
		}
	}

	@Override
	public List<AdminBoardImageDTO> selectReviewImages(int boardNo) {
		try (SqlSession session = MybatisUtil.getSqlSession()) {
			return session.selectList(namespace + ".selectReviewImages", boardNo);
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}

	@Override
	public void deleteBoardDislikes(int boardNo) {
		try (SqlSession session = MybatisUtil.getSqlSession()) {
			session.delete(namespace + ".deleteBoardDislikes", boardNo);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	

}