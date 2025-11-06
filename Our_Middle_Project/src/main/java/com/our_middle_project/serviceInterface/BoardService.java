package com.our_middle_project.serviceInterface;

import java.util.List;
import org.apache.ibatis.session.SqlSession;
import com.our_middle_project.dto.BoardDTO;
import com.our_middle_project.dto.UserInfoDTO;

public interface BoardService {
	public List<BoardDTO> selectFreeBoard();
	
	// 게시글 상세 1건 가져오기
	public BoardDTO selectBoardCont(String boardNo);

	// 1) 특정 페이지의 게시글 리스트를 가져오기
	public List<BoardDTO> getBoardList(int page, int pageSize);

	// 2) 전체 게시글 수를 가져오기
    int getTotalCount();

    // 게시글 수정
    public int updateBoard(BoardDTO board);
	
    
    //새 글 작성
    int insertBoard(BoardDTO dto);
    
    //수정폼 열기 전에 본인 글 체크
	public com.our_middle_project.dto.BoardDTO selectBoardForEdit(String boardNo, String loginUserMemNo);
	
	// 삭제 처리
	boolean deleteBoard(BoardDTO boardDTO); 
}
