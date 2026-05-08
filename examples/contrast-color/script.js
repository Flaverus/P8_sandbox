const colorPicker             = document.getElementById('base-color');
const intensityPercentage     = document.getElementById('intensity-percentage');
const pickedColorParagraph    = document.getElementById('picked-color-text');
const resultingColorParagraph = document.getElementById('resulting-color-text');
const root                    = document.documentElement;


pickedColorParagraph.innerText = colorPicker.value;

const updateResultingColorText = () => {
    resultingColorParagraph.innerText = getComputedStyle(root).getPropertyValue('--contrast-color');
};
updateResultingColorText();

colorPicker.addEventListener('change', () => {
    const color = colorPicker.value;
    root.style.setProperty('--selected-color', color);
    pickedColorParagraph.innerText = color;
    updateResultingColorText();
});

intensityPercentage.addEventListener('change', () => {
    const percentage = intensityPercentage.value;
    root.style.setProperty('--selected-percentage', `${percentage}%`);
    updateResultingColorText();
});
