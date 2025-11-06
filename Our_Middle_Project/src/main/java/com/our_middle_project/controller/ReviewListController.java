package com.our_middle_project.controller;

import java.io.IOException;
import java.util.List;

import com.our_middle_project.action.Action;
import com.our_middle_project.action.ActionForward;
import com.our_middle_project.dto.ReviewDTO;
import com.our_middle_project.service.ReviewServiceImpl;
import com.our_middle_project.serviceInterface.ReviewService;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class ReviewListController implements Action {

    private final ReviewService reviewService = new ReviewServiceImpl();

    @Override
    public ActionForward execute(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int limit = parseIntOr(req.getParameter("limit"), 10);

        List<ReviewDTO> list = reviewService.selectReview(limit);

        // JSON 만들기 (Jackson 없다 가정 → 수동 직렬화)
        StringBuilder sb = new StringBuilder(256 + list.size() * 200);
        sb.append("{\"ok\":true,\"count\":").append(list.size()).append(",\"items\":[");
        for (int i = 0; i < list.size(); i++) {
            ReviewDTO r = list.get(i);
            if (i > 0) sb.append(',');
            sb.append('{')
              .append("\"boardNo\":").append(r.getBoardNo()).append(',')
              .append("\"memNo\":").append(r.getMemNo()).append(',')
              .append("\"nickName\":\"").append(esc(r.getNickName())).append("\",")
              .append("\"boardContent\":\"").append(esc(r.getBoardContent())).append("\",")
              .append("\"createdDate\":\"").append(esc(r.getCreatedDate())).append("\",")
              .append("\"updatedDate\":\"").append(esc(r.getUpdatedDate())).append("\",")
              .append("\"star\":").append(r.getStar())
              // ※ firstImagePath는 DTO에 없으니 필요하면 DTO에 필드 추가 + mapper 컬럼 alias 맞추기
              .append('}');
        }
        sb.append("]}");

        resp.setContentType("application/json; charset=UTF-8");
        resp.getWriter().write(sb.toString());
        return null; // 직접 응답
    }

    private int parseIntOr(String s, int def) {
    	try { return Integer.parseInt(s); 
    	} catch (Exception e) {
    		return def; 
    		} 
    	}
    private String esc(String s) {
        if (s == null) return "";
        return s.replace("\\","\\\\").replace("\"","\\\"").replace("\r","\\r").replace("\n","\\n");
    }
}