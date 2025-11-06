console.log("12312ddddd3");

async function yesOrNoAlert(type, text, yes, no) {
	
	const result = await Swal.fire({
	    icon: type,
		html: text,
	    showCancelButton: true,
	    confirmButtonColor: '#ff66a9',
	    cancelButtonColor: '#888',
	    confirmButtonText: yes,
	    cancelButtonText: no,
		allowOutsideClick: false,
		customClass: {
			popup: 'non-join-Modal-back',
			confirmButton: 'non-join-btn'
		}
	})
	
	return result.isConfirmed;
	
}

async function yesAlert(type, text) {
	
	const result = await Swal.fire({
		icon: type,
		// text: text,
		html: text,
		confirmButtonText: '확인',
		allowOutsideClick: false,
		customClass: {
			popup: 'non-join-Modal-back',
			confirmButton: 'non-join-btn'
		}
	});

	return result.isConfirmed;
	
}
