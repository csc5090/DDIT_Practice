package com.our_middle_project.dao;

import java.util.ArrayList;
import java.util.List;

import org.apache.ibatis.session.SqlSession;

import com.our_middle_project.dto.BoardDTO;

public class BoardDAOImpl implements BoardDAO {
	
	// 백업 됨
	
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

}
