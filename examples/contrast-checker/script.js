const colorPickerBackground  = document.getElementById('background-color');
const colorPickerForeground  = document.getElementById('foreground-color');
const textBackgroundColor    = document.getElementById('text-background-color');
const textForegroundColor    = document.getElementById('text-foreground-color');
const contrastRatioParagraph = document.getElementById('contrast-ratio-text');
const body                   = document.body;

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

const parseHexToRGB = (hexString) => {
    const hex = hexString.replace('#', '');
    const r = parseInt(hex.substring(0, 2), 16);
    const g = parseInt(hex.substring(2, 4), 16);
    const b = parseInt(hex.substring(4, 6), 16);
    return [r, g, b];
};

const calculateContrastRatio = (color1, color2) => {
    const rgb1 = parseHexToRGB(color1);
    const rgb2 = parseHexToRGB(color2);

    const lum1 = getRelativeLuminance(rgb1[0], rgb1[1], rgb1[2]);
    const lum2 = getRelativeLuminance(rgb2[0], rgb2[1], rgb2[2]);

    // Figure out the higher (lighter) value to get a ratio >= 1
    const lighter = Math.max(lum1, lum2);
    const darker  = Math.min(lum1, lum2);

    return (lighter + 0.05) / (darker + 0.05);
};

const updateResultingColorText = () => {
    const contrastColor   = colorPickerForeground.value;
    const backgroundColor = colorPickerBackground.value;
    const ratio           = calculateContrastRatio(backgroundColor, contrastColor);

    contrastRatioParagraph.innerText  = `${ratio.toFixed(2)}:1`;
};
updateResultingColorText();

colorPickerBackground.addEventListener('change', () => {
    const color = colorPickerBackground.value;
    textBackgroundColor.innerText = color;
    body.style.setProperty('--background-color', color);
    updateResultingColorText();
});

colorPickerForeground.addEventListener('change', () => {
    const color = colorPickerForeground.value;
    textForegroundColor.innerText = color;
    body.style.setProperty('--foreground-color', color);
    updateResultingColorText();
});
