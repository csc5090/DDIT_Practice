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

public class BoardWriteController implements Action {

	@Override
	public ActionForward execute(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
        BoardService boardService = new BoardServiceImpl();
        ActionForward forward = new ActionForward();
        forward.setRedirect(false);

        String state = request.getParameter("state"); // submit

        HttpSession session = request.getSession();
        String loginUserId = (String) session.getAttribute("memId"); // 로그인 세션

        // 로그인 체크
        if (loginUserId == null) {
            ActionForward f = new ActionForward();
            f.setRedirect(true);
            f.setPath("/login.do");
            System.out.println("로그인 해라... ");
            return f;
        }

        if ("submit".equals(state)) {
            // 폼에서 넘어온 값 가져오기
            String title = request.getParameter("title");
            String content = request.getParameter("content");

            BoardDTO dto = new BoardDTO();
            dto.setBoardTitle(title);
            dto.setBoardContent(content);
            dto.setMemId(loginUserId); // 세션의 로그인 아이디

            int result = boardService.insertBoard(dto);
            

            if (result > 0) {
                forward.setRedirect(true);
                forward.setPath("boardList.do"); // 글 등록 후 목록으로
            } else {
                request.setAttribute("msg", "글 작성 실패!");
                forward.setPath("/WEB-INF/our_middle_project_view/error.jsp");
            }
        } else {
            // state가 없으면 글쓰기 폼 보여주기
            forward.setPath("/WEB-INF/our_middle_project_view/board/boardWrite.jsp");
        }

        return forward;
	}

}
