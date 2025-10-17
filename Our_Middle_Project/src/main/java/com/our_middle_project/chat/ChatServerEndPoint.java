package com.our_middle_project.chat;

import java.io.IOException;
import java.util.Collections;
import java.util.HashSet;
import java.util.Set;

import jakarta.websocket.OnClose;
import jakarta.websocket.OnMessage;
import jakarta.websocket.OnOpen;
import jakarta.websocket.Session;
import jakarta.websocket.server.ServerEndpoint;

@ServerEndpoint("/chat")
public class ChatServerEndPoint {
	
	//동시성 문제를 방지하기 위해 synchronizedSet 사용
	private static Set<Session> clients = Collections.synchronizedSet(new HashSet<Session>());
	
	
	@OnOpen
	public void onOpen(Session session) {
		System.out.println("새로운 클라이언트 접속: " + session.getId());
		clients.add(session); //세션 추가
	}
	
	//클라이언트로부터 메시지를 받았을 때 실행되는 코드.
	@OnMessage
	public void getMessage(String message, Session session) 
	throws IOException {
		System.out.println("메시지 수신(" + session.getId() + ") : " + message);
		
		//접속하고 있는 모든 클라이언트에게 메시지 전송(브로드캐스팅)
		synchronized (clients) {
			for (Session client : clients) {
				if (!session.equals(client)) {
					client.getBasicRemote().sendText(message);
				}
			}
			
		}
	}
	
	@OnClose
	public void onClose(Session session) {
        System.out.println("클라이언트 접속 종료: " + session.getId());
        clients.remove(session); // 세션 제거
    }
}
