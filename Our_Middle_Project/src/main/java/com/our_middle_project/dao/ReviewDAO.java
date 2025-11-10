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
	
	int checkReviewAuthority(Map<String, Object> param);
	
	// --- (삭제 트랜잭션용 메소드) ---
    // ReviewServiceImpl이 SqlSession을 직접 제어하며 호출할 것임
    void deleteReviewImages(Map<String, Object> param);
    void deleteReviewStars(Map<String, Object> param);
    void deleteReviewReplies(Map<String, Object> param);
    void deleteReviewBoard(Map<String, Object> param);
    
    int updateReviewBoard(Map<String, Object> param);
    
    int updateReviewStar(Map<String, Object> param);

}