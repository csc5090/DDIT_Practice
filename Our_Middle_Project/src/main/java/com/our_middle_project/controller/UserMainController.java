package com.our_middle_project.controller;

import java.io.IOException;

import com.our_middle_project.action.Action;
import com.our_middle_project.action.ActionForward;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class UserMainController implements Action { //사실 이름만 컨트롤러일 뿐. 엄밀히 따지면 액션이라고 해야함.

	@Override
	public ActionForward execute(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		// user의 main.jsp로 포워드
        ActionForward forward = new ActionForward();
        forward.setPath("/WEB-INF/our_middle_project_view/user/main.jsp");
        forward.setRedirect(false);
        
		return forward;
	}

}
