package com.our_middle_project.controller;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import com.our_middle_project.action.Action;
import com.our_middle_project.action.ActionForward;
import com.our_middle_project.dto.GameLogDTO;
import com.our_middle_project.serviceInterface.GameLogService;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class GameLogController implements Action {
	
	private GameLogService gameLogService;

	public GameLogController() {
	    // 기본 생성자
	}
    // 생성자 주입
    public GameLogController(GameLogService gameLogService) {
        this.gameLogService = gameLogService;
    }
    
	@Override
	public ActionForward execute(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		HttpSession session = request.getSession();
		Integer sessionMemNo = (Integer) session.getAttribute("memNo");
		
		if(sessionMemNo == null) {
		    ActionForward forward = new ActionForward();
		    forward.setRedirect(true);
		    forward.setPath("login.do");
		    return forward;
		}

        // 클라이언트에서 전송한 게임 정보 가져오기
        int reqMemNo = Integer.parseInt(request.getParameter("memNo"));
        int levelNo = Integer.parseInt(request.getParameter("levelNo"));
        int score = Integer.parseInt(request.getParameter("score"));
        int combo = Integer.parseInt(request.getParameter("combo"));
        int clearTime = Integer.parseInt(request.getParameter("clearTime"));
        String startTime = request.getParameter("startTime");
        String endTime = request.getParameter("endTime");

        


     // DTO 생성
        GameLogDTO gameLog = new GameLogDTO();
        gameLog.setMemNo(sessionMemNo);
        gameLog.setLevelNo(Integer.parseInt(request.getParameter("levelNo")));
        gameLog.setScore(Integer.parseInt(request.getParameter("score")));
        gameLog.setCombo(Integer.parseInt(request.getParameter("combo")));
        gameLog.setClearTime(Integer.parseInt(request.getParameter("clearTime")));

        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
        gameLog.setStartTime(LocalDateTime.parse(request.getParameter("startTime"), formatter));
        gameLog.setEndTime(LocalDateTime.parse(request.getParameter("endTime"), formatter));

        // 서비스 호출
        gameLogService.saveGameLog(gameLog);

        // 완료 후 페이지 이동 (예: 게임 종료 페이지)
//        ActionForward forward = new ActionForward();
//        forward.setRedirect(true);
//        forward.setPath("gameEndSuccess.do"); // JSP나 다른 컨트롤러 URL
          return null;
    }
}
