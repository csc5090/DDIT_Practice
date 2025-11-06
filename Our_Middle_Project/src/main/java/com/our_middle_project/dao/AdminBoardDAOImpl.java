package com.our_middle_project.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;

import com.our_middle_project.dto.AdminBoardDTO;
import com.our_middle_project.dto.AdminCommentDTO; // [추가]
import com.our_middle_project.util.MybatisUtil;

public class AdminBoardDAOImpl implements AdminBoardDAO {

	private String namespace = "com.our_middle_project.dao.AdminBoardDAO";

	@Override
	public List<AdminBoardDTO> getAdminBoardList() {
		try (SqlSession session = MybatisUtil.getSqlSession()) {
			return session.selectList(namespace + ".getAdminBoardList");
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("AdminBoardDAOImpl getAdminBoardList() 문제 발생.");
			return null;
		}
	}

	@Override
	public int insertNotice(AdminBoardDTO dto) {
		try (SqlSession session = MybatisUtil.getSqlSession()) {
			return session.insert(namespace + ".insertNotice", dto);
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("AdminBoardDAOImpl insertNotice() 문제 발생");
			return 0;
		}
	}

	@Override
	public int updateNotice(AdminBoardDTO dto) {
		try (SqlSession session = MybatisUtil.getSqlSession()) {
			return session.update(namespace + ".updateNotice", dto);
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("AdminBoardDAOImpl updateNotice() 문제 발생");
			return 0;
		}
	}

	@Override
	public int deleteNotice(int board_no) {
		try (SqlSession session = MybatisUtil.getSqlSession()) {
			return session.delete(namespace + ".deleteNotice", board_no);
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("AdminBoardDAOImpl deleteNotice() 문제 발생");
			return 0;
		}
	}

	// --- 게시물 관리 ---

	@Override
	public List<AdminBoardDTO> getAdminPostList() {
		try (SqlSession session = MybatisUtil.getSqlSession()) {
			return session.selectList(namespace + ".getAdminPostList");
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("AdminBoardDAOImpl getAdminPostList() 문제 발생.");
			return null;
		}
	}

	@Override
	public int deletePost(int board_no) {
		try (SqlSession session = MybatisUtil.getSqlSession()) {
			return session.update(namespace + ".deletePost", board_no);
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("AdminBoardDAOImpl deletePost() (soft delete) 문제 발생");
			return 0;
		}
	}

	@Override
	public int updatePost(AdminBoardDTO dto) {
		try (SqlSession session = MybatisUtil.getSqlSession()) {
			return session.update(namespace + ".updatePost", dto);
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("AdminBoardDAOImpl updatePost() 문제 발생");
			return 0;
		}
	}

	// 댓글 관리

	@Override
	public List<AdminCommentDTO> getPostComments(int board_no) {
		try (SqlSession session = MybatisUtil.getSqlSession()) {
			return session.selectList(namespace + ".getPostComments", board_no);
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("AdminBoardDAOImpl getPostComments() 문제 발생.");
			return null;
		}
	}

	@Override
	public int deleteComment(int reply_no) {
		try (SqlSession session = MybatisUtil.getSqlSession()) {
			return session.delete(namespace + ".deleteComment", reply_no);
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("AdminBoardDAOImpl deleteComment() 문제 발생.");
			return 0;
		}
	}

	@Override
	public int restorePost(int board_no) {
		try (SqlSession session = MybatisUtil.getSqlSession()) {
			return session.update(namespace + ".restorePost", board_no);
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("AdminBoardDAOImpl restorePost() 문제 발생.");
			return 0;
		}
	}

	@Override
	public int hardDeletePost(int board_no) {
		try (SqlSession session = MybatisUtil.getSqlSession()) {
			return session.delete(namespace + ".hardDeletePost", board_no);
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("AdminBoardDAOImpl hardDeletePost() 문제 발생.");
			return 0;
		}
	}

}