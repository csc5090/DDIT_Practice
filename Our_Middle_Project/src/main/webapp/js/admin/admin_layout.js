window.onload = () => {
	loadContent('/admin/view/dashboard.do');
	document.querySelector('.nav-big-area').classList.add('active');
	addEventHandle();
};

function addEventHandle() {
	let bigMenus = document.getElementsByClassName('bigmenu-container');
	for (let i = 0; i < bigMenus.length; i++) {
		bigMenus[i].addEventListener('click', (e) => {
			sideBarToggleHandle(e);
		});
	}

	let smallMenus = document.getElementsByClassName('ul-small-container');
	for (let i = 0; i < smallMenus.length; i++) {
		let menuItems = smallMenus[i].getElementsByTagName('li');
		for (let j = 0; j < menuItems.length; j++) {
			menuItems[j].addEventListener('click', (e) => {
				e.stopPropagation();
				contentLoadHandle(e);
			});
		}
	}
}

function sideBarToggleHandle(e) {
	let clicked = e.currentTarget;
	let parentLi = clicked.parentElement;
	let childElement = clicked.nextElementSibling;

	if (childElement && childElement.classList.contains('ul-container-none')) {
		closeOtherSubmenus(parentLi);
		childElement.classList.toggle('active');
		parentLi.classList.toggle('active');
		updateActiveMenu(parentLi);
	} else {
		const url = parentLi.dataset.url;
		if (url) {
			loadContent(url);
			updateActiveMenu(parentLi);
		}
	}
}

function closeOtherSubmenus(currentItem) {
	let allBigAreas = document.getElementsByClassName('nav-big-area');
	for (let i = 0; i < allBigAreas.length; i++) {
		if (allBigAreas[i] !== currentItem) {
			let submenuToClose = allBigAreas[i].querySelector('.ul-container-none');
			if (submenuToClose) {
				submenuToClose.classList.remove('active');
				allBigAreas[i].classList.remove('active');
			}
		}
	}
}

function contentLoadHandle(e) {
	let clickedLi = e.currentTarget;
	const url = clickedLi.dataset.url;

	if (url) {
		loadContent(url);
		updateActiveMenu(clickedLi);
	}
}

function updateActiveMenu(clickedItem) {
	const allMenuItems = document.querySelectorAll('[data-url]');
	allMenuItems.forEach(item => item.classList.remove('active'));

	document.querySelectorAll('.nav-big-area').forEach(item => {
        if (!item.contains(clickedItem)) {
            item.classList.remove('active');
        }
    });

	clickedItem.classList.add('active');

	const parentBigArea = clickedItem.closest('.nav-big-area');
	if (parentBigArea) {
		parentBigArea.classList.add('active');
	}
}

async function loadContent(url) {
	const mainArea = document.querySelector('.main-area');
	try {
		mainArea.innerHTML = '<div>Loading...</div>';

		const contextPath = getContextPath();
		const response = await fetch(contextPath + url);

		if (!response.ok) {
			throw new Error('페이지를 불러오는 데 실패했습니다.');
		}

		const htmlContent = await response.text();
		mainArea.innerHTML = htmlContent;

	} catch (error) {
		mainArea.innerHTML = `<div>오류 발생: ${error.message}</div>`;
		console.error(error);
	}
}

function getContextPath() {
	return '/' + location.pathname.split('/')[1];
}