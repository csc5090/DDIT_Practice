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

		BoardService boardService = new BoardServiceImpl(); 
		
		System.out.println("게시판 내용 ㅎㅇ");
		
		int boardNo=Integer.parseInt(request.getParameter("boardNo"));
		String state=request.getParameter("state");

		int page=1;
		if(request.getParameter("page") != null) {
			page=Integer.parseInt(request.getParameter("page"));			
		}

//		if(state.equals("cont")) {//내용보기일때만 조회수 증가
//			boardService.updateHit(board_no);
//		}
		
		BoardDTO bc=boardService.getBoardCont(boardNo);
		String boardContHtml= bc.getBoardContent().replace("\n","<br/>");


		request.setAttribute("b", bc);
		request.setAttribute("bcont",boardContHtml);
		request.setAttribute("page",page);//키,값 쌍으로 저장
		
		ActionForward forward = new ActionForward();
		forward.setRedirect(false);
		
		if(state.equals("cont")) {//내용보기
			forward.setPath("/WEB-INF/our_middle_project_view/board/boardCont.jsp");	
			
			//board_cont.jsp 뷰페이지로 이동
//		}else if(state.equals("reply")) {//답변글 폼
//			forward.setPath("./WEB-INF/views/board/board_reply.jsp");	
			
		}else if(state.equals("edit")) {//수정폼
			forward.setPath("/WEB-INF/our_middle_project_view/board/boardEdit.jsp");
			
//		}else if(state.equals("del")) {//삭제폼
//			forward.setPath("./WEB-INF/views/board/board_del.jsp");
		}		
		return forward;		
	}
}
