const colorPicker             = document.getElementById('base-color');
const pickedColorParagraph    = document.getElementById('picked-color-text');
const contrastColor           = document.getElementById('contrast-color');
const resultingColorParagraph = document.getElementById('resulting-color');
const root                    = document.documentElement;


pickedColorParagraph.innerText = colorPicker.value;

colorPicker.addEventListener('change', () => {
    const color = colorPicker.value;
    root.style.setProperty('--selected-color', color);
    pickedColorParagraph.innerText = color;
});
