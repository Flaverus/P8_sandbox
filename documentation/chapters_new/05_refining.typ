= Enabling Users to Finetune their Experience

Lastly the focus shifts from developers to the users interacting with webapplications. Developers are able to optimize a lot to the individual needs of users based on asumptions made from for example media queries but enabling the user to further refine and personalize his experience allows for even more diversity. This chapter focuses on a more powerful version of the previously introduced Developer Widget giving users the needed tools to customize their experience for each webapplication individually.

== View Transition API

The View Transition API provides a native mechanism for animating transitions between different states of a web application. It can be used to create smooth visual effects when navigating between pages or when updating views within single-page applications (SPAs).

For transitions that occur within the same document, the state change is wrapped inside the ``` document.startViewTransition()``` method. Cross-document transitions in multi-page applications (MPAs) are triggered automatically during navigation and can be enabled through the ``` @view-transition``` at-rule. Internally, the API captures snapshots of both the previous and the new state and animates between them. By default, this transition consists of a simple fade effect, where the old view gradually decreases its opacity to ``` 0``` while the new view increases its opacity to ``` 1```.

The generated animations can be customized through the ``` ::view-transition-old()``` and ``` ::view-transition-new()``` pseudo-elements, which target the previous and new view respectively. Shared styling can be applied through ``` ::view-transition-group()```. These pseudo-elements accept different targets, including ``` root``` for animating the entire page, ``` *``` for all transition targets, or a custom ``` view-transition-name``` to animate specific elements independently.

An example of a custom page transition is shown in @view-transition-example. In this case, the previous page is animated out of view towards the left while the new page enters from the right, creating a horizontal swipe effect. @view-transition-api

#figure(
  align(left,
    ```css
    @keyframes move-out {
      from {
        transform: translateX(0%);
      }
      to {
        transform: translateX(-100%);
      }
    }

    @keyframes move-in {
      from {
        transform: translateX(100%);
      }
      to {
        transform: translateX(0%);
      }
    }

    ::view-transition-old(root) {
      animation: move-out 0.4s ease-in both;
    }

    ::view-transition-new(root) {
      animation: move-in 0.4s ease-in both;
    }
    ```
  ),
  caption: [A custom page transition that swipes the previous view \ out to the left while moving the new view in from the right.],
) <view-transition-example>

#pagebreak()


== Validation and Verification

The Preferences Widget underwent smaller-scale user testing to gather feedback from real users and refine the interface for future integration into Kolibri. The tests were intentionally kept simple to allow participation from users with different backgrounds and experience levels. The primary focus was usability, keyboard accessibility, intuitiveness, and the overall visual experience.

The documentation and results of the conducted user tests are available in the project's repository under the usertests section. @p8-usertests

The different example applications and prototype pages were additionally validated using automated accessibility testing tools such as the axe DevTools browser extension and Google Lighthouse. These automated checks were supplemented with manual keyboard accessibility testing to verify practical usability beyond purely automated evaluation.

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
  caption: [A screenshot of the preferences widget with page-specific \ settings for reduced motion and color blindness.],
) <preference-widget>

=== JavaScript Part

Where supported, existing CSS media queries serve as the foundation for the widget's default values. When a user visits the page for the first time, the current operating system or browser settings are used as the initial configuration. Any changes made through the widget are stored in the browser's ``` localStorage```, ensuring that preferences persist across page reloads and remain available throughout the application.

Each preference is also written to a CSS custom property on the ``` root``` element, making the value accessible from both JavaScript and CSS. This approach establishes a single source of truth that can be used consistently across the entire application, as shown in @set-accessibility-property.

#figure(
  align(left,
    ```js
    const setAccessibilityProperty = (property,
                                      value,
                                      mediaQueryString) => {

      localStorage.setItem(property, value);

      if(value === 'system' && mediaQueryString !== '') {
        const systemSetting = window.matchMedia(mediaQueryString).matches;
        document.documentElement.style.setProperty(property, systemSetting);
      } else {
        document.documentElement.style.setProperty(property, value);
      }
    }
    ```
  ),
  caption: [The ``` setAccessibilityProperty()``` function stores a value in \ ``` localStorage``` and updates the corresponding custom property on ``` root```.] ,
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
  caption: [The ``` getAccessibilityProperty()``` function returns \ a saved value or falls back to the system setting.],
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

The ``` syncWidgetOption()``` function shown in @sync-accessibility-option synchronizes the values stored in the custom properties with the corresponding radio buttons in the widget. By reading the values directly from ``` root```, the custom properties remain the single source of truth for both the user interface and the underlying logic.

