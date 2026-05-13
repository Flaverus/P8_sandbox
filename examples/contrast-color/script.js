const colorPicker             = document.getElementById('base-color');
const intensityPercentage     = document.getElementById('intensity-percentage');
const pickedColorParagraph    = document.getElementById('picked-color-text');
const resultingColorParagraph = document.getElementById('resulting-color-text');
const contrastRatioParagraph  = document.getElementById('contrast-ratio-text');
const copyButton              = document.getElementById('copy-button');
const root                    = document.documentElement;

const linearizeChannel = channel => {
    const normalized = channel / 255;

    // Using the wrong 0.03928 instead of 0.04045 as this is defined in the WCAG specs
    if (normalized <= 0.03928) {
        return normalized / 12.92;
    } else {
        return Math.pow((normalized + 0.055) / 1.055, 2.4);
    }
};

const getRelativeLuminance = (r, g, b) => {
    const rLinear = linearizeChannel(r);
    const gLinear = linearizeChannel(g);
    const bLinear = linearizeChannel(b);

    // RGB relative luminance as defined in WCAG (2.x)
    return 0.2126 * rLinear + 0.7152 * gLinear + 0.0722 * bLinear;
};

const parseColorToRGB = (colorString) => {
    // Create a canvas to use the browser's color parsing as getting the rgb values from oklab is nearly impossible
    const canvas = document.createElement('canvas');
    const ctx    = canvas.getContext('2d');

    ctx.fillStyle = colorString;
    ctx.fillRect(0, 0, 1, 1);

    // Returning data array based on canvas context (Array values: r, g, b, a)
    return ctx.getImageData(0, 0, 1, 1).data;
};

const calculateContrastRatio = (color1, color2) => {
    const rgb1 = parseColorToRGB(color1);
    const rgb2 = parseColorToRGB(color2);

    const lum1 = getRelativeLuminance(rgb1[0], rgb1[1], rgb1[2]);
    const lum2 = getRelativeLuminance(rgb2[0], rgb2[1], rgb2[2]);

    // Figure out the higher (lighter) value to get a ratio >= 1
    const lighter = Math.max(lum1, lum2);
    const darker  = Math.min(lum1, lum2);

    return (lighter + 0.05) / (darker + 0.05);
};

const updateResultingColorText = () => {
    const contrastColor   = getComputedStyle(root).getPropertyValue('--contrast-color').trim();
    const backgroundColor = colorPicker.value;
    const ratio           = calculateContrastRatio(backgroundColor, contrastColor);

    resultingColorParagraph.innerText = contrastColor;
    contrastRatioParagraph.innerText  = `${ratio.toFixed(2)}:1`;
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

copyButton.addEventListener('click', () => {
  const textToCopy = resultingColorParagraph.innerText;

  navigator.clipboard.writeText(textToCopy).then(() => {
    const originalText     = copyButton.textContent;
    copyButton.textContent = 'Copied!';

    setTimeout(() => {
      copyButton.textContent = originalText;
    }, 2000);
  });
});

pickedColorParagraph.innerText = colorPicker.value;
