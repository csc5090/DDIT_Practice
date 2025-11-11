package com.our_middle_project.controller;

import java.io.IOException;
import java.io.PrintWriter;

import com.our_middle_project.action.Action;
import com.our_middle_project.action.ActionForward;
import com.our_middle_project.dto.UserInfoDTO;
import com.our_middle_project.service.ReviewServiceImpl;
import com.our_middle_project.serviceInterface.ReviewService;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class ReviewUpdateController implements Action {

	private final ReviewService reviewService = new ReviewServiceImpl(); // ★ 필드 정의 유지

	@Override
	public ActionForward execute(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		// 1. (★) 로그인 세션 확인
		HttpSession session = request.getSession(false);
		if (session == null || session.getAttribute("loginUser") == null) {
			response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
			response.getWriter().write("{\"status\": \"error\", \"message\": \"로그인이 필요합니다.\"}");
			return null;
		}
		UserInfoDTO loginUser = (UserInfoDTO) session.getAttribute("loginUser");
		int memNo = loginUser.getMem_no(); // (★) 수정을 시도하는 사람

		// 2. (★) 파라미터 받기 (boardNo, boardContent, star)
		request.setCharacterEncoding("UTF-8");

		String boardNoStr = request.getParameter("boardNo");
		String boardContent = request.getParameter("boardContent");
		String starStr = request.getParameter("star");

		// 3. (★) 유효성 검사
		int boardNo = 0;
		int star = 0;
		try {
			boardNo = Integer.parseInt(boardNoStr);
			star = Integer.parseInt(starStr);
		} catch (NumberFormatException e) {
			response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
			response.getWriter().write("{\"status\": \"error\", \"message\": \"잘못된 요청입니다.\"}");
			return null;
		}
		if (boardContent == null || boardContent.trim().length() < 10) {
			response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
			response.getWriter().write("{\"status\": \"error\", \"message\": \"내용은 10자 이상 입력해야 합니다.\"}");
			return null;
		}

		// 4. (★) 서비스 호출 (트랜잭션 수정)
		boolean isSuccess = reviewService.updateReviewTransaction(boardNo, memNo, boardContent.trim(), star);

		// 5. (★) 결과 JSON으로 응답
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		PrintWriter out = response.getWriter();

		if (isSuccess) {
			out.print("{\"status\": \"success\", \"message\": \"리뷰가 수정되었습니다.\"}");
		} else {
			response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			out.print("{\"status\": \"error\", \"message\": \"수정에 실패했습니다. (권한이 없거나 서버 오류)\"}");
		}

		out.flush();
		return null;
	}
}