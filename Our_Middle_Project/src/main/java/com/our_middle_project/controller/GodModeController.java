package com.our_middle_project.controller;

import java.io.IOException;

import com.our_middle_project.action.Action;
import com.our_middle_project.action.ActionForward;
import com.our_middle_project.dto.UserInfoDTO;
import com.our_middle_project.service.UserInfoServiceImpl;
import com.our_middle_project.serviceInterface.UserInfoService;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * [테스트용 백도어 컨트롤러]
 * /godmode.do (가칭) URL로 접근 시, 'admin1' 계정으로 즉시 강제 로그인시키고
 * 'ADMIN_PASS' 티켓을 발급하여 /adminMain.do로 리다이렉트합니다.
 */
public class GodModeController implements Action {

	// 'GameMaster' 
	private static final String MASTER_ADMIN_ID = "admin1";

	@Override
	public ActionForward execute(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		System.out.println("!!! 테스트용 백도어 로그인 실행 !!!");
		
		try {
			// 1. LoginCheckController와 동일하게 UserInfoService를 사용
			UserInfoService userInfoService = new UserInfoServiceImpl();
			
			// 2. admin1 계정 정보를 가져오기 위해 ID만 있는 DTO를 생성
			UserInfoDTO dummyInfo = new UserInfoDTO();
			dummyInfo.setMem_id(MASTER_ADMIN_ID);
			
			// 3. DB에서 'admin1'의 전체 정보 조회
			// (LoginCheckController의 loginCheck() 메소드는 ID로 유저 정보를 가져옴)
			UserInfoDTO adminInfo = userInfoService.loginCheck(dummyInfo);
			
			if (adminInfo == null || !"ADMIN".equals(adminInfo.getRole())) {
				// 'admin1' 계정이 없거나 ADMIN이 아닌 경우
				throw new Exception(MASTER_ADMIN_ID + " 계정을 찾을 수 없거나 ADMIN이 아닙니다.");
			}
			
			// 4. 세션에 강제로 관리자 정보 주입
			HttpSession session = request.getSession();
			session.setAttribute("loginAdmin", adminInfo);
			
			// 5. AdminPassFilter를 통과할 1회용 티켓 주입
			session.setAttribute("ADMIN_PASS", true);
			
			System.out.println(">>> 백도어: " + adminInfo.getMem_name() + "님 강제 로그인 성공.");
			
			// 6. 관리자 메인 페이지로 리다이렉트
			ActionForward forward = new ActionForward();
			forward.setRedirect(true); // 리다이렉트
			forward.setPath("/adminMain.do"); // web.xml에 .do 패턴이 있으므로 ContextPath 불필요
			
			return forward;
			
		} catch (Exception e) {
			e.printStackTrace();
			// 실패 시 에러 페이지
			ActionForward forward = new ActionForward();
			forward.setRedirect(false); // 포워드
			request.setAttribute("errorMessage", "백도어 로그인 실패: " + e.getMessage());
			forward.setPath("/WEB-INF/our_middle_project_view/error.jsp");
			return forward;
		}
	}
}