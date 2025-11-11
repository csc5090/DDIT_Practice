package com.our_middle_project.controller;

import java.io.IOException;

import java.util.ArrayList;
import java.util.List;

import com.google.gson.Gson;
import com.our_middle_project.action.Action;
import com.our_middle_project.action.ActionForward;
import com.our_middle_project.dto.BoardDTO;
import com.our_middle_project.dto.UserInfoDTO;
import com.our_middle_project.service.BoardServiceImpl;
import com.our_middle_project.serviceInterface.BoardService;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class BoardFreeController implements Action {


	@Override
	public ActionForward execute(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		System.out.println("BoardFreeController Start");
		
	    // 세션 체크
	    UserInfoDTO loginUser = (UserInfoDTO) request.getSession().getAttribute("loginUser");

	    if (loginUser == null) {
	        response.setContentType("application/json; charset=UTF-8");
	        response.getWriter().write("{\"status\":\"error\",\"message\":\"login required\"}");
	        return null;
	    }
		
		
		try{
	
			BoardService boardService = new BoardServiceImpl();
			
			List<BoardDTO> boardList = new ArrayList<>();
			boardList = boardService.selectFreeBoard();

			
			Gson gson = new Gson();
			response.getWriter().write(gson.toJson(boardList));

			
		} catch (Exception e) {
			e.printStackTrace();

		}
		return null;
	}
}
