package com.our_middle_project.controller;

import java.io.IOException;

import com.our_middle_project.action.Action;
import com.our_middle_project.action.ActionForward;
import com.our_middle_project.dto.BoardDTO;
import com.our_middle_project.dto.UserInfoDTO;
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

        System.out.println("BoardEditController 실행");

        BoardService boardService = new BoardServiceImpl();
        ActionForward forward = new ActionForward();
        forward.setRedirect(false);

        String state = request.getParameter("state"); // form / submit
        String boardNo = request.getParameter("boardNo");

        HttpSession session = request.getSession();

        // 세션에서 로그인 사용자 DTO 꺼내기
        UserInfoDTO loginUser = (UserInfoDTO) session.getAttribute("loginUser");

        // 로그인 안했으면 로그인 페이지로
        if (loginUser == null) {
            ActionForward f = new ActionForward();
            f.setRedirect(true);
            f.setPath("/login.do");
            return f;
        }

        // 로그인 되었으면 memNo 꺼내기
        String memNo = String.valueOf(loginUser.getMem_no());

        System.out.println("memNo = " + memNo);
        System.out.println("boardNo = " + boardNo);
        System.out.println("state = " + state);

        if ("form".equals(state)) {
            // 수정폼 보여주기
            BoardDTO dto = boardService.selectBoardForEdit(boardNo, memNo);

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
            dto.setBoardTitle("[자유]" + title);
            dto.setBoardContent(content);
            dto.setMemNo(memNo); // DB의 MEM_NO 컬럼 기준

            int result = boardService.updateBoard(dto);

            if (result > 0) {
            	forward.setRedirect(true);
            	forward.setPath("/board.do");
            } else {
                request.setAttribute("msg", "수정 실패! 본인 글만 수정 가능합니다.");
                forward.setPath("/WEB-INF/our_middle_project_view/error.jsp");
            }
        }

        System.out.println("[BoardEditController] Forward Path: " + forward.getPath());
        return forward;
    }
}
