package com.our_middle_project.dto;

import lombok.Data;

@Data
public class BoardDTO {
	private String boardNo;
	private String boardTitle;
	private String boardContent;
	private String createdDate;
	private String updateDate;
	private String viewCount;
	private String likeCount;
	private String dislikeCount;
	private String memNo;
	private String typeNo;
	
	//닉네임을 가져오기위한 변수
	private String memId;
	private int findBoard;
}
