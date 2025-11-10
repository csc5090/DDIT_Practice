package com.our_middle_project.controller;

import java.io.IOException;
import java.time.format.DateTimeFormatter;
import java.util.List;

import com.our_middle_project.action.Action;
import com.our_middle_project.action.ActionForward;
import com.our_middle_project.dto.GameLogDTO;
import com.our_middle_project.dto.RankingDTO;
import com.our_middle_project.dto.UserInfoDTO;
import com.our_middle_project.service.MyPageServiceImpl;
import com.our_middle_project.serviceInterface.MyPageService;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class MyPageController implements Action {

    @Override
    public ActionForward execute(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
    	System.out.println();
        System.out.println("MyPageController Start");
        System.out.println();
        
        
        
        UserInfoDTO loginUser = (UserInfoDTO) request.getSession().getAttribute("loginUser");
        System.out.println(loginUser);
        
        if (loginUser == null) {
            ActionForward forward_ = new ActionForward();
            forward_.setRedirect(true);
            forward_.setPath("/login.do");
            System.out.println("로그인 필요");
            return forward_;
        }
        
        MyPageService myPageService = new MyPageServiceImpl();
        
        // 사용자 정보 가져오기
        UserInfoDTO userInfoDTO = myPageService.getMyUserData(loginUser);
        
        
        // 랭킹 정보 가져오기
        List<RankingDTO> rankingDTOList = myPageService.getMyRankingData(loginUser);
        
        // score_best 기준 내림차순 정렬 (높은 점수 = 1등)
        rankingDTOList.sort((a, b) -> b.getScore_best() - a.getScore_best());

        
        // 레벨별 RankingDTO 분리 및 rank 설정
        RankingDTO hard = null;
        RankingDTO normal = null;
        RankingDTO easy = null;

        int currentRank = 1;
        for (RankingDTO dto : rankingDTOList) {
            dto.setRank(currentRank++);  // 등수 넣기
            
            if (dto.getLevel_no() == 3) hard = dto;
            else if (dto.getLevel_no() == 2) normal = dto;
            else if (dto.getLevel_no() == 1) easy = dto;
        }
        

        
        // 게임 로그 가져오기
        List<GameLogDTO> gameLogDTO = myPageService.getMyGameLogData(loginUser);  
        
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");

        for(GameLogDTO log : gameLogDTO) {
            if(log.getStartTime() != null) {
                log.setStartTimeStr(log.getStartTime().format(formatter));
            } else {
                log.setStartTimeStr("-");
            }
        }
        
        // 세션에 각각 담기
        request.getSession().setAttribute("MyPage_UserData", userInfoDTO);
        request.getSession().setAttribute("MyPage_RankingDataHard", hard);
        request.getSession().setAttribute("MyPage_RankingDataNormal", normal);
        request.getSession().setAttribute("MyPage_RankingDataEasy", easy);
        request.getSession().setAttribute("MyPage_GameLogData", gameLogDTO);
        
        
        System.out.println("0 startTimeStr = " + gameLogDTO.get(0).getStartTimeStr());
        System.out.println("1 startTimeStr = " + gameLogDTO.get(1).getStartTimeStr());
        
        System.out.println(userInfoDTO);
 
        System.out.println("Hard: " + hard);
        System.out.println("Normal: " + normal);
        System.out.println("Easy: " + easy);
        System.out.println(gameLogDTO);
        
        ActionForward forward = new ActionForward();
        forward.setRedirect(false); // 포워드 방식
        forward.setPath("/WEB-INF/our_middle_project_view/user/myPage.jsp");
        
        return forward;
    }
}
