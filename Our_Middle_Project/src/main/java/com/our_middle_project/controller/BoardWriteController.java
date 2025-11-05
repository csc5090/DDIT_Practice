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

public class BoardWriteController implements Action {

	@Override
	public ActionForward execute(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		System.out.println("글쓰기 ㅎㅇ");
		
        BoardService boardService = new BoardServiceImpl();
        ActionForward forward = new ActionForward();
        forward.setRedirect(false);

        String state = request.getParameter("state"); // submit

        HttpSession session = request.getSession();
        UserInfoDTO loginUser = (UserInfoDTO) session.getAttribute("loginUser");
        System.out.println(loginUser);
        System.out.println(loginUser.getMem_id());
        String userID = loginUser.getMem_id();
        // 로그인 체크
        if (userID == null) {
            ActionForward forward_ = new ActionForward();
            forward_.setRedirect(true);
            forward_.setPath("/login.do");
            System.out.println(loginUser);
            System.out.println("로그인 해라... ");
            return forward_;
        }
        
        // 로그인 사용자의 memNo 가져오기
        String loginUserMemNo = String.valueOf(loginUser.getMem_no());
        
        
        if ("submit".equals(state)) {
            // 폼에서 넘어온 값 가져오기
            String title = request.getParameter("title");
            String content = request.getParameter("content");
            
            BoardDTO dto = new BoardDTO();
            dto.setBoardTitle(title);
            dto.setBoardContent(content);
            dto.setMemNo(loginUserMemNo);
            dto.setViewCount((int)(Math.random() * 1000) + 1);          //  조회수 랜덤값 주기
            dto.setLikeCount((int)(Math.random() * 10) + 1);          //  좋아요 랜덤값 주기 
            dto.setDislikeCount(0);       // 여기서 3으로 고정
            dto.setTypeNo("3"); 

            int result = boardService.insertBoard(dto);
            

            if (result > 0) {
                forward.setRedirect(true);
                System.out.println("성공");
                forward.setPath("/board.do"); // 글 등록 후 목록으로
            } else {
                request.setAttribute("msg", "글 작성 실패!");
                System.out.println("실패");
                forward.setPath("/WEB-INF/our_middle_project_view/error.jsp");
            }
        } else {
            // state가 없으면 글쓰기 폼 보여주기
        	System.out.println("state가 없다");
            forward.setPath("/WEB-INF/our_middle_project_view/board/boardWrite.jsp");
        }

        return forward;
	}

}
