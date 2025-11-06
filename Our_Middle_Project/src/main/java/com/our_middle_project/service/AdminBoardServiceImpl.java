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
    
    //  insertNotice 메서드 구현체 (memNo 파라미터 추가
    @Override
    public boolean insertNotice(AdminBoardDTO dto, int adminMemNo) {
        //컨트롤러에서 받은 작성자 정보를 DTO에 설정.
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

    // 공지사항 생성 권한 검사 로직
    @Override
    public boolean canCreateNotice(String nickname) {
        // 공지사항 생성 권한은 닉네임(등급) 1, 2, 3만 허용
        try {
            int grade = Integer.parseInt(nickname);
            return grade >= 1 && grade <= 3;
        } catch (NumberFormatException e) {
            return false; // 닉네임이 숫자가 아니면 권한 없음
        }
    }
    
    // 3. 공지사항 수정/삭제 권한 검사 로직
    @Override
    public boolean canEditDeleteNotice(String nickname) {
        // 공지사항 수정/삭제 권한은 닉네임(등급) 1, 2, 3, 4 모두 허용
        try {
            int grade = Integer.parseInt(nickname);
            return grade >= 1 && grade <= 4;
        } catch (NumberFormatException e) {
            return false; // 닉네임이 숫자가 아니면 권한 없음
        }
    }
}