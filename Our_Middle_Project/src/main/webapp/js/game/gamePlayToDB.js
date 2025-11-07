// 1️⃣ 서버로 POST 전송 함수 (전역)
function gameLogToDB(jsonData) {
    axios({
        baseURL: BASE_URL,
        url: 'gameLog.do',
        method: 'post',
        headers: {
            "Content-Type": "application/json; charset=UTF-8"
        },
        responseType: 'json',
        data: jsonData
    })
    .then(function(response) {
        console.log("게임 로그 저장 성공:", response.data);
    })
    .catch(function(err) {
        console.error("게임 로그 저장 실패:", err);
    });
}

