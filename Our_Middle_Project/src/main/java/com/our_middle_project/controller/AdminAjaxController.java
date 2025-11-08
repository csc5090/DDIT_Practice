package com.our_middle_project.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.google.gson.Gson;
import com.our_middle_project.action.Action;
import com.our_middle_project.action.ActionForward;
import com.our_middle_project.dto.AdminBoardDTO;
import com.our_middle_project.dto.AdminBoardImageDTO;
import com.our_middle_project.dto.AdminCommentDTO;
import com.our_middle_project.dto.AdminReviewDTO;
import com.our_middle_project.dto.MemberDTO;
import com.our_middle_project.dto.UserInfoDTO;
import com.our_middle_project.service.AdminBoardServiceImpl;
import com.our_middle_project.service.AdminServiceImpl;
import com.our_middle_project.serviceInterface.AdminBoardService;
import com.our_middle_project.serviceInterface.AdminService;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

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

		if (adminInfo == null) {
			response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
			response.getWriter().write(gson.toJson(Map.of("status", "error", "message", "관리자 로그인이 필요합니다.")));
			return null;
		}

		adminNickname = adminInfo.getNickname();

		if (!adminBoardService.canEditDeleteNotice(adminNickname)) {
			if (command.startsWith("/adminNotice") || command.startsWith("/getAdminNoticeList")) {
				response.setStatus(HttpServletResponse.SC_FORBIDDEN);
				response.getWriter().write(gson.toJson(Map.of("status", "error", "message", "페이지 접근 권한이 없습니다.")));
				return null;
			}
		}

		try {

			if ("/getStats.do".equals(command)) {

				System.out.println("AJAX 요청: /getStats.do");

				// 1. KPI 카드 데이터 (Goal 1 포함)
				int userCount = adminService.getTotalUserCount();
				int newUserCount = adminService.getNewUserCountToday();
				int totalGames = adminService.getTotalGameCount();

				// 2. 차트 데이터 (Goal 2)
				Map<String, Object> chartData = adminService.getDashboardChartData();

				// 3. 응답 데이터 구성
				Map<String, Object> responseData = new HashMap<>();
				responseData.put("totalUsers", userCount);
				responseData.put("newUsers", newUserCount);
				responseData.put("totalGames", totalGames);
				responseData.put("chartData", chartData);

				response.getWriter().write(gson.toJson(responseData));

				// [제거] 아래 중복 코드를 삭제합니다.
				/*
				 * Map<String, Object> chartData = new HashMap<>(); chartData.put("labels",
				 * chartLabels); chartData.put("values", chartValues); Map<String, Object>
				 * responseData = new HashMap<>(); responseData.put("totalUsers", userCount);
				 * responseData.put("newUsers", newUserCount); responseData.put("chartData",
				 * chartData); response.getWriter().write(gson.toJson(responseData));
				 */

			} else if ("/getUserList.do".equals(command)) {

				System.out.println("AJAX 요청: /getUserList.do");
				String keyword = request.getParameter("keyword");
				List<MemberDTO> userList = adminService.getUsersByKeyword(keyword);
				response.getWriter().write(gson.toJson(userList));

			} else if ("/getUserDetails.do".equals(command)) {
				// ... (이하 모든 코드는 기존과 동일) ...
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
				String keyword = null;
				try {
					HashMap<String, String> payload = gson.fromJson(request.getReader(), HashMap.class);
					if (payload != null) {
						keyword = payload.get("keyword");
					}
				} catch (Exception e) {
					// e.printStackTrace(); // 페이로드 없으면(검색어x) 여길로 옴. 정상.
				}
				List<AdminReviewDTO> reviewList = adminService.getReviewList(keyword);
				response.getWriter().write(gson.toJson(reviewList));

			} else if ("/getReviewImages.do".equals(command)) {
				response.setContentType("application/json; charset=UTF-8");

				Map<String, Object> payload = new Gson().fromJson(request.getReader(), Map.class);
				int boardNo = ((Double) payload.get("boardNo")).intValue();

				List<AdminBoardImageDTO> images = adminService.getReviewImages(boardNo);

				// 디버깅 로그
				System.out.println("getReviewImages size = " + (images == null ? "null" : images.size()));
				if (images != null) {
					for (AdminBoardImageDTO im : images) {
						System.out.println(" -> " + im.getFileNo() + " | " + im.getFilePath() + im.getFileName());
					}
				}

				response.getWriter().write(gson.toJson(images != null ? images : List.of()));
				return null;

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
				String keyword = null;
				try {
					HashMap<String, String> payload = gson.fromJson(request.getReader(), HashMap.class);
					if (payload != null) {
						keyword = payload.get("keyword");
					}
				} catch (Exception e) {
					// e.printStackTrace(); // 페이로드 없으면(검색어x) 여길로 옴. 정상.
				}
				List<AdminBoardDTO> postList = adminBoardService.getAdminPostList(keyword);
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

			} else if ("/getPostComments.do".equals(command)) {
				System.out.println("AJAX 요청: /getPostComments.do");
				AdminBoardDTO postDTO = gson.fromJson(request.getReader(), AdminBoardDTO.class);
				List<AdminCommentDTO> comments = adminBoardService.getPostComments(postDTO.getBoard_no());
				response.getWriter().write(gson.toJson(comments));
			} else if ("/adminDeleteComment.do".equals(command)) {
				System.out.println("AJAX 요청: /adminDeleteComment.do");
				AdminCommentDTO commentDTO = gson.fromJson(request.getReader(), AdminCommentDTO.class);
				boolean isSuccess = adminBoardService.deleteComment(commentDTO.getReply_no());
				if (isSuccess) {
					response.getWriter().write(gson.toJson(Map.of("status", "success", "message", "댓글이 삭제되었습니다.")));
				} else {
					response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
					response.getWriter().write(gson.toJson(Map.of("status", "error", "message", "댓글 삭제에 실패했습니다.")));
				}
			} else if ("/adminPostRestore.do".equals(command)) {
				System.out.println("AJAX 요청: /adminPostRestore.do");
				AdminBoardDTO postDTO = gson.fromJson(request.getReader(), AdminBoardDTO.class);
				boolean isSuccess = adminBoardService.restorePost(postDTO.getBoard_no());
				if (isSuccess) {
					response.getWriter().write(gson.toJson(Map.of("status", "success", "message", "게시물이 복원되었습니다.")));
				} else {
					response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
					response.getWriter().write(gson.toJson(Map.of("status", "error", "message", "게시물 복원에 실패했습니다.")));
				}
			} else if ("/adminPostHardDelete.do".equals(command)) {
				System.out.println("AJAX 요청: /adminPostHardDelete.do");
				AdminBoardDTO postDTO = gson.fromJson(request.getReader(), AdminBoardDTO.class);
				boolean isSuccess = adminBoardService.hardDeletePost(postDTO.getBoard_no());
				if (isSuccess) {
					response.getWriter()
							.write(gson.toJson(Map.of("status", "success", "message", "게시물이 영구적으로 삭제되었습니다.")));
				} else {
					response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
					response.getWriter().write(gson.toJson(Map.of("status", "error", "message", "게시물 영구 삭제에 실패했습니다.")));
				}

				// --- 리뷰 관리 (수정됨) ---

			} else if ("/updateAdminReply.do".equals(command)) {
				System.out.println("AJAX 요청: /updateAdminReply.do");
				Map<String, Object> payload = gson.fromJson(request.getReader(), Map.class);
				int boardNo = ((Double) payload.get("reviewNo")).intValue();
				String replyContent = (String) payload.get("replyContent");
				int adminMemNo = adminInfo.getMem_no();

				boolean isSuccess = adminService.updateAdminReply(boardNo, adminMemNo, replyContent);
				if (isSuccess) {
					response.getWriter().write(gson.toJson(Map.of("status", "success", "message", "댓글이 저장되었습니다.")));
				} else {
					response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
					response.getWriter().write(gson.toJson(Map.of("status", "error", "message", "댓글 저장에 실패했습니다.")));
				}
			} else if ("/deleteReviewImage.do".equals(command)) {
				Map<String, Object> payload = gson.fromJson(request.getReader(), Map.class);
				int fileNo = ((Double) payload.get("fileNo")).intValue();

				boolean ok = adminService.deleteReviewImageByFileNo(fileNo);
				if (ok) {
					response.getWriter().write(gson.toJson(Map.of("status", "success")));
				} else {
					response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
					response.getWriter().write(gson.toJson(Map.of("status", "error", "message", "삭제 실패")));
				}

			} else if ("/deleteReviewImages.do".equals(command)) {
				Map<String, Object> payload = gson.fromJson(request.getReader(), Map.class);
				@SuppressWarnings("unchecked")
				List<Double> nums = (List<Double>) payload.get("fileNos");
				List<Integer> fileNos = nums.stream().map(Double::intValue).toList();

				boolean ok = adminService.deleteReviewImagesByFileNos(fileNos);
				if (ok) {
					response.getWriter().write(gson.toJson(Map.of("status", "success", "deleted", fileNos.size())));
				} else {
					response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
					response.getWriter().write(gson.toJson(Map.of("status", "error", "message", "삭제 실패")));
				}

			} else if ("/deleteReview.do".equals(command)) {
				System.out.println("AJAX 요청: /deleteReview.do");
				Map<String, Object> payload = gson.fromJson(request.getReader(), Map.class);
				int boardNo = ((Double) payload.get("reviewNo")).intValue();

				boolean isSuccess = adminService.deleteReview(boardNo);
				if (isSuccess) {
					response.getWriter().write(gson.toJson(Map.of("status", "success", "message", "리뷰가 삭제되었습니다.")));
				} else {
					response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
					response.getWriter().write(gson.toJson(Map.of("status", "error", "message", "리뷰 삭제에 실패했습니다.")));
				}
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