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

	// K-Card: 오늘 작성된 리뷰 수
	int getTodayReviewCount();

	// 바 차트: 리뷰 평점 분포
	List<Map<String, Object>> getRatingDistribution();

}