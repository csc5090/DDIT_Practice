package com.our_middle_project.dao;

import java.util.List;

import com.our_middle_project.dto.AdminReviewDTO;

public interface AdminReviewDAO {
	List<AdminReviewDTO> selectAllReviews();
}
