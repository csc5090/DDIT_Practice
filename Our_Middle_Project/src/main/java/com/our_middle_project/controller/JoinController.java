package com.our_middle_project.controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.util.Map;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.our_middle_project.action.Action;
import com.our_middle_project.action.ActionForward;
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
	    System.out.println(userInfo);
	    
	    String salt = PWencrypt.generateSalt();
	    String encryptpw = PWencrypt.hashPassword(userInfo.getMem_pass(), salt);
	    
	    userInfo.setStatus("ACTIVE");
	    userInfo.setMem_pass(encryptpw);
	    
		/* ACTIVE SUSPENDED DELETED */
	    
		UserInfoService userInfoService = new UserInfoServiceImpl();
		userInfoService.JoinUser(userInfo);
	    
	    // Map<String, Object> data = gson.fromJson(json, new TypeToken<Map<String, Object>>(){}.getType());
	    
	    
		return null;
	}

}
