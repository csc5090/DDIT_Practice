package com.our_middle_project.util;

import java.util.concurrent.atomic.AtomicInteger;

import com.our_middle_project.dashboardendpt.DashboardEndPoint;

import jakarta.servlet.http.HttpSessionEvent;
import jakarta.servlet.http.HttpSessionListener;

public class ActiveUserListener implements HttpSessionListener {

    // 동시성 문제를 해결하기 위해 AtomicInteger 사용
    private static final AtomicInteger activeUsers = new AtomicInteger(0);

    @Override
    public void sessionCreated(HttpSessionEvent se) {
        // 세션이 생성될 때마다 카운트 증가
        activeUsers.incrementAndGet();
        System.out.println("세션 생성. 현재 접속자: " + activeUsers.get());
        
        //대시보드에 실시간 업데이트 신호 전송
        DashboardEndPoint.broadCastStatsUpdate();
    }

    @Override
    public void sessionDestroyed(HttpSessionEvent se) {
        // 세션이 소멸될 때마다 카운트 감소
        activeUsers.decrementAndGet();
        System.out.println("세션 소멸. 현재 접속자: " + activeUsers.get());
        
        // 대시보드에 실시간 업데이트 신호 전송
        DashboardEndPoint.broadCastStatsUpdate();
    }

    // A차트(Controller)에서 이 값을 가져갈 수 있도록 public static 메소드 제공
    public static int getActiveUserCount() {
        return activeUsers.get();
    }
}