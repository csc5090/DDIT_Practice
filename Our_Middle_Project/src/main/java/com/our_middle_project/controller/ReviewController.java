package com.our_middle_project.controller;

import java.io.IOException;
import java.util.List;

import com.our_middle_project.action.Action;
import com.our_middle_project.action.ActionForward;
import com.our_middle_project.dto.ReviewDTO;
import com.our_middle_project.service.ReviewServiceImpl;
import com.our_middle_project.serviceInterface.ReviewService;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class ReviewController implements Action {

	/*	
	@Override
	public ActionForward execute(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		ActionForward forward = new ActionForward();
        forward.setPath("/WEB-INF/our_middle_project_view/review.jsp");
        forward.setRedirect(false);
        return forward;
}
	 */

	private final ReviewService reviewService = new ReviewServiceImpl();

	@Override
	public ActionForward execute(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		int limit = parseIntOr(request.getParameter("limit"), 10); // 기본 10개

		List<ReviewDTO> reviews = reviewService.selectReview(limit);

		request.setAttribute("reviews", reviews);
		request.setAttribute("limit", limit);

		ActionForward f = new ActionForward();
		f.setRedirect(false);
		// 실제 뷰 경로로 교체 (예: /WEB-INF/our_middle_project_view/review.jsp)
		f.setPath("/WEB-INF/our_middle_project_view/review.jsp");
		return f;
	}

	private int parseIntOr(String s, int def) {
		try { return Integer.parseInt(s); 
		} catch (Exception e) {
			return def; }
	}
}