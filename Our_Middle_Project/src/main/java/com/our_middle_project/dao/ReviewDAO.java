package com.our_middle_project.dao;

import java.util.List;
import java.util.Map;

import com.our_middle_project.dto.FileImageDTO;
import com.our_middle_project.dto.ReviewDTO;

public interface ReviewDAO {
	
	// insert
	int insertBoard(ReviewDTO dto);            
	int insertImage(FileImageDTO img);
	int insertAuthorStar(int boardNo, int memNo, int star);
	
	// select
    List<ReviewDTO> selectReview();

}