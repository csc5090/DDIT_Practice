package com.our_middle_project.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import com.google.gson.Gson;
import com.our_middle_project.action.Action;
import com.our_middle_project.action.ActionForward;
import com.our_middle_project.dao.MemberDAO;
import com.our_middle_project.dto.MemberDTO;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class GetUsersController implements Action {

	@Override
	public ActionForward execute(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		String query = request.getParameter("query");
		
		MemberDAO dao = MemberDAO.getInstance();
		List<MemberDTO> memberList = dao.getMemberList(query);
		String jsonResult = new Gson().toJson(memberList);
		
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		
		PrintWriter out = response.getWriter();
		out.print(jsonResult);
		out.flush();
		
		return null;
	}
	

}
