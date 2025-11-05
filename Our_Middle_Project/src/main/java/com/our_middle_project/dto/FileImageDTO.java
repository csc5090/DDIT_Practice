package com.our_middle_project.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class FileImageDTO {

	// DB: FILE_NO (NUMBER)
	private int fileNo;
	  
	// DB: FILE_NAME (VARCHAR2)
	private String fileName;
	
	// DB: FILE_PATH (VARCHAR2)
	private String filePath;
	
	// DB: FILE_SIZE (NUMBER)
	private int fileSize;
	
	// DB: FILE_TYPE (VARCHAR2)
	private String fileType;
	
	// DB: UPLOAD_DATE (DATE)
	private String uploadDate;
	
	// DB: TYPE_NO (NUMBER)
	private int typeNo;
	
	// DB: BOARD_NO (NUMBER)
	private int boardNo;

}
