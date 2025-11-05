package com.our_middle_project.service;

import com.our_middle_project.dao.ReviewDAO;
import com.our_middle_project.dao.ReviewDAOImpl;
import com.our_middle_project.dto.FileImageDTO;
import com.our_middle_project.dto.ReviewDTO;
import com.our_middle_project.serviceInterface.ReviewService;

public class ReviewServiceImpl implements ReviewService {

	private final ReviewDAO dao = new ReviewDAOImpl();

    @Override
    public int insertBoard(ReviewDTO dto) {
        return dao.insertBoard(dto);
    }

    @Override
    public int insertImage(FileImageDTO img) {
        return dao.insertImage(img);
    }

    @Override
    public int insertAuthorStar(int boardNo, int memNo, int star) {
        return dao.insertAuthorStar(boardNo, memNo, star);
    }
    
}