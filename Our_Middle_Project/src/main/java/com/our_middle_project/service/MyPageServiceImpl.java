package com.our_middle_project.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;

import com.our_middle_project.dao.MyPageDAO;
import com.our_middle_project.dao.MyPageDAOImpl;
import com.our_middle_project.dto.GameLogDTO;
import com.our_middle_project.dto.RankingDTO;
import com.our_middle_project.dto.UserInfoDTO;
import com.our_middle_project.pwencrypt.PWencrypt;
import com.our_middle_project.serviceInterface.MyPageService;
import com.our_middle_project.util.MybatisUtil;

public class MyPageServiceImpl implements MyPageService {

	@Override
	public UserInfoDTO getMyUserData(UserInfoDTO loingUser) {
		UserInfoDTO result;
		try(SqlSession sqlSession = MybatisUtil.getSqlSession()) {
			MyPageDAO myPageDAO = new MyPageDAOImpl(sqlSession);
			result = myPageDAO.getMyUserData(loingUser);
		}
		return result;
	}

	@Override
	public List<RankingDTO> getMyRankingData(UserInfoDTO loingUser) {
		List<RankingDTO> result;
		try(SqlSession sqlSession = MybatisUtil.getSqlSession()) {
			MyPageDAO myPageDAO = new MyPageDAOImpl(sqlSession);
			result = myPageDAO.getMyRankingData(loingUser);
		}
		return result;
	}

	@Override
	public List<GameLogDTO> getMyGameLogData(UserInfoDTO loingUser) {
		List<GameLogDTO> result;
		try(SqlSession sqlSession = MybatisUtil.getSqlSession()) {
			MyPageDAO myPageDAO = new MyPageDAOImpl(sqlSession);
			result = myPageDAO.getMyGameLogData(loingUser);
		}
		return result;
	}

	@Override
	public boolean deleteMember(String memId, String inputPw) {

	    try (SqlSession sqlSession = MybatisUtil.getSqlSession()) {

	        // 1) DB에서 비밀번호와 salt 가져오기
	        Map<String, String> pwData = sqlSession.selectOne("myPageMapper.getPasswordByMemId", memId);
	        if (pwData == null) return false;

	        String dbPw = pwData.get("MEM_PASS");
	        String salt = pwData.get("SALT");

	        System.out.println("dbPw=[" + dbPw + "]");
	        System.out.println("inputPw=[" + inputPw + "]");
	        System.out.println("salt=[" + salt + "]");

	        // 2) 입력값을 DB salt로 암호화
	        String inputHashed = PWencrypt.hashPassword(inputPw, salt);

	        // 3) 비교
	        if (!dbPw.equals(inputHashed)) {
	            return false; // 비밀번호 불일치
	        }

	        // 4) STATUS 업데이트
	        int updateCount = sqlSession.update("myPageMapper.updateStatusToDeleted", memId);

	        if (updateCount > 0) {
	            sqlSession.commit();  // 커밋
	            return true;
	        } else {
	            sqlSession.rollback();
	            return false;
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	        return false;
	    }
	}
	@Override
	public boolean updateMember(String memId, String nickname, String password, String hp, String mail) {

	    try (SqlSession sqlSession = MybatisUtil.getSqlSession()) {

	        Map<String, Object> params = new HashMap<>();
	        params.put("memId", memId);
	        params.put("nickname", nickname);
	        params.put("hp", hp);
	        params.put("mail", mail);

	        // 비밀번호 입력시만 암호화 처리
	        if (password != null && !password.isEmpty()) {
	        	Map<String, String> dbUser = sqlSession.selectOne("myPageMapper.getPasswordByMemId", memId);
	        	String salt = dbUser.get("SALT");
	            String encryptedPw = PWencrypt.hashPassword(password, salt);
	            params.put("mem_pass", encryptedPw);
	        }

	        int updateCount = sqlSession.update("myPageMapper.updateMemberInfo", params);

	        if (updateCount > 0) {
	            sqlSession.commit();
	            return true;
	        } else {
	            sqlSession.rollback();
	            return false;
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	        return false;
	    }
	}
}
