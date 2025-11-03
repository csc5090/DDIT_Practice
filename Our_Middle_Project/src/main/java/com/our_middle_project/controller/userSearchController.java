package com.our_middle_project.controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.Random;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.our_middle_project.action.Action;
import com.our_middle_project.action.ActionForward;
import com.our_middle_project.dto.UserInfoDTO;
import com.our_middle_project.dto.UserInfoReturnDTO;
import com.our_middle_project.pwencrypt.PWencrypt;
import com.our_middle_project.service.UserInfoServiceImpl;
import com.our_middle_project.serviceInterface.UserInfoService;
import com.our_middle_project.util.FindPasswordMailSend;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class userSearchController implements Action {

	@Override
	public ActionForward execute(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		System.out.println("controller: userSearchController");

		BufferedReader reader = request.getReader();
		StringBuilder sb = new StringBuilder();

		String line;
		while ((line = reader.readLine()) != null) {
			sb.append(line);
		}

		String json = sb.toString();
		Gson gson = new Gson();

		Map<String, Object> map = gson.fromJson(json, new TypeToken<Map<String, Object>>(){}.getType());
		Map<String, Object> reName = new HashMap<>();
		reName.put("mem_id", map.get("id"));
		reName.put("mem_mail", map.get("email"));
		
		String searchType = (String)map.get("type");
		
		String newJson = gson.toJson(reName);
		UserInfoDTO userInfo = gson.fromJson(newJson, UserInfoDTO.class);
		
		UserInfoService userInfoService = new UserInfoServiceImpl();
		UserInfoReturnDTO findUserInfoDto;
		String resultJson;
		
		if (searchType.equals("id")) {
			System.out.println("해당 영역실행됨 22");
			findUserInfoDto = userInfoService.getIdFind(userInfo);
			resultJson = gson.toJson(findUserInfoDto);
			
			response.setContentType("application/json; charset=UTF-8");
			response.getWriter().write(resultJson);
			
		} 
		else {
			System.out.println("해당 영역실행됨 11");
			findUserInfoDto = userInfoService.getPasswordFind(userInfo);
			resultJson = gson.toJson(findUserInfoDto);
			
			
			
	        Random rand = new Random();
	        int num = rand.nextInt(9000) + 1000;
	        String numStr = String.valueOf(num);
	        System.out.println(numStr);
	        
		    String salt = PWencrypt.generateSalt();
		    String mem_pass = PWencrypt.hashPassword(numStr, salt);
		    String mem_id = findUserInfoDto.getMem_id();
		    
			Map<String, Object> pram = new HashMap<>();
			pram.put("mem_id", mem_id);
			pram.put("mem_pass", mem_pass);
			
		    userInfoService.newPasswordSave(pram);
		    
		    // 이메일 전송
		    String mailTo = findUserInfoDto.getMem_mail(); // 사용자가 입력한 이메일
		    String mailTitle = "임시 비밀번호 안내";
		    String mailContent = "안녕하세요. 요청하신 임시 비밀번호는 [" + numStr + "] 입니다.\n"
		                       + "로그인 후 반드시 비밀번호를 변경해주세요.";

		    FindPasswordMailSend.sendMail(mailTo, mailTitle, mailContent);

		    response.setContentType("application/json; charset=UTF-8");
		    response.getWriter().write(resultJson);
		    
			
			response.setContentType("application/json; charset=UTF-8");
			response.getWriter().write(resultJson);
			
		}

		return null;
	}

}
