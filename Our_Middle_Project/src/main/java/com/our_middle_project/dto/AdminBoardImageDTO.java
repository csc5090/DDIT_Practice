package com.our_middle_project.dto;

import lombok.Data;

@Data
public class AdminBoardImageDTO {
    private int fileNo;
    private String fileName;
    private String filePath;
    private long fileSize;
}