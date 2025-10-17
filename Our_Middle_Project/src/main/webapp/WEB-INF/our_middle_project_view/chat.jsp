<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>실시간 채팅</title>
<style>
#chat-box { 
border: 1px solid #ccc; 
height: 300px;
overflow-y: scroll; 
padding: 10px;
margin-bottom: 10px;
}

#message-input { 
width: 80%;
}
</style>
</head>
<body>
<h1>실시간 채팅</h1>
<div id="chat-box"></div>
<input type="text" id="message-input" placeholder="메시지 입력">
<button onclick="sendMessage()">전송</button>

<script>
// 웹소켓 접속
// "ws://" 로 시작하며, 주소와 포트, 프로젝트 경로, 
// 그리고 @ServerEndpoint에서 설정한 주소를 적어줌.

const websocket = new WebSocket("ws://" + window.location.host + "/Our_Middle_Project/chat");

const chatBox = document.getElementById('chat-box');
const messageInput = document.getElementById('message-input');

//웹소켓 서버와 연결되었을 때 실행
websocket.onopen = function(event) {
	chatBox.innerHTML += "<div>채팅 서버 연결 완료.</div>";
};

//서버로부터 메시지를 수신했을 때 실행
websocket.onmessage = function(event){
	chatBox.innerHTML += "<div>" + event.data + "</div>";
	chatBox.scrollTop = chatBox.scrollHeight; //스크롤을 항상 아래로 두게
};

//연결이 끊겼을 때 실행
websocket.onclose = function(event){
	chatBox.innerHTML += "<div>채팅 서버와 연결이 끊김</div>";
};

//전송 버튼을 눌렀을 때 메시지 전송
function sendMessage() {
	const message = messageInput.value;
	if (message.trim() !== "") {
		// 내가 보낸 메시지를 화면에 먼저 표시
		chatBox.innerHTML += "<div> 당신 : " + message + "</div>";
		
		//웹소켓 서버로 메시지 전송
		websocket.send(message);
		messageInput.value = "";
		chatBox.scrollTop = chatBox.scrollHeight;
	}
}

//Enter 키로 메시지 전송 기능
messageInput.addEventListener("keyup", function(event) {
	if (event.key === "Enter") {
		sendMessage();
	}
});
</script>

</body>
</html>