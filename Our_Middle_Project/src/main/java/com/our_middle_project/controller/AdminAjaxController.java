package com.our_middle_project.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.google.gson.Gson;
import com.our_middle_project.action.Action;
import com.our_middle_project.action.ActionForward;
import com.our_middle_project.dto.MemberDTO;
import com.our_middle_project.dto.ReviewDTO;
import com.our_middle_project.service.AdminServiceImpl;
import com.our_middle_project.serviceInterface.AdminService;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class AdminAjaxController implements Action {

	@Override
	public ActionForward execute(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");

		// 현재 요청된 URL(command)을 request 객체에서 가져옴.
		String command = request.getRequestURI().substring(request.getContextPath().length());

		AdminService adminService = new AdminServiceImpl();
		Gson gson = new Gson();

		try {

			// 요청 URL(command)에 따라 로직을 분기.

			if ("/getStats.do".equals(command)) {

				System.out.println("AJAX 요청: /getStats.do");

				// --- 1. 기존 통계 데이터 조회 ---
				int userCount = adminService.getTotalUserCount();
				int newUserCount = adminService.getNewUserCountToday();

				// --- 2. [새로운 작업] 일일 가입 통계 서비스 호출 ---
				// DB에서 `List<Map<String, Object>>` 형태로 데이터를 가져옵니다.
				List<Map<String, Object>> dailyStats = adminService.getDailySignupStats();

				// --- 3. [새로운 작업] 프론트엔드 차트가 사용하기 좋은 형태로 데이터 가공 ---
				// 비어있는 List 두 개를 준비합니다: 하나는 라벨(날짜), 하나는 값(가입자 수)
				List<String> chartLabels = new ArrayList<>();
				List<Object> chartValues = new ArrayList<>();

				// DB에서 가져온 dailyStats를 반복하면서 각 List에 담습니다.
				for (Map<String, Object> stat : dailyStats) {
					// 1. String.valueOf()를 사용하여 어떤 타입이 오든 안전하게 문자열로 '변환'합니다.
					chartLabels.add(String.valueOf(stat.get("LABEL")));

					// 2. 값(VALUE)은 숫자일 수 있으므로 그대로 Object 타입으로 리스트에 추가합니다.
					chartValues.add(stat.get("VALUE"));
				}

				// --- 4. [새로운 작업] 가공된 차트 데이터를 별도의 Map에 담기 ---
				Map<String, Object> chartData = new HashMap<>();
				chartData.put("labels", chartLabels);
				chartData.put("values", chartValues);

				// --- 5. [수정된 작업] 최종적으로 프론트엔드에 보낼 전체 데이터 맵 구성 ---
				// 기존의 숫자 데이터와, 새로 만든 차트 데이터를 모두 담습니다.
				Map<String, Object> responseData = new HashMap<>();
				responseData.put("totalUsers", userCount);
				responseData.put("newUsers", newUserCount);
				responseData.put("chartData", chartData); // 여기에 차트 데이터를 포함시킵니다!

				// --- 6. [수정된 작업] 전체 데이터를 JSON으로 변환하여 응답 ---
				response.getWriter().write(gson.toJson(responseData));

			} else if ("/getUserList.do".equals(command)) {

				// --- 새로운 유저 목록 (검색) 로직 ---
				System.out.println("AJAX 요청: /getUserList.do");

				// 프론트엔드에서 보낸 'keyword' 파라미터를 받습니다.
				String keyword = request.getParameter("keyword");

				System.out.println("컨트롤러에 전달된 검색어: " + keyword);

				// 'keyword'를 서비스로 전달하여 사용자 목록을 가져옵니다.
				// (다음 단계에서 이 메소드를 서비스에 만들어야 합니다)
				List<MemberDTO> userList = adminService.getUsersByKeyword(keyword);

				// 조회된 사용자 목록을 JSON으로 응답.
				response.getWriter().write(gson.toJson(userList));
			} else if ("/getUserDetails.do".equals(command)) {
				System.out.println("AJAX 요청: /getUserDetails.do");

				// 프론트엔드에서 보낸 JSON 데이터를 DTO로 변환
				MemberDTO requestDTO = gson.fromJson(request.getReader(), MemberDTO.class);
				String memberId = requestDTO.getUserId();

				// 서비스를 호출하여 상세 정보 조회
				MemberDTO userDetails = adminService.getUserDetails(memberId);

				// 조회된 상세 정보를 JSON으로 프론트엔드에 응답
				response.getWriter().write(gson.toJson(userDetails));
			} else if ("/updateUser.do".equals(command)) {

				System.out.println("AJAX 요청: /updateUser.do");

				// 프론트엔드에서 보낸 JSON 데이터를 DTO로 변환
				MemberDTO memberDTO = gson.fromJson(request.getReader(), MemberDTO.class);

				System.out.println("컨트롤러가 받은 DTO 데이터: " + memberDTO.toString());
				
				// 서비스를 호출하여 업데이트 로직 실행
				boolean isSuccess = adminService.updateUser(memberDTO);

				// 결과를 JSON으로 프론트엔드에 응답
				Map<String, String> responseData = new HashMap<>();
				responseData.put("status", isSuccess ? "success" : "fail");
				
				if (!isSuccess) {
			        responseData.put("message", "사용자 정보 업데이트에 실패했습니다.");
			    }
				
			    response.getWriter().write(gson.toJson(responseData));
			} else if ("/getReviewList.do".equals(command)) {
				System.out.println("AJAX 요청: /getReviewList.do");

			    List<ReviewDTO> reviewList = adminService.getReviewList();
			    response.getWriter().write(gson.toJson(reviewList));
			}

		} catch (Exception e) {
			e.printStackTrace();

			response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			Map<String, String> errorData = new HashMap<>();
			errorData.put("error", "데이터를 처리하는 중 오류가 발생.");

			response.getWriter().write(gson.toJson(errorData));
		}

		// AJAX 처리가 모두 끝났으므로 FrontController에는 null을 반환.
		return null;
	}

}