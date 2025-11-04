package com.our_middle_project.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;

import com.our_middle_project.dto.BoardDTO;

public interface BoardDAO {
	public List<BoardDTO> selectFreeBoard(BoardDTO board,SqlSession session);
	
	public BoardDTO selectBoardCont(String boardNo);


	
}
