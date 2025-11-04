package com.our_middle_project.serviceInterface;

import java.util.List;

import org.apache.ibatis.session.SqlSession;

import com.our_middle_project.dto.BoardDTO;

public interface BoardService {
	public List<BoardDTO> selectFreeBoard(BoardDTO board);
	
	public BoardDTO getBoardCont(int boardNo);




	
	

}
