package com.our_middle_project.controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.nio.charset.StandardCharsets;

import com.google.gson.Gson;
import com.our_middle_project.action.Action;
import com.our_middle_project.action.ActionForward;
import com.our_middle_project.dashboardendpt.DashboardEndPoint;
import com.our_middle_project.dto.UserInfoDTO;
import com.our_middle_project.pwencrypt.PWencrypt;
import com.our_middle_project.service.UserInfoServiceImpl;
import com.our_middle_project.serviceInterface.UserInfoService;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class JoinController implements Action {

	@Override
	public ActionForward execute(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		
		BufferedReader reader = request.getReader();
		StringBuilder sb = new StringBuilder();
		
	    String line;
	    while ((line = reader.readLine()) != null) {
	        sb.append(line);
	    }
	    
	    String json = sb.toString();	    
	    Gson gson = new Gson();
	    
	    UserInfoDTO userInfo = gson.fromJson(json, UserInfoDTO.class);
	    
	    String salt = PWencrypt.generateSalt();
	    String encryptpw = PWencrypt.hashPassword(userInfo.getMem_pass(), salt);
	    
	    userInfo.setStatus("ACTIVE");
	    userInfo.setRole("USER");
	    userInfo.setSalt(salt);
	    userInfo.setMem_pass(encryptpw);
	    
		/* ACTIVE SUSPENDED DELETED */
	    
	    System.out.println(userInfo);
	    
		UserInfoService userInfoService = new UserInfoServiceImpl();
		
		try {
			userInfoService.JoinUser(userInfo);
			DashboardEndPoint.broadCastStatsUpdate();
			response.setContentType("application/json");
	        response.setCharacterEncoding(StandardCharsets.UTF_8.name());
	        response.getWriter().write("{\"status\": \"success\"}");
		} catch (Exception e) {
			e.printStackTrace();
			response.setContentType("application/json");
	        response.setCharacterEncoding(StandardCharsets.UTF_8.name());
	        // 500 Internal Server Error 상태 코드 전송
	        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR); 
	        response.getWriter().write("{\"status\": \"error\", \"message\": \"회원가입 중 오류가 발생했습니다.\"}");
		}    
	    // Map<String, Object> data = gson.fromJson(json, new TypeToken<Map<String, Object>>(){}.getType());

		return null;
	}

}
