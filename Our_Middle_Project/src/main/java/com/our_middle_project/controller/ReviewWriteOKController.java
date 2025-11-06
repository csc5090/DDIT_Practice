package com.our_middle_project.controller;

import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.Collection;
import java.util.UUID;

import com.our_middle_project.action.Action;
import com.our_middle_project.action.ActionForward;
import com.our_middle_project.dto.FileImageDTO;
import com.our_middle_project.dto.ReviewDTO;
import com.our_middle_project.service.ReviewServiceImpl;
import com.our_middle_project.serviceInterface.ReviewService;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

public class ReviewWriteOKController implements Action {

	private final ReviewService reviewService = new ReviewServiceImpl();

    @Override
    public ActionForward execute(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
       
    	request.setCharacterEncoding("UTF-8");
    	response.setContentType("text/html; charset=UTF-8");
        PrintWriter out = response.getWriter();

        // 0) 업로드 경로 준비 (/uploads)
        String uploadPath = request.getServletContext().getRealPath("/uploads");
        Path uploadDir = Paths.get(uploadPath);
        Files.createDirectories(uploadDir);

        // 1) 파라미터 수집
        String boardContent = request.getParameter("boardContent");
        String typeStr = request.getParameter("typeNo");    // 리뷰게시판 타입 번호(없으면 2 가정)
        int typeNo = (typeStr == null || typeStr.isBlank()) ? 2 : Integer.parseInt(typeStr.trim());

        // 로그인 없이 저장: 게스트/더미 사용자 번호 사용 (예: MEM_NO=1)
        int memNo = 1;
       // int memNo = (int) request.getSession().getAttribute("LOGIN_MEM_NO");

        // 2) 리뷰글 INSERT (selectKey AFTER-CURRVAL 로 boardNo가 dto에 세팅됨)
        ReviewDTO dto = new ReviewDTO();
        dto.setMemNo(memNo);
        dto.setTypeNo(typeNo);
        dto.setBoardContent(boardContent);

        reviewService.insertBoard(dto);
        int boardNo = dto.getBoardNo(); // ↑ 매퍼에서 자동 주입됨

        // 3) 첨부파일 저장 (input name="image", multiple 가정)
        Collection<Part> parts = request.getParts();
      
        for (Part part : parts) {
            if (!"image".equals(part.getName()) || part.getSize() == 0) continue;

            // 원본 파일명
            String originalName = extractOriginalName(part);
            // 저장 파일명: UUID + 확장자
            String storedName = buildStoredName(originalName);
            Path filePath = uploadDir.resolve(storedName);

            // 실제 파일 저장
            try (InputStream in = part.getInputStream()) {
                Files.copy(in, filePath, StandardCopyOption.REPLACE_EXISTING);
            }

            // 이미지 메타 DB 저장
            FileImageDTO img = new FileImageDTO();
            img.setBoardNo(boardNo);
            img.setTypeNo(typeNo);
            img.setFileName(originalName);
            // DB에는 웹 기준 경로 저장
            img.setFilePath(request.getContextPath() + "/uploads/" + storedName);
            img.setFileSize((int) part.getSize());
            img.setFileType(part.getContentType());

            reviewService.insertImage(img);
        }

 /*       // 4) (선택) 별점 — 로그인 없으니 게스트로 넣을지, 스킵할지 정책 선택
        String starStr = request.getParameter("star");
        if (starStr != null && !starStr.isBlank()) {
            int star = Integer.parseInt(starStr.trim());
            // 게스트로도 별점을 저장하려면 아래 라인 유지, 아니라면 주석 처리
            reviewService.insertAuthorStar(boardNo, memNo, star);
        }
*/
        // 5) 완료 안내 및 목록/완료페이지로 이동
        String cp = request.getContextPath();
        out.println("<script>");
        out.println("alert('등록이 완료되었습니다.');");
        out.println("location.href='" + cp + "/review.do';");
        out.println("</script>");
        out.flush();

        return null; // JS로 리다이렉트
    }

    private String extractOriginalName(Part part) {
        String cd = part.getHeader("Content-Disposition");
        if (cd == null) return "unknown";
        for (String seg : cd.split(";")) {
            String s = seg.trim();
            if (s.startsWith("filename=")) {
                String fn = s.substring("filename=".length()).trim().replace("\"", "");
                // IE 경로 포함 케이스 제거
                int slash = Math.max(fn.lastIndexOf('/'), fn.lastIndexOf('\\'));
                return (slash >= 0) ? fn.substring(slash + 1) : fn;
            }
        }
        return "unknown";
    }

    private String buildStoredName(String originalName) {
        String ext = "";
        int dot = originalName.lastIndexOf('.');
        if (dot != -1) ext = originalName.substring(dot);
        return UUID.randomUUID().toString().replace("-", "") + ext;
    }
}
