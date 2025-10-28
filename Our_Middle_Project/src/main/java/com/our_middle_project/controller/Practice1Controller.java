package com.our_middle_project.controller;

import java.io.IOException;

import com.our_middle_project.action.Action;
import com.our_middle_project.action.ActionForward;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class Practice1Controller implements Action {

	@Override
	public ActionForward execute(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		request.setAttribute("viewPage", "/WEB-INF/our_middle_project_view/admin/practice1.jsp");
		
		ActionForward forward = new ActionForward();
		forward.setPath("/WEB-INF/our_middle_project_view/admin/practice1.jsp");
        forward.setRedirect(false);
		return forward;
	}

}
