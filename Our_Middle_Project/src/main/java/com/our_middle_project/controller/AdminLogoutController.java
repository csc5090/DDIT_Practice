package com.our_middle_project.controller;

import java.io.IOException;

import com.our_middle_project.action.Action;
import com.our_middle_project.action.ActionForward;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class AdminLogoutController implements Action {

	@Override
	public ActionForward execute(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession(false);

		if (session != null) {
			System.out.println("로그아웃 컨트롤러 : " + session.getId() + " 의 세션 파괴");
			session.invalidate();
		}

		ActionForward forward = new ActionForward();

		forward.setRedirect(true);

		forward.setPath("/login.do");

		return forward;
	}

}