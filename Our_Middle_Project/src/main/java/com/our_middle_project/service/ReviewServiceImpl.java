package com.our_middle_project.service;

import java.util.Collections;
import java.util.List;
import java.util.Map;

import com.our_middle_project.dao.ReviewDAO;
import com.our_middle_project.dao.ReviewDAOImpl;
import com.our_middle_project.dto.FileImageDTO;
import com.our_middle_project.dto.ReviewDTO;
import com.our_middle_project.serviceInterface.ReviewService;

public class ReviewServiceImpl implements ReviewService {

	private final ReviewDAO reviewDAO = new ReviewDAOImpl();

	// === 게시글 등록 ===
	@Override
	public int insertBoard(ReviewDTO dto) {
		if (dto == null) return 0;
		try {
			return reviewDAO.insertBoard(dto);
		} catch (Exception e) {
			e.printStackTrace();
			return 0;
		}
	}

	// === 이미지 등록 ===
	@Override
	public int insertImage(FileImageDTO img) {
		if (img == null) return 0;
		try {
			return reviewDAO.insertImage(img);
		} catch (Exception e) {
			e.printStackTrace();
			return 0;
		}
	}
	
	// === 작성자 별점 등록 ===
	@Override
	public int insertAuthorStar(int boardNo, int memNo, int star) {
		try {
			return reviewDAO.insertAuthorStar(boardNo, memNo, star);
		} catch (Exception e) {
			e.printStackTrace();
			return 0;
		}
	}
	
	// === 리뷰 목록 ===
	@Override
	public List<ReviewDTO> selectReview() {
		try {
			List<ReviewDTO> list = reviewDAO.selectReview();
			return list != null ? list : Collections.emptyList();
		} catch (Exception e) {
			e.printStackTrace();
			return Collections.emptyList();
		}
	}

}