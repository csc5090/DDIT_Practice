async function onlyCheckAlert(type, text) {
	
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