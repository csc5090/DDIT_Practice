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
import jakarta.servlet.http.HttpSession;

public class BoardEditController implements Action {

	@Override
	public ActionForward execute(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		
		 BoardService boardService = new BoardServiceImpl();
	        ActionForward forward = new ActionForward();
	        forward.setRedirect(false);

	        String state = request.getParameter("state"); // form / submit
	        String boardNo = request.getParameter("boardNo");

	        HttpSession session = request.getSession();
	        session.setAttribute("memId", "testUser01");
	        
	        String loginUserId = (String) session.getAttribute("memId"); // 로그인 세션
	        
	        System.out.println("loginUserId = " + loginUserId);
	        System.out.println("boardNo = " + boardNo);
	        System.out.println("state = " + state);

	        // 로그인 안했으면 바로 로그인으로 보내기
//	        if (loginUserId == null) {
//	            ActionForward f = new ActionForward();
//	            f.setRedirect(true);
//	            f.setPath("/login.do");   
//	            System.out.println("로그인 안된 유저 or 본인 글 아닌 유저 ");
//	            return f;
//	        }
	        

	        
	        if ("form".equals(state)) { 
	            // 수정폼 보여주기
	            BoardDTO dto = boardService.selectBoardForEdit(boardNo, loginUserId);

	            if (dto == null) {
	                request.setAttribute("msg", "본인 글이 아니거나 존재하지 않는 게시물입니다.");
	                forward.setPath("/WEB-INF/our_middle_project_view/error.jsp");
	                return forward;
	            }

	            request.setAttribute("b", dto);
	            forward.setPath("/WEB-INF/our_middle_project_view/board/boardEdit.jsp");

	        } else if ("submit".equals(state)) { 
	            // 수정 처리
	            String title = request.getParameter("boardTitle");
	            String content = request.getParameter("boardContent");

	            BoardDTO dto = new BoardDTO();
	            dto.setBoardNo(boardNo);
	            dto.setBoardTitle(title);
	            dto.setBoardContent(content);
	            dto.setMemId(loginUserId);

	            int result = boardService.updateBoard(dto);

	            if (result > 0) {
	                forward.setRedirect(true);
	                forward.setPath("boardCont.do?boardNo=" + boardNo + "&state=cont");
	            } else {
	                request.setAttribute("msg", "수정 실패! 본인 글만 수정 가능합니다.");
	                forward.setPath("/WEB-INF/our_middle_project_view/error.jsp");
	            }
	        }

	        // 디버깅용 로그
	        System.out.println("[BoardEditController] Forward Path: " + forward.getPath());
	        return forward;
	    }
	}
