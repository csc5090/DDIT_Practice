package com.our_middle_project.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import com.google.gson.Gson;
import com.our_middle_project.action.Action;
import com.our_middle_project.action.ActionForward;
import com.our_middle_project.dto.ReviewDTO;
import com.our_middle_project.service.ReviewServiceImpl;
import com.our_middle_project.serviceInterface.ReviewService;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class ReviewListController implements Action {

	private final ReviewService reviewService = new ReviewServiceImpl();
	private final Gson gson = new Gson();

	@Override
	public ActionForward execute(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		// 1. 서비스 호출 (DB에서 목록 가져오기)
		List<ReviewDTO> reviewList = reviewService.selectReview();

		// 2. 응답 설정 (JSON)
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		PrintWriter out = response.getWriter();

		// 3. List<ReviewDTO>를 JSON 문자열로 변환하여 응답
		out.print(gson.toJson(reviewList));
		out.flush();

		return null; // AJAX 컨트롤러는 항상 null 반환
	}
}