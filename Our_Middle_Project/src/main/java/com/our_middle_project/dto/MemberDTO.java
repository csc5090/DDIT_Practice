package com.our_middle_project.dto;

import java.sql.Date;
import lombok.Data;

@Data
public class MemberDTO {
	// DB: MEM_NO (NUMBER)
    private int memNo;

    // DB: MEM_ID (VARCHAR2)
    private String userId;

    // DB: MEM_NAME (VARCHAR2)
    private String userName;

    // DB: NICKNAME (VARCHAR2)
    private String nickname;
    
    // DB: MEM_MAIL (VARCHAR2)
    private String userMail;

    // DB: MEM_GENDER (CHAR)
    private String memGender;

    // DB: MEM_BIRTH (DATE)
    private Date memBirth;

    // DB: MEM_ZIP (VARCHAR2)
    private String memZip;

    // DB: MEM_ADD1 (VARCHAR2)
    private String memAdd1;

    // DB: MEM_ADD2 (VARCHAR2)
    private String memAdd2;

    // DB: MEM_HP (VARCHAR2)
    private String memHp;

    // DB: STATUS (VARCHAR2)
    private String status;

    // DB: ROLE (VARCHAR2)
    private String role;
    
    // DB: CREATED_DATE (DATE)
    private Date regDate;

    // DB: DELETED_DATE (DATE)
    private Date deletedDate;

    // DB: DELETED_REASON (VARCHAR2)
    private String deletedReason;
}