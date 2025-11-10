package com.our_middle_project.controller;

import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList; // (★) ArrayList 임포트
import java.util.Collection;
import java.util.List; // (★) List 임포트
import java.util.Map; // (★) Map 임포트
import java.util.UUID;

import com.our_middle_project.action.Action;
import com.our_middle_project.action.ActionForward;
import com.our_middle_project.dto.FileImageDTO;
import com.our_middle_project.dto.ReviewDTO;
import com.our_middle_project.dto.UserInfoDTO;
import com.our_middle_project.service.ReviewServiceImpl;
import com.our_middle_project.serviceInterface.ReviewService;
import com.google.gson.Gson; // (★) GSON 임포트

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

public class ReviewWriteOKController implements Action {

	private final ReviewService reviewService = new ReviewServiceImpl();

	@Override
	public ActionForward execute(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		System.out.println("ReviewWriteOKController (v3 - AJAX) Start");

		request.setCharacterEncoding("UTF-8");
		// (★) 응답 타입을 JSON으로 변경
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		PrintWriter out = response.getWriter();
		Gson gson = new Gson(); // (★) JSON 변환기

		// 1. 로그인 정보 확인
		HttpSession session = request.getSession(false);
		if (session == null || session.getAttribute("loginUser") == null) {
			response.setStatus(HttpServletResponse.SC_UNAUTHORIZED); // 401
			out.print(gson.toJson(Map.of("status", "error", "message", "로그인이 필요합니다.")));
			out.flush();
			return null;
		}
		UserInfoDTO loginUser = (UserInfoDTO) session.getAttribute("loginUser");
		int memNo = loginUser.getMem_no();

		// 2. 파라미터 수집 (글 내용, 별점)
		String boardContent = request.getParameter("boardContent");
		String starStr = request.getParameter("star");
		String typeStr = request.getParameter("typeNo");

		int star = (starStr == null || starStr.isBlank()) ? 0 : Integer.parseInt(starStr);
		int typeNo = (typeStr == null || typeStr.isBlank()) ? 2 : Integer.parseInt(typeStr.trim());

		// 3. 파일 저장 (디스크) 및 DB 저장용 DTO 목록 생성
		String uploadPath = request.getServletContext().getRealPath("/uploads");
		Path uploadDir = Paths.get(uploadPath);
		Files.createDirectories(uploadDir);

		List<FileImageDTO> imageList = new ArrayList<>();
		String firstThumbUrl = null; // (★) 썸네일 URL을 JS로 반환하기 위함

		try {
			Collection<Part> parts = request.getParts();
			for (Part part : parts) {
				if (!"image".equals(part.getName()) || part.getSize() == 0)
					continue;

				String originalName = extractOriginalName(part);
				String storedName = buildStoredName(originalName);
				Path filePath = uploadDir.resolve(storedName);

				try (InputStream in = part.getInputStream()) {
					Files.copy(in, filePath, StandardCopyOption.REPLACE_EXISTING);
				}

				FileImageDTO img = new FileImageDTO();
				img.setTypeNo(typeNo);
				img.setFileName(storedName);
				img.setFilePath("/uploads");
				img.setFileSize((int) part.getSize());
				img.setFileType(part.getContentType());

				imageList.add(img);

				// (★) 첫 번째 이미지의 URL을 썸네일로 저장 (컨텍스트 경로 제외)
				if (firstThumbUrl == null) {
					firstThumbUrl = "/uploads/" + storedName;
				}
			}
		} catch (IOException | ServletException e) { // (★) ServletException 추가
			e.printStackTrace();
			response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			out.print(gson.toJson(Map.of("status", "error", "message", "파일 업로드 중 오류 발생.")));
			out.flush();
			return null;
		}

		// 4. (★) DB 저장 (트랜잭션)
		ReviewDTO boardDTO = new ReviewDTO();
		boardDTO.setMemNo(memNo);
		boardDTO.setTypeNo(typeNo);
		boardDTO.setBoardContent(boardContent);

		int newBoardNo = reviewService.writeReviewTransaction(boardDTO, star, imageList);

		// 5. (★) 완료 결과를 JSON으로 응답
		if (newBoardNo > 0) {
			// (★) JS가 새 카드를 그릴 수 있도록 필요한 정보를 반환
			ReviewDTO newReviewData = new ReviewDTO();
			newReviewData.setBoardNo(newBoardNo);
			newReviewData.setMemNo(memNo);
			newReviewData.setNickName(loginUser.getNickname()); // (★) 세션 정보
			newReviewData.setMemId(loginUser.getMem_id()); // (★) 세션 정보
			newReviewData.setStar(star);
			newReviewData.setBoardContent(boardContent);
			newReviewData.setCreatedDate("방금 전"); // (★) 날짜는 "방금 전"으로 간단히 처리
			newReviewData.setThumbUrl(firstThumbUrl); // (★) 썸네일 URL

			// (★) Map을 사용하여 status와 newReview를 함께 반환
			out.print(gson.toJson(Map.of("status", "success", "newReview", newReviewData)));
		} else {
			response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			out.print(gson.toJson(Map.of("status", "error", "message", "DB 저장 중 오류 발생.")));
		}

		out.flush();
		return null; // AJAX 컨트롤러는 항상 null 반환
	}

	// 업로드된 파일명 추출
	private String extractOriginalName(Part part) {
		String cd = part.getHeader("Content-Disposition");
		if (cd == null)
			return "unknown";
		for (String seg : cd.split(";")) {
			String s = seg.trim();
			if (s.startsWith("filename=")) {
				String fn = s.substring("filename=".length()).trim().replace("\"", "");

				int slash = Math.max(fn.lastIndexOf('/'), fn.lastIndexOf('\\'));
				return (slash >= 0) ? fn.substring(slash + 1) : fn;
			}
		}
		return "unknown";
	}

	// 서버 저장용 파일명 생성
	private String buildStoredName(String originalName) {
		String ext = "";
		int dot = originalName.lastIndexOf('.');
		if (dot != -1)
			ext = originalName.substring(dot);
		return UUID.randomUUID().toString().replace("-", "") + ext;
	}
}