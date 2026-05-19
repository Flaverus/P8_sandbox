= Implementation

This chapter contains suggestions that extend browser standards regarding improved accessibility. The *preferences widget* allows user-specific configuration of an individual website, the *contrast color function* is a function that extends the new ``` contrast-color()``` CSS function by adding a color component, and the *interactive ishihara plate* allows users to manually check color contrasts, as well as test color values and their contrasts using different color filters that simulate various forms of color blindness.

== Preferences Weidget

CSS media queries already allow to address certain user needs. However, this requires that the user has configured specific needs in their operating system or browser settings. If no settings have been configured, there is no way to take the necessary precautions to offer the user a tailored accessibility experience. If incorrect settings exist, or if certain measures are not desired by the user in specific scenarios, these would have to be adjusted globally, even if the circumstances differ only for a single website. Furthermore, there are accessibility aspects that are not yet covered by CSS media queries and therefore cannot be directly considered.

To prevent these limitations and give the user complete freedom, this preferences widget, shown in @preference-widget, was created. It refers to existing system settings but allows users to customize them and offers the possibility to extend the limited scope of CSS media queries to suit specific websites.

#figure(
  box(
    inset: 0pt,
    radius: 6pt,
    clip: true,
    stroke: 0.5pt + rgb("#cbd5e1"),
  {
    image("../ressources/preference-widget.png", width: 25%)
  }),
  caption: [A screenshot of the preferences widget where custom settings for reduced motion and colorblindness on a pagespecifiv level were configured.],
) <preference-widget>

=== JavaScript Part

Existing media queries are used as a basis, provided the relevant setting is included in the scope of CSS media queries. It is possible to configure settings specifically based on the operating system or browser settings. The system settings are used as the initial value when a page is visited for the first time. All values are stored in the browsers ``` localStorage```, ensuring that settings are not lost on page refreshes and are consistently available across a web application. The values are set as CSS custom properties on the pseudo-class ``` :root```, from where they can then be used, as shown in @set-accessibility-property.

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
  caption: [The ``` setAccessibilityProperty()``` saves a property value to the ``` localStorage``` and creates a custom property on ``` :root```.],
) <set-accessibility-property>

With the function ``` getAccessibilityProperty()``` shown in @get-accessibility-property previously saved configurations are read from the ``` localStorage``` or set to the system default if they have not been defined yet.

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
  caption: [With the usage of ``` getAccessibilityProperty()``` previously saved values are returned or the systems default value will be used.],
) <get-accessibility-property>

The widget makes use of both the ``` setAccessibilityProperty()```and ``` getAccessibilityProperty()``` functions to set the custom properties on page load as it can be seen in @handle-accessibility-property. The first parameter in ``` setAccessibilityProperty()``` is the custom property name that will be set to the ``` :root```, the second parameter contains the return value of the ``` getAccessibilityProperty()``` function which is either the previously saved value from the ``` localStorage``` or the string 'system' as default value if no saved data exists so far, as well as the CSS media query string as the third and last parameter if only a ``` true``` or ``` false``` value is considered for this property.

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
  caption: [Setting the global custom propperties on page load with the properties custom name, the return value of ``` getAccessibilityProperty()``` to consider already set values and system settings, as well as the media query in question.],
) <handle-accessibility-property>

As a next step the function ``` syncWidgetOption()``` seen in @sync-accessibility-option synchronizes the values from the CSS custom properties to the radio buttons representing the setings in the UI. This makes use of the custom properties on the ``` :root``` as single source of truth to not having to propagates data change to different areas of the code as it is accessible both from CSS and JavaScript.

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
  caption: [Setting the global custom propperties on page load with the properties custom name, the return value of ``` getAccessibilityProperty()``` to consider already set values and system settings, as well as the media query in question.],
) <sync-accessibility-option>

Lastly each setting needs to be updated in both the ``` localStorage``` as well as the property value in the document if the selection in the radio button group changes which is shown in @on-change-accessibility-option.


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
  caption: [Reacting to changes in the radio button group to update the users preference setting.],
) <on-change-accessibility-option>

=== CSS Part

