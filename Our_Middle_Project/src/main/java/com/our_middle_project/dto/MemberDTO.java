package com.our_middle_project.dto;

import java.sql.Date;
import lombok.Data;

@Data
public class MemberDTO {
    private int userNo;
    private String userId;
    //비밀번호는 보안상 DTO에 안적음
    private String userName;
    private String nickname;
    private Date regDate;
    private String status;
    private String userMail;
    private String role;
    private Date deleted_date;
    private String deleted_reason;
}