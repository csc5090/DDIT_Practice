package com.our_middle_project.action;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class AdminMainAction implements Action {

	@Override
	public ActionForward execute(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		// 관리자 페이지에 필요한 데이터가 있다면 여기에 추가
		// 예: request.setAttribute("memberCount", 100);
		
		// adminMain.jsp로 포워드
        ActionForward forward = new ActionForward();
        forward.setPath("/our_middle_project_view/admin/adminMain.jsp");
        forward.setRedirect(false);
        
		return forward;
	}

}
