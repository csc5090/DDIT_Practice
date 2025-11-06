package com.our_middle_project.serviceInterface;

import java.util.List;

import com.our_middle_project.dto.FileImageDTO;
import com.our_middle_project.dto.ReviewDTO;

public interface ReviewService {
	
	// insert
	int insertBoard(ReviewDTO dto);

	int insertImage(FileImageDTO img);

	int insertAuthorStar(int boardNo, int memNo, int star);
	
	
    // select
    List<ReviewDTO> selectReview(int limit);
    
    List<ReviewDTO> selectMoreReview(int ltBoardNo, int limit);
    
    // 무한스크롤 안 쓰면 호출 안 하면 됨
    List<FileImageDTO> selectImagesByBoard(int boardNo);
}