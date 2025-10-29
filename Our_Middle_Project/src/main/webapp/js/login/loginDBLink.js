
function joinDBAdd(jsonData) {
	
	console.log(jsonData)
	let testJson = {		
		userAddr1: 35276,
		userAddr2: "대전 서구 갈마동 307-5",
		userAddr3: "-",
		userAddr4: "208호",
		userBirth: "19980608",
		userEmail: "test@naver.com",
		userGender: "남",
		userId: "mollymolly001",
		userName: "김철수",
		userNickName: "짱짱맨",
		userPhone: "010-5484-1378",
		userPw: "votmdnjem",
	}
	
	axios({
		baseURL: BASE_URL,
		url: 'join.do',
		method: 'post',
		responseType: 'json',
		data: testJson
	})
	.then(function (response) {
		/*console.log(response)*/
	})
	.catch(function (err) {
    	console.error(err);	// errror
	});
	
}