With the CSS custom properties that represent the users preferences in place the next step is to make use of these properties and build different representations of a website for the possible combinations of these configurations. In @change-css-base-properties-attribute-selector custom CSS properties are defined, holding the base style for a website and with the CSS attribute selector ``` []``` these base styles are overwritten for the dark color theme if the user prefers that one.

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
  caption: [Overwriting the base styling CSS custom properties with the CSS attribute selector on ``` :root``` for a dark color scheme styling.],
) <change-css-base-properties-attribute-selector>

The more configuration properties available the more combinations of different settings must me considered. @change-css-base-multiple-properties shows how the base styling properties are set to yet other values if both the color scheme is set to dark as well as the high contrast styling is enabled, resulting in another visual representation of the website.

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
  caption: [Considering both the color scheme as well as the high contrast setting leads to another styling.],
) <change-css-base-multiple-properties>

If not only the base styles change based on the widget configuration but also additional rules must be applies the ``` @container``` CSS rule with the ``` style()``` query provide the needed functionality. This allows to select the root level for styling as the properties are defined on ``` :root``` and therfore can be applies throughout the whole application. @additonal-rules-custom-properties considers disabling animations and transitions when the user prefers reduced motion.

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
  caption: [Additional styling based on the custom propperties can be added with the ``` @container``` rule in combination with the ``` style()``` query.],
) <additonal-rules-custom-properties>

#pagebreak()
== Contrast Color Functions

In the theory chapter the ``` contrast-color()``` CSS function was used as an example and how such a function could be built with CSS custom functions. As mentioned before, this CSS function returns for a given color either white or black, depending on which of those two have a higher lightness contrast to the given color. It was also mentioned that having pure black or white can feel harsh to read.

To solve this problem an improved version of the ``` contrast-color()``` that can be inspected in @custom-color-contrast-function has been created during this project. This custom function takes a parameter from type ``` <color>``` as well as an optional ``` <percentage>``` parameter. In a first step it is calculated weather black or white has a better contrast to the given color with the help of  ``` oklch()```. If a color has a lightness value of 50% or above the resulting color for ``` --black-or-white``` is black and otherwise white. In a second step the resulting black or white is put into the ``` color-mix()```function that allows to mix two colors together. Here the ``` --intensity``` parameter comes into play, as the defined percentage defines, how much from the given color should be mixed back into the resulting contrast color to smoothen it out further.

To not have the problem of a contrast that hurts your eyes when reading in the first place, the lightness of ``` --black-or-white``` is reduced with the usage of the ``` clamp()``` function. This part ensures that the lightness for a light contrast color is at least 15% and a dark contrast color will not exceed 97.5%, smoothening the resulting color even if there is no color from the selected color mixed back in.

#figure(
  align(left,
    ```css
    @function --color-contrast(--color <color>, --intensity <percentage>: 0%) returns <color> {
      --black-or-white: oklch(from var(--color) calc((0.5 - l) * infinity) 0 0);

      result: color-mix(in oklch, oklch(from var(--black-or-white) clamp(0.15, l, 0.975) c h), var(--color) var(--intensity));
    }
    ```
  ),
  caption: [A custom color contrast function that adjusts the lightness of the resulting black or white and allows to mix back in some parts of the original color.],
) <custom-color-contrast-function>

The example page from the examples collection for this custom contrast color function also calculates the resulting contrast ratio as defined for WCAG 2.x as it can be seen in @custom-contrast-color-example-screenshot below.

#figure(
  box(
    inset: 0pt,
    radius: 6pt,
    clip: true,
    stroke: 0.5pt + rgb("#cbd5e1"),
  {
    image("../ressources/custom-contrast-color-example.png")
  }),
  caption: [A screenshot of the configuration UI for the custom contrast color function.],
) <custom-contrast-color-example-screenshot>

To be able to calculate the relative contrast ratio of two colors the ``` RGB``` values of each color are needed. When working with e.g. ``` oklch()``` these values are not directly accessible within the browser as the computed styles are in the ``` oklch()``` format too. A workaround to extract the needed values that was used for this example is to use the HTML ``` <canvas>``` element. This element allows styling with the common CSS color functions and allows to extract ``` RGBA``` values through the ``` getImageData()``` function. With this little trick shown in @canvas-for-color-extraction it is possible to extract these values from every color, no matter the original format.

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
  caption: [Extracting the ``` RGBA``` values from any color in any format through the ``` <canvas>``` element.],
) <canvas-for-color-extraction>

#pagebreak()
== Interactive Ishihara Plate

#pagebreak()