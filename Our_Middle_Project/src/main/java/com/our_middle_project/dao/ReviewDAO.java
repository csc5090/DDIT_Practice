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
    List<ReviewDTO> selectReview(int limit);  // 최신 N건
    List<ReviewDTO> selectMoreReview(int ltBoardNo, int limit);  // 더보기(선택)
    List<FileImageDTO> selectImagesByBoard(int boardNo);  

}