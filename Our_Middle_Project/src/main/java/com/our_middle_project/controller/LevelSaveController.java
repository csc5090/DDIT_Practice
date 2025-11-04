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
	    System.out.println(json);
	    
	    Gson gson = new Gson();
	    Map<String, Object> map = gson.fromJson(json, new TypeToken<Map<String, Object>>(){}.getType());
	    
	    request.getSession().setAttribute("map", map);
	    
	    String test = gson.toJson(map);
	    
		response.setContentType("application/json; charset=UTF-8");
		response.getWriter().write(request.getContextPath() + "/gamePlay.do");
	    
		/*
		 * ActionForward forward = new ActionForward();
		 * forward.setPath("/WEB-INF/our_middle_project_view/user/gamePlay.jsp");
		 * forward.setRedirect(false);
		 * 
		 * System.out.println("123123123111111111111a1");
		 */
		/*
		 * 
		 * 
		 * UserInfoDTO userInfo = gson.fromJson(json, UserInfoDTO.class);
		 * System.out.println(userInfo);
		 */
		
			
	    
		return null;
	}

}
