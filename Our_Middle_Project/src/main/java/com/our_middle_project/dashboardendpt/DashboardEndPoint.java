package com.our_middle_project.dashboardendpt;

import java.io.IOException;
import java.util.Collections;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

import com.google.gson.Gson;

import jakarta.websocket.OnClose;
import jakarta.websocket.OnMessage;
import jakarta.websocket.OnOpen;
import jakarta.websocket.Session;
import jakarta.websocket.server.ServerEndpoint;

@ServerEndpoint("/dashboardEndPoint")
public class DashboardEndPoint {

	private static Set<Session> sessionCase = Collections.synchronizedSet(new HashSet<>());
	private static Gson gson = new Gson();

	@OnOpen
	public void openCase(Session session) {
		System.out.println("대시보드 웹소켓 연결됨: " + session.getId());
	}

	@OnMessage
	public void messageHandler(String message, Session session) throws IOException {
		Map<String, String> msgData = gson.fromJson(message, Map.class);
		String type = msgData.get("type");

		if ("REQUEST_JOIN".equals(type)) {
			sessionCase.add(session);
			System.out.println("대시보드 관리자 세션 등록 : " + session.getId());
		}
	}

	@OnClose
	public void closeCase(Session session) {
		sessionCase.remove(session);
		System.out.println("대시보드 관리자 세션 종료 : " + session.getId());
	}

	public static void broadCastStatsUpdate() {

		// "REFRESH" 신호만 보냄. 실제 데이터는 page-dashboard.js가 AJAX로 가져감.
		String updateMessage = "{\"type\": \"RESPONSE_REFRESH\"}";

		sessionCase.forEach(session -> {
			if (session.isOpen()) {
				try {
					session.getBasicRemote().sendText(updateMessage);
				} catch (IOException e) {
					System.out.println("대시보드 업데이트 브로드캐스트 실패: " + e.getMessage());
				}
			}
		});
	}
}