package com.our_middle_project.controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.our_middle_project.action.Action;
import com.our_middle_project.action.ActionForward;
import com.our_middle_project.dto.UserInfoDTO;
import com.our_middle_project.service.UserInfoServiceImpl;
import com.our_middle_project.serviceInterface.UserInfoService;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class userSearchController implements Action {

	@Override
	public ActionForward execute(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		System.out.println("search Controller");

		BufferedReader reader = request.getReader();
		StringBuilder sb = new StringBuilder();

		String line;
		while ((line = reader.readLine()) != null) {
			sb.append(line);
		}

		System.out.println(sb);

		String json = sb.toString();

		System.out.println(json);
		Gson gson = new Gson();

		Map<String, Object> map = gson.fromJson(json, new TypeToken<Map<String, Object>>(){}.getType());
		Map<String, Object> reName = new HashMap<>();
		reName.put("mem_id", map.get("id"));
		reName.put("mem_mail", map.get("email"));
		
		String searchType = (String)map.get("type");
		
		String newJson = gson.toJson(reName);
		UserInfoDTO userInfo = gson.fromJson(newJson, UserInfoDTO.class);
		System.out.println(userInfo);
		
		UserInfoService userInfoService = new UserInfoServiceImpl();
		UserInfoDTO findUserInfoDto;
		String resultJson;
		
		if (searchType.equals("id")) {
			System.out.println("해당 영역실행됨 22");
			findUserInfoDto = userInfoService.getIdFind(userInfo);
			findUserInfoDto.setMem_pass("");
			resultJson = gson.toJson(findUserInfoDto);
			
			response.setContentType("application/json; charset=UTF-8");
			response.getWriter().write(resultJson);
			
		} 
		else {
			System.out.println("해당 영역실행됨 11");
			findUserInfoDto = userInfoService.getPasswordFind(userInfo);
			findUserInfoDto.setMem_pass("");
			resultJson = gson.toJson(findUserInfoDto);
			
			System.out.println(resultJson); 
			
			response.setContentType("application/json; charset=UTF-8");
			response.getWriter().write(resultJson);
			
		}

		return null;
	}

}
