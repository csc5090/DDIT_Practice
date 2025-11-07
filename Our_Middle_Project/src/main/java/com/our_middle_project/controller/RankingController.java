package com.our_middle_project.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.google.gson.Gson;
import com.our_middle_project.action.Action;
import com.our_middle_project.action.ActionForward;
import com.our_middle_project.dto.RankingDTO;
import com.our_middle_project.serviceInterface.RankingService;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class RankingController implements Action {
	
	public RankingController() {
        // 기본 생성자
    }

    private RankingService rankingService;
    private Gson gson = new Gson();

    public RankingController(RankingService rankingService) {
        this.rankingService = rankingService;
    }

    @Override
    public ActionForward execute(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // AJAX 요청인지 확인
        String ajaxParam = request.getParameter("ajax");
        if ("true".equals(ajaxParam)) {
            // 레벨, 제한 수 받아오기
            int levelNo = request.getParameter("levelNo") != null ? Integer.parseInt(request.getParameter("levelNo")) : 1;
            int limit = request.getParameter("limit") != null ? Integer.parseInt(request.getParameter("limit")) : 100;

            Map<String, Object> param = new HashMap<>();
            param.put("levelNo", levelNo);
            param.put("limit", limit);

            List<RankingDTO> rankingList = rankingService.getRankingByLevel(levelNo, limit);

            // JSON 반환
            response.setContentType("application/json;charset=UTF-8");
            response.getWriter().write(gson.toJson(rankingList));
            return null; // forward 안 함
        }

        // JSP 이동
        ActionForward forward = new ActionForward();
        forward.setRedirect(false);
        forward.setPath("/WEB-INF/our_middle_project_view/user/ranking.jsp");
        return forward;
    }
}
