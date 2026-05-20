= Implementation

This chapter presents practical approaches that extend existing browser standards to further improve accessibility. The *preferences widget* enables users to define website-specific settings tailored to their individual needs. The *contrast color function* expands the native ``` contrast-color()``` CSS function by introducing an additional color component. The *interactive Ishihara plate* allows users to evaluate color combinations manually and to test contrast under simulated color vision deficiencies.

== Preferences Widget

CSS media queries already make it possible to respond to certain user preferences. However, this only works when the user has configured the corresponding settings in the operating system or browser. If no such settings exist, websites have no reliable way to adapt to the user's individual accessibility needs.

Even when system-level preferences are configured, they may not reflect the requirements of every website. A user may prefer reduced motion in general, but still want to enable animations on a specific page, or the opposite. In addition, some accessibility preferences, such as color blindness simulations, are not currently covered by CSS media queries and therefore cannot be addressed through native browser mechanisms alone.

To overcome these limitations and give users greater control, the preferences widget shown in @preference-widget was developed. It uses existing system settings as a starting point, while allowing them to be adjusted and extended on a per-website basis.

#figure(
  box(
    inset: 0pt,
    radius: 6pt,
    clip: true,
    stroke: 0.5pt + rgb("#cbd5e1"),
  {
    image("../ressources/preference-widget.png", width: 25%)
  }),
  caption: [A screenshot of the preferences widget with page-specific settings for reduced motion and color blindness.],
) <preference-widget>

=== JavaScript Part

Where supported, existing CSS media queries serve as the foundation for the widget's default values. When a user visits the page for the first time, the current operating system or browser settings are used as the initial configuration. Any changes made through the widget are stored in the browser's ``` localStorage```, ensuring that preferences persist across page reloads and remain available throughout the application.

Each preference is also written to a CSS custom property on the ``` :root``` element, making the value accessible from both JavaScript and CSS. This approach establishes a single source of truth that can be used consistently across the entire application, as shown in @set-accessibility-property.

#figure(
  align(left,
    ```js
    const setAccessibilityProperty = (property,
                                      value,
                                      mediaQueryString) => {

      localStorage.setItem(property, value);

      if(value === 'system' && mediaQueryString !== '') {
        const systemSetting = window.matchMedia(mediaQueryString).matches;
        root.style.setProperty(property, systemSetting);
      } else {
        root.style.setProperty(property, value);
      }
    }
    ```
  ),
  caption: [The ``` setAccessibilityProperty()``` function stores a value in ``` localStorage``` and updates the corresponding custom property on ``` :root```.] ,
) <set-accessibility-property>

The ``` getAccessibilityProperty()``` function shown in @get-accessibility-property reads a previously saved value from ``` localStorage```. If no value has been stored yet, it returns ``` 'system'```, indicating that the operating system or browser setting should be used as the default.

#figure(
  align(left,
    ```js
    const getAccessibilityProperty = (property) => {
        const savedProperty = localStorage.getItem(property);

        if(savedProperty) {
            return savedProperty;
        } else  {
            return 'system';
        }
    }
    ```
  ),
  caption: [The ``` getAccessibilityProperty()``` function returns a saved value or falls back to the system setting.],
) <get-accessibility-property>

During page initialization, both functions are used to populate the custom properties with either the stored value or the corresponding system preference, as shown in @handle-accessibility-property.

#figure(
  align(left,
    ```js
    setAccessibilityProperty('--prefers-reduced-motion',
                             getAccessibilityProperty(
                                 '--prefers-reduced-motion'),
                             '(prefers-reduced-motion: reduce)');
    setAccessibilityProperty('--prefers-contrast',
                             getAccessibilityProperty(
                                 '--prefers-contrast'),
                             '(prefers-contrast: more)');
    setAccessibilityProperty('--prefers-dark-theme',
                             getAccessibilityProperty(
                                 '--prefers-dark-theme'),
                             '(prefers-color-scheme: dark)');
    setAccessibilityProperty('--prefers-colorblind-mode',
                             getAccessibilityProperty(
                                 '--prefers-colorblind-mode'),
                             '');
    ```
  ),
  caption: [Initializing the global custom properties with stored values or system defaults.],
) <handle-accessibility-property>

