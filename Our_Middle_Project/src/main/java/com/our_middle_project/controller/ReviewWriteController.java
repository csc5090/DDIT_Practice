package com.our_middle_project.controller;

import java.io.File;
import java.io.IOException;
import java.util.Collection;
import java.util.UUID;

import com.our_middle_project.dto.FileImageDTO;
import com.our_middle_project.dto.ReviewDTO;
import com.our_middle_project.service.ReviewServiceImpl;
import com.our_middle_project.serviceInterface.ReviewService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

@WebServlet("/review/write")
@MultipartConfig
public class ReviewWriteController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final ReviewService svc = new ReviewServiceImpl();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        // 1) 로그인 확인
        Integer memNo = (Integer) req.getSession().getAttribute("LOGIN_MEM_NO");
        if (memNo == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // 2) 폼 파라미터
        String content = req.getParameter("boardContent");
        String typeStr = req.getParameter("typeNo");
        String starStr = req.getParameter("star");
        int typeNo = (typeStr == null || typeStr.isBlank()) ? 2 : Integer.parseInt(typeStr.trim()); // 기본 리뷰게시판 가정

        // 3) 글 INSERT (selectKey AFTER-CURRVAL 로 boardNo 세팅됨)
        ReviewDTO dto = new ReviewDTO();
        dto.setMemNo(memNo);
        dto.setTypeNo(typeNo);
        dto.setBoardContent(content);
        svc.insertBoard(dto); // dto.setBoardNo(...) 이 매퍼에서 채워짐
        int boardNo = dto.getBoardNo();

        // 4) 파일 업로드 (input name="image" multiple 가정)
        Collection<Part> parts = req.getParts();
        for (Part p : parts) {
            if (!"image".equals(p.getName()) || p.getSize() == 0) continue;

            String savedPath = savePartToUploads(req, p);
            FileImageDTO img = new FileImageDTO();
            img.setBoardNo(boardNo);
            img.setTypeNo(typeNo);
            img.setFileName(extractFileName(p));
            img.setFilePath(savedPath);
            img.setFileSize((int) p.getSize());
            img.setFileType(p.getContentType());
            svc.insertImage(img);
        }

        // 5) 별점(선택)
        if (starStr != null && !starStr.isBlank()) {
            int star = Integer.parseInt(starStr.trim());
            svc.insertAuthorStar(boardNo, memNo, star);
        }

        // 6) 완료 페이지로 이동
        resp.sendRedirect("/WEB-INF/our_middle_project_view/review.jsp");
    }

    private String extractFileName(Part part) {
        String cd = part.getHeader("Content-Disposition");
        if (cd == null) return "unknown";
        for (String seg : cd.split(";")) {
            String s = seg.trim();
            if (s.startsWith("filename=")) {
                String fn = s.substring("filename=".length()).trim().replace("\"", "");
                return fn.substring(fn.lastIndexOf(File.separatorChar) + 1);
            }
        }
        return "unknown";
    }

    private String savePartToUploads(HttpServletRequest req, Part part) throws IOException {
        String uploadRoot = req.getServletContext().getRealPath("/uploads");
        File dir = new File(uploadRoot);
        if (!dir.exists()) dir.mkdirs();

        String ext = "";
        String orig = extractFileName(part);
        int dot = orig.lastIndexOf('.');
        if (dot != -1) ext = orig.substring(dot);

        String saved = UUID.randomUUID().toString().replace("-", "") + ext;
        File dest = new File(dir, saved);
        part.write(dest.getAbsolutePath());

        // DB에는 웹 기준 경로 저장 예시
        return req.getContextPath() + "/uploads/" + saved;
    }
}

    	/*
        ActionForward forward = new ActionForward();
        forward.setPath("/WEB-INF/our_middle_project_view/review.jsp");
        forward.setRedirect(false);
        return forward;
        */

