package com.our_middle_project.serviceInterface;

import java.util.List;
import com.our_middle_project.dto.AdminBoardDTO;

/**
 * 관리자 페이지의 게시판(공지사항, 게시물) 비즈니스 로직을 위한 Service 인터페이스
 */
public interface AdminBoardService {

    List<AdminBoardDTO> getAdminBoardList();

    boolean insertNotice(AdminBoardDTO dto, int adminMemNo);

    boolean updateNotice(AdminBoardDTO dto);

    boolean deleteNotice(int board_no);

    // 공지사항 생성 권한 검사 메서드
    boolean canCreateNotice(String nickname);
    
    // 공지사항 수정/삭제 권한 검사 메서드
    boolean canEditDeleteNotice(String nickname);
}