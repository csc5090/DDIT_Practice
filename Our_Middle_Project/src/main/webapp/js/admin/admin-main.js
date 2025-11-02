window.onload = () => {

	const lastViewId = sessionStorage.getItem('lastView');

	if (lastViewId && document.getElementById(lastViewId)) {
		
		document.getElementById('dashboard-main').classList.remove('active');

		document.getElementById(lastViewId).classList.add('active');
	}


	AdminCore.init();

	if (document.getElementById('dashboard-main')) {
		DashboardPage.init();
	}
	if (document.getElementById('user-management')) {
		UserPage.init();
	}
	if (document.getElementById('notice-management')) {
		NoticePage.init();
	}
	if (document.getElementById('post-management')) {
		PostPage.init();
	}
	if (document.getElementById('review-management')) {
		ReviewPage.init();
	}
	if (document.getElementById('stats-main')) {
		StatsPage.init();
	}
	if (document.getElementById('stats-main')) {
		StatsPage.init();
	}
	
	if (lastViewId === 'user-management') {
	        UserPage.clearDetailPanel(); 
	        UserPage.getList();
	} else if (lastViewId === 'review-management') {
				ReviewPage.loadAndRender();
	}
};