package com.our_middle_project.controller;

import java.io.IOException;
import java.util.List;

import com.google.gson.Gson;
import com.our_middle_project.action.Action;
import com.our_middle_project.action.ActionForward;
import com.our_middle_project.dto.GameLevelDTO;
import com.our_middle_project.service.GameServiceImpl;
import com.our_middle_project.serviceInterface.GameService;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class GameHomeController implements Action {
	
	@Override
	public ActionForward execute(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		System.out.println("GameHomeController Start");
		
		
		GameService gameService = new GameServiceImpl(); 
		List<GameLevelDTO> gameLevelList = gameService.getLevelInfo();
		for(int i=0 ; i<gameLevelList.size() ; i++) {
			System.out.println(gameLevelList.get(i));
		}
		
		/*
		Gson gson = new Gson();
		String levelList = gson.toJson(gameLevelList);
		*/
		
		request.setAttribute("levelList", gameLevelList);
		System.out.println("레벨 리스트 내용 확인: " + gameLevelList.get(0).getClass().getName());
		
		ActionForward forward = new ActionForward();
		forward.setRedirect(false);
		forward.setPath("/WEB-INF/our_middle_project_view/user/gameHome.jsp");
		
		return forward;
		
	}

}
