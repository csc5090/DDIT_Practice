package com.our_middle_project.controller;

import com.our_middle_project.action.Action;
import com.our_middle_project.action.ActionForward;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class AdminUserListController implements Action {

    @Override
    public ActionForward execute(HttpServletRequest request, HttpServletResponse response) {

        
        request.setAttribute("viewPage", "/our_middle_project_view/admin/userList.jsp");

        
        ActionForward forward = new ActionForward();
        forward.setPath("/our_middle_project_view/admin/layout.jsp");
        forward.setRedirect(false);

        return forward;
    }
}