console.log('123')

// 연결 성공
socket.onopen = function() {
  console.log("✅ 서버와 WebSocket 연결 성공");

};

// 서버에서 메시지 받기
socket.onmessage = function(event) {
  console.log("📩 서버 → " + event.data);
  
  let bb = JSON.parse(event.data)
  console.log(bb);

};

// 연결 종료
socket.onclose = function() {
  console.log("❌ 서버와 연결 종료");

};

// 메시지 전송 함수
function gameChatMessageSend() {

  let message = {
	id: "test",
	nick: "tt",
	value: "Hellow"
  }
	
  let abc = JSON.stringify(message);
	
  socket.send(abc);

}