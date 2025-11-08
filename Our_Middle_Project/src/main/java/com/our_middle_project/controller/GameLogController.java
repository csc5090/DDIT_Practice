package com.our_middle_project.controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import com.google.gson.*;
import com.our_middle_project.action.Action;
import com.our_middle_project.action.ActionForward;
import com.our_middle_project.dao.GameLogDAOImpl;
import com.our_middle_project.dashboardendpt.DashboardEndPoint; 
import com.our_middle_project.dto.GameLogDTO;
import com.our_middle_project.dto.UserInfoDTO;
import com.our_middle_project.service.GameLogServiceImpl;
import com.our_middle_project.serviceInterface.GameLogService;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class GameLogController implements Action {

    private GameLogService gameLogService = new GameLogServiceImpl(new GameLogDAOImpl());

    // LocalDateTime Adapter
    private static class LocalDateTimeAdapter implements JsonSerializer<LocalDateTime>, JsonDeserializer<LocalDateTime> {
        private static final DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

        @Override
        public JsonElement serialize(LocalDateTime src, java.lang.reflect.Type typeOfSrc, JsonSerializationContext context) {
            return new JsonPrimitive(src.format(formatter));
        }

        @Override
        public LocalDateTime deserialize(JsonElement json, java.lang.reflect.Type typeOfT, JsonDeserializationContext context) throws JsonParseException {
            return LocalDateTime.parse(json.getAsString(), formatter);
        }
    }

    @Override
    public ActionForward execute(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        // 1. loginUser에서 memNo 가져오기
        UserInfoDTO loginUser = (UserInfoDTO) session.getAttribute("loginUser");
        if (loginUser == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\":\"No loginUser in session\"}");
            return null;
        }
        Integer memNo = loginUser.getMem_no();
        System.out.println("세션에서 가져온 memNo: " + memNo);

        // 2. JSON 읽기
        StringBuilder sb = new StringBuilder();
        try (BufferedReader reader = request.getReader()) {
            String line;
            while ((line = reader.readLine()) != null) sb.append(line);
        }

        String jsonData = sb.toString();
        System.out.println("받은 JSON: " + jsonData);

        Gson gson = new GsonBuilder()
                .registerTypeAdapter(LocalDateTime.class, new LocalDateTimeAdapter())
                .create();

        GameLogDTO gameLog;
        try {
            gameLog = gson.fromJson(jsonData, GameLogDTO.class);

            // 3. 세션에서 가져온 memNo 세팅
            gameLog.setMemNo(memNo);

            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
            if (gameLog.getStartTimeStr() != null && gameLog.getStartTime() == null)
                gameLog.setStartTime(LocalDateTime.parse(gameLog.getStartTimeStr(), formatter));
            if (gameLog.getEndTimeStr() != null && gameLog.getEndTime() == null)
                gameLog.setEndTime(LocalDateTime.parse(gameLog.getEndTimeStr(), formatter));

        } catch (JsonSyntaxException | JsonIOException e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\":\"Invalid JSON format\"}");
            return null;
        }

        // 4. DB 저장
        try {
            gameLogService.saveGameLog(gameLog);
            
            // 게임 저장 성공 시, 대시보드에 실시간 갱신 신호 전송
            DashboardEndPoint.broadCastStatsUpdate();
            
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"DB insert failed\"}");
            return null;
        }

        response.setContentType("application/json; charset=UTF-8");
        response.getWriter().write("{\"result\":\"success\"}");
        return null;
    }
}