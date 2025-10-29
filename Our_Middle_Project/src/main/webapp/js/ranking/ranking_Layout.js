

const slide = document.getElementById('topwidth500');

document.getElementById('btnEazy').addEventListener('click', () => {
    slide.style.transform = 'translateX(0%)';
});

document.getElementById('btnNormal').addEventListener('click', () => {
    slide.style.transform = 'translateX(-20%)';
});

document.getElementById('btnHard').addEventListener('click', () => {
    slide.style.transform = 'translateX(-40%)';
});

document.getElementById('btnVs').addEventListener('click', () => {
    slide.style.transform = 'translateX(-60%)';
});

document.getElementById('btnTotal').addEventListener('click', () => {
    slide.style.transform = 'translateX(-80%)';
});