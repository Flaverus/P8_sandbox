const widget       = document.getElementById('developer-widget');
const widgetToggle = document.getElementById('widget-toggle');
const blurry       = document.querySelectorAll('input[name="blurry"]');

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

// simplified widget logic working only with classes
const setupRadioGroupClasses = (groupName) => {
    const radios      = document.querySelectorAll(`input[name="${groupName}"]`);
    const storageKey  = `dev-widget-${groupName}`;
    const activeValue = localStorage.getItem(storageKey) || 'default';

    radios.forEach(radio => {
        if (radio.value === activeValue) {
            radio.checked = true;

            // we don't need to set a class if the setting is turned off
            if (activeValue !== 'default') {
                document.body.classList.add(radio.value);
            }
        } else {
            document.body.classList.remove(radio.value);
        }

        radio.addEventListener('change', () => {
            if (radio.checked) {
                // Cleanup other classes from that settings group
                radios.forEach(r => document.body.classList.remove(r.value));

                // we don't need to set a class if the setting is turned off
                if (radio.value !== 'default') {
                    document.body.classList.add(radio.value);
                }

                // Save settings for MPA convenience
                localStorage.setItem(storageKey, radio.value);
            }
        });
    });
};

setupRadioGroupClasses('colorblindness');
setupRadioGroupClasses('blurry');

document.body.classList.remove('preload');
