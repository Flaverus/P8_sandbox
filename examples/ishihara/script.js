const root = document.documentElement;

document.querySelectorAll('.color-picker').forEach(picker => {
    picker.addEventListener('change', e => {
        root.style.setProperty(e.target.dataset.variable, e.target.value);
    });
});

document.getElementById('protanopia').addEventListener('click', () => {
    root.style.setProperty('--background-dark', '#2f2c2f');
    root.style.setProperty('--background-medium', '#544841');
    root.style.setProperty('--background-light', '#847358');
    root.style.setProperty('--foreground-dark', '#f62b34');
    root.style.setProperty('--foreground-medium', '#fc403e');
    root.style.setProperty('--foreground-light', '#fa665a');
});

document.getElementById('deuteranopia').addEventListener('click', () => {
    root.style.setProperty('--background-dark', '#2f2c2f');
    root.style.setProperty('--background-medium', '#544841');
    root.style.setProperty('--background-light', '#847358');
    root.style.setProperty('--foreground-dark', '#943a47');
    root.style.setProperty('--foreground-medium', '#ab334b');
    root.style.setProperty('--foreground-light', '#f46959');
});

document.getElementById('tritanopia').addEventListener('click', () => {
    /* NOT DEFINED YET */
});

document.getElementById('daltonism').addEventListener('click', () => {
    root.style.setProperty('--background-dark', '#607478');
    root.style.setProperty('--background-medium', '#756e40');
    root.style.setProperty('--background-light', '#eed16c');
    root.style.setProperty('--foreground-dark', '#ca5433');
    root.style.setProperty('--foreground-medium', '#fa7347');
    root.style.setProperty('--foreground-light', '#fca15f');
});

const setVision = (type) => {
    document.body.dataset.vision = type;
};

document.getElementById('protanopia-vision').addEventListener('click', () => {
    setVision('protanopia');
});

document.getElementById('deuteranopia-vision').addEventListener('click', () => {
    setVision('deuteranopia');
});

document.getElementById('tritanopia-vision').addEventListener('click', () => {
    setVision('tritanopia');
});

document.getElementById('regular-vision').addEventListener('click', () => {
    setVision('regular');
});