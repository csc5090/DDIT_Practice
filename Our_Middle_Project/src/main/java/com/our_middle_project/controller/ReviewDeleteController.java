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

public class ReviewDeleteController implements Action {

	private final ReviewService reviewService = new ReviewServiceImpl();

	@Override
	public ActionForward execute(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		// 1. (★) 로그인 세션 확인
		HttpSession session = request.getSession(false);
		if (session == null || session.getAttribute("loginUser") == null) {
			// 401: Unauthorized (인증되지 않음)
			response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
			response.getWriter().write("{\"status\": \"error\", \"message\": \"로그인이 필요합니다.\"}");
			return null;
		}
		UserInfoDTO loginUser = (UserInfoDTO) session.getAttribute("loginUser");
		int memNo = loginUser.getMem_no(); // (★) 삭제를 시도하는 사람

		// 2. (★) 삭제할 리뷰 번호 받기
		String boardNoStr = request.getParameter("boardNo");
		if (boardNoStr == null || boardNoStr.isBlank()) {
			// 400: Bad Request (잘못된 요청)
			response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
			response.getWriter().write("{\"status\": \"error\", \"message\": \"리뷰 번호가 없습니다.\"}");
			return null;
		}

		int boardNo = 0;
		try {
			boardNo = Integer.parseInt(boardNoStr);
		} catch (NumberFormatException e) {
			response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
			response.getWriter().write("{\"status\": \"error\", \"message\": \"잘못된 리뷰 번호입니다.\"}");
			return null;
		}

		// 3. (★) 서비스 호출 (트랜잭션 삭제)
		// (Service가 내부적으로 본인 확인(Authority)까지 처리)
		boolean isSuccess = reviewService.deleteReviewTransaction(boardNo, memNo);

		// 4. (★) 결과 JSON으로 응답
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		PrintWriter out = response.getWriter();

		if (isSuccess) {
			// 200: OK (성공)
			out.print("{\"status\": \"success\", \"message\": \"리뷰가 삭제되었습니다.\"}");
		} else {
			// 500: Internal Server Error (실패)
			// (Service 로직에서 본인 확인 실패 시 false를 반환)
			response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			out.print("{\"status\": \"error\", \"message\": \"삭제에 실패했습니다. (권한이 없거나 서버 오류)\"}");
		}

		out.flush();
		return null; // AJAX 컨트롤러는 항상 null을 반환
	}
}