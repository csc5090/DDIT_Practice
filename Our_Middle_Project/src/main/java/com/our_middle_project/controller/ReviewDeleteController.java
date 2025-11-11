package com.our_middle_project.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Map;

import com.google.gson.Gson;
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
	private final Gson gson = new Gson();

	@Override
	public ActionForward execute(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		// 1. (★) 로그인 세션 확인
		HttpSession session = request.getSession(false);
		if (session == null || session.getAttribute("loginUser") == null) {
			sendJsonResponse(response, HttpServletResponse.SC_UNAUTHORIZED, "error", "로그인이 필요합니다.");
			return null;
		}
		UserInfoDTO loginUser = (UserInfoDTO) session.getAttribute("loginUser");
		int memNo = loginUser.getMem_no();

		// 2. (★) 파라미터 받기 (boardNo)
		// review.js에서 URLSearchParams로 보냄
		request.setCharacterEncoding("UTF-8");
		String boardNoStr = request.getParameter("boardNo");

		int boardNo = 0;
		try {
			boardNo = Integer.parseInt(boardNoStr);
		} catch (NumberFormatException e) {
			sendJsonResponse(response, HttpServletResponse.SC_BAD_REQUEST, "error", "잘못된 요청입니다.");
			return null;
		}

		// 3. (★) 서비스 호출 (트랜잭션 삭제)
		// (ServiceImpl에서 본인 확인(Authority)까지 처리)
		boolean isSuccess = reviewService.deleteReviewTransaction(boardNo, memNo);

		// 4. (★) 결과 JSON으로 응답
		if (isSuccess) {
			sendJsonResponse(response, HttpServletResponse.SC_OK, "success", "리뷰가 삭제되었습니다.");
		} else {
			sendJsonResponse(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "error",
					"삭제에 실패했습니다. (권한이 없거나 서버 오류)");
		}

		return null; // AJAX 컨트롤러는 항상 null을 반환
	}

	// JSON 응답을 위한 헬퍼 메서드
	private void sendJsonResponse(HttpServletResponse response, int status, String result, String message)
			throws IOException {
		response.setStatus(status);
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		PrintWriter out = response.getWriter();
		out.print(gson.toJson(Map.of("status", result, "message", message)));
		out.flush();
	}
}