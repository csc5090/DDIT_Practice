
window.onload = () => {
	addEventHandle()
};

function addEventHandle() {
	let dash = document.getElementsByClassName('bigmenu-container');
	
	for(let i=0 ; i<dash.length ; i++) {
		dash[i].addEventListener('click', (e) => { sideBarToggleHandle(e) })
	}	
}

function sideBarToggleHandle(e) {
	
	let clicked = e.currentTarget;
	console.log(clicked)
	let childElement = clicked.nextElementSibling
	if(childElement != null) {
		console.log(childElement)
		let toggle = childElement.getAttribute('data-toggle')
		
		if(toggle == "true") {
			console.log('true')
			childElement.className = "ul-container"
			childElement.setAttribute('data-toggle', 'false')
		}
		else {
			console.log('false')
			childElement.className = "ul-container-none"
			childElement.setAttribute('data-toggle', 'true')
		}
		
	}
	
}
