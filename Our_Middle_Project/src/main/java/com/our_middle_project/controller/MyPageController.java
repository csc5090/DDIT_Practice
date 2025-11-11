package com.our_middle_project.controller;

import java.io.IOException;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

import com.our_middle_project.action.Action;
import com.our_middle_project.action.ActionForward;
import com.our_middle_project.dto.GameLogDTO;
import com.our_middle_project.dto.RankingDTO;
import com.our_middle_project.dto.UserInfoDTO;
import com.our_middle_project.service.MyPageServiceImpl;
import com.our_middle_project.service.RankingServiceImpl;
import com.our_middle_project.serviceInterface.MyPageService;
import com.our_middle_project.serviceInterface.RankingService;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class MyPageController implements Action {

    @Override
    public ActionForward execute(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        UserInfoDTO loginUser = (UserInfoDTO) request.getSession().getAttribute("loginUser");
        if (loginUser == null) {
            ActionForward forward = new ActionForward();
            forward.setRedirect(true);
            forward.setPath("/login.do");
            return forward;
        }

        MyPageService myPageService = new MyPageServiceImpl();
        RankingService rankingService = new RankingServiceImpl();

        // 1️⃣ 사용자 정보 가져오기
        UserInfoDTO userInfoDTO = myPageService.getMyUserData(loginUser);

        // 2️⃣ 전체 랭킹 가져오기
        List<RankingDTO> rankingList = rankingService.getRankingList();

        // 3️⃣ 레벨별 리스트
        List<RankingDTO> easyList = new ArrayList<>();
        List<RankingDTO> normalList = new ArrayList<>();
        List<RankingDTO> hardList = new ArrayList<>();

        for (RankingDTO dto : rankingList) {
            switch (dto.getLevel_no()) {
                case 1: easyList.add(dto); break;
                case 2: normalList.add(dto); break;
                case 3: hardList.add(dto); break;
            }
        }

        // 4️⃣ 점수 내림차순 정렬 + 등수 설정
        for (List<RankingDTO> list : List.of(easyList, normalList, hardList)) {
            list.sort((a, b) -> b.getScore_best() - a.getScore_best());
            for (int i = 0; i < list.size(); i++) {
                list.get(i).setRank(i + 1);
            }
        }

        // 5️⃣ 로그인 유저 데이터만 추출 (memNo 기준)
        RankingDTO easy = easyList.stream()
                .filter(r -> r.getMem_no() == loginUser.getMem_no())
                .findFirst().orElse(null);

        RankingDTO normal = normalList.stream()
                .filter(r -> r.getMem_no() == loginUser.getMem_no())
                .findFirst().orElse(null);

        RankingDTO hard = hardList.stream()
                .filter(r -> r.getMem_no() == loginUser.getMem_no())
                .findFirst().orElse(null);

        // 6️⃣ 로그아웃 처리
        if ("logout".equals(request.getParameter("action"))) {
            request.getSession().invalidate();
            ActionForward forward = new ActionForward();
            forward.setRedirect(true);
            forward.setPath("/login.do");
            return forward;
        }

        // 7️⃣ 게임 로그 가져오기
        List<GameLogDTO> gameLogDTO = myPageService.getMyGameLogData(loginUser);
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        for (GameLogDTO log : gameLogDTO) {
            if (log.getStartTime() != null) {
                log.setStartTimeStr(log.getStartTime().format(formatter));
            } else {
                log.setStartTimeStr("-");
            }
        }

        // 8️⃣ 세션에 저장
        request.getSession().setAttribute("MyPage_UserData", userInfoDTO);
        request.getSession().setAttribute("MyPage_RankingDataEasy", easy);
        request.getSession().setAttribute("MyPage_RankingDataNormal", normal);
        request.getSession().setAttribute("MyPage_RankingDataHard", hard);
        request.getSession().setAttribute("MyPage_GameLogData", gameLogDTO);

        ActionForward forward = new ActionForward();
        forward.setRedirect(false);
        forward.setPath("/WEB-INF/our_middle_project_view/user/myPage.jsp");
        return forward;
    }
}