The ``` syncWidgetOption()``` function shown in @sync-accessibility-option synchronizes the values stored in the custom properties with the corresponding radio buttons in the widget. By reading the values directly from ``` :root```, the custom properties remain the single source of truth for both the user interface and the underlying logic.

#figure(
  align(left,
    ```js
    const syncWidgetOption = (option, property) => {
      const value = root.style.getPropertyValue(property);

      option.forEach(radio => {
        radio.checked = radio.value === value;
      });
    }

    syncWidgetOption(motion,         '--prefers-reduced-motion');
    syncWidgetOption(contrast,       '--prefers-contrast');
    syncWidgetOption(colorscheme,    '--prefers-dark-theme');
    syncWidgetOption(colorblindness, '--prefers-colorblind-mode');
    ```
  ),
  caption: [Synchronizing the selected radio buttons with the values stored in the custom properties.],
) <sync-accessibility-option>

Finally, each radio group registers a ``` change``` event listener that updates both ``` localStorage``` and the corresponding custom property whenever the user selects a different option, as shown in @on-change-accessibility-option.

#figure(
  align(left,
    ```js
    addOptionEventListener(motion,
                           '--prefers-reduced-motion',
                           '(prefers-reduced-motion: reduce)');
    addOptionEventListener(contrast,
                           '--prefers-contrast',
                           '(prefers-contrast: more)');
    addOptionEventListener(colorscheme,
                           '--prefers-dark-theme',
                           '(prefers-color-scheme: dark)');
    addOptionEventListener(colorblindness,
                           '--prefers-colorblind-mode',
                           '');

    const addOptionEventListener = (option, property, mediaQueryString) => {
      option.forEach(radio => {
        radio.addEventListener('change', () => {
          if(radio.checked) {
            setAccessibilityProperty(property, radio.value, mediaQueryString);
          }
        });
      });
    }
    ```
  ),
  caption: [Updating the user's preference when the selected radio button changes.],
) <on-change-accessibility-option>

=== CSS Part

Once the CSS custom properties representing the user's preferences are in place, they can be used to create different visual representations of the website. In @change-css-base-properties-attribute-selector, a set of custom properties defines the default styling. These values are selectively overridden using the CSS attribute selector ``` []``` when the user prefers a dark color scheme.

#figure(
  align(left,
    ```css
    :root {
      --bg-color:       #fcfcfc;
      --text-color:     #222222;
      --content-bg:     #ffffff;
      --border-color:   #eeeeee;
      --primary-accent: #0056b3;
      --shadow:         0 2px 8px rgba(0, 0, 0, 0.1);

      color-scheme: light;
    }

    :root[style*="--prefers-dark-theme: true"] {
      --bg-color:       #212121;
      --text-color:     #EDEDED;
      --content-bg:     #2E2E2E;
      --border-color:   #232323;
      --primary-accent: #6DB3F4;
      --shadow:         0 2px 8px rgba(0, 0, 0, 0.5);

      color-scheme: dark;
    }
    ```
  ),
  caption: [Overriding the default custom properties with the CSS attribute selector on ``` :root``` to apply a dark color scheme.],
) <change-css-base-properties-attribute-selector>

As additional preferences are introduced, the number of possible combinations increases. @change-css-base-multiple-properties demonstrates how the base styling is adjusted when both the dark theme and the high contrast mode are enabled, resulting in a different visual presentation.

#figure(
  align(left,
    ```css
    :root[style*="--prefers-dark-theme: true"]
    [style*="--prefers-contrast: true"] {
      --bg-color:       #000000;
      --text-color:     #ffffff;
      --content-bg:     #000000;
      --border-color:   #ffffff;
      --primary-accent: #80c5ff;
      --shadow:         none;
    }
    ```
  ),
  caption: [Applying a dedicated style when both dark mode and high contrast mode are enabled.],
) <change-css-base-multiple-properties>

In some cases, changing individual custom property values is not sufficient and additional CSS rules must be applied. The ``` @container``` at-rule combined with the ``` style()``` query makes this possible. Because the preference properties are defined on ``` :root```, they can be used to conditionally apply styles across the entire application. @additonal-rules-custom-properties demonstrates how animations and transitions can be disabled when the user prefers reduced motion.

