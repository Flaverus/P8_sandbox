const root = document.documentElement;

document.querySelectorAll('.color-picker').forEach(picker => {
    picker.addEventListener('change', (e) => {
        root.style.setProperty(e.target.dataset.variable, e.target.value);
    });
});