package com.our_middle_project.controller;

import java.io.IOException;
import java.util.List;
import com.our_middle_project.action.Action;
import com.our_middle_project.action.ActionForward;
import com.our_middle_project.dto.ReviewDTO;
import com.our_middle_project.service.ReviewServiceImpl; // ServiceImpl import
import com.our_middle_project.serviceInterface.ReviewService; // Interface import (필요시)

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class ReviewController implements Action {

	private final ReviewService reviewService = new ReviewServiceImpl();

	@Override
	public ActionForward execute(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		response.setContentType("text/html; charset=UTF-8");
		
		List<ReviewDTO> reviewList = reviewService.selectReview();
		request.setAttribute("reviewList", reviewList);

		ActionForward forward = new ActionForward();
		forward.setPath("/WEB-INF/our_middle_project_view/user/review.jsp");
		forward.setRedirect(false);
		return forward;
	}
}