
function gameLevelSaveToDB(jsonData) {
	
	console.log(jsonData)
	console.log(BASE_URL)
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
		/*console.log(response)*/
	})
	.catch(function (err) {
    	console.error(err);	// errror
	});
	
}