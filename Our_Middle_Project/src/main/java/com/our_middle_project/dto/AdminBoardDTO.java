package com.our_middle_project.dto;

import java.util.Date;
import lombok.Data;

/**
 * 관리자 페이지의 게시판(공지사항, 게시물) 조회를 위한 DTO
 */
@Data
public class AdminBoardDTO {

    private int board_no;
    private String board_title;
    private String board_content; 
    private String created_date;
    private Date updated_date;
    private int view_count;
    private int like_count;
    private int dislike_count;
    private int mem_no;
    private int type_no;

    private String nickname;
    private String userId; 
}