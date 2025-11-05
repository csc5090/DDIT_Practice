
function joinDBAdd(jsonData) {

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

async function loginCheckToDB(jsonData) {
	let result
	await axios({
		baseURL: BASE_URL,
		url: 'loginCheck.do',
		method: 'post',
		withCredentials: true,
		headers: {
			"Content-Type": "application/json; charset=UTF-8"
		},
		responseType: 'json',
		data: jsonData
	})
	.then(function (response) {
		console.log(response)
		result = response.data;
	})
	.catch(function (err) {
    	console.error(err);
	});
	
	return result
	
}

async function searchToDB(jsonData) {
	
	let result;
	
	await axios({
		baseURL: BASE_URL,
		url: 'userSearch.do',
		method: 'post',
		headers: {
			"Content-Type": "application/json; charset=UTF-8"
		},
		responseType: 'json',
		data: jsonData
	})
	.then(function (response) {
		result = response.data
	})
	.catch(function (err) {
    	console.error(err);
	});
	
	return result
	
}




