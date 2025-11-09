package com.our_middle_project.dao;

import java.util.List;

import com.our_middle_project.dto.GameLogDTO;
import com.our_middle_project.dto.RankingDTO;
import com.our_middle_project.dto.UserInfoDTO;

public interface MyPageDAO {

	UserInfoDTO getMyUserData(UserInfoDTO loingUser);

	List<RankingDTO> getMyRankingData(UserInfoDTO loingUser);

	List<GameLogDTO> getMyGameLogData(UserInfoDTO loingUser);

}
