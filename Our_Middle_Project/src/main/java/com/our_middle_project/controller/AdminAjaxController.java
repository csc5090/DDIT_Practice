package com.our_middle_project.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.google.gson.Gson;
import com.our_middle_project.action.Action;
import com.our_middle_project.action.ActionForward;
import com.our_middle_project.dto.AdminBoardDTO;
import com.our_middle_project.dto.AdminReviewDTO;
import com.our_middle_project.dto.MemberDTO;
import com.our_middle_project.dto.UserInfoDTO; // Admin 세션 정보 DTO 추가
import com.our_middle_project.service.AdminBoardServiceImpl;
import com.our_middle_project.service.AdminServiceImpl;
import com.our_middle_project.serviceInterface.AdminBoardService;
import com.our_middle_project.serviceInterface.AdminService;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession; // 세션 사용을 위해 추가

public class AdminAjaxController implements Action {

	@Override
	public ActionForward execute(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		response.setContentType("application/json");

		// 현재 요청된 URL(command)을 request 객체에서 가져옴.
		String command = request.getRequestURI().substring(request.getContextPath().length());

		AdminService adminService = new AdminServiceImpl();
		AdminBoardService adminBoardService = new AdminBoardServiceImpl(); // Board Service 초기화
		Gson gson = new Gson();

		// 관리자 세션 정보 확인 및 권한 검사를 위한 정보 추출
		HttpSession session = request.getSession();
		UserInfoDTO adminInfo = (UserInfoDTO) session.getAttribute("loginAdmin"); // 로그인 시 저장된 DTO를 가져옴

		// 공지사항 CRUD는 관리자 권한이 필수. 세션이 없거나 Role이 ADMIN이 아니면 401 Unauthorized 에러 응답.
		String adminNickname = null;
		if (adminInfo == null || !"ADMIN".equals(adminInfo.getRole())) {
			// 공지사항 관련 요청이 들어왔을 경우
			if (command.startsWith("/adminNotice") || command.startsWith("/getAdminNoticeList")) {
				response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
				response.getWriter()
						.write(gson.toJson(Map.of("status", "error", "message", "관리자 권한 정보가 유효하지 않습니다. 다시 로그인해주세요.")));
				return null;
			}
		} else {
			adminNickname = adminInfo.getNickname(); // 등급(1, 2, 3, 4) 추출
		}

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

				// --- 4. 가공된 차트 데이터를 별도의 Map에 담기 ---
				Map<String, Object> chartData = new HashMap<>();
				chartData.put("labels", chartLabels);
				chartData.put("values", chartValues);

				// --- 5. 최종적으로 프론트엔드에 보낼 전체 데이터 맵 구성 ---
				// 기존의 숫자 데이터와, 새로 만든 차트 데이터를 모두 담습니다.
				Map<String, Object> responseData = new HashMap<>();
				responseData.put("totalUsers", userCount);
				responseData.put("newUsers", newUserCount);
				responseData.put("chartData", chartData); // 여기에 차트 데이터를 포함시킵니다!

				// --- 6. 전체 데이터를 JSON으로 변환하여 응답 ---
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

				List<AdminReviewDTO> reviewList = adminService.getReviewList();
				response.getWriter().write(gson.toJson(reviewList));
			} else if ("/getAdminNoticeList.do".equals(command)) { // 공지사항 목록 조회

				System.out.println("AJAX 요청: /getAdminNoticeList.do");

				// AdminBoardService를 사용하여 공지사항 목록 조회
				List<AdminBoardDTO> noticeList = adminBoardService.getAdminBoardList();

				// 결과를 JSON으로 응답
				response.getWriter().write(gson.toJson(noticeList));
			} else if ("/adminNoticeWrite.do".equals(command)) {

				System.out.println("AJAX 요청: /adminNoticeWrite.do");

				// 권한 검사 (1, 2, 3 등급만 생성 가능)
				if (!adminBoardService.canCreateNotice(adminNickname)) {
					response.setStatus(HttpServletResponse.SC_FORBIDDEN); // 403 Forbidden
					response.getWriter().write(
							gson.toJson(Map.of("status", "error", "message", "권한 부족: 공지사항 생성은 1~3 등급 관리자만 가능합니다.")));
					return null;
				}

				AdminBoardDTO noticeDTO = gson.fromJson(request.getReader(), AdminBoardDTO.class);

				// Service 호출 (작성자 mem_no를 세션에서 가져와 전달)
				boolean isSuccess = adminBoardService.insertNotice(noticeDTO, adminInfo.getMem_no());

				if (isSuccess) {
					response.getWriter().write(gson.toJson(Map.of("status", "success", "message", "공지사항이 등록되었습니다.")));
				} else {
					response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
					response.getWriter().write(gson.toJson(Map.of("status", "error", "message", "공지사항 등록에 실패했습니다.")));
				}
			}

