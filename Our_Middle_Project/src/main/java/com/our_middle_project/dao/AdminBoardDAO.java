package com.our_middle_project.dao;

import java.util.List;
import com.our_middle_project.dto.AdminBoardDTO;

public interface AdminBoardDAO {

    List<AdminBoardDTO> getAdminBoardList();
    int insertNotice(AdminBoardDTO dto);
    int updateNotice(AdminBoardDTO dto);
    int deleteNotice(int board_no);

}