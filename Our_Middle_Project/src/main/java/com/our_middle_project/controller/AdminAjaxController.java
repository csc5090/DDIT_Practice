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
import com.our_middle_project.dto.AdminCommentDTO;
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

		String command = request.getRequestURI().substring(request.getContextPath().length());

		AdminService adminService = new AdminServiceImpl();
		AdminBoardService adminBoardService = new AdminBoardServiceImpl(); 
		Gson gson = new Gson();

		HttpSession session = request.getSession();
		UserInfoDTO adminInfo = (UserInfoDTO) session.getAttribute("loginAdmin"); 

		String adminNickname = null;
		
		// [수정] 관리자 세션이 아예 없으면 모든 요청 차단
		if (adminInfo == null) {
			response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
			response.getWriter()
					.write(gson.toJson(Map.of("status", "error", "message", "관리자 로그인이 필요합니다.")));
			return null;
		}
		
		adminNickname = adminInfo.getNickname(); // 등급(1, 2, 3, 4) 추출
		
		// [수정] 공지사항 권한 체크 로직 (Role "ADMIN" 대신 닉네임(등급) 사용)
		if (command.startsWith("/adminNotice") || command.startsWith("/getAdminNoticeList")) {
			if (!adminBoardService.canEditDeleteNotice(adminNickname)) {
				response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
				response.getWriter()
						.write(gson.toJson(Map.of("status", "error", "message", "관리자 권한 정보가 유효하지 않습니다.")));
				return null;
			}
		}


		try {

			// ... (getStats.do, getUserList.do 등 다른 로직은 동일) ...
			
			if ("/getStats.do".equals(command)) {

				System.out.println("AJAX 요청: /getStats.do");

				// --- 1. 기존 통계 데이터 조회 ---
				int userCount = adminService.getTotalUserCount();
				int newUserCount = adminService.getNewUserCountToday();

				// --- 2. [새로운 작업] 일일 가입 통계 서비스 호출 ---
				List<Map<String, Object>> dailyStats = adminService.getDailySignupStats();

				// --- 3. [새로운 작업] 프론트엔드 차트가 사용하기 좋은 형태로 데이터 가공 ---
				List<String> chartLabels = new ArrayList<>();
				List<Object> chartValues = new ArrayList<>();

				for (Map<String, Object> stat : dailyStats) {
					chartLabels.add(String.valueOf(stat.get("LABEL")));
					chartValues.add(stat.get("VALUE"));
				}

				// --- 4. 가공된 차트 데이터를 별도의 Map에 담기 ---
				Map<String, Object> chartData = new HashMap<>();
				chartData.put("labels", chartLabels);
				chartData.put("values", chartValues);

				// --- 5. 최종적으로 프론트엔드에 보낼 전체 데이터 맵 구성 ---
				Map<String, Object> responseData = new HashMap<>();
				responseData.put("totalUsers", userCount);
				responseData.put("newUsers", newUserCount);
				responseData.put("chartData", chartData); 

				// --- 6. 전체 데이터를 JSON으로 변환하여 응답 ---
				response.getWriter().write(gson.toJson(responseData));

			} else if ("/getUserList.do".equals(command)) {

				System.out.println("AJAX 요청: /getUserList.do");
				String keyword = request.getParameter("keyword");
				List<MemberDTO> userList = adminService.getUsersByKeyword(keyword);
				response.getWriter().write(gson.toJson(userList));
				
			} else if ("/getUserDetails.do".equals(command)) {
				System.out.println("AJAX 요청: /getUserDetails.do");
				MemberDTO requestDTO = gson.fromJson(request.getReader(), MemberDTO.class);
				String memberId = requestDTO.getUserId();
				MemberDTO userDetails = adminService.getUserDetails(memberId);
				response.getWriter().write(gson.toJson(userDetails));
				
			} else if ("/updateUser.do".equals(command)) {
				System.out.println("AJAX 요청: /updateUser.do");
				MemberDTO memberDTO = gson.fromJson(request.getReader(), MemberDTO.class);
				boolean isSuccess = adminService.updateUser(memberDTO);
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
				
			} else if ("/getAdminNoticeList.do".equals(command)) { 
				System.out.println("AJAX 요청: /getAdminNoticeList.do");
				List<AdminBoardDTO> noticeList = adminBoardService.getAdminBoardList();
				response.getWriter().write(gson.toJson(noticeList));
				
			} else if ("/adminNoticeWrite.do".equals(command)) {
				System.out.println("AJAX 요청: /adminNoticeWrite.do");
				if (!adminBoardService.canCreateNotice(adminNickname)) {
					response.setStatus(HttpServletResponse.SC_FORBIDDEN); 
					response.getWriter().write(
							gson.toJson(Map.of("status", "error", "message", "권한 부족: 공지사항 생성은 1~3 등급 관리자만 가능합니다.")));
					return null;
				}
				AdminBoardDTO noticeDTO = gson.fromJson(request.getReader(), AdminBoardDTO.class);
				boolean isSuccess = adminBoardService.insertNotice(noticeDTO, adminInfo.getMem_no());
				if (isSuccess) {
					response.getWriter().write(gson.toJson(Map.of("status", "success", "message", "공지사항이 등록되었습니다.")));
				} else {
					response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
					response.getWriter().write(gson.toJson(Map.of("status", "error", "message", "공지사항 등록에 실패했습니다.")));
				}
			}

			else if ("/adminNoticeUpdate.do".equals(command)) {
				System.out.println("AJAX 요청: /adminNoticeUpdate.do");
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

			else if ("/adminNoticeDelete.do".equals(command)) {
				System.out.println("AJAX 요청: /adminNoticeDelete.do");
				if (!adminBoardService.canEditDeleteNotice(adminNickname)) {
					response.setStatus(HttpServletResponse.SC_FORBIDDEN);
					response.getWriter()
							.write(gson.toJson(Map.of("status", "error", "message", "권한 부족: 공지사항 삭제 권한이 없습니다.")));
					return null;
				}
				AdminBoardDTO noticeDTO = gson.fromJson(request.getReader(), AdminBoardDTO.class);
				int boardNoToDelete = noticeDTO.getBoard_no();
				boolean isSuccess = adminBoardService.deleteNotice(boardNoToDelete); 
				if (isSuccess) {
					response.getWriter()
							.write(gson.toJson(Map.of("status", "success", "message", "공지사항이 완전히 삭제되었습니다.")));
				} else {
					response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
					response.getWriter().write(gson.toJson(Map.of("status", "error", "message", "공지사항 삭제에 실패했습니다.")));
				}
				
			// --- 게시물 관리 ---
				
			} else if ("/getAdminPostList.do".equals(command)) { 
				System.out.println("AJAX 요청: /getAdminPostList.do");
				// [수정] 닉네임(등급)으로 권한 체크
				if (!adminBoardService.canEditDeleteNotice(adminNickname)) {
					response.setStatus(HttpServletResponse.SC_FORBIDDEN);
					response.getWriter()
							.write(gson.toJson(Map.of("status", "error", "message", "게시물 관리 권한이 없습니다.")));
					return null;
				}
				List<AdminBoardDTO> postList = adminBoardService.getAdminPostList();
				response.getWriter().write(gson.toJson(postList));

			} else if ("/adminPostDelete.do".equals(command)) { 
				System.out.println("AJAX 요청: /adminPostDelete.do (Soft Delete)");
				if (!adminBoardService.canEditDeleteNotice(adminNickname)) {
					response.setStatus(HttpServletResponse.SC_FORBIDDEN);
					response.getWriter()
							.write(gson.toJson(Map.of("status", "error", "message", "권한 부족: 게시물 삭제 권한이 없습니다.")));
					return null;
				}
				AdminBoardDTO postDTO = gson.fromJson(request.getReader(), AdminBoardDTO.class);
				int boardNoToDelete = postDTO.getBoard_no();
				
				// [수정] deletePost는 이제 soft delete(999)를 실행
				boolean isSuccess = adminBoardService.deletePost(boardNoToDelete); 
				Map<String, String> responseData = new HashMap<>();
				responseData.put("status", isSuccess ? "success" : "fail");
				if (isSuccess) {
					responseData.put("message", "게시물이 성공적으로 삭제(비활성) 처리되었습니다.");
				} else {
					responseData.put("message", "게시물 삭제 처리에 실패했습니다.");
				}
				response.getWriter().write(gson.toJson(responseData));
				
			} else if ("/adminPostUpdate.do".equals(command)) {
				System.out.println("AJAX 요청: /adminPostUpdate.do");
				if (!adminBoardService.canEditDeleteNotice(adminNickname)) {
					response.setStatus(HttpServletResponse.SC_FORBIDDEN);
					response.getWriter()
							.write(gson.toJson(Map.of("status", "error", "message", "권한 부족: 게시물 수정 권한이 없습니다.")));
					return null;
				}
				AdminBoardDTO postDTO = gson.fromJson(request.getReader(), AdminBoardDTO.class);
				boolean isSuccess = adminBoardService.updatePost(postDTO);
				if (isSuccess) {
					response.getWriter()
							.write(gson.toJson(Map.of("status", "success", "message", "게시물이 성공적으로 수정되었습니다.")));
				} else {
					response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
					response.getWriter().write(gson.toJson(Map.of("status", "error", "message", "게시물 수정에 실패했습니다.")));
				} 
				
				}else if("/getPostComments.do".equals(command)) {
					System.out.println("AJAX 요청: /getPostComments.do");
					// board_no를 받기 위해 AdminBoardDTO 재활용
					AdminBoardDTO postDTO = gson.fromJson(request.getReader(), AdminBoardDTO.class);
					List<AdminCommentDTO> comments = adminBoardService.getPostComments(postDTO.getBoard_no());
					response.getWriter().write(gson.toJson(comments));
				} else if ("/adminDeleteComment.do".equals(command)) {
					System.out.println("AJAX 요청: /adminDeleteComment.do");
					// reply_no를 받기 위해 AdminCommentDTO 재활용
					AdminCommentDTO commentDTO = gson.fromJson(request.getReader(), AdminCommentDTO.class);
					boolean isSuccess = adminBoardService.deleteComment(commentDTO.getReply_no());
					if (isSuccess) { response.getWriter().write(gson.toJson(Map.of("status", "success", "message", "댓글이 삭제되었습니다."))); } 
	                else { response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR); response.getWriter().write(gson.toJson(Map.of("status", "error", "message", "댓글 삭제에 실패했습니다."))); }
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