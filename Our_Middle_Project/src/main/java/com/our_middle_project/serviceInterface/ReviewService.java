package com.our_middle_project.serviceInterface;

import com.our_middle_project.dto.FileImageDTO;
import com.our_middle_project.dto.ReviewDTO;

public interface ReviewService {
	
	int insertBoard(ReviewDTO dto);

	int insertImage(FileImageDTO img);

	int insertAuthorStar(int boardNo, int memNo, int star);
}