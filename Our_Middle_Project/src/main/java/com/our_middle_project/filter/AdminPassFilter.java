package com.our_middle_project.filter;

import java.io.IOException;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * 관리자 페이지 보안 필터 (수정됨)
 * 1. (유지) 로그아웃 후 접근을 차단 (메인 세션 'loginAdmin' 검사)
 * 2. (추가) 브라우저 캐시를 비활성화 (뒤로가기 차단)
 * 3. (삭제) '일회용 티켓' 로직 삭제 (새로고침 허용)
 */

@WebFilter(urlPatterns = {
	    "/adminMain.do",        // 관리자 메인 페이지
	    "/getStats.do",         // 대시보드 API
	    "/getReviewList.do",    // 리뷰 목록 API
	    "/updateAdminReply.do", // 리뷰 댓글 저장 API
	    "/deleteReview.do",     // 리뷰 삭제 API
	    "/deleteReviewImage.do" // 리뷰 이미지 삭제 API
	})
public class AdminPassFilter implements Filter {

	private String errorPage = "/WEB-INF/our_middle_project_view/error.jsp";

	@Override
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
			throws IOException, ServletException {

		HttpServletRequest httpRequest = (HttpServletRequest) request;
		HttpServletResponse httpResponse = (HttpServletResponse) response;
		HttpSession session = httpRequest.getSession(false);

		String adminSessionKey = "loginAdmin";

		
		// loginAdmin가 있는지 검사 ---
		if (session == null || session.getAttribute(adminSessionKey) == null) {
			System.out.println("[AdminPassFilter] 'loginAdmin' 세션 없음. 에러 페이지로 포워딩.");

			request.setAttribute("errorMessage", "적절한 세션이 없는 것");
			httpRequest.getRequestDispatcher(errorPage).forward(httpRequest, httpResponse);
			return; 
		}

		// 캐시 비활성화 헤더 설정
        // (뒤로가기 버튼으로 캐시된 페이지에 접근하는 것을 방지)
        httpResponse.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1
        httpResponse.setHeader("Pragma", "no-cache"); // HTTP 1.0
        httpResponse.setDateHeader("Expires", 0); // Proxies
        
        // 1차 검문을 통과했으면 무조건 통과
        // (새로고침 및 모든 관리자 접근 허용)
        chain.doFilter(request, response);
	}

	@Override
	public void init(FilterConfig filterConfig) throws ServletException {
		// (필터 초기화)
	}

	@Override
	public void destroy() {
		// (필터 종료)
	}
}