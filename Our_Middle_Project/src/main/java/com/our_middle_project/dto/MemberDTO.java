package com.our_middle_project.dto;

import java.sql.Date;
import lombok.Data;

@Data
public class MemberDTO {
    private int userNo;
    private String userId;
    private String nickname;
    private Date regDate;
    private String status;
}