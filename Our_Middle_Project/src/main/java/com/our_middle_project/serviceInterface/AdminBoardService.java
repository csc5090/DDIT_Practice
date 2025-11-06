package com.our_middle_project.serviceInterface;

import java.util.List;
import com.our_middle_project.dto.AdminBoardDTO;

public interface AdminBoardService {

    List<AdminBoardDTO> getAdminBoardList();
    boolean insertNotice(AdminBoardDTO dto, int adminMemNo);
    boolean updateNotice(AdminBoardDTO dto);
    boolean deleteNotice(int board_no);
    boolean canCreateNotice(String nickname);
    boolean canEditDeleteNotice(String nickname);

    List<AdminBoardDTO> getAdminPostList();

    boolean deletePost(int board_no);
}