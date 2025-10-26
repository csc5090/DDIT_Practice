package com.our_middle_project.controller;

import java.io.IOException;
import java.io.PrintWriter;

import com.google.gson.Gson;
import com.our_middle_project.action.Action;
import com.our_middle_project.action.ActionForward;
import com.our_middle_project.dao.MemberDAO;
import com.our_middle_project.dto.DashboardKpiDTO;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class AdminKpiApiController implements Action {

	@Override
	public ActionForward execute(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		// 1. DAO를 통해 필요한 데이터를 DB에서 가져옴.
		MemberDAO dao = MemberDAO.getInstance();
		int totalUsers = dao.getTotalUserCount();
		int todayUsers = dao.getTodayUserCount();
		
		// 2. 조회된 데이터를 DTO(포장 상자)에 담음.
		DashboardKpiDTO kpiData = new DashboardKpiDTO();
		kpiData.setTotalUsers(totalUsers);
		kpiData.setTodayUsers(todayUsers);
		
		// 3. Gson 라이브러리를 사용해 DTO 객체를 JSON 문자열로 변환.
        // 결과 예: {"totalUsers":10242,"todayUsers":12}
		String jsonResult = new Gson().toJson(kpiData);
		
		
		// 4. 응답의 형식이 JSON이라고 브라우저에게 알림.
		response.setContentType("aplication/json");
		response.setCharacterEncoding("UTF-8");
		
		// 5. JSON 문자열을 응답으로 직접 전송
		PrintWriter out = response.getWriter();
		out.print(jsonResult);
		out.flush();
		
		// 6. 이미 응답을 처리했으므로 프론트 컨트롤러에게 별 다른 걸 리턴하지 않음.
		return null;
	}

}
