package com.our_middle_project.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class FileImageDTO {

	  private int fileNo;
	  private int boardNo;
	  private int typeNo;       
	  private String fileName;   
	  private String filePath;   
	  private int fileSize;
	  private String fileType;   
	  private String uploadDate;
}
