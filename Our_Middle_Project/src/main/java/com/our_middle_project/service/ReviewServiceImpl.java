package com.our_middle_project.service;

import java.util.List;

import com.our_middle_project.dao.ReviewDAO;
import com.our_middle_project.dto.FileImageDTO;
import com.our_middle_project.dto.ReviewDTO;

public class ReviewServiceImpl implements ReviewService {

	private final ReviewDAO reviewDAO;

	public ReviewServiceImpl(ReviewDAO reviewDAO) {
		this.reviewDAO = reviewDAO;
	}

	@Override
	public int writeOnly(ReviewDTO dto, List<FileImageDTO> images, Integer starOrNull) {
		reviewDAO.insertBoard(dto);
		int boardNo = dto.getBoardNo();

		if (images != null) {
			int cnt = 0;
			for (FileImageDTO img : images) {
				if (cnt >= 2) break;
				img.setBoardNo(boardNo);
				img.setTypeNo(2);
				reviewDAO.insertImage(img);
				cnt++;
			}
		}

		if (starOrNull != null) {
			int star = starOrNull;
			if (star < 1 || star > 5) throw new IllegalArgumentException("STAR must be 1..5");
			reviewDAO.mergeAuthorStar(boardNo, dto.getMemNo(), star);
		}
		return boardNo;
	}
}