#figure(
  align(left,
    ```js
    const syncWidgetOption = (option, property) => {
      const value = getAccessibilityProperty(property);

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
  caption: [Synchronizing the selected radio buttons \ with the values stored in the custom properties.],
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
            setAccessibilityProperty(
                property, radio.value, mediaQueryString
            );
          }
        });
      });
    }
    ```
  ),
  caption: [Updating the user's preference when the selected radio button changes.],
) <on-change-accessibility-option>

=== CSS Part

Once the CSS custom properties representing the user's preferences are in place, they can be used to create different visual representations of the website. In @change-css-base-properties-attribute-selector, a set of custom properties defines the default styling. These values are selectively overridden using the CSS ``` @container``` at-rule when the user prefers a dark color scheme.

#figure(
  align(left,
    ```css
    body {
      --bg-color:       #fcfcfc;
      --text-color:     #222222;
      --content-bg:     #ffffff;
      --border-color:   #eeeeee;
      --primary-accent: #0056b3;
      --shadow:         0 2px 8px rgba(0, 0, 0, 0.1);

      color-scheme: light;
    }

    @container style(--prefers-dark-theme: true) {
      body {
        --bg-color:       #212121;
        --text-color:     #ededed;
        --content-bg:     #2e2e2e;
        --border-color:   #232323;
        --primary-accent: #6db3f4;
        --shadow:         0 2px 8px rgba(0, 0, 0, 0.5);

        color-scheme: dark;
      }
    }
    ```
  ),
  caption: [Overriding the default custom properties with the CSS \ ``` @container``` at-rule on ``` body``` to apply a dark color scheme.],
) <change-css-base-properties-attribute-selector>

As additional preferences are introduced, the number of possible combinations increases. @change-css-base-multiple-properties demonstrates how the base styling is adjusted when both the dark theme and the high contrast mode are enabled, resulting in a different visual presentation.

#figure(
  align(left,
    ```css
    @container style(--prefers-dark-theme: true) and
    style(--prefers-contrast: true) {
      body {
        --bg-color:       #000000;
        --text-color:     #ffffff;
        --content-bg:     #000000;
        --border-color:   #ffffff;
        --primary-accent: #80c5ff;
        --shadow:         none;
      }
    }
    ```
  ),
  caption: [Applying a dedicated style when both dark \ mode and high contrast mode are enabled.],
) <change-css-base-multiple-properties>

In some cases, changing individual custom property values is not sufficient and additional CSS rules must be applied. The ``` @container``` at-rule combined with the ``` style()``` query makes this possible. Because the preference properties are defined on ``` body```, they can be used to conditionally apply styles across the entire application. @additonal-rules-custom-properties demonstrates how animations and transitions can be disabled when the user prefers reduced motion.

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
  caption: [Applying additional styles based on custom properties \ using the ``` @container``` rule and a ``` style()``` query.],
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
  caption: [Having custom properties defined with ``` @property``` \ to be able to add a transition within a ``` @container``` rule.],
) <smooth-transition>

==== View Transition

While animating individual properties can be useful, it may result in less coherent transitions when multiple properties change simultaneously. In such situations, individual animations can compete for attention and create a visually noisy effect that is ultimately more distracting than beneficial. To avoid this, it is often preferable to transition the page state as a whole by using the View Transition API.

For the Preferences Widget, this can be achieved by wrapping the property update inside the ``` document.startViewTransition()``` method, as shown in @smooth-view-transition-js. This allows the browser to capture the previous and new state of the page and animate the transition between them in a coordinated manner. The resulting animation can be further refined through CSS. For example, the duration can be increased to create a smoother transition, as demonstrated in @smooth-view-transition-css.

#figure(
  align(left,
    ```js
    document.startViewTransition(() => {
      document.documentElement.style.setProperty(property, appliedValue);
    });
    ```
  ),
  caption: [Enabling a view transition for a property change \ using the ``` startViewTransition()``` method.],
) <smooth-view-transition-js>

#figure(
  align(left,
    ```css
::view-transition-group(root) {
    animation-duration: 0.6s;
}
    ```
  ),
  caption: [Increasing the duration of the view transition \ to create a smoother visual effect.],
) <smooth-view-transition-css>

The implementation of the preference widget, including several example settings that demonstrate how individual and combined preferences affect the website's styling, is available in the project's repository. @p8-widget

#pagebreak()