package com.our_middle_project.controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.util.Map;

import com.google.gson.Gson;
import com.our_middle_project.action.Action;
import com.our_middle_project.action.ActionForward;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class JoinController implements Action {

	@Override
	public ActionForward execute(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		
		StringBuilder sb = new StringBuilder();
	    BufferedReader reader = request.getReader();
	    System.out.println(reader);
	    String line;
	    while ((line = reader.readLine()) != null) {
	        sb.append(line);
	    }
	    String json = sb.toString();
	    System.out.println("받은 JSON: " + json);
	    
	    Gson gson = new Gson();
	    
	    Map<String, Object> data = gson.fromJson(json, Map.class);
	    System.out.println("userAddr1: " + data.get("userAddr1"));
	    System.out.println("userAddr2: " + data.get("userAddr2"));
	    System.out.println("userAddr3: " + data.get("userAddr3"));
	    System.out.println("userAddr4: " + data.get("userAddr4"));
	    System.out.println("userBirth: " + data.get("userBirth"));
	    System.out.println("userEmail: " + data.get("userEmail"));
	    System.out.println("userGender: " + data.get("userGender"));
	    System.out.println("userId: " + data.get("userId"));
	    System.out.println("userName: " + data.get("userName"));
	    System.out.println("userNickName: " + data.get("userNickName"));
	    System.out.println("userPhone: " + data.get("userPhone"));
	    System.out.println("userPw: " + data.get("userPw"));
	    
		return null;
	}

}
