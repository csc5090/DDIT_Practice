package com.our_middle_project.action;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class LoginAction implements Action {

    @Override
    public ActionForward execute(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        // 여기에 로그인 기능 구현 (예: ID, 비밀번호 확인 로직)
        // 현재는 단순히 로그인 페이지로 이동하기만 함.
        
        ActionForward forward = new ActionForward();
        forward.setPath("/our_middle_project_view/login.jsp");
        forward.setRedirect(false); // 포워드 방식으로 이동
        
        return forward;
    }
}