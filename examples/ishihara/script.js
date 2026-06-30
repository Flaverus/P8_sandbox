const backgroundDark   = document.getElementById('background-dark');
const backgroundMedium = document.getElementById('background-medium');
const backgroundLight  = document.getElementById('background-light');
const foregroundDark   = document.getElementById('foreground-dark');
const foregroundMedium = document.getElementById('foreground-medium');
const foregroundLight  = document.getElementById('foreground-light');
const body             = document.body;

const setPlateColors = (colors) => {
    body.style.setProperty('--background-dark',   colors.bgDark);
    body.style.setProperty('--background-medium', colors.bgMedium);
    body.style.setProperty('--background-light',  colors.bgLight);
    body.style.setProperty('--foreground-dark',   colors.fgDark);
    body.style.setProperty('--foreground-medium', colors.fgMedium);
    body.style.setProperty('--foreground-light',  colors.fgLight);

    backgroundDark.value   = colors.bgDark;
    backgroundMedium.value = colors.bgMedium;
    backgroundLight.value  = colors.bgLight;
    foregroundDark.value   = colors.fgDark;
    foregroundMedium.value = colors.fgMedium;
    foregroundLight.value  = colors.fgLight;
}

document.querySelectorAll('.color-picker').forEach(picker => {
    picker.addEventListener('change', e => {
        body.style.setProperty(e.target.dataset.variable, e.target.value);
    });
});

document.getElementById('protanopia').addEventListener('click', () => {
    setPlateColors({
        bgDark:   '#2f2c2f',
        bgMedium: '#544841',
        bgLight:  '#847358',
        fgDark:   '#a61b21',
        fgMedium: '#cf4342',
        fgLight:  '#fa665a'
    });
});

document.getElementById('deuteranopia').addEventListener('click', () => {
    setPlateColors({
        bgDark:   '#2f2c2f',
        bgMedium: '#544841',
        bgLight:  '#847358',
        fgDark:   '#943a47',
        fgMedium: '#ab334b',
        fgLight:  '#f46959'
    });
});

document.getElementById('tritanopia').addEventListener('click', () => {
    setPlateColors({
        bgDark:   '#ae0a69',
        bgMedium: '#d11180',
        bgLight:  '#e71092',
        fgDark:   '#a62810',
        fgMedium: '#cc3214',
        fgLight:  '#de3519'
    });
});

document.getElementById('daltonism').addEventListener('click', () => {
    setPlateColors({
        bgDark:   '#607478',
        bgMedium: '#756e40',
        bgLight:  '#eed16c',
        fgDark:   '#ca5433',
        fgMedium: '#fa7347',
        fgLight:  '#fca15f'
    });
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