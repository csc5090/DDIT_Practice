package com.our_middle_project.serviceInterface;

import java.util.List;

import com.our_middle_project.dao.ReviewDAO;
import com.our_middle_project.dto.FileImageDTO;
import com.our_middle_project.dto.ReviewDTO;
import com.our_middle_project.service.ReviewService;

public class ReviewServiceImpl implements ReviewService {

	private final ReviewDAO reviewDAO;

	public ReviewServiceImpl(ReviewDAO reviewDAO) {
		this.reviewDAO = reviewDAO;
	}

	@Override
	public int writeOnly(ReviewDTO dto, List<FileImageDTO> images, Integer starOrNull) {
		// 1) 글 저장
		reviewDAO.insertBoard(dto);
		int boardNo = dto.getBoardNo();

		// 2) 이미지 최대 2장 저장 (서버에서 재확인)
		if (images != null) {
			int cnt = 0;
			for (FileImageDTO img : images) {
				if (cnt >= 2) break;
				img.setBoardNo(boardNo);
				img.setTypeNo(2); // 리뷰
				reviewDAO.insertImage(img);
				cnt++;
			}
		}

		// 3) 별점(옵션, 1~5, 작성자 본인)
		if (starOrNull != null) {
			int star = starOrNull;
			if (star < 1 || star > 5) throw new IllegalArgumentException("STAR must be 1..5");
			reviewDAO.mergeAuthorStar(boardNo, dto.getMemNo(), star);
		}

		return boardNo;
	}
}