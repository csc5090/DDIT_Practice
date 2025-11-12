package com.our_middle_project.controller;

import java.io.IOException;

import com.our_middle_project.action.Action;
import com.our_middle_project.action.ActionForward;
import com.our_middle_project.dashboardendpt.DashboardEndPoint;
import com.our_middle_project.dto.UserInfoDTO;
import com.our_middle_project.service.MyPageServiceImpl;
import com.our_middle_project.serviceInterface.MyPageService;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class MyPageDeleteController implements Action {

    @Override
    public ActionForward execute(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1️⃣ 세션에서 로그인 유저 정보 가져오기
        HttpSession session = request.getSession();
        UserInfoDTO loginUser = (UserInfoDTO) session.getAttribute("loginUser");

        
        response.setContentType("text/plain;charset=UTF-8");

        if (loginUser == null) {
            // 로그인 안 된 상태
            response.getWriter().write("FAIL_NOT_LOGIN");
            return null;
        }

        // 2️ 요청 파라미터: 비밀번호
        String inputPw = request.getParameter("password");
        if (inputPw == null || inputPw.isEmpty()) {
            response.getWriter().write("FAIL_NO_PASSWORD");
            return null;
        }

        
        // 3️ 서비스 호출
        MyPageService myPageService = new MyPageServiceImpl();
        boolean result = myPageService.deleteMember(loginUser.getMem_id(), inputPw);
        
        // 4️ 결과 처리
        if (result) {
            // 탈퇴 성공 → 세션 초기화
        	DashboardEndPoint.broadCastStatsUpdate();
            session.invalidate();
            response.getWriter().write("OK");
        } else {
            // 비밀번호 불일치 또는 탈퇴 실패
            response.getWriter().write("FAIL_WRONG_PASSWORD");
        }
        // AJAX 호출이므로 페이지 이동 없음
        return null;
    }
}
