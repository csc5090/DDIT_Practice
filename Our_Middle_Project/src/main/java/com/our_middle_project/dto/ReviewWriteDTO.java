package com.our_middle_project.dto;

import java.util.List;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ReviewWriteDTO {
	
	private int boardNo;
	private int memNo;
	private int typeNo;
	private String boardTitle;
	private String boardContent;
	private String createDate;
	private String updateDate;
	private String nickName;
	private int star;
	private List<FileImageDTO> images;

}
