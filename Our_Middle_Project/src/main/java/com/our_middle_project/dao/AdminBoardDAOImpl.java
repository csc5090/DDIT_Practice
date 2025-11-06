package com.our_middle_project.dao;

import java.util.List;
import org.apache.ibatis.session.SqlSession;
import com.our_middle_project.dto.AdminBoardDTO;
import com.our_middle_project.util.MybatisUtil;

public class AdminBoardDAOImpl implements AdminBoardDAO {

	private String namespace = "com.our_middle_project.dao.AdminBoardDAO";

	@Override
	public List<AdminBoardDTO> getAdminBoardList() {
		SqlSession session = MybatisUtil.getSqlSession();
		try {
			return session.selectList(namespace + ".getAdminBoardList");
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("AdminBoardDAOImpl getAdminBoardList() 문제 발생.");
			return null;
		} finally {
			if (session != null)
				session.close();
		}
	}

	@Override
	public int insertNotice(AdminBoardDTO dto) {
		SqlSession session = MybatisUtil.getSqlSession();
		try {
			int result = session.insert(namespace + ".insertNotice", dto);
			session.commit();
			return result;
		} catch (Exception e) {
			session.rollback();
			e.printStackTrace();
			System.out.println("AdminBoardDAOImpl insertNotice() 문제 발생");
			return 0;
		} finally {
			if (session != null)
				session.close();
		}
	}

	@Override
	public int updateNotice(AdminBoardDTO dto) {
		SqlSession session = MybatisUtil.getSqlSession();
		try {
			int result = session.update(namespace + ".updateNotice", dto);
			session.commit();
			return result;
		} catch (Exception e) {
			session.rollback();
			e.printStackTrace();
			System.out.println("AdminBoardDAOImpl updateNotice() 문제 발생");
			return 0;
		} finally {
			if (session != null)
				session.close();
		}
	}

	@Override
	public int deleteNotice(int board_no) {
		SqlSession session = MybatisUtil.getSqlSession();
		try {
			int result = session.delete(namespace + ".deleteNotice", board_no);
			session.commit();
			return result;
		} catch (Exception e) {
			session.rollback();
			e.printStackTrace();
			System.out.println("AdminBoardDAOImpl deleteNotice() 문제 발생");
			return 0;
		} finally {
			if (session != null)
				session.close();
		}
	}

	@Override
	public List<AdminBoardDTO> getAdminPostList() {
		SqlSession session = MybatisUtil.getSqlSession();
		try {
			// AdminBoardMapper.xml에 정의된 쿼리 ID를 호출
			return session.selectList(namespace + ".getAdminPostList");
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("AdminBoardDAOImpl getAdminPostList() 문제 발생.");
			return null;
		} finally {
			if (session != null)
				session.close();
		}
	}

	@Override
	public int deletePost(int board_no) {
		SqlSession session = MybatisUtil.getSqlSession();
		try {
			// AdminBoardMapper.xml에 정의된 쿼리 ID를 호출
			int result = session.delete(namespace + ".deletePost", board_no);
			session.commit();
			return result;
		} catch (Exception e) {
			session.rollback();
			e.printStackTrace();
			System.out.println("AdminBoardDAOImpl deletePost() 문제 발생");
			return 0;
		} finally {
			if (session != null)
				session.close();
		}
	}

}