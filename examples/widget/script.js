// Get references to the DOM elements
const widget         = document.getElementById('preferences-widget');
const widgetToggle   = document.getElementById('widget-toggle');
const motion         = document.querySelectorAll('input[name="motion"]');
const contrast       = document.querySelectorAll('input[name="contrast"]');
const colorscheme    = document.querySelectorAll('input[name="colorscheme"]');
const colorblindness = document.querySelectorAll('input[name="colorblindness"]');
const root           = document.documentElement;

const toggleWidgetState = (forceClose = false) => {
    const isWidgetOpen =  widget.classList.contains('open')

    if(forceClose || isWidgetOpen) {
        widget.classList.remove('open');
        widgetToggle.setAttribute('aria-expanded', 'false');
    } else {
        widget.classList.add('open');
        widgetToggle.setAttribute('aria-expanded', 'true');
    }
}

widgetToggle.addEventListener('click', () => {
    toggleWidgetState();
});

// Close widget if clicked outside
document.addEventListener('click', (e) => {
    if (!widget.contains(e.target)) {
        toggleWidgetState(true);
    }
});

// Close widget with escape key
document.addEventListener('keydown', (e) => {
    if (e.key === 'Escape' || e.key === 'Esc') {
        toggleWidgetState(true);
    }
});

// Helper functions
const setAccessibilityProperty = (property, value, mediaQueryString) => {
    localStorage.setItem(property, value);

    const appliedValue = (value === 'system' && mediaQueryString !== '')
                       ? window.matchMedia(mediaQueryString).matches
                       : value;

    const isPreloading      = document.body.classList.contains('preload');
    const isReducedMotionOn = root.style.getPropertyValue('--prefers-reduced-motion') === 'true' && property !== '--prefers-reduced-motion';

    // only do view transition when reduced-motion is on and after initial page load
    if (isPreloading || !isReducedMotionOn) {
        root.style.setProperty(property, appliedValue);
    } else {
        document.startViewTransition(() => {
            root.style.setProperty(property, appliedValue);
        });
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
    const value = getAccessibilityProperty(property);

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
setAccessibilityProperty('--prefers-reduced-motion',  getAccessibilityProperty('--prefers-reduced-motion'),  '(prefers-reduced-motion: reduce)');
setAccessibilityProperty('--prefers-contrast',        getAccessibilityProperty('--prefers-contrast'),        '(prefers-contrast: more)');
setAccessibilityProperty('--prefers-dark-theme',      getAccessibilityProperty('--prefers-dark-theme'),      '(prefers-color-scheme: dark)');
setAccessibilityProperty('--prefers-colorblind-mode', getAccessibilityProperty('--prefers-colorblind-mode'), '');

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
