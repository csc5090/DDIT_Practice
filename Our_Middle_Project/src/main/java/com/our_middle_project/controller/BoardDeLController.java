package com.our_middle_project.controller;

import java.io.IOException;

import com.our_middle_project.action.Action;
import com.our_middle_project.action.ActionForward;
import com.our_middle_project.dto.BoardDTO;
import com.our_middle_project.service.BoardServiceImpl;
import com.our_middle_project.serviceInterface.BoardService;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class BoardDeLController implements Action {

	@Override
	public ActionForward execute(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		System.out.println("================");
		
		System.out.println(request.getParameter("boardNo"));
		String boardNoParam = request.getParameter("boardNo");
		System.out.println("값: " + boardNoParam);
		System.out.println("타입: " + ((boardNoParam == null) ? "null" : boardNoParam.getClass().getName()));
		
	    BoardService boardService = new BoardServiceImpl(); 
	    BoardDTO boardDTO = new BoardDTO();
	    boardDTO.setBoardNo(request.getParameter("boardNo"));
	    
	    boolean deleted = boardService.deleteBoard(boardDTO);
	    System.out.println(deleted);

	    // 삭제 성공 시 board.do로 이동
	    ActionForward forward = new ActionForward();
	    forward.setRedirect(true); // true = sendRedirect
	    forward.setPath("/board.do");
	    return forward;
	}

}
