package com.our_middle_project.controller;

import java.io.File;
import java.io.IOException;
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
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;


// @WebServlet 및 @MultipartConfig 어노테이션 제거
// HttpServlet 상속 대신 Action 인터페이스 구현
public class ReviewListController implements Action {

    private final ReviewService svc = new ReviewServiceImpl();

    @Override
    public ActionForward execute(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // 1) 로그인 확인
        // (참고: CharacterEncodingFilter가 이미 있으므로 req.setCharacterEncoding 불필요)
        HttpSession session = req.getSession(false);
        Integer memNo = null;
        
        if (session != null) {
            // (참고) 로그인 시 세션에 저장한 속성 이름이 'LOGIN_MEM_NO'가 맞는지 확인 필요
            Object memNoObj = session.getAttribute("LOGIN_MEM_NO"); 
            if (memNoObj instanceof Integer) {
                memNo = (Integer) memNoObj;
            }
        }

        if (memNo == null) {
            // 세션이 없으면 로그인 페이지로 리다이렉트
            ActionForward forward = new ActionForward();
            forward.setPath(req.getContextPath() + "/login.do");
            forward.setRedirect(true);
            return forward;
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
        // (주의: FrontController에 multipart-config가 설정되어 있어야 함)
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

        // 6) 완료 페이지로 이동 (Post-Redirect-Get 패턴)
        // JSP로 직접 포워딩하지 않고, 리뷰 목록을 보여주는 .do URL로 리다이렉트합니다.
        ActionForward forward = new ActionForward();
        forward.setPath(req.getContextPath() + "/review.do"); // 리뷰 목록 페이지 URL
        forward.setRedirect(true); // true로 설정하여 브라우저 URL 변경
        return forward;
    }

    /**
     * Part에서 원본 파일 이름을 추출합니다.
     */
    private String extractFileName(Part part) {
        String cd = part.getHeader("Content-Disposition");
        if (cd == null) return "unknown";
        for (String seg : cd.split(";")) {
            String s = seg.trim();
            if (s.startsWith("filename=")) {
                String fn = s.substring("filename=".length()).trim().replace("\"", "");
                // (보안) 경로 순회를 방지하기 위해 파일 이름만 추출
                return fn.substring(fn.lastIndexOf(File.separatorChar) + 1);
            }
        }
        return "unknown";
    }

    private String savePartToUploads(HttpServletRequest req, Part part) throws IOException {
        // (보안) 실제 배포 시에는 /uploads 폴더가 웹 루트(webapp) 밖에 위치하는 것이 좋습니다.
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