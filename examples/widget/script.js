// Get references to the DOM elements
const motion      = document.getElementById('motion');
const contrast    = document.getElementById('contrast');
const colorscheme = document.getElementById('colorscheme');
const root        = document.documentElement;

// Helper functions
const setAccessibilityProperty = (property, value) => {
    root.style.setProperty(property, value);
    localStorage.setItem(property, value);
}

const getAccessibilityProperty = (property, mediaQueryString) => {
    const savedProperty = localStorage.getItem(property);

    if(savedProperty) {
        return savedProperty;
    } else  {
        return window.matchMedia(mediaQueryString).matches
    }
}

// Users initial or saved settings
setAccessibilityProperty('--prefers-reduced-motion', getAccessibilityProperty('--prefers-reduced-motion', '(prefers-reduced-motion: reduce)'));
setAccessibilityProperty('--prefers-contrast',       getAccessibilityProperty('--prefers-contrast', '(prefers-contrast: more)'));
setAccessibilityProperty('--prefers-dark-theme',     getAccessibilityProperty('--prefers-dark-theme', '(prefers-color-scheme: dark)'));

// Set widget values based on user settings (returns strings)
motion.checked      = getComputedStyle(root).getPropertyValue('--prefers-reduced-motion').trim() === 'true';
contrast.checked    = getComputedStyle(root).getPropertyValue('--prefers-contrast').trim()       === 'true';
colorscheme.checked = getComputedStyle(root).getPropertyValue('--prefers-dark-theme').trim()     === 'true';


// Change values when checkboxes change
motion.addEventListener('change', () => {
    setAccessibilityProperty('--prefers-reduced-motion', motion.checked);
});

contrast.addEventListener('change', () => {
    setAccessibilityProperty('--prefers-contrast', contrast.checked);
});

colorscheme.addEventListener('change', () => {
    setAccessibilityProperty('--prefers-dark-theme', colorscheme.checked);
});
