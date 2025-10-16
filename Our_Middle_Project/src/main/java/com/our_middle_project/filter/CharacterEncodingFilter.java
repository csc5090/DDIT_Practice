package com.our_middle_project.filter;

import java.io.IOException;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;


// @WebFilter("/*") : 모든 주소 요청을 가로채고, 먼저 인코딩 설정을 검사해주겠다는 어노테이션.
// 이 덕분에 우리가 서블릿, jsp를 만들 때 마다 관련 셋팅 코딩을 하지 않아도 됨.
// 모든 요청, 응답을 UTF-8로 통일하겠다는 뜻.

@WebFilter("/*")
public class CharacterEncodingFilter implements Filter {
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) 
    		throws IOException, ServletException {
        
        request.setCharacterEncoding("UTF-8");

        chain.doFilter(request, response);
    }
}