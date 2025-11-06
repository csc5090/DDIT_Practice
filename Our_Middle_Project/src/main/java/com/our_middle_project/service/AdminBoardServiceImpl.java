package com.our_middle_project.service;

import java.util.Collections;
import java.util.List;

import com.our_middle_project.dao.AdminBoardDAO;
import com.our_middle_project.dao.AdminBoardDAOImpl;
import com.our_middle_project.dto.AdminBoardDTO;
import com.our_middle_project.serviceInterface.AdminBoardService;


public class AdminBoardServiceImpl implements AdminBoardService {

	private AdminBoardDAO adminBoardDAO = new AdminBoardDAOImpl();
    
	@Override
	public List<AdminBoardDTO> getAdminBoardList() {
		try {
			List<AdminBoardDTO> noticeList = adminBoardDAO.getAdminBoardList();
			return noticeList != null ? noticeList : Collections.emptyList();
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("AdminBoardServiceImpl-getAdminBoardList 문제 발생.");
			return Collections.emptyList();
		}
	}
    
    @Override
    public boolean insertNotice(AdminBoardDTO dto, int adminMemNo) {
        dto.setMem_no(adminMemNo);
        int result = adminBoardDAO.insertNotice(dto);
        return result > 0;
    }

    @Override
    public boolean updateNotice(AdminBoardDTO dto) {
        int result = adminBoardDAO.updateNotice(dto);
        return result > 0;
    }

    @Override
    public boolean deleteNotice(int board_no) {
        int result = adminBoardDAO.deleteNotice(board_no);
        return result > 0;
    }

    @Override
    public boolean canCreateNotice(String nickname) {
        try {
            int grade = Integer.parseInt(nickname);
            return grade >= 1 && grade <= 3;
        } catch (NumberFormatException e) {
            return false;
        }
    }
    
    @Override
    public boolean canEditDeleteNotice(String nickname) {
        try {
            int grade = Integer.parseInt(nickname);
            return grade >= 1 && grade <= 4;
        } catch (NumberFormatException e) {
            return false;
        }
    }



    @Override
    public List<AdminBoardDTO> getAdminPostList() {
        try {
            List<AdminBoardDTO> postList = adminBoardDAO.getAdminPostList();
            return postList != null ? postList : Collections.emptyList();
        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
    }

    @Override
    public boolean deletePost(int board_no) {
        int result = adminBoardDAO.deletePost(board_no);
        return result > 0;
    }
}