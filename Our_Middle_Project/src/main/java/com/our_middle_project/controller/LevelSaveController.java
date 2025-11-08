package com.our_middle_project.controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.util.Map;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.our_middle_project.action.Action;
import com.our_middle_project.action.ActionForward;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class LevelSaveController implements Action {

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
	    Map<String, Object> map = gson.fromJson(json, new TypeToken<Map<String, Object>>(){}.getType());
	    
	    System.out.println("테스트 "+map);
	    
	    request.getSession().setAttribute("map", map);
		response.setContentType("application/json; charset=UTF-8");
		response.getWriter().write(request.getContextPath() + "/gamePlay.do");
			
	    
		return null;
	}

}