			// 2. 공지사항 수정 (U) - 1, 2, 3, 4 등급 모두 허용
			else if ("/adminNoticeUpdate.do".equals(command)) {

				System.out.println("AJAX 요청: /adminNoticeUpdate.do");

				// 권한 검사 (1, 2, 3, 4 등급 모두 수정 가능)
				if (!adminBoardService.canEditDeleteNotice(adminNickname)) {
					response.setStatus(HttpServletResponse.SC_FORBIDDEN);
					response.getWriter()
							.write(gson.toJson(Map.of("status", "error", "message", "권한 부족: 공지사항 수정 권한이 없습니다.")));
					return null;
				}

				AdminBoardDTO noticeDTO = gson.fromJson(request.getReader(), AdminBoardDTO.class);
				boolean isSuccess = adminBoardService.updateNotice(noticeDTO);

				if (isSuccess) {
					response.getWriter()
							.write(gson.toJson(Map.of("status", "success", "message", "공지사항이 성공적으로 수정되었습니다.")));
				} else {
					response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
					response.getWriter().write(gson.toJson(Map.of("status", "error", "message", "공지사항 수정에 실패했습니다.")));
				}
			}

			// 3. 공지사항 삭제 (D) - 1, 2, 3, 4 등급 모두 허용 (DB 완전 삭제)
			else if ("/adminNoticeDelete.do".equals(command)) {

				System.out.println("AJAX 요청: /adminNoticeDelete.do");

				// 권한 검사 (1, 2, 3, 4 등급 모두 삭제 가능)
				if (!adminBoardService.canEditDeleteNotice(adminNickname)) {
					response.setStatus(HttpServletResponse.SC_FORBIDDEN);
					response.getWriter()
							.write(gson.toJson(Map.of("status", "error", "message", "권한 부족: 공지사항 삭제 권한이 없습니다.")));
					return null;
				}

				AdminBoardDTO noticeDTO = gson.fromJson(request.getReader(), AdminBoardDTO.class);
				int boardNoToDelete = noticeDTO.getBoard_no();

				boolean isSuccess = adminBoardService.deleteNotice(boardNoToDelete); // DB에서 완전 삭제

				if (isSuccess) {
					response.getWriter()
							.write(gson.toJson(Map.of("status", "success", "message", "공지사항이 완전히 삭제되었습니다.")));
				} else {
					response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
					response.getWriter().write(gson.toJson(Map.of("status", "error", "message", "공지사항 삭제에 실패했습니다.")));
				}
			} else if ("/getAdminPostList.do".equals(command)) { // 게시물 목록 조회

				System.out.println("AJAX 요청: /getAdminPostList.do");
				List<AdminBoardDTO> postList = adminBoardService.getAdminPostList();
				response.getWriter().write(gson.toJson(postList));

			} else if ("/adminPostDelete.do".equals(command)) { // 게시물 삭제 (D)

				System.out.println("AJAX 요청: /adminPostDelete.do");

				if (adminInfo == null || !adminBoardService.canEditDeleteNotice(adminNickname)) {
					response.setStatus(HttpServletResponse.SC_FORBIDDEN);
					response.getWriter()
							.write(gson.toJson(Map.of("status", "error", "message", "권한 부족: 게시물 삭제 권한이 없습니다.")));
					return null;
				}

				AdminBoardDTO postDTO = gson.fromJson(request.getReader(), AdminBoardDTO.class);
				int boardNoToDelete = postDTO.getBoard_no();

				boolean isSuccess = adminBoardService.deletePost(boardNoToDelete);

				Map<String, String> responseData = new HashMap<>();
				responseData.put("status", isSuccess ? "success" : "fail");

				if (isSuccess) {
					responseData.put("message", "게시물이 성공적으로 삭제되었습니다.");
				} else {
					responseData.put("message", "게시물 삭제에 실패했습니다.");
				}
				response.getWriter().write(gson.toJson(responseData));
			}

		} catch (Exception e) {
			e.printStackTrace();
			response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			Map<String, String> errorData = new HashMap<>();
			errorData.put("status", "error");
			errorData.put("error", "데이터를 처리하는 중 오류가 발생했습니다.");
			response.getWriter().write(gson.toJson(errorData));
		}

		return null;
	}
}