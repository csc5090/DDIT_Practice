package com.our_middle_project.service;

import java.util.ArrayList;
import java.util.List;

import org.apache.ibatis.session.SqlSession;

import com.our_middle_project.dao.BoardDAO;
import com.our_middle_project.dao.BoardDAOImpl;
import com.our_middle_project.dto.BoardDTO;
import com.our_middle_project.serviceInterface.BoardService;
import com.our_middle_project.util.MybatisUtil;

public class BoardServiceImpl implements BoardService {
	
	private BoardDAO boardDao;
	
	@Override
	public List<BoardDTO> selectFreeBoard(BoardDTO board) {
		
		List<BoardDTO> list = new ArrayList<>();
		
		try {
			SqlSession session = MybatisUtil.getSqlSession();
			BoardDAO dao = new BoardDAOImpl(session);
			list = dao.selectFreeBoard(board,session);
		}catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}
	
	@Override
	public BoardDTO getBoardCont(int boardNo) {
		return this.boardDao.getBoardCont(boardNo);
	}//번호에 해당하는 게시판 내용보기

	
	
	
}
