package com.our_middle_project.dto;

public class ReviewDTO {
	private int boardNo;         	// 리뷰 고유 번호 (BOARD.BOARD_NO)
    private String boardTitle;      // 리뷰 제목 (BOARD.BOARD_TITLE)
    private String boardContent;    // 리뷰 내용 (BOARD.BOARD_CONTENT)
    private String nickname;        // 작성자 닉네임 (MEMBER.NICKNAME)
    private String createdDate;     // 작성일 (BOARD.CREATED_DATE, YYYY-MM-DD)
    private int stars;              // 별점 (BOARD_STAR.STAR)
    private String hasImage;        // 이미지 존재 여부 ('Y' 또는 'N')
    private String adminReply;      // 관리자 댓글 내용 (BOARD_REPLY.REPLY_CONTENT)
    private String adminReplyDate;  // 관리자 댓글 작성일 (BOARD_REPLY.CREATE_DATE)
}
