package com.our_middle_project.dto;

import lombok.Data;

@Data
public class BoardDTO {
    private String boardNo;
    private String boardTitle;
    private String boardContent;
    private String createdDate;
    private String updatedDate;
    private int viewCount;
    private int likeCount;
    private int dislikeCount;
    private String memNo;   // 작성자 번호, 반드시 필요
    private String typeNo;  // 게시판 종류
	
	//닉네임을 가져오기위한 변수
	private String memId;
	private int findBoard;
	
	//검색 필드
	private String findField;
	private String findName;
	
}
