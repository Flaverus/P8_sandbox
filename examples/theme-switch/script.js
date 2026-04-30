const root = document.documentElement;

document.getElementById('btn-dark-theme').addEventListener('click', () => {
    root.style.setProperty('--prefers-dark-theme', 'true');
});

document.getElementById('btn-light-theme').addEventListener('click', () => {
    root.style.setProperty('--prefers-dark-theme', 'false');
});