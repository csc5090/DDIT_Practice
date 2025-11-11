package com.our_middle_project.controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.util.List;

import com.google.gson.Gson;
import com.our_middle_project.action.Action;
import com.our_middle_project.action.ActionForward;
import com.our_middle_project.dto.GameLevelDTO;
import com.our_middle_project.dto.UserInfoDTO;
import com.our_middle_project.service.GameServiceImpl;
import com.our_middle_project.service.UserInfoServiceImpl;
import com.our_middle_project.serviceInterface.GameService;
import com.our_middle_project.serviceInterface.UserInfoService;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class GameHomeController implements Action {
	
	@Override
	public ActionForward execute(HttpServletRequest request, HttpServletResponse response)
	        throws ServletException, IOException {

	    // 세션 체크
	    UserInfoDTO loginUser = (UserInfoDTO) request.getSession().getAttribute("loginUser");

	    // logout 파라미터가 있으면 세션 종료
	    if ("logout".equals(request.getParameter("action"))) {
	        request.getSession().invalidate(); // 세션 종료
	        ActionForward forward = new ActionForward();
	        forward.setRedirect(true);
	        forward.setPath("/login.do"); // 로그인 페이지 이동
	        return forward;
	    }

	    if (loginUser == null) {
	        ActionForward forward = new ActionForward();
	        forward.setRedirect(true);
	        forward.setPath("/login.do");
	        return forward;
	    }
 
	    // 기존 레벨 리스트 로직
	    GameService gameService = new GameServiceImpl(); 
	    List<GameLevelDTO> gameLevelList = gameService.getLevelInfo();
	    request.setAttribute("levelList", gameLevelList);

	    ActionForward forward = new ActionForward();
	    forward.setRedirect(false);
	    forward.setPath("/WEB-INF/our_middle_project_view/user/gameHome.jsp");
	    return forward;
	}
}
