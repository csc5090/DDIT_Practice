document.addEventListener('DOMContentLoaded', () => {

    const sidebar = document.querySelector('.sidebar');

    
    sidebar.addEventListener('mouseenter', () => {
        sidebar.classList.add('expanded');
    });

    sidebar.addEventListener('mouseleave', () => {
        sidebar.classList.remove('expanded');
    });


    
    const navLinks = document.querySelectorAll('.nav-link');

    navLinks.forEach(link => {
        link.addEventListener('click', function(e) {
            const navItem = this.parentElement;

            
            if (navItem.classList.contains('has-submenu')) {
                e.preventDefault();

                
                document.querySelectorAll('.nav-item.open').forEach(openItem => {
                    if (openItem !== navItem) {
                        openItem.classList.remove('open');
                    }
                });
                
                
                navItem.classList.toggle('open');
            }
        });
    });
});