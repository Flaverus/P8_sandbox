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
    image("../ressources/preference-widget.png")
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
      --text-color:     #ededed;
      --content-bg:     #2e2e2e;
      --border-color:   #232323;
      --primary-accent: #6db3f4;
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

=== The Paradox of Reduced Motion Transitions

An interesting and somewhat ironic aspect is that enabling reduced motion preferences does not necessarily mean that all transitions and animations should be removed from a webpage. In certain contexts, the opposite can even be beneficial. Different accessibility concerns require different solutions, and some of these measures may appear counterintuitive at first glance.

For example, users who prefer reduced motion may still benefit from smooth and controlled transitions when switching between color themes. Abrupt flashes or immediate color changes, even when triggered intentionally by the user, can create discomfort or visual strain. In such situations, introducing subtle transitions may improve the overall experience rather than worsen it.

Although it may initially seem contradictory to apply transitions when ``` --prefers-reduced-motion: true``` is configured, carefully controlled color transitions can therefore represent a valid accessibility measure.

==== Animating Properties

To animate CSS custom properties, the ``` @property``` at-rule is required. This informs the browser about the expected value type of a property, such as ``` <color>```, allowing it to interpolate the values during transitions. Once defined, transitions can be applied directly to the custom properties within a ``` @container``` rule using the global ``` *``` selector, since the registered properties themselves are not scoped locally. @smooth-transition demonstrates how custom color properties can be registered and transitioned.

#figure(
  align(left,
    ```css
    @property --bg-color {
      syntax: '<color>';
      inherits: true;
      initial-value: #fcfcfc;
    }

    @property --text-color {
      syntax: '<color>';
      inherits: true;
      initial-value: #222222;
    }

    @container style(--prefers-reduced-motion: true) {
      * {
        transition: --bg-color   0.3s linear,
                    --text-color 0.3s linear,
      }
    }
    ```
  ),
  caption: [Having custom properties defined with ``` @property``` to be able to add a transition within a ``` @container``` rule.],
) <smooth-transition>

==== View Transition

While animating individual properties can be useful, it may result in less coherent transitions when multiple properties change simultaneously. In such situations, individual animations can compete for attention and create a visually noisy effect that is ultimately more distracting than beneficial. To avoid this, it is often preferable to transition the page state as a whole by using the View Transition API.

For the Preferences Widget, this can be achieved by wrapping the property update inside the ``` document.startViewTransition()``` method, as shown in @smooth-view-transition-js. This allows the browser to capture the previous and new state of the page and animate the transition between them in a coordinated manner. The resulting animation can be further refined through CSS. For example, the duration can be increased to create a smoother transition, as demonstrated in @smooth-view-transition-css.

#figure(
  align(left,
    ```js
    document.startViewTransition(() => {
      root.style.setProperty(property, appliedValue);
    });
    ```
  ),
  caption: [Enabling a view transition for a property change using the ``` startViewTransition()``` method.],
) <smooth-view-transition-js>

#figure(
  align(left,
    ```css
::view-transition-group(root) {
    animation-duration: 0.6s;
}
    ```
  ),
  caption: [Increasing the duration of the view transition to create a smoother visual effect.],
) <smooth-view-transition-css>

The implementation of the preference widget, including several example settings that demonstrate how individual and combined preferences affect the website's styling, is available in the project's repository: #link("https://github.com/Flaverus/P8_sandbox/tree/main/examples/widget")

#pagebreak()
== Contrast Color Function

The theory chapter introduced the native ``` contrast-color()``` CSS function and demonstrated how similar behavior can be implemented using CSS custom functions. Given a color, ``` contrast-color()``` returns either black or white, depending on which of the two provides the greater lightness contrast. While this approach is effective, pure black and white can appear visually harsh, especially when used for larger blocks of text.

To address this limitation, an enhanced version of ``` contrast-color()``` was developed during this project and is shown in @custom-color-contrast-function. The custom function accepts a required parameter of type ``` <color>``` and an optional ``` <percentage>``` parameter named ``` --intensity```.

In the first step, the function determines whether black or white provides the better contrast by evaluating the lightness component of the input color in the OkLCH color space. This is achieved by subtracting the lightness value from ``` 0.5```, representing 50% lightness, and multiplying the result by the constant ``` infinity```. Due to the way ``` oklch()``` handles lightness values, this effectively collapses the result to either 0 or 1, depending on whether the original color is darker or lighter than 50%. If the lightness value is greater than or equal to 50%, black is selected. Otherwise, white is used.

