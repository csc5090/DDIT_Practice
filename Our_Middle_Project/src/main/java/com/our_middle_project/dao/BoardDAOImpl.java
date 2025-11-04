package com.our_middle_project.dao;

import java.util.ArrayList;
import java.util.List;

import org.apache.ibatis.session.SqlSession;

import com.our_middle_project.dto.BoardDTO;

public class BoardDAOImpl implements BoardDAO {
	
	private SqlSession sqlSession;
	
    public BoardDAOImpl(SqlSession sqlSession) {
        this.sqlSession = sqlSession;
    }
	
	@Override
	public List<BoardDTO> selectFreeBoard(BoardDTO board, SqlSession session) {
		List<BoardDTO> list = new ArrayList<>();
		list = sqlSession.selectList("boardMapper.selectFreeBoard",board);
		return list;
	}

	@Override
	public BoardDTO selectBoardCont(String boardNo, SqlSession session) {
		return session.selectOne("boardMapper.selectBoardCont", boardNo);
	}//게시물 상세내용

	
	@Override
	public List<BoardDTO> selectBoardList(int start, int pageSize, SqlSession session) {
        return session.selectList("BoardMapper.selectBoardList", 
                new java.util.HashMap<String, Integer>() {{
                    put("start", start);
                    put("pageSize", pageSize);
                }});
	}

	@Override
	public int selectBoardCount(SqlSession session) {
		return session.selectOne("boardMapper.selectBoardCount");
	}

}
