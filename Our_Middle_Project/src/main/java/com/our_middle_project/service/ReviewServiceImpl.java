package com.our_middle_project.service;

import java.util.List;

import com.our_middle_project.dao.ReviewDAO;
import com.our_middle_project.dao.ReviewDAOImpl;
import com.our_middle_project.dto.FileImageDTO;
import com.our_middle_project.dto.ReviewDTO;
import com.our_middle_project.serviceInterface.ReviewService;

public class ReviewServiceImpl implements ReviewService {


	private final ReviewDAO reviewDAO;

	/** 기본 생성자: 내부에서 DAO 생성 (변경 최소) */
	public ReviewServiceImpl() {
		this.reviewDAO = new ReviewDAOImpl();
	}

	/** 주입용 생성자 (테스트/확장용) */
	public ReviewServiceImpl(ReviewDAO reviewDAO) {
		this.reviewDAO = reviewDAO;
	}

	@Override
	public int writeOnly(ReviewDTO dto, List<FileImageDTO> images, Integer starOrNull) {
		// 1) 본문 저장
		reviewDAO.insertBoard(dto);
		int boardNo = dto.getBoardNo();

		// 2) 이미지 저장 (최대 2장)
		if (images != null) {
			int cnt = 0;
			for (FileImageDTO img : images) {
				if (cnt >= 2) break;
				img.setBoardNo(boardNo);
				img.setTypeNo(2); // 리뷰 타입
				reviewDAO.insertImage(img);
				cnt++;
			}
		}

		// 3) 별점 (옵션: 1~5)
		if (starOrNull != null) {
			int star = starOrNull;
			if (star < 1 || star > 5) {
				throw new IllegalArgumentException("STAR must be 1..5");
			}
			reviewDAO.mergeAuthorStar(boardNo, dto.getMemNo(), star);
		}

		return boardNo;
	}
}