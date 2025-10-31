
function joinDBAdd(jsonData) {
	
	/*	
	let testJson = {		
		mem_add1: "서울 강남구 강남대로 지하 396 (역삼동)",
		mem_add2: "201호",
		mem_birth: "19980815",
		mem_gender: "M",
		mem_hp: "010-5584-6648",
		mem_id: "mollymolly001",
		mem_mail: "molly@naver.com",
		mem_name: "김철수",
		mem_pass: "votmdnjem112",
		mem_zip: "06232",
		nickname: "짱짱맨"
	}
	*/
	axios({
		baseURL: BASE_URL,
		url: 'join.do',
		method: 'post',
		headers: {
			"Content-Type": "application/json; charset=UTF-8"
		},
		responseType: 'json',
		data: jsonData
	})
	.then(function (response) {
		/*console.log(response)*/
		console.log("회원가입이 완료 되었어용 우왕 짝짝")
	})
	.catch(function (err) {
    	console.error(err);	// errror
	});
	
}

async function idCheckToDB(jsonData) {
	
	let result
	
	console.log(jsonData)
	console.log(BASE_URL)
	await axios({
		baseURL: BASE_URL,
		url: 'idcheck.do',
		method: 'post',
		headers: {
			"Content-Type": "application/json; charset=UTF-8"
		},
		responseType: 'json',
		data: jsonData
	})
	.then(function (response) {
		result = response.data.idCheck;
	})
	.catch(function (err) {
    	console.error(err);
	});
	
	return result
}





