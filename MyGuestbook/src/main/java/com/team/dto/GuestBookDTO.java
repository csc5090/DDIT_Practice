package com.team.dto;

import java.util.Date;

import lombok.Data;

@Data
public class GuestBookDTO {
	
	private int no;
	private String writer;
	private String content;
	private String pw;
	private Date regDate;
	
}

