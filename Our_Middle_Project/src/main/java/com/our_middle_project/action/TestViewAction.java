package com.our_middle_project.action;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class TestViewAction implements Action {

    @Override
    public ActionForward execute(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("---- TestViewAction의 execute() 메소드 호출 ----");

        ActionForward forward = new ActionForward();
        forward.setPath("/our_middle_project_view/test.jsp");
        forward.setRedirect(false);
        return forward;
    }
}