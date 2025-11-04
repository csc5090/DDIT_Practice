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
import jakarta.servlet.http.HttpSession;

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
        	
        	if(idCheckValue.getRole().equals("USER")) {
        		System.out.println("이 사람은 USER 이다.");
        		System.out.println(idCheckValue);
        	}
        	else if(idCheckValue.getRole().equals("ADMIN")) {
        		System.out.println("이 사람은 ADMIN 이다.");
        		System.out.println(idCheckValue);
        	}
        	else {
        		System.out.println(idCheckValue);
        		System.out.println("이녀석의 신분을 알 수 없다.");
        	}
        	
            // 입력받은 비밀번호 + DB에 저장된 salt로 암호화
            String inputEncryptedPw = PWencrypt.hashPassword(userInfo.getMem_pass(), idCheckValue.getSalt());
            System.out.println("입력한 비밀번호 암호화 결과: " + inputEncryptedPw);
            System.out.println("DB 저장된 비밀번호: " + idCheckValue.getMem_pass());

            // 비밀번호 비교
            if (inputEncryptedPw.equals(idCheckValue.getMem_pass())) {
            	result.put("idCheck", true);
            	result.put("pwCheck", true);

            	idCheckValue.setMem_pass("");
            	idCheckValue.setSalt("");
            	
            	HttpSession session = request.getSession(); 
            	session.setAttribute("loginUser", idCheckValue);
            	
            }
            else {
            	result.put("idCheck", true);
            	result.put("pwCheck", false);
            }
        }
        else {
        	result.put("idCheck", false);
        	result.put("pwCheck", false);
        }
		
		String resultJson = gson.toJson(result); 

		response.setContentType("application/json; charset=UTF-8");
		response.getWriter().write(resultJson);

	    
		return null;
	}

}
