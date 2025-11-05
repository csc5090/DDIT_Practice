package com.our_middle_project.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;

import com.our_middle_project.dto.BoardDTO;

public interface BoardDAO {
	
	// 백업 됨
	
	// 자유게시판 목록
	public List<BoardDTO> selectFreeBoard(BoardDTO board,SqlSession session);
	
	// 게시글 상세
	public BoardDTO selectBoardCont(String boardNo, SqlSession session);
	
	//특정 페이지의 게시글 리스트를 가져옴
	public List<BoardDTO> selectBoardList(int start, int pageSize, SqlSession session);
	
	//전체 게시글 수를 가져옴
	int selectBoardCount(SqlSession session);
	
	 // 1) 게시글 수정
	public int updateBoard(BoardDTO board, SqlSession session);
    
    // 2) (선택) 본인 글 확인용
	public BoardDTO selectBoardForEdit(String boardNo, String memNo, SqlSession session);

}
