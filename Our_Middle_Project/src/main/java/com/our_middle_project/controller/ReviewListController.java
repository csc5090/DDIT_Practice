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

public class ReviewListController implements Action {

    @Override
    public ActionForward execute(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

    	// 서비스 객체 생성
    	ReviewService reviewService = new ReviewServiceImpl();
    	
    	
    	List<ReviewDTO> list = reviewService.selectReview();

//    	System.out.println("리뷰 목록개수: " + list.size() + "개");
        
    	// JSP로 전달
    	req.setAttribute("reviewList", list);
        
        // 포워드 설정
        ActionForward forward = new ActionForward();
        forward.setRedirect(false);
        forward.setPath("/WEB-INF/our_middle_project_view/review.jsp");

        return forward;
    }
}