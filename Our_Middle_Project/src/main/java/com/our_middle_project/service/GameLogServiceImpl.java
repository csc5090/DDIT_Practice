package com.our_middle_project.service;

import com.our_middle_project.dao.GameLogDAO;
import com.our_middle_project.dto.GameLogDTO;
import com.our_middle_project.serviceInterface.GameLogService;

public class GameLogServiceImpl implements GameLogService {
	
	private GameLogDAO gameLogDAO;

    public GameLogServiceImpl(GameLogDAO gameLogDAO) {
        this.gameLogDAO = gameLogDAO;
    }
	
	public void saveGameLog(GameLogDTO gameLog) {
		gameLogDAO.insertGameLog(gameLog);
	}

}
