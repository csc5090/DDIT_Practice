
function joinDBAdd() {
	
	console.log(BASE_URL)
	
	axios({
		baseURL: BASE_URL,
		url: 'join.do',
		method: 'post',
		responseType: 'json',
		data: {
			ID: 12345
		}
	})
	.then(function (response) {
		console.log(response)
	})
	.catch(function (err) {
    	console.error(err);	// errror
	});
	
}