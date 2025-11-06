package com.our_middle_project.dao;

import java.util.List;
import java.util.Map;

import com.our_middle_project.dto.AdminReviewDTO;

public interface AdminReviewDAO {
	List<AdminReviewDTO> selectAllReviews(String keyword);

    // ▼▼▼ [추가] 3개 메소드 ▼▼▼
	int upsertAdminReply(Map<String, Object> params);
	int deleteReviewImage(int boardNo);
	int deleteReview(int boardNo);
}
