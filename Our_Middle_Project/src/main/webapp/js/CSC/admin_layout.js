document.addEventListener('DOMContentLoaded', () => {

    const sidebar = document.querySelector('.sidebar');

    sidebar.addEventListener('mouseenter', () => {
        sidebar.classList.add('expanded');
    });

    sidebar.addEventListener('mouseleave', () => {
        sidebar.classList.remove('expanded');
    });

});