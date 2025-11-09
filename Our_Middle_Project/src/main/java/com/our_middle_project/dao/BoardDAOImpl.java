package com.our_middle_project.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;

import com.our_middle_project.dto.BoardDTO;
import com.our_middle_project.util.MybatisUtil;

public class BoardDAOImpl implements BoardDAO {

	private SqlSession sqlSession;
	
	public BoardDAOImpl() {}

	public BoardDAOImpl(SqlSession sqlSession) {
		this.sqlSession = sqlSession;
	}

	@Override
	public List<BoardDTO> selectFreeBoard(SqlSession session) {
		List<BoardDTO> list = new ArrayList<>();
		list = sqlSession.selectList("boardMapper.selectFreeBoard");
		return list;
	}

	@Override
	public BoardDTO selectBoardCont(String boardNo, SqlSession session) {
		return session.selectOne("boardMapper.selectBoardCont", boardNo);
	}// 게시물 상세내용

	@Override
	public List<BoardDTO> selectBoardList(int start, int pageSize, SqlSession session) {
		int end = start + pageSize - 1; // 끝 인덱스 계산

		return session.selectList("boardMapper.selectBoardList", new java.util.HashMap<String, Integer>() {
			{
				put("start", start);
				put("end", end);
			}
		});
	}

	@Override
	public int selectBoardCount(SqlSession session) {
		return session.selectOne("boardMapper.selectBoardCount");
	}

	// 게시글 수정
	@Override
	public int updateBoard(BoardDTO board, SqlSession session) {
		return session.update("boardMapper.updateBoard", board);
	}

	// 본인 글 체크용
	@Override
	public BoardDTO selectBoardForEdit(String boardNo, String memNo, SqlSession session) {
		BoardDTO param = new BoardDTO();
		param.setBoardNo(boardNo);
		param.setMemNo(memNo);
		return session.selectOne("boardMapper.selectBoardForEdit", param);
	}

	@Override
	public int insertBoard(BoardDTO dto, SqlSession session) {
		return session.insert("boardMapper.insertBoard", dto);
	}

	// 삭제 폼
	@Override
	public int deleteBoard(BoardDTO boardDTO, SqlSession session) {
		return session.update("deleteBoard", boardDTO);
	}

	@Override
	public int getTodayPostCount() {
		try (SqlSession sqlSession = MybatisUtil.getSqlSession()) {
			return sqlSession.selectOne("boardMapper.getTodayPostCount");
		} catch (Exception e) {
			e.printStackTrace();
			return 0;
		}
	}

	@Override
	public Map<String, Object> getCommunityMix(Map<String, Object> params) {
		try (SqlSession sqlSession = MybatisUtil.getSqlSession()) {
			return sqlSession.selectOne("boardMapper.getCommunityMix", params);
		} catch (Exception e) {
			e.printStackTrace();
			// 오류 발생 시 기본값 0으로 채운 맵 반환
			Map<String, Object> errorMap = new HashMap<>();
			errorMap.put("POSTS", 0);
			errorMap.put("COMMENTS", 0);
			errorMap.put("REVIEWS", 0);
			return errorMap;
		}
	}

}
