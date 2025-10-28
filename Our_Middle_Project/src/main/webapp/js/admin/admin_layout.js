window.onload = () => {
	addEventHandle();
};

function addEventHandle() {
	let bigMenus = document.getElementsByClassName('bigmenu-container');
	for(let i=0 ; i < bigMenus.length ; i++) {
		bigMenus[i].addEventListener('click', (e) => { 
			sideBarToggleHandle(e);
		});
	}
}

function sideBarToggleHandle(e) {
	let clicked = e.currentTarget;
	let parentLi = clicked.parentElement;
	let childElement = clicked.nextElementSibling;
	
	if(childElement != null && childElement.classList.contains('ul-container-none')) {
		closeOtherSubmenus(parentLi);
		childElement.classList.toggle('active');
		
		parentLi.classList.toggle('active');
	}
}

function closeOtherSubmenus(currentItem) {
	let allBigAreas = document.getElementsByClassName('nav-big-area');
	for (let i=0; i < allBigAreas.length; i++) {
		if (allBigAreas[i] !== currentItem) {
			let submenuToClose = allBigAreas[i].querySelector('.ul-container-none');
			if (submenuToClose) {
				submenuToClose.classList.remove('active');
				
				allBigAreas[i].classList.remove('active');
			}
		}
	}
}

