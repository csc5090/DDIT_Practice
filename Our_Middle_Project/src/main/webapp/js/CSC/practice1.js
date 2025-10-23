const followBtn = document.getElementById('follow-btn');

followBtn.addEventListener('click', function(){
	
	if (followBtn.classList.contains('is-following')) {
		followBtn.textContent = '팔로우';
		followBtn.style.backgroundColor = 'var(--primary-color)';
	} else {
		followBtn.textContent = '팔로잉';
		followBtn.style.backgroundColor = '#ccc';
	}
	followBtn.classList.toggle('is-following');
});