const colorPicker             = document.getElementById('base-color');
const intensityPercentage     = document.getElementById('intensity-percentage');
const pickedColorParagraph    = document.getElementById('picked-color-text');
const contrastColor           = document.getElementById('contrast-color');
const resultingColorParagraph = document.getElementById('resulting-color-text');
const foregroundColorDiv      = document.getElementById('foreground-color');
const root                    = document.documentElement;


pickedColorParagraph.innerText = colorPicker.value;

colorPicker.addEventListener('change', () => {
    const color = colorPicker.value;
    root.style.setProperty('--selected-color', color);
    pickedColorParagraph.innerText = color;
    updateResultingColorText();
});

intensityPercentage.addEventListener('change', () => {
    const percentage = intensityPercentage.value;
    root.style.setProperty('--selected-percentage', percentage + '%');
    updateResultingColorText();
});

const updateResultingColorText = () => {
    resultingColorParagraph.innerText = getComputedStyle(foregroundColorDiv).backgroundColor;
};
