package com.our_middle_project.controller;

import java.io.File;
import java.io.PrintWriter;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import com.our_middle_project.action.Action;
import com.our_middle_project.action.ActionForward;
import com.our_middle_project.dto.FileImageDTO;
import com.our_middle_project.dto.ReviewDTO;
import com.our_middle_project.service.ReviewServiceImpl;
import com.our_middle_project.serviceInterface.ReviewService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

/** 리뷰 저장(JSON 응답) — web.xml 수정 없이 @MultipartConfig 사용 */
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,   // 1MB 메모리 임계
    maxFileSize = 10 * 1024 * 1024,    // 개별 파일 10MB
    maxRequestSize = 20 * 1024 * 1024  // 전체 요청 20MB
)
public class ReviewWriteOKController implements Action {

    private final ReviewService reviewService = new ReviewServiceImpl();

    @Override
    public ActionForward execute(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, java.io.IOException {

        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();
        request.setCharacterEncoding("UTF-8");

        /*
        // 로그인 체크
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("LOGIN_MEM_NO") == null) {
            response.setStatus(401);
            out.write("{\"ok\":false,\"error\":\"LOGIN_REQUIRED\"}");
            return null;
        }
        int memNo = (int) session.getAttribute("LOGIN_MEM_NO");
   		*/
 
 // 로그인 되면 지우자        
        int memNo = 1;
        String memNoStr = request.getParameter("memNo");
        if (memNoStr != null && !memNoStr.isBlank()) {
            try { memNo = Integer.parseInt(memNoStr.trim()); } catch (NumberFormatException ignore) { /* 기본값 1 */ }
        }
// 여기까지
        
        // 필수: 내용
        String content = nz(request.getParameter("boardContent"));
        if (content.isBlank()) {
            response.setStatus(400);
            out.write("{\"ok\":false,\"error\":\"boardContent required\"}");
            return null;
        }

        // 선택: 별점(1~5 정수)
        Integer star = null;
        String starStr = request.getParameter("star");
        if (starStr != null && !starStr.isBlank()) {
            try {
                int st = Integer.parseInt(starStr);
                if (st < 1 || st > 5) throw new NumberFormatException();
                star = st;
            } catch (NumberFormatException e) {
                response.setStatus(400);
                out.write("{\"ok\":false,\"error\":\"star must be 1..5\"}");
                return null;
            }
        }

        // 첨부(name="images") 최대 2개
        List<Part> parts = new ArrayList<>();
        for (Part p : request.getParts()) {
            if ("images".equals(p.getName()) && p.getSize() > 0) {
                parts.add(p);
            }
        }
        if (parts.size() > 2) {
            response.setStatus(400);
            out.write("{\"ok\":false,\"error\":\"max 2 images allowed\"}");
            return null;
        }

        // 저장 경로 /uploads/review/YYYY/MM/DD/
        String root = request.getServletContext().getRealPath("/");
        LocalDate d = LocalDate.now();
        String base = "uploads" + File.separator + "review" + File.separator
                    + String.format("%04d", d.getYear()) + File.separator
                    + String.format("%02d", d.getMonthValue()) + File.separator
                    + String.format("%02d", d.getDayOfMonth());
        File dir = new File(root, base);
        if (!dir.exists()) dir.mkdirs();

        // DTO 조립
        ReviewDTO dto = ReviewDTO.builder()
                .boardContent(content)
                .memNo(memNo)
                .typeNo(2)
                .build();

        List<FileImageDTO> imgs = new ArrayList<>();
        for (Part p : parts) {
            String orig = fileName(p);
            String saved = UUID.randomUUID().toString().replace("-", "") + "_" + orig;

            File dest = new File(dir, saved);
            p.write(dest.getAbsolutePath());

            FileImageDTO f = FileImageDTO.builder()
                    .fileName(saved)
                    .filePath(("/" + base + "/" + saved).replace(File.separatorChar, '/'))
                    .fileSize((int) p.getSize())
                    .fileType(p.getContentType())
                    .typeNo(2)
                    .build();
            imgs.add(f);
        }

        try {
            int boardNo = reviewService.writeOnly(dto, imgs, star);
            out.write("{\"ok\":true,\"boardNo\":" + boardNo + "}");
        } catch (IllegalArgumentException e) {
            response.setStatus(400);
            out.write("{\"ok\":false,\"error\":\"" + esc(e.getMessage()) + "\"}");
        } catch (Exception e) {
            response.setStatus(500);
            out.write("{\"ok\":false,\"error\":\"INTERNAL_ERROR\"}");
        }
        return null; // JSON 직접 출력
    }

    // ===== util =====
    private String nz(String s){ return s==null? "" : s.trim(); }
    private String esc(String s){ return s==null? "" : s.replace("\"","\\\""); }
    private String fileName(Part part){
        String cd = part.getHeader("content-disposition");
        if (cd == null) return "unknown";
        for (String t : cd.split(";")) {
            t = t.trim();
            if (t.startsWith("filename=")) {
                String fn = t.substring(t.indexOf('=')+1).trim().replace("\"","");
                int idx = Math.max(fn.lastIndexOf('/'), fn.lastIndexOf('\\'));
                return (idx>=0? fn.substring(idx+1): fn);
            }
        }
        return "unknown";
    }
}