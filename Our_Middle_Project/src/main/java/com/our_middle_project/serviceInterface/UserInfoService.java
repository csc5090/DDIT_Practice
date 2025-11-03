package com.our_middle_project.serviceInterface;

import java.util.Map;

import com.our_middle_project.dto.UserInfoDTO;
import com.our_middle_project.dto.UserInfoReturnDTO;

public interface UserInfoService {

	void JoinUser(UserInfoDTO userInfo);

	UserInfoDTO getIdCheck(UserInfoDTO userInfo);

	UserInfoReturnDTO getIdFind(UserInfoDTO userInfo);

	UserInfoReturnDTO getPasswordFind(UserInfoDTO userInfo);

	void newPasswordSave(Map<String, Object> pram);

}
