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

	@Override
	public List<BoardDTO> selectFreeBoard() {
		
		List<BoardDTO> list = new ArrayList<>();
		
		try {
			SqlSession session = MybatisUtil.getSqlSession();
			BoardDAO dao = new BoardDAOImpl(session);
			list = dao.selectFreeBoard(session);
		}catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	@Override
	public BoardDTO selectBoardCont(String boardNo) {

		BoardDTO dto = null;

		try {
			SqlSession session = MybatisUtil.getSqlSession();
			BoardDAO dao = new BoardDAOImpl(session);
			dto = dao.selectBoardCont(boardNo, session);

		} catch (Exception e) {
			e.printStackTrace();
		}
		return dto;
	}

	@Override
	public List<BoardDTO> getBoardList(int page, int pageSize) {
	    List<BoardDTO> list = new ArrayList<>();
	    int start = (page - 1) * pageSize; // 페이지 시작 글 번호 계산

	    try {
	        SqlSession session = MybatisUtil.getSqlSession();
	        BoardDAO dao = new BoardDAOImpl(session); // DAO 객체 생성
	        list = dao.selectBoardList(start, pageSize, session); // 객체 메서드 호출
	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return list;
	}

	@Override
	public int getTotalCount() {
	    int total = 0;
	    try {
	        SqlSession session = MybatisUtil.getSqlSession();
	        BoardDAO dao = new BoardDAOImpl(session);
	        total = dao.selectBoardCount(session); // 객체 메서드 호출
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return total;
	}

	
	@Override
    public int updateBoard(BoardDTO board) {
        int result = 0;
        try (SqlSession session = MybatisUtil.getSqlSession()) {
            BoardDAO dao = new BoardDAOImpl(session);
            result = dao.updateBoard(board, session);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

	@Override
    public BoardDTO selectBoardForEdit(String boardNo, String memNo) {
        BoardDTO dto = null;
        try (SqlSession session = MybatisUtil.getSqlSession()) {
            BoardDAO dao = new BoardDAOImpl(session);
            dto = dao.selectBoardForEdit(boardNo, memNo, session);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return dto;
    }

	//새 글 작성
	@Override
	public int insertBoard(BoardDTO dto) {
	    int result = 0;
	    try (SqlSession session = MybatisUtil.getSqlSession()) {
	        BoardDAO dao = new BoardDAOImpl(session);
	        result = dao.insertBoard(dto, session);
	        session.commit();  // 트랜잭션 커밋 필수
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return result;
    }

	@Override
	public boolean deleteBoard(BoardDTO boardDTO) {
	    int result = 0;
	    try (SqlSession session = MybatisUtil.getSqlSession()) {
	        BoardDAO dao = new BoardDAOImpl(session);
	        result = dao.deleteBoard(boardDTO, session);  // DAO 메서드에 session 전달
	        session.commit();  // 트랜잭션 커밋 필수
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return result > 0;
	}

}
