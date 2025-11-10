package com.our_middle_project.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import com.google.gson.Gson;
import com.our_middle_project.action.Action;
import com.our_middle_project.action.ActionForward;
import com.our_middle_project.dto.RankingDTO;
import com.our_middle_project.service.RankingServiceImpl;
import com.our_middle_project.serviceInterface.RankingService;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class RankingController implements Action {

    @Override
    public ActionForward execute(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

    	RankingService rankingService = new RankingServiceImpl();
    	 
        List<RankingDTO> rankingList = rankingService.getRankingList();

        List<RankingDTO> easyList = new ArrayList<>();
        List<RankingDTO> normalList = new ArrayList<>();
        List<RankingDTO> hardList = new ArrayList<>();
            
        for(int i=0 ; i<rankingList.size() ; i++) {
        	
        	int lv_no = rankingList.get(i).getLevel_no();
        	
        	if(lv_no == 1) {
        		easyList.add(rankingList.get(i));
        	}
        	else if(lv_no == 2) {
        		normalList.add(rankingList.get(i));
        	}
        	else if(lv_no == 3) {
        		hardList.add(rankingList.get(i));
        	}
        	else {
        		System.out.println(rankingList.get(i));
        		System.out.println("no mach level data");
        	}
        }
        
        Gson gson = new Gson();
        String easy = gson.toJson(easyList);
        String normal = gson.toJson(normalList);
        String hard = gson.toJson(hardList);
        request.getSession().setAttribute("easyList", easy);
        request.getSession().setAttribute("normalList", normal);
        request.getSession().setAttribute("hardList", hard);
    	
        ActionForward forward = new ActionForward();
        forward.setRedirect(false);
        forward.setPath("/WEB-INF/our_middle_project_view/user/ranking.jsp");
        return forward;
    }
}
