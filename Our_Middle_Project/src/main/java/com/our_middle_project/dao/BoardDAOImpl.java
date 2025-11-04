package com.our_middle_project.dao;

import java.util.ArrayList;
import java.util.List;

import org.apache.ibatis.session.SqlSession;

import com.our_middle_project.dto.BoardDTO;
import com.our_middle_project.util.MybatisUtil;

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
	public BoardDTO selectBoardCont(String boardNo) {
		SqlSession session = MybatisUtil.getSqlSession(); 
		BoardDTO dto = null;

		try {
			dto = session.selectOne("boardMapper.selectBoardCont", boardNo);
		} finally {
			session.close();
		}
		return dto;
	}


}
