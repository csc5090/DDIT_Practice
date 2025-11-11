package com.our_middle_project.controller;

import java.io.IOException;

import com.our_middle_project.action.Action;
import com.our_middle_project.action.ActionForward;
import com.our_middle_project.dto.UserInfoDTO;
import com.our_middle_project.service.MyPageServiceImpl;
import com.our_middle_project.serviceInterface.MyPageService;
import com.our_middle_project.pwencrypt.PWencrypt;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class MyPageUpdateController implements Action {

    @Override
    public ActionForward execute(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        UserInfoDTO loginUser = (UserInfoDTO) session.getAttribute("loginUser");

        response.setContentType("text/plain;charset=UTF-8");

        if (loginUser == null) {
            response.getWriter().write("FAIL_NOT_LOGIN");
            return null;
        }

        String nickname = request.getParameter("nickname");
        String password = request.getParameter("password");
        String hp = request.getParameter("hp");
        String mail = request.getParameter("mail");

        MyPageService myPageService = new MyPageServiceImpl();

        boolean result = myPageService.updateMember(loginUser.getMem_id(), nickname, password, hp, mail);

        if (result) {
            // DB 업데이트 성공 → 세션에 새 정보 반영
            UserInfoDTO updatedUser = myPageService.getMyUserData(loginUser);
            request.getSession().setAttribute("loginUser", updatedUser);

            response.getWriter().write("OK");
        } else {
            response.getWriter().write("FAIL");
        }

        return null;
    }
}
