package com.our_middle_project.FrontController;

import java.io.FileInputStream;
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

public class AdminFrontController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final Properties properties = new Properties();

    @Override
    public void init() throws ServletException {
        String propertiesPath = getServletContext().getRealPath("/WEB-INF/config/admin.properties");
        try (InputStream is = new FileInputStream(propertiesPath)) {
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
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "요청한 관리자 명령어를 찾을 수 없습니다.");
            return;
        }

        try {
            Class<?> clazz = Class.forName(className);
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
            System.err.println("관리자 액션 실행 중 오류가 발생했습니다: " + e.getMessage());
            throw new ServletException("관리자 액션 실행 중 오류가 발생했습니다.", e);
        }
    }
}