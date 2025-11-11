console.log('123')

// 연결 성공
socket.onopen = function() {
	
	console.log("System: Chatting Connection OK..");

};

// 서버에서 메시지 받기

socket.onmessage = function(event) {

	let message = JSON.parse(event.data)
	let element = `
		<div class="message theirChat">
			<div class="theirChat_info">
				<span class="chat_nickName">${ message.nick }</span>
				<span class="chat_id">#${ message.id }</span>
				:
				<span class="chat_detail">
					${ message.value }
				</span>
			</div>
		</div>
	`
	chatMessages.insertAdjacentHTML('afterbegin', element)

};

// 연결 종료
socket.onclose = function() {
	
	console.log("System: Chatting UnConnection OK..");

};

// 메시지 전송 함수
function gameChatMessageSend(message) {

	let element = `
		<div class="message myChat">
			<div class="myChat_info">
				<span class="chat_detail">${ message.value }</span>
			</div>
		</div>
	`
	chatMessages.insertAdjacentHTML('afterbegin', element)
	
	let sendMessage = JSON.stringify(message);

	socket.send(sendMessage);

}