In the second step, the selected contrast color is passed to the ``` color-mix()``` function. The optional ``` --intensity``` parameter controls how much of the original color is mixed back into the result. This produces a softer contrast color that retains some of the visual characteristics of the source color.

To further reduce extreme contrast, the lightness of the selected black or white is adjusted using the ``` clamp()``` function. This ensures that light colors do not exceed a lightness of 97.5% and dark colors do not fall below 15%. As a result, the generated contrast color remains readable while appearing less visually aggressive. The selected bounds represent pragmatic perceptual limits intended to preserve strong readability while reducing the visual harshness associated with maximum contrast combinations.

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

*Note:* The specific thresholds of 15% and 97.5% used in this function serve as a subjective, baseline example to illustrate the concept. These values are not absolute standards and should be modified to align with the specific contrast ratios, aesthetic preferences, and accessibility requirements of the design system in use.

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

The interactive Ishihara plate is not intended to directly enhance a website through integration into a production environment. Instead, it serves as a developer tool for visually evaluating color contrast in situations where shape, placement, or additional visual cues do not influence recognition. The focus lies entirely on the perception of color itself.

The application allows three separate colors to be defined for the background circles and three additional colors for the foreground circles. Through their arrangement, the foreground circles form the number 42. This setup makes it possible to evaluate how different shades of the same color, for example variations in saturation or lightness, interact with one another and whether sufficient visual contrast remains between foreground and background elements. An example configuration using colors from the Kolibri palette is shown in @interactive-ishihara-plate.

#figure(
  box(
    inset: 0pt,
    radius: 6pt,
    clip: true,
    stroke: 0.5pt + rgb("#cbd5e1"),
  {
    image("../ressources/ishihara-plate-with-controls.png")
  }),
  caption: [A screenshot of the interactive Ishihara plate configured with colors from the Kolibri palette.],
) <interactive-ishihara-plate>

In addition to freely configurable colors, the application also includes predefined color combinations designed to simulate scenarios that are difficult or impossible to distinguish for people with specific forms of color vision deficiency such as ``` Protanopia```, ``` Deuteranopia```, and ``` Tritanopia```. These presets make it possible to evaluate whether certain color combinations remain distinguishable under different forms of impaired color perception.

Although these configurations are inspired by the original Ishihara test plates, the application is not intended to serve as a medically accurate diagnostic tool. Instead, it should be considered a visual indicator that may suggest the need for further professional examination.

An example of these comparison modes can be seen in @ishihara-plate-comparisement. The left side displays a plate configured with colors that are difficult to distinguish for users with ``` Deuteranopia```. The right side shows the same plate with a ``` Deuteranopia``` simulation filter applied, illustrating how the color combination may appear to affected users. The simulation filters are based on the bookmarklet filters developed during the previous P7 project.

A more detailed discussion of these bookmarklets is available in the corresponding chapter of the previous P7 project: #link("https://accessible-web-initiative.gitbook.io/accessibility-on-the-web-where-we-stand/research/debugging-and-testing-accessibility")

#figure(
  box(
    inset: 0pt,
    radius: 6pt,
    clip: true,
    stroke: 0.5pt + rgb("#cbd5e1"),
  {
    image("../ressources/ishihara-comparisement.png", width: 80%)
  }),
  caption: [A comparison between a plate configured for ``` Deuteranopia``` on the left and the same plate viewed through a ``` Deuteranopia``` simulation filter on the right.],
) <ishihara-plate-comparisement>

The implementation of the interactive Ishihara plate is available in the project's repository: #link("https://github.com/Flaverus/P8_sandbox/tree/main/examples/widget")

#pagebreak()
== (Accessible Drag and Drop Suggestion)

The accessible drag and drop solution presented in this chapter as seen in @drag-and-drop-full was not a direct part of the project itself. However, it was explored during the project's development period and fits thematically into the broader accessibility focus of this documentation. The underlying problem emerged during a coordination meeting related to the project and was further investigated out of personal curiosity.

#figure(
  box(
    inset: 0pt,
    radius: 6pt,
    clip: true,
    stroke: 0.5pt + rgb("#cbd5e1"),
  {
    image("../ressources/drag-and-drop.png")
  }),
  caption: [A screenshot of the keyboard accessible drag and drop example.],
) <drag-and-drop-full>

Because this topic is not part of the project's core implementation, the related theory was intentionally omitted from the main theory chapter. In addition, this section does not analyze the implementation in the same level of detail as the primary project components.

The draggable elements are HTML ``` <li>``` elements with the attribute ``` draggable="true"``` applied to them. Within the context of this example, they represent tickets in a kanban board. Each ticket additionally contains a ``` <select>``` element that is populated with available placement options, allowing the same interaction to be performed using a keyboard.

