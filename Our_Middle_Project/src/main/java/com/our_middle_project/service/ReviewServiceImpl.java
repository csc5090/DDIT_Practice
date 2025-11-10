package com.our_middle_project.service;

import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;

import com.our_middle_project.dao.ReviewDAO;
import com.our_middle_project.dao.ReviewDAOImpl;
import com.our_middle_project.dto.FileImageDTO;
import com.our_middle_project.dto.ReviewDTO;
import com.our_middle_project.serviceInterface.ReviewService;
import com.our_middle_project.util.MybatisUtil;

public class ReviewServiceImpl implements ReviewService {

	private final ReviewDAO reviewDAO = new ReviewDAOImpl();

	// === 게시글 등록 ===
	@Override
	public int insertBoard(ReviewDTO dto) {
		if (dto == null)
			return 0;
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
		if (img == null)
			return 0;
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

	@Override
	public int writeReviewTransaction(ReviewDTO boardDTO, int star, List<FileImageDTO> imageList) {

		// (★) 트랜잭션 관리를 위해 SqlSession을 직접 엽니다. (auto-commit = false)
		SqlSession session = MybatisUtil.getSqlSession(false);

		try {
			// 1. 리뷰 글(Board) 저장
			// (★) DAO 대신 SqlSession으로 매퍼를 직접 호출합니다.
			session.insert("mappers.reviewMapper.insertBoard", boardDTO);

			// (★) insertBoard 쿼리의 <selectKey> 덕분에 boardDTO 객체에 boardNo가 세팅됩니다.
			int newBoardNo = boardDTO.getBoardNo();
			if (newBoardNo == 0) {
				throw new Exception("boardNo를 가져오지 못했습니다.");
			}

			// 2. 별점(Star) 저장 (별점이 1점 이상일 때만)
			if (star > 0) {
				Map<String, Object> starParam = new HashMap<>();
				starParam.put("boardNo", newBoardNo);
				starParam.put("memNo", boardDTO.getMemNo());
				starParam.put("star", star);
				session.insert("mappers.reviewMapper.insertAuthorStar", starParam);
			}

			// 3. 이미지(Image) 메타데이터 저장 (이미지가 있을 때만)
			if (imageList != null && !imageList.isEmpty()) {
				for (FileImageDTO img : imageList) {
					img.setBoardNo(newBoardNo); // (★) 모든 이미지에 동일한 boardNo 세팅
					session.insert("mappers.reviewMapper.insertImage", img);
				}
			}

			// 4. (★) 모든 DB 작업이 성공하면 커밋
			session.commit();
			return newBoardNo; // 성공 시 boardNo 반환

		} catch (Exception e) {
			e.printStackTrace();
			// 5. (★) 하나라도 실패하면 롤백
			session.rollback();
			return 0; // 실패 시 0 반환

		} finally {
			// 6. (★) 세션 닫기
			if (session != null) {
				session.close();
			}
		}
	}

	@Override
	public boolean deleteReviewTransaction(int boardNo, int memNo) {

		// (★) 트랜잭션 관리를 위해 SqlSession을 직접 엽니다. (auto-commit = false)
		SqlSession session = MybatisUtil.getSqlSession(false);
		Map<String, Object> param = new HashMap<>();
		param.put("boardNo", boardNo);
		param.put("memNo", memNo);

		try {
			// 1. 본인 확인
			// (DAOImpl을 사용하지 않고, 트랜잭션 세션으로 직접 쿼리 호출)
			int count = session.selectOne("mappers.reviewMapper.checkReviewAuthority", param);
			if (count == 0) {
				// 본인 리뷰가 아니므로 삭제 권한 없음
				System.out.println("리뷰 삭제 권한 없음. boardNo=" + boardNo + ", memNo=" + memNo);
				session.rollback(); // (필수) 롤백
				return false;
			}

			// 2. (★) 자식 테이블부터 순서대로 삭제 (FK 제약조건 위배 방지)

			// 2-1. 이미지 삭제 (BOARD_IMAGE)
			session.delete("mappers.reviewMapper.deleteReviewImages", param);

			// 2-2. 별점 삭제 (BOARD_STAR)
			session.delete("mappers.reviewMapper.deleteReviewStars", param);

			// 2-3. 댓글 삭제 (BOARD_REPLY)
			session.delete("mappers.reviewMapper.deleteReviewReplies", param);

			// 2-4. (참고) 좋아요/싫어요 삭제 (BOARD_LIKE, BOARD_DISLIKE)
			// (Mapper에 쿼리가 없어서 생략, 필요시 추가해야 함)
			// session.delete("mappers.reviewMapper.deleteReviewLikes", param);
			// session.delete("mappers.reviewMapper.deleteReviewDislikes", param);

			// 3. (★) 부모 테이블(리뷰 본체) 삭제 (BOARD)
			session.delete("mappers.reviewMapper.deleteReviewBoard", param);

			// 4. (★) 모든 DB 작업이 성공하면 커밋
			session.commit();
			return true;

		} catch (Exception e) {
			e.printStackTrace();
			// 5. (★) 하나라도 실패하면 롤백
			session.rollback();
			return false;

		} finally {
			// 6. (★) 세션 닫기
			if (session != null) {
				session.close();
			}
		}
	}

	@Override
	public boolean updateReviewTransaction(int boardNo, int memNo, String newContent, int newStar) {

		SqlSession session = MybatisUtil.getSqlSession(false);
		Map<String, Object> param = new HashMap<>();
		param.put("boardNo", boardNo);
		param.put("memNo", memNo);

		try {
			// 1. 본인 확인
			int count = session.selectOne("mappers.reviewMapper.checkReviewAuthority", param);
			if (count == 0) {
				// 본인 리뷰가 아니므로 수정 권한 없음
				System.out.println("리뷰 수정 권한 없음. boardNo=" + boardNo + ", memNo=" + memNo);
				session.rollback();
				return false;
			}

			// 2. (★) 리뷰 본문(BOARD) 수정
			param.put("boardContent", newContent);
			session.update("mappers.reviewMapper.updateReviewBoard", param);

			// 3. (★) 리뷰 별점(BOARD_STAR) 수정 (MERGE 쿼리 사용)
			param.put("star", newStar);
			session.update("mappers.reviewMapper.updateReviewStar", param);

			// 4. (★) 모든 DB 작업이 성공하면 커밋
			session.commit();
			return true;

		} catch (Exception e) {
			e.printStackTrace();
			// 5. (★) 하나라도 실패하면 롤백
			session.rollback();
			return false;

		} finally {
			// 6. (★) 세션 닫기
			if (session != null) {
				session.close();
			}
		}
	}

}