package com.our_middle_project.controller;

import java.io.IOException;

import com.our_middle_project.action.Action;
import com.our_middle_project.action.ActionForward;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class RankingController implements Action {

	@Override
	public ActionForward execute(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		System.out.println("ddddd");
		System.out.println("ddddd");
		System.out.println("ddddd");
		System.out.println("ddddd");
		System.out.println("ddddd");
		System.out.println("ddddd");
		System.out.println("ddddd");
		System.out.println("ddddd");
		ActionForward forward = new ActionForward();
		forward.setRedirect(false);
		forward.setPath("/WEB-INF/our_middle_project_view/user/ranking.jsp");
		
		return forward;
	}

}
