package com.our_middle_project.serviceInterface;

import java.util.List;

import com.our_middle_project.dto.GameLogDTO;
import com.our_middle_project.dto.RankingDTO;
import com.our_middle_project.dto.UserInfoDTO;

public interface MyPageService {

	UserInfoDTO getMyUserData(UserInfoDTO loingUser);

	List<RankingDTO> getMyRankingData(UserInfoDTO loingUser);

	List<GameLogDTO> getMyGameLogData(UserInfoDTO loingUser);

	boolean deleteMember(String mem_id, String inputPw);

	boolean updateMember(String mem_id, String nickname, String password, String hp, String mail);

}
