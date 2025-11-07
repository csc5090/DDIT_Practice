package com.our_middle_project.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ReviewDTO {
	
	// DB: BOARD_NO (NUMBER)
	private int boardNo;

	// DB: BOARD_TITLE (VARCHAR2)
	private String boardTitle;
	
	// DB: BOARD_CONTENT (CLOB)
	private String boardContent;
	
	// DB: CREATED_DATE (DATE)
	private String createdDate;
	
	// DB: UPDATED_DATE (DATE)
	private String updatedDate;
	
	// DB: MEM_NO (NUMBER)
	private int memNo;
	
	// DB: MEM_ID (VARCHAR2)
	private String memId;
	
	// DB: TYPE_NO (NUMBER)
	private int typeNo;
	
	// DB: MEMBER.NICKNAME (VARCHAR2)
	private String nickName;
	
	// DB: BOARD_STAR.STAR (NUMBER)
	private int star;
	
	// DB: FILE_IMAGE.PATH (FILE_PATH)
	private String thumbUrl;
	
}