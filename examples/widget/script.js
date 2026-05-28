// Get references to the DOM elements
const motion         = document.querySelectorAll('input[name="motion"]');
const contrast       = document.querySelectorAll('input[name="contrast"]');
const colorscheme    = document.querySelectorAll('input[name="colorscheme"]');
const colorblindness = document.querySelectorAll('input[name="colorblindness"]');
const root           = document.documentElement;

// Helper functions
const setAccessibilityProperty = (property, value, mediaQueryString) => {
    localStorage.setItem(property, value);

    // 'settings' is not a value we listen to in the CSS, as is can be anything, so we have to get the media query value
    if(value === 'system' && mediaQueryString !== '') {
        root.style.setProperty(property, window.matchMedia(mediaQueryString).matches);
    } else {
        root.style.setProperty(property, value);
    }
}

const getAccessibilityProperty = (property) => {
    const savedProperty = localStorage.getItem(property);

    if(savedProperty) {
        return savedProperty;
    } else  {
        return 'system';
    }
}

const syncWidgetOption = (option, property) => {
    const value = root.style.getPropertyValue(property);

    option.forEach(radio => {
        radio.checked = radio.value === value;
    });
}

const addOptionEventListener = (option, property, mediaQueryString) => {
    option.forEach(radio => {
        radio.addEventListener('change', () => {
            if(radio.checked) {
                setAccessibilityProperty(property, radio.value, mediaQueryString);
            }
        });
    });
}

// Users initial or saved settings
setAccessibilityProperty('--prefers-reduced-motion',      getAccessibilityProperty('--prefers-reduced-motion'),  '(prefers-reduced-motion: reduce)');
setAccessibilityProperty('--prefers-contrast',            getAccessibilityProperty('--prefers-contrast'),        '(prefers-contrast: more)');
setAccessibilityProperty('--prefers-dark-theme',          getAccessibilityProperty('--prefers-dark-theme'),      '(prefers-color-scheme: dark)');
setAccessibilityProperty('--prefers-colorblind-mode',     getAccessibilityProperty('--prefers-colorblind-mode'), '');

// Set widget values based on user settings (returns strings)
syncWidgetOption(motion,         '--prefers-reduced-motion');
syncWidgetOption(contrast,       '--prefers-contrast');
syncWidgetOption(colorscheme,    '--prefers-dark-theme');
syncWidgetOption(colorblindness, '--prefers-colorblind-mode');

// Change values when checkboxes change
addOptionEventListener(motion,         '--prefers-reduced-motion',  '(prefers-reduced-motion: reduce)');
addOptionEventListener(contrast,       '--prefers-contrast',        '(prefers-contrast: more)');
addOptionEventListener(colorscheme,    '--prefers-dark-theme',      '(prefers-color-scheme: dark)');
addOptionEventListener(colorblindness, '--prefers-colorblind-mode', '');

document.body.classList.remove('preload');
