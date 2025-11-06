package com.our_middle_project.dto;

import lombok.Data;

@Data
public class AdminCommentDTO {
    
    private int reply_no;       // 댓글 번호
    private int board_no;       // 원본 게시물 번호
    private int mem_no;         // 작성자 회원 번호
    private String reply_content; // 댓글 내용
    private String create_date;   // 작성일 (TO_CHAR()로 포맷팅)
    
    // Member Join
    private String nickname;      // 작성자 닉네임
    private String userId;        // 작성자 ID (MEMBER.MEM_ID)
}