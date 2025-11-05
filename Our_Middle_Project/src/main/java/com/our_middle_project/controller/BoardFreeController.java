package com.our_middle_project.controller;

import java.io.IOException;

import java.util.ArrayList;
import java.util.List;

import com.google.gson.Gson;
import com.our_middle_project.action.Action;
import com.our_middle_project.action.ActionForward;
import com.our_middle_project.dto.BoardDTO;
import com.our_middle_project.service.BoardServiceImpl;
import com.our_middle_project.serviceInterface.BoardService;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class BoardFreeController implements Action {


	@Override
	public ActionForward execute(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");

//		  String findBoardType = request.getParameter("findBoard");
//		  
//		  int findBoard = Integer.parseInt(findBoardType);
		
		
		BoardDTO board = new BoardDTO();
		
		board.setFindBoard(3);
		
		BoardService boardService = new BoardServiceImpl();

		List<BoardDTO> boardList = new ArrayList<>();
		System.out.println("==================");		
		System.out.println(boardList);	
		System.out.println("==================");	
		
		Gson gson = new Gson();
		
		System.out.println(gson.toJson(boardList));
		try {
			
			boardList = boardService.selectFreeBoard(board);
			
			response.getWriter().write(gson.toJson(boardList));
			
		} catch (Exception e) {
			e.printStackTrace();

		}
		return null;
	}
}
