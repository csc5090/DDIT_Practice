package com.our_middle_project.dao;

import com.our_middle_project.dto.FileImageDTO;
import com.our_middle_project.dto.ReviewDTO;

public interface ReviewDAO {
	
	int insertBoard(ReviewDTO dto);            
	int insertImage(FileImageDTO img);
	int mergeAuthorStar(int boardNo, int memNo, int star);
	
}