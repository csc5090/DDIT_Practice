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
 * 관리자 페이지 보안 필터 (검문소 역할)
 * 1. URL 직접 입력을 차단 (일회용 티켓 'ADMIN_PASS' 검사)
 * 2. 로그아웃 후 접근을 차단 (메인 세션 'loginAdmin' 검사)
 */

@WebFilter(urlPatterns = { "/adminMain.do", // 관리자 메인 페이지
		"/dashboard.do", // 대시보드
		"/getStats.do", // 대시보드 API
		"/getUserList.do", // 유저 목록 API
		"/getUserDetails.do", // 유저 상세 API
		"/updateUser.do", // 유저 수정 API
		"/getReviewList.do" // 리뷰 목록 API
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
		String adminPassKey = "ADMIN_PASS";

		String requestURI = httpRequest.getRequestURI();
		String contextPath = httpRequest.getContextPath();
		String url = requestURI.substring(contextPath.length());

		// --- 1. 'loginAdmin' 세션 검사 (로그아웃/세션만료 차단) ---
		if (session == null || session.getAttribute(adminSessionKey) == null) {
			System.out.println("[AdminPassFilter] 'loginAdmin' 세션 없음. 에러 페이지로 포워딩.");
			request.setAttribute("errorMessage", "접근 권한이 없습니다. (로그인 필요)");
			httpRequest.getRequestDispatcher(errorPage).forward(httpRequest, httpResponse);
			return;
		}
		
		httpResponse.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1
        httpResponse.setHeader("Pragma", "no-cache");
        httpResponse.setDateHeader("Expires", 0);

		// --- 2. 'ADMIN_PASS' 티켓 검사 (새로고침/URL입력 차단) ---
		if (url.equals("/adminMain.do")) {

			if (session.getAttribute(adminPassKey) != null) {
				// (성공) 티켓이 있음 = 정식 로그인
				System.out.println("[AdminPassFilter] 'ADMIN_PASS' 확인. 입장권 소모.");
				session.removeAttribute(adminPassKey); // 티켓 소모
				chain.doFilter(request, response);
			} else {
				// (실패) 티켓이 없음 = 새로고침 또는 URL 직접 입력
				System.out.println("[AdminPassFilter] 'ADMIN_PASS' 없음. 에러 페이지로 포워딩.");
				request.setAttribute("errorMessage", "알량한 접근(새로고침/URL 직접 접근 시도)");
				httpRequest.getRequestDispatcher(errorPage).forward(httpRequest, httpResponse);
				return;
			}

		} else {
			// (통과) /adminMain.do가 아닌 다른 API 요청 (예: /getStats.do)
			// 1차 검문(loginAdmin)을 통과했으므로 허용
			chain.doFilter(request, response);
		}
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