package com.our_middle_project.controller;

import java.io.BufferedReader;
import java.io.IOException;

import com.google.gson.Gson;
import com.our_middle_project.action.Action;
import com.our_middle_project.action.ActionForward;
import com.our_middle_project.dto.UserInfoDTO;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class levelSaveController implements Action {

	@Override
	public ActionForward execute(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		System.out.println("레벨 저장하는 컨트롤러 levelSaveController");
		BufferedReader reader = request.getReader();
		StringBuilder sb = new StringBuilder();
		
	    String line;
	    while ((line = reader.readLine()) != null) {
	        sb.append(line);
	    }
	    
	    String json = sb.toString();	    
	    Gson gson = new Gson();
	    
	    UserInfoDTO userInfo = gson.fromJson(json, UserInfoDTO.class);
	    System.out.println(userInfo);
		
			
	    
		return null;
	}

}
