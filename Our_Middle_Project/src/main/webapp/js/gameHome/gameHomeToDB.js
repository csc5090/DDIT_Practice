
function gameLevelSaveToDB(jsonData) {
	
	axios({
		baseURL: BASE_URL,
		url: 'levelSave.do',
		method: 'post',
		headers: {
			"Content-Type": "application/json; charset=UTF-8"
		},
		responseType: 'json',
		data: jsonData
	})
	.then(function (response) {
		
		window.location.href = response.data
	})
	.catch(function (err) {
    	console.error(err);	// errror
	});
	
}