#figure(
  align(left,
    ```css
    @container style(--prefers-reduced-motion: true) {
      .animated-contents {
        animation: none !important;
      }

      .transitional-contents {
        transition: none !important;
      }
    }
    ```
  ),
  caption: [Applying additional styles based on custom properties using the ``` @container``` rule and a ``` style()``` query.],
) <additonal-rules-custom-properties>

The implementation of the accessibility widget, including several example settings that demonstrate how individual and combined preferences affect the website's styling, is available in the project's repository: #link("https://github.com/Flaverus/P8_sandbox/tree/main/examples/widget")

#pagebreak()
== Contrast Color Functions

The theory chapter introduced the native ``` contrast-color()``` CSS function and demonstrated how similar behavior can be implemented using CSS custom functions. Given a color, ``` contrast-color()``` returns either black or white, depending on which of the two provides the greater lightness contrast. While this approach is effective, pure black and white can appear visually harsh, especially when used for larger blocks of text.

To address this limitation, an enhanced version of ``` contrast-color()``` was developed during this project and is shown in @custom-color-contrast-function. The custom function accepts a required parameter of type ``` <color>``` and an optional ``` <percentage>``` parameter named ``` --intensity```.

In the first step, the function determines whether black or white provides the better contrast by evaluating the lightness component of the input color in the OkLCH color space. If the lightness value is greater than or equal to 50%, black is selected. Otherwise, white is used.

In the second step, the selected contrast color is passed to the ``` color-mix()``` function. The optional ``` --intensity``` parameter controls how much of the original color is mixed back into the result. This produces a softer contrast color that retains some of the visual characteristics of the source color.

To further reduce extreme contrast, the lightness of the selected black or white is adjusted using the ``` clamp()``` function. This ensures that light colors do not exceed a lightness of 97.5% and dark colors do not fall below 15%. As a result, the generated contrast color remains readable while appearing less visually aggressive.

#figure(
  align(left,
    ```css
    @function --color-contrast(--color <color>, --intensity <percentage>: 0%) returns <color> {
      --black-or-white: oklch(from var(--color) calc((0.5 - l) * infinity) 0 0);

      result: color-mix(in oklch, oklch(from var(--black-or-white) clamp(0.15, l, 0.975) c h), var(--color) var(--intensity));
    }
    ```
  ),
  caption: [A custom contrast function that softens pure black and white and optionally mixes in a portion of the original color.],
) <custom-color-contrast-function>

The accompanying example from the project's example collection also calculates the WCAG 2.x contrast ratio for the generated colors, as shown in @custom-contrast-color-example-screenshot.

#figure(
  box(
    inset: 0pt,
    radius: 6pt,
    clip: true,
    stroke: 0.5pt + rgb("#cbd5e1"),
  {
    image("../ressources/custom-contrast-color-example.png")
  }),
  caption: [A screenshot of the configuration interface for the custom contrast color function.],
) <custom-contrast-color-example-screenshot>

To calculate the WCAG 2.x contrast ratio, the RGB values of both colors are required. When colors are defined using functions such as ``` oklch()```, these values are not directly available, as browsers may preserve the original color format in the computed styles.

A practical workaround is to use the HTML ``` <canvas>``` element. The canvas can be filled with any valid CSS color, and the resulting RGBA values can then be extracted using ``` getImageData()```. As shown in @canvas-for-color-extraction, this technique makes it possible to convert any supported CSS color format into numeric RGBA values.

#figure(
  align(left,
    ```js
    const parseColorToRGBA = (colorString) => {
      const canvas = document.createElement('canvas');
      const ctx    = canvas.getContext('2d');

      ctx.fillStyle = colorString;
      ctx.fillRect(0, 0, 1, 1);

      // Returning data array contining RGBA values as follows: r, g, b, a
      return ctx.getImageData(0, 0, 1, 1).data;
    };
    ```
  ),
  caption: [Extracting the ``` RGBA``` values of any CSS color using the HTML ``` <canvas>``` element.],
) <canvas-for-color-extraction>

The implementation of the custom contrast color function is available in the project's repository: #link("https://github.com/Flaverus/P8_sandbox/tree/main/examples/contrast-color")

#pagebreak()
== Interactive Ishihara Plate

#pagebreak()