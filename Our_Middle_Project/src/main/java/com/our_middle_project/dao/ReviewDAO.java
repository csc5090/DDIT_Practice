package com.our_middle_project.dao;

import java.util.List;

import com.our_middle_project.dto.ReviewDTO;

public interface ReviewDAO {
	List<ReviewDTO> selectAllReviews();
}
