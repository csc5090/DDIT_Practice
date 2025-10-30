package com.our_middle_project.service;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;

import com.our_middle_project.dao.MemberDAO;
import com.our_middle_project.dao.MemberDAOImpl;
import com.our_middle_project.dto.MemberDTO;
import com.our_middle_project.serviceInterface.AdminService;
import com.our_middle_project.util.MybatisUtil;

public class AdminServiceImpl implements AdminService {

	@Override
	public int getTotalUserCount() {
		// try-with-resources: 이 블록이 끝나면 sqlSession이 자동으로 닫힘.
		try (SqlSession sqlSession = MybatisUtil.getSqlSession()) {
			// 1. DAO 작업자(Impl)를 생성하고, 일할 도구(sqlSession)를 준다.
			MemberDAO memberDAO = new MemberDAOImpl(sqlSession);

			// 2. 작업자에게 일을 시키고 결과를 받는다.
			return memberDAO.getTotalUserCount();
		}
	}

	@Override
	public int getNewUserCountToday() {
		try (SqlSession sqlSession = MybatisUtil.getSqlSession()) {
			MemberDAO memberDAO = new MemberDAOImpl(sqlSession);
			return memberDAO.getNewUserCountToday();
		}
	}

	@Override
	public List<MemberDTO> getUsersByKeyword(String keyword) {
		try (SqlSession sqlSession = MybatisUtil.getSqlSession()) {
			MemberDAO memberDAO = new MemberDAOImpl(sqlSession);
			// DAO에게는 이제 'keyword' 정보만 전달합니다.
			return memberDAO.selectUsersByKeyword(keyword);
		}
	}

	@Override
	public List<Map<String, Object>> getDailySignupStats() {
		try (SqlSession sqlSession = MybatisUtil.getSqlSession()) {

			MemberDAO memberDAO = new MemberDAOImpl(sqlSession);
			return memberDAO.selectDailySignupStats();
		}
	}

	@Override
	public MemberDTO getUserDetails(String memberId) {
		try (SqlSession sqlSession = MybatisUtil.getSqlSession()) {
			// 1. DAO 작업자를 생성하고, 일할 도구(sqlSession)를 줍니다.
			MemberDAO memberDAO = new MemberDAOImpl(sqlSession);

			// 2. 작업자에게 memberId를 전달하여 사용자 한 명의 정보를 가져오도록 시킵니다.
			return memberDAO.selectUserDetails(memberId);
		}
	}

	@Override
	public boolean updateUser(MemberDTO memberDTO) {
		try (SqlSession sqlSession = MybatisUtil.getSqlSession()) {
			MemberDAO memberDAO = new MemberDAOImpl(sqlSession);
			
			int result = memberDAO.updateUser(memberDTO);

			// 중요: UPDATE, INSERT, DELETE 후에는 반드시 commit()!
			sqlSession.commit();
			
			return result > 0;
		}

	}
	
	/*   //null 작업 후에 교체할 것.
	 * @Override public boolean updateUser(MemberDTO memberDTO) { try (SqlSession
	 * sqlSession = MybatisUtil.getSqlSession()) { MemberDAO memberDAO = new
	 * MemberDAOImpl(sqlSession);
	 * 
	 * // 비즈니스 규칙 적용: 'USER' 역할은 DB에 NULL로 저장 if
	 * ("USER".equals(memberDTO.getRole())) { memberDTO.setRole(null); }
	 * 
	 * int result = memberDAO.updateUser(memberDTO); sqlSession.commit(); return
	 * result > 0; } }
	 */
	

}