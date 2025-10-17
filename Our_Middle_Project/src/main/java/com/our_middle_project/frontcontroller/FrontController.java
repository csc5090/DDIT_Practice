package com.our_middle_project.frontcontroller;

import java.io.IOException;
import java.io.InputStream;
import java.lang.reflect.Constructor;
import java.util.Properties;

import com.our_middle_project.action.Action;
import com.our_middle_project.action.ActionForward;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class FrontController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final Properties properties = new Properties();

    @Override
    public void init() throws ServletException {
        // webapp/WEB-INF/config/url.properties 파일 경로를 찾습니다.
        try (InputStream is = getServletContext().getResourceAsStream("/WEB-INF/config/url.properties")) {
            properties.load(is);
        } catch (IOException e) {
            throw new ServletException("설정 파일을 로드 실패.", e);
        }
    }

    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) 
    		throws ServletException, IOException {
    	
    	
        String requestURI = request.getRequestURI();
        String contextPath = request.getContextPath();
        String command = requestURI.substring(contextPath.length());
        
        ActionForward forward = null;
        Action action = null;

        String className = properties.getProperty(command);

        if (className == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "요청한 명령어를 찾을 수 없습니다.");
            return;
        }

        try {
        	// className 변수에 담긴 문자열(패키지 포함 클래스명)을 바탕으로,
            // 해당 클래스의 Class 객체를 메모리에 로드.
        	// 와일드카드<?>로 clazz라는 변수에 담길 Class정보가 어떤 타입일지 알 수 없기 때문에 이렇게 해둠.
        	// 타입 유연성 확보
            Class<?> clazz = Class.forName(className);
            
            // 로드된 클래스 객체(clazz)로부터 생성자(Constructor)를 얻어옴.
            // getConstructor()는 매개변수가 없는 기본 생성자를 찾음.
            // 우리가 자주 쓰던 new는 소스코드에 특정 클래스 이름이 명확하게 있을 때 사용 가능.
            //하지만 프론트 컨트롤러는 어떤 클래스를 호출할 지 먼저 알 수 없음. 이 문제를 해결하는게 바로 이 리플랙션 코드
            //이 코드는 즉 얻어올 클래스의 객체를 만들어낼 수 있는 만능 키를 복사하는 과정
            Constructor<?> constructor = clazz.getConstructor();
            
            action = (Action) constructor.newInstance();

            forward = action.execute(request, response);

            if (forward != null) {
                if (forward.isRedirect()) {
                    response.sendRedirect(request.getContextPath() + forward.getPath());
                } else {
                    request.getRequestDispatcher(forward.getPath()).forward(request, response);
                }
            }
        } catch (Exception e) {
        	e.printStackTrace();
            throw new ServletException("액션 실행 중 오류 발생", e);
        }
    }
}