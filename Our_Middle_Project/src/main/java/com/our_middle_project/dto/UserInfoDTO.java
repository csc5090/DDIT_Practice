package com.our_middle_project.dto;

import lombok.Data;

@Data
public class UserInfoDTO {

	private int mem_no;
	private String mem_id;
	private String mem_pass;
	private String mem_name;
	private String mem_gender;
	private String mem_birth;
	private String mem_zip;
	private String mem_add1;
	private String mem_add2;
	private String mem_hp;
	private String mem_mail;
	private String nickname;
	private String create_date;
	private String deleted_data;
	private String delete_reason;
	private String status;
	private String role;
	private String salt;
	
}
