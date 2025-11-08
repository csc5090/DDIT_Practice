package com.our_middle_project.dao;

import java.util.List;
import java.util.Map;

import com.our_middle_project.dto.AdminBoardImageDTO;
import com.our_middle_project.dto.AdminReviewDTO;

public interface AdminReviewDAO {
	List<AdminReviewDTO> selectAllReviews(String keyword);

	int upsertAdminReply(Map<String, Object> params); // 댓글 저장/수정

	int deleteReviewStars(int boardNo);// 별점 삭제

	int deleteReviewImageByFileNo(int fileNo); // 단일

	int deleteReviewImagesByFileNos(List<Integer> fileNos); // 배치

	int deleteAllReviewImagesByBoardNo(int boardNo); // 전체(보드 단위)

	int deleteReviewReplies(int boardNo);// 리뷰 댓글 삭제

	int deleteReview(int boardNo); // 리뷰 삭제

	List<AdminBoardImageDTO> selectReviewImages(int boardNo);

	public void deleteBoardDislikes(int boardNo);
}