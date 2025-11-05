package com.our_middle_project.dao;

import java.util.List;

import com.our_middle_project.dto.GameLevelDTO;

public interface GameDAO {

	List<GameLevelDTO> getLevelInfo();

}
