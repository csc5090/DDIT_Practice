package com.our_middle_project.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.google.gson.Gson;
import com.our_middle_project.action.Action;
import com.our_middle_project.action.ActionForward;
import com.our_middle_project.dao.StatsDAO;
import com.our_middle_project.dto.StatsDTO;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class AdminSignupStatsController implements Action {
    @Override
    public ActionForward execute(HttpServletRequest request, HttpServletResponse response) throws IOException {
        
        // 1. DAO를 통해 DB에서 통계 데이터를 가져옴.
        StatsDAO dao = StatsDAO.getInstance();
        List<StatsDTO> statsList = dao.getDailySignupStats();
        
        // 2. Chart.js가 원하는 형태로 데이터를 가공.
        List<String> labels = new ArrayList<>();
        List<Integer> values = new ArrayList<>();
        
        for (StatsDTO stat : statsList) {
            labels.add(stat.getLabel());
            values.add(stat.getValue());
        }
        
        // Map을 사용해 최종 JSON 구조를 만듬.
        Map<String, Object> chartData = new HashMap<>();
        chartData.put("labels", labels);
        chartData.put("values", values);
        
        // 3. 가공된 데이터를 JSON 문자열로 변환.
        String jsonResult = new Gson().toJson(chartData);
        
        // 4. JSON으로 응답.
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        PrintWriter out = response.getWriter();
        out.print(jsonResult);
        out.flush();
        
        return null;
    }
}