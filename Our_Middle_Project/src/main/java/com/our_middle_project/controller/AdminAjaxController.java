package com.our_middle_project.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import com.google.gson.Gson;
import com.our_middle_project.action.Action;
import com.our_middle_project.action.ActionForward;
import com.our_middle_project.service.AdminServiceImpl;
import com.our_middle_project.serviceInterface.AdminService;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class AdminAjaxController implements Action {
	
	
	/**
     * @apiNote     관리자 대시보드 통계 API
     * @since       2025-10-29
     * @endpoint    /getStats.do
     * @method      GET
     * @description 관리자 대시보드에 필요한 요약 통계(총 회원 수, 신규 가입자 수 등)를 조회합니다.
     * @return      통계 데이터를 담은 JSON 객체. FrontController에는 null을 반환합니다.
     */
	
	@Override
	public ActionForward execute(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		// 응답 타입을 미리 설정해두면 코드가 더 깔끔해짐.
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");

		try {
			// 1. 서비스 매니저(Impl)를 생성.
			AdminService adminService = new AdminServiceImpl();
	
			// 2. 매니저에게 일을 시켜 결과를 받음. 기능 추가마다 여기에 추가
			int userCount = adminService.getTotalUserCount();
			int newUserCount = adminService.getNewUserCountToday();
			
			// 3. 결과를 JSON 형식으로 포장. 여기에도 추가해야함
			Map<String, Integer> data = new HashMap<>();
			data.put("totalUsers", userCount);
			data.put("newUsers", newUserCount);
			
			
			
			String jsonResponse = new Gson().toJson(data);
			
			// 4. 성공적인 JSON 데이터를 서빙.
			response.getWriter().write(jsonResponse);

		} catch (Exception e) {
			e.printStackTrace();

			// 클라이언트(브라우저)에게 서버 내부 오류가 발생했음을 알림. (HTTP 500)
			response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			
			// 사용자에게 보여줄 에러 메시지를 JSON 형식으로 만듬.
			Map<String, String> errorData = new HashMap<>();
			errorData.put("error", "데이터를 가져오는 중 오류가 발생했습니다.");
			String errorJson = new Gson().toJson(errorData);
			
			// 에러 JSON 데이터를 서빙.
			response.getWriter().write(errorJson);
		}
		
		// 프론트 컨트롤러에게 "성공이든 실패든 내 일은 끝났으니, 더 이상 아무것도 하지 마라"고 알림.
		return null;
	}

}