The tickets can be moved between different states such as _BACKLOG_ and _IN DEVELOPMENT_, which are represented by ``` <ol>``` elements. The basic HTML structure is shown in @drag-and-drop-html.

#figure(
  align(left,
    ```html
    <div class="kanban">
      <section>
        <h3>BACKLOG</h3>
        <ol id="area-one" data-identifier="Backlog">
          <li draggable="true" id="one">
            <article>
              <div class="tile-header">
                <a href="#">TICKET-123</a>
                <label>
                  <span class="visually-hidden">Move TICKET-123 to:</span>
                  <select></select>
                </label>
              </div>
              <p>Task description one</p>
            </article>
          </li>
        </ol>
      </section>

      <section>
        <h3>IN DEVELOPMENT</h3>
        <ol id="area-two" data-identifier="In Development"></ol>
      </section>
    </div>
    ```
  ),
  caption: [The basic HTML structure with draggable ``` <li>``` elements that can be moved between ``` <ol>``` containers.],
) <drag-and-drop-html>

To support drag and drop interactions, the elements require additional JavaScript functionality. The ``` dragstartHandler()```, ``` dragoverHandler()```, and ``` dropHandler()``` functions provide the core interaction logic.

The ``` dragstartHandler()``` stores the identifier of the dragged element for later use. The ``` dragoverHandler()``` prevents the default browser behavior so dropping remains possible. Finally, ``` dropHandler()``` appends the dragged ``` <li>``` element to the target ``` <ol>``` element and updates the available keyboard selection options, as shown in @drag-and-drop-api-js.

#figure(
  align(left,
    ```js
    const dragstartHandler = ev => {
      ev.dataTransfer.setData("text", ev.target.id);
    }

    const dragoverHandler = ev => {
      ev.preventDefault();
    }

    const dropHandler = ev => {
      ev.preventDefault();
      const data   = ev.dataTransfer.getData("text");
      const target = ev.target.closest('ol');
      if(target) {
        target.appendChild(document.getElementById(data));
        updateSelectMenus();
      }
    }

    const initBoardEvents = () => {
      const allOLs = document.querySelectorAll('.kanban ol');
      allOLs.forEach(ol => {
        ol.addEventListener('drop', dropHandler);
        ol.addEventListener('dragover', dragoverHandler);
      });

      const allLIs = document.querySelectorAll('.kanban li');
      allLIs.forEach(li => {
        li.addEventListener('dragstart', dragstartHandler);
      });
    };
    ```
  ),
  caption: [JavaScript event handlers used to support drag and drop interactions between the ``` <ol>``` containers.],
) <drag-and-drop-api-js>

The accessibility-related addition that differentiates this example from the implementation shown in Mozilla's HTML Drag and Drop API documentation @drag-and-drop-api is the ``` updateSelectMenus()``` function. This function dynamically updates all ``` <select>``` elements with the available target columns, allowing tickets to be moved entirely through keyboard interaction.

The ``` selectHandler()``` function then moves the corresponding ``` <li>``` element to the selected column whenever the value of the ``` <select>``` element changes, as demonstrated in @drag-and-drop-select-js.

Although the implementation is intentionally simple and not heavily optimized, it demonstrates that accessible drag and drop interactions can be implemented with relatively little additional complexity.

#figure(
  align(left,
    ```js
    const selectHandler = ev => {
      const targetColumnId = ev.target.value;
      const listItem       = ev.target.closest('li');
      const targetColumn   = document.getElementById(targetColumnId);
      targetColumn.appendChild(listItem);
      updateSelectMenus();
    }


    const updateSelectMenus = () => {
      const columns = document.querySelectorAll('.kanban ol');
      const selects = document.querySelectorAll('.kanban li select');

      selects.forEach(select => {
        const parentUl        = select.closest('ol');
        const currentColumnId = parentUl.id;
        select.innerHTML      = '';

        columns.forEach(column => {
          const option       = document.createElement('option');
          option.value       = column.id;
          option.textContent = column.getAttribute('data-identifier');

          if (column.id === currentColumnId) {
            option.selected = true;
          }

          select.appendChild(option);
        });

        select.removeEventListener('change', selectHandler);
        select.addEventListener('change', selectHandler);
      });
    };
    ```
  ),
  caption: [Keyboard accessible movement of tickets through dynamically updated ``` <select>``` elements.],
) <drag-and-drop-select-js>

The implementation of the keyboard accessible drag and drop example is available in the project's repository: #link("https://github.com/Flaverus/P8_sandbox/tree/main/examples/drag-and-drop")

#pagebreak()