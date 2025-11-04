package com.our_middle_project.controller;

import java.io.IOException;
import java.util.List;

import com.our_middle_project.action.Action;
import com.our_middle_project.action.ActionForward;
import com.our_middle_project.dto.BoardDTO;
import com.our_middle_project.service.BoardServiceImpl;
import com.our_middle_project.serviceInterface.BoardService;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class BoardController implements Action {
	@Override
	public ActionForward execute(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
	    BoardService boardService = new BoardServiceImpl();

	    // 1) 페이지 정보 받기 (파라미터 없으면 1페이지)
	    int page = 1;
	    int pageSize = 10; 
	    String pageParam = request.getParameter("page");
	    if (pageParam != null) {
	        page = Integer.parseInt(pageParam);
	    }

	    // 2) Service 호출
	    List<BoardDTO> boardList = boardService.getBoardList(page, pageSize);
	    int totalCount = boardService.getTotalCount();

	    // 3) JSP로 데이터 전달
	    request.setAttribute("boardList", boardList);
	    request.setAttribute("currentPage", page);
	    request.setAttribute("pageSize", pageSize);
	    request.setAttribute("totalCount", totalCount);

	    ActionForward forward = new ActionForward();
	    forward.setRedirect(false);
	    forward.setPath("/WEB-INF/our_middle_project_view/board/board.jsp");
	    return forward;
	}

}
