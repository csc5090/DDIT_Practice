package com.our_middle_project.controller;

import java.io.BufferedReader;
import java.io.IOException;

import com.google.gson.Gson;
import com.our_middle_project.action.Action;
import com.our_middle_project.action.ActionForward;
import com.our_middle_project.dto.IdCheckDTO;
import com.our_middle_project.dto.UserInfoDTO;
import com.our_middle_project.service.UserInfoServiceImpl;
import com.our_middle_project.serviceInterface.UserInfoService;
import com.our_middle_project.util.MybatisUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class IdCheckController implements Action {

	@Override
	public ActionForward execute(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		System.out.println("=========================");
		System.out.println("=========================");
		System.out.println("=========================");
		System.out.println("=========================");
		System.out.println("=========================");
		
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
		
		UserInfoService userInfoService = new UserInfoServiceImpl();
		UserInfoDTO idCheckValue = userInfoService.getIdCheck(userInfo);

		System.out.println(idCheckValue);
		
		IdCheckDTO resultObj = new IdCheckDTO();
		if(idCheckValue == null) {
			resultObj.setIdCheck(true);
		}
		else { 
			resultObj.setIdCheck(false);
		}
		
		String resultJson = gson.toJson(resultObj); 

		response.setContentType("application/json; charset=UTF-8");
		response.getWriter().write(resultJson);

		return null;
	}

}
