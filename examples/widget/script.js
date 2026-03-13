// Get references to the DOM elements
const motion      = document.getElementById("motion");
const contrast    = document.getElementById("contrast");
const colorscheme = document.getElementById("colorscheme");
const root        = document.documentElement;

// Users initial settings
root.style.setProperty('--prefers-reduced-motion', window.matchMedia("(prefers-reduced-motion: reduce)").matches);
root.style.setProperty('--prefers-contrast', window.matchMedia("(prefers-contrast: more)").matches);
root.style.setProperty('--prefers-dark-theme', window.matchMedia("(prefers-color-scheme: dark)").matches);

// Set initial values based on user settings (returns strings)
motion.checked      = getComputedStyle(root).getPropertyValue('--prefers-reduced-motion').trim() === 'true';
contrast.checked    = getComputedStyle(root).getPropertyValue('--prefers-contrast').trim() === 'true';
colorscheme.checked = getComputedStyle(root).getPropertyValue('--prefers-dark-theme').trim() === 'true';


// Change values when checkboxes change
motion.addEventListener("change", () => {
    root.style.setProperty('--prefers-reduced-motion', motion.checked);
});

contrast.addEventListener("change", () => {
    root.style.setProperty('--prefers-contrast', contrast.checked);
});

colorscheme.addEventListener("change", () => {
    root.style.setProperty('--prefers-dark-theme', colorscheme.checked);
});
