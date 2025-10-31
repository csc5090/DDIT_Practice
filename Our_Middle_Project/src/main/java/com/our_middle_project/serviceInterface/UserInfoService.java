package com.our_middle_project.serviceInterface;

import com.our_middle_project.dto.UserInfoDTO;

public interface UserInfoService {

	void JoinUser(UserInfoDTO userInfo);

	UserInfoDTO getIdCheck(UserInfoDTO userInfo);

}
