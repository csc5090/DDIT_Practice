package com.our_middle_project.controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import com.google.gson.Gson;
import com.our_middle_project.action.Action;
import com.our_middle_project.action.ActionForward;
import com.our_middle_project.dto.UserInfoDTO;
import com.our_middle_project.pwencrypt.PWencrypt;
import com.our_middle_project.service.UserInfoServiceImpl;
import com.our_middle_project.serviceInterface.UserInfoService;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class LoginCheckController implements Action {

	@Override
	public ActionForward execute(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		BufferedReader reader = request.getReader();
		StringBuilder sb = new StringBuilder();
		
	    String line;
	    while ((line = reader.readLine()) != null) {
	        sb.append(line);
	    }
	    
	    String json = sb.toString();	    
	    Gson gson = new Gson();
	    
	    UserInfoDTO userInfo = gson.fromJson(json, UserInfoDTO.class);
		
	    System.out.println(sb);
	    
	    /*
	    String salt = PWencrypt.generateSalt();
	    String encryptpw = PWencrypt.hashPassword(userInfo.getMem_pass(), salt);
	    
	    userInfo.setMem_pass(encryptpw);
	    */
	    
		UserInfoService userInfoService = new UserInfoServiceImpl();
		UserInfoDTO idCheckValue = userInfoService.loginCheck(userInfo);
		
		System.out.println(idCheckValue);
		
		Map<String, Object> result = new HashMap<>();
        if (idCheckValue != null) {
        	
        	if(idCheckValue.getRole() != null) {
        		
        		if(idCheckValue.getRole().equals("USER")) {
        			System.out.println("이 사람은 USER 이다.");
        			System.out.println(idCheckValue);
        			
        			// 입력받은 비밀번호 + DB에 저장된 salt로 암호화
        			String inputEncryptedPw = PWencrypt.hashPassword(userInfo.getMem_pass(), idCheckValue.getSalt());
        			System.out.println("입력한 비밀번호 암호화 결과: " + inputEncryptedPw);
        			System.out.println("DB 저장된 비밀번호: " + idCheckValue.getMem_pass());
        			
        			// 비밀번호 비교
        			if (inputEncryptedPw.equals(idCheckValue.getMem_pass())) {
        				
        				result.put("pwCheck", true);
        				
        				idCheckValue.setMem_pass("");
        				idCheckValue.setSalt("");
        				
        				request.getSession().setAttribute("loginUser", idCheckValue);
        				System.out.println("세션 loginAdmin ID: " + request.getSession().getId());
        				System.out.println(">>> 세션 저장 완료: " + request.getSession().getAttribute("loginAdmin"));
        				
        			}
        			else {
        				
        				result.put("pwCheck", false);
        				
        			}
        			
        			result.put("idCheck", true);
        			result.put("role", idCheckValue.getRole());
        			result.put("url", request.getContextPath() + "/gameHome.do");
        			
        			
        		}
        		else if(idCheckValue.getRole().equals("ADMIN")) {
        			
        			// admin 계정은 암호화 없이 비밀번호만 대조 합낟.
        			if (userInfo.getMem_pass().equals(idCheckValue.getMem_pass())) {
        				
        				result.put("pwCheck", true);

        				request.getSession().setAttribute("loginAdmin", idCheckValue);
        				request.getSession().setAttribute("ADMIN_PASS", true);
        				System.out.println("세션 loginAdmin ID: " + request.getSession().getId());
        				System.out.println(">>> 세션 저장 완료: " + request.getSession().getAttribute("loginAdmin"));
        				
        				idCheckValue.setMem_pass("");
        				
        			}
        			else {
        				
        				result.put("pwCheck", false);
        				
        			}
        			
        			result.put("idCheck", true);
        			result.put("role", idCheckValue.getRole());
        			result.put("url", request.getContextPath() + "/adminMain.do");
        			
        		}
        		
        	}
        	else {
        		
        		System.out.println("LoginCheckController NULL Error");
        		System.out.println(idCheckValue.getRole());
        		System.out.println(idCheckValue);
        		
				result.put("idCheck", false);
				result.put("pwCheck", false);
				result.put("role", "null");
        		
        	}
        	
        }
        else {
        	
        	result.put("idCheck", false);
        	result.put("pwCheck", false);
        	result.put("role", "undefined");
        	
        }
		
		String resultJson = gson.toJson(result); 

		System.out.println(resultJson);
		
		response.setContentType("application/json; charset=UTF-8");
		response.getWriter().write(resultJson);
		
		//test

	    
		return null;
	}

}
