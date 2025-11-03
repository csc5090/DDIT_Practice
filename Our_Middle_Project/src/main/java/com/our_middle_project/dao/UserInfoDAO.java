package com.our_middle_project.dao;

import com.our_middle_project.dto.UserInfoDTO;

public interface UserInfoDAO {

	void JoinUser(UserInfoDTO userInfo);

	UserInfoDTO getIdCheck(UserInfoDTO userInfo);

	UserInfoDTO getIdFind(UserInfoDTO userInfo);

	UserInfoDTO getPasswordFind(UserInfoDTO userInfo);
	
}
