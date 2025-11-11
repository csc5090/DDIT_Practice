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

		System.out.println("GameHomeController Start");

	    // 세션 체크
	    UserInfoDTO loginUser = (UserInfoDTO) request.getSession().getAttribute("loginUser");

	    if (loginUser == null) {
	        System.out.println("로그인 정보 없음 -> login.do 로 이동");
	        ActionForward forward = new ActionForward();
	        forward.setRedirect(true);
	        forward.setPath("/login.do");
	        return forward;
	    }
		
		    
			//-------------------
		
		GameService gameService = new GameServiceImpl(); 
		List<GameLevelDTO> gameLevelList = gameService.getLevelInfo();
		for(int i=0 ; i<gameLevelList.size() ; i++) {
			System.out.println(gameLevelList.get(i));
		}
	
		request.setAttribute("levelList", gameLevelList);
		System.out.println("레벨 리스트 내용 확인: " + gameLevelList.get(0).getClass().getName());
		
		ActionForward forward = new ActionForward();
		forward.setRedirect(false);
		forward.setPath("/WEB-INF/our_middle_project_view/user/gameHome.jsp");
		
		return forward;
		
	}

}
