package com.our_middle_project.controller;

import java.io.IOException;
import java.util.List;

import com.our_middle_project.action.Action;
import com.our_middle_project.action.ActionForward;
import com.our_middle_project.dto.GameLogDTO;
import com.our_middle_project.dto.RankingDTO;
import com.our_middle_project.dto.UserInfoDTO;
import com.our_middle_project.service.MyPageServiceImpl;
import com.our_middle_project.serviceInterface.MyPageService;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class MyPageController implements Action {

	@Override
	public ActionForward execute(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		System.out.println();
		System.out.println("MyPageController Start");
		System.out.println();
		
		UserInfoDTO loingUser = (UserInfoDTO) request.getSession().getAttribute("loginUser");
		
		System.out.println(loingUser);
		
		MyPageService myPageService = new MyPageServiceImpl();
		
		UserInfoDTO userInfoDTO = myPageService.getMyUserData(loingUser);
		List<RankingDTO> rankingDTO = myPageService.getMyRankingData(loingUser); 
		List<GameLogDTO> gameLogDTO = myPageService.getMyGameLogData(loingUser);  
		
		request.getSession().setAttribute("MyPage_UserData", userInfoDTO);
		request.getSession().setAttribute("MyPage_RankingData", rankingDTO);
		request.getSession().setAttribute("MyPage_GameLogData", gameLogDTO);
		
		System.out.println(userInfoDTO);
		System.out.println(rankingDTO);
		System.out.println(gameLogDTO);
		
		/* List<RankingDTO> rankingDTO = */
		
        ActionForward forward = new ActionForward();
        forward.setRedirect(false); // 포워드 방식으로 이동
        forward.setPath("/WEB-INF/our_middle_project_view/user/myPage.jsp");
		
		return forward;
	}

}
