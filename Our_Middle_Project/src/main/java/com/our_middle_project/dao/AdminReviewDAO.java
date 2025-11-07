package com.our_middle_project.dao;

import java.util.List;
import java.util.Map;
import com.our_middle_project.dto.AdminReviewDTO;

public interface AdminReviewDAO {
	List<AdminReviewDTO> selectAllReviews(String keyword);

	int upsertAdminReply(Map<String, Object> params); // 댓글 저장/수정

	int deleteReviewImage(int boardNo); // 이미지 삭제
	
	int deleteReviewStars(int boardNo);//별점 삭제
	
	int deleteReviewReplies(int boardNo);//리뷰 댓글 삭제
	
	int deleteReview(int boardNo); // 리뷰 삭제
}