window.onload = () => {

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
    if (document.getElementById('stats-main')) {
        StatsPage.init();
    }
};