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

public class BoardContController implements Action {

	@Override
	public ActionForward execute(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException { 

		System.out.println("게시물 상세보기 ㅎㅇ");
		
		
		BoardService boardService = new BoardServiceImpl();

		int boardNo = Integer.parseInt(request.getParameter("boardNo"));
		String state = request.getParameter("state");

		int page = 1;
		if(request.getParameter("page") != null) {
		    page = Integer.parseInt(request.getParameter("page"));
		}

		// 게시글 상세 조회
		BoardDTO bc = boardService.selectBoardCont(String.valueOf(boardNo)); // service 메소드 호출
		String boardContHtml = bc.getBoardContent().replace("\n", "<br/>");

		request.setAttribute("b", bc);
		request.setAttribute("bcont", boardContHtml);
		request.setAttribute("page", page);

		ActionForward forward = new ActionForward();
		forward.setRedirect(false);

		if("cont".equals(state)) {
		    forward.setPath("/WEB-INF/our_middle_project_view/board/boardCont.jsp");    
		} else if("edit".equals(state)) {
		    forward.setPath("/WEB-INF/our_middle_project_view/board/boardEdit.jsp");
		}

		return forward;
	}
}
