// Special code snippet including a colored square to the right
#let color-snippet(code-block, preview-color) = {
  block(
    fill: rgb("#f8fafc"),
    inset: 12pt,
    radius: 6pt,
    width: 100%,
    stroke: 0.5pt + rgb("#cbd5e1"),
    grid(
      columns: (1fr, auto),
      align: horizon,
      text(font: "Roboto Mono", size: 10pt, code-block.text),
      square(size: 1.25cm, fill: preview-color, radius: 2pt, stroke: 0.5pt + rgb("#cbd5e1"))
    )
  )
}

= Theory

The following chapter introduces CSS and JavaScript features, along with patterns and standards that can serve as a foundation for improving visual accessibility. These techniques help create a better user experience, particularly for people with visual impairments.

== CSS Media Queries

CSS Media Queries allow developers to apply different styles based on the characteristics of the device or environment used to display a web page. This mechanism is commonly used to create responsive layouts that adapt their appearance according to the available screen width.

@media-synthax-example below illustrates the syntax of a media query as defined by the W3C.

#figure(
  align(left,
    ```css
    @media <media-query-list> {
      <rule-list>
    }
    ```
  ),
  caption: [Syntax of a media query, where ``` <media-query-list>``` contains ``` <media-type>``` values, ``` <media-feature>``` values, and logical operators.],
) <media-synthax-example>

In web development, the ``` screen``` media type is the most commonly used, but media queries can also target printers by using ``` print```. If no media type is specified, the default value is ``` all```, which applies the styles to all devices.

Media features are where media queries become particularly powerful, as more than 40 features are currently available. They allow styles to respond to specific characteristics of the user's environment. Common examples include ``` max-width``` and ``` max-height```, as well as their counterparts ``` min-width``` and ``` min-height```. These features are widely used to create responsive websites with layouts optimized for different screen sizes.

@screen-width-example demonstrates a media query that uses the ``` screen``` media type together with the ``` max-width``` media feature.

Some media features take accessibility needs and user preferences into account. They make it possible to adapt the presentation of a website to individual requirements. Despite their importance, they are still used less frequently than they should be. The following media features are particularly relevant when building web applications that aim to be accessible to all users. @media_queries

#figure(
  align(left,
    ```css
    @media screen and (max-width: 768px) {
      body {
        background-color: lightskyblue;
      }
    }
    ```
  ),
  caption: [Example of a media query that changes the background color on smaller screens using the ``` screen``` media type and the ``` max-width``` media feature.],
) <screen-width-example>

=== Reduced Motion

The ``` prefers-reduced-motion``` media feature indicates whether a user has enabled a system setting that reduces non-essential motion. If the value is set to ``` reduce```, animations and transitions should be limited to the bare minimum.

A value of ``` no-preference``` indicates that the user has not expressed a preference for reduced motion, allowing animations and transitions to be displayed without restriction. @reduced-motion

=== Contrast

The ``` prefers-contrast``` media feature allows users to indicate whether they prefer content to be presented with higher or lower contrast. A value of ``` no-preference``` indicates that the user has not configured a contrast preference.

If the value is set to ``` more```, the user requests a higher level of contrast. Conversely, a value of ``` less``` indicates that a lower contrast is preferred.

The value ``` custom``` indicates that the user prefers a specific set of colors. This color palette is typically defined through the ``` forced-colors``` media feature, which is explained in the following section. @contrast

=== Forced Colors

The ``` forced-colors``` media feature detects whether the user agent has enabled a forced color mode, such as Windows High Contrast. This media feature has the value ``` active``` when such a mode is enabled and ``` none``` when it is not.

When forced colors mode is active, many color values defined in the style sheet are overridden by the browser during the painting process. The exact colors applied depend on the semantic role of each element. In addition, browsers may draw backplates behind text to preserve legibility and maintain sufficient contrast when text appears on top of images or patterned backgrounds.

Developers are generally not encouraged to create a separate design specifically for users who enable forced colors mode. Instead, this media query should be used to make targeted adjustments when certain components do not work well in this context. For example, a button that relies solely on ``` box-shadow``` to stand out from the background may lose its visual distinction. In such cases, replacing the shadow with a visible border can provide a more robust solution. @forced-colors

=== Reduced Transparency

The ``` prefers-reduced-transparency``` media feature indicates whether a user has enabled a system setting to reduce transparent or translucent visual effects. If the value is set to ``` reduce```, transparency effects such as blurred overlays or frosted glass backgrounds should be minimized or removed. A value of ``` no-preference``` indicates that the user has not expressed a preference and that the default design can be used.

Reducing transparency can improve contrast and readability, particularly for users who find translucent interface elements distracting or difficult to perceive.

Support for this media feature is currently limited and it is not yet fully supported by Firefox and Safari. @reduced-transparency

=== Color Scheme

A more widely adopted media feature is ``` prefers-color-scheme```. It indicates whether the user prefers a light or dark color theme configured through the operating system or the user agent. The value ``` light``` represents a light color theme, while ``` dark``` represents a dark color theme. @color-scheme

=== Inverted Colors

The ``` inverted-colors``` media feature detects whether the user agent is displaying content with inverted colors. Color inversion can introduce visual side effects, such as shadows appearing as highlights, which may reduce the readability of the content. By responding to this media feature, developers can make targeted adjustments to preserve the visual integrity of the page.

Support for this media feature is currently limited and, at the time of writing, it is only supported by Safari. @inverted-colors

=== Accessing Media Features through JavaScript

The ``` window``` interface provides the ``` matchMedia()``` method, which returns a ``` MediaQueryList``` object. This object can be used to determine whether the current ``` document``` matches a given media query string. @dark-color-scheme-example demonstrates this approach using the ``` prefers-color-scheme``` media feature.

#figure(
  align(left,
    ```js
    const isDarkTheme = window.matchMedia('(prefers-color-scheme: dark)').matches;
    ```
  ),
  caption: [Checking whether the user's system settings prefer a dark color scheme.],
) <dark-color-scheme-example>

This allows developers to respond to user preferences not only in CSS, but also within JavaScript logic and application-specific features. @match-media

=== Changes in the World of Media Queries

CSS media queries continue to evolve, but one important aspect of visual accessibility is still not addressed. Different forms of color blindness and other impairments that affect color perception are not yet covered by an official media feature.

An open issue in the W3C's ``` csswg-drafts``` repository proposes a new media feature called ``` color-vision-adjustment```. Its goal is to improve web accessibility by allowing developers to respond directly to the needs of users with color vision deficiencies.

The proposal includes support for several specific conditions, including protanopia (red deficiency), deuteranopia (red-green deficiency), tritanopia (blue-yellow deficiency), and achromatopsia (near-total color blindness, resulting in grayscale vision). These impairments were previously investigated in the P7 project through browser bookmarklets designed to simulate the corresponding visual deficiencies.

Further details regarding the implementation and theoretical background of these simulations can be found in the P7 project documentation: #link("https://accessible-web-initiative.gitbook.io/accessibility-on-the-web-where-we-stand").

A media feature of this kind would increase awareness of color vision deficiencies and provide developers with a standardized way to adapt interfaces to the needs of affected users. @color_blindness_media_qiery

=== Deprecated Features

Earlier versions of CSS included media types such as ``` embossed```, ``` aural```, and ``` braille```, which were intended to address specific accessibility needs. These media types were later deprecated because the distinction between device categories was expected to become less meaningful over time. In addition, media types describe classes of devices rather than the actual capabilities they support. @css3_qa @at_media

=== Security Concerns

Information exposed through media queries can be used to build a browser fingerprint, which may allow a device to be identified and tracked across websites. To reduce this risk, browsers may deliberately modify or generalize certain reported values.

Some browsers also provide settings that further limit this information. For example, Firefox offers the "Resist Fingerprinting" option, which causes many media queries to return standardized values instead of device-specific settings. @at_media

#pagebreak()
== CSS Custom Properties

CSS custom properties, also known as CSS variables, are named values that can be reused throughout a style sheet. Their value depends on the scope in which they are defined, but within that scope they evaluate to the same value wherever they are used. This makes styles easier to maintain and reduces duplication.

Custom properties are defined using a name that begins with two dashes, ``` --```, followed by a descriptive identifier. Their value can be accessed using the CSS ``` var()``` function. @primary-color-custom-property demonstrates how the custom property ``` --primary-color``` can be defined once and reused throughout a website. This approach is particularly useful when implementing multiple themes, such as light and dark mode, because colors can be changed in a single central location. @custom-properties

#figure(
  align(left,
    ```css
    :root {
      --primary-color:          #204ccf;
      --primary-color-contrast: #ffffff;
    }

    button.primary {
      background-color: var(--primary-color);
      color: var(--primary-color-contrast);
    }

    h1, h2, h3 {
      color: var(--primary-color);
    }

    ```
  ),
  caption: [Defining a primary color custom property that can be reused throughout the website.],
) <primary-color-custom-property>

The ``` @property``` at-rule allows custom properties to be defined more precisely. It makes it possible to specify the expected value type using ``` syntax```, whether the property is inherited by default using ``` inherits```, and an initial value using ``` initial-value```. Possible syntax definitions include ``` <color>```, ``` <number>```, and ``` <url>```. @primary-color-custom-property-at-rule shows how the previous ``` --primary-color``` example can be expressed using this at-rule. @at-property @at-property-syntax

#figure(
  align(left,
    ```css
    @property --primary-color {
      syntax: "<color>";
      inherits: false;
      initial-value: #204ccf;
    }
    ```
  ),
  caption: [Defining a primary color custom property using the ``` @property``` at-rule.],
) <primary-color-custom-property-at-rule>

As shown in @primary-color-custom-property-js, custom properties can also be defined in JavaScript using ``` registerProperty()``` or using ``` setProperty()```. @register-property @set-property

#figure(
  align(left,
    ```js
    window.CSS.registerProperty({
      name: '--primary-color',
      syntax: '<color>',
      inherits: false,
      initialValue: '#204ccf ',
    });

    const root = document.documentElement;
    root.style.setProperty('--primary-color-contrast', '#ffffff');
    ```
  ),
  caption: [Using ``` registerProperty()``` and ``` setProperty()``` in JavaScript to define CSS custom properties.],
) <primary-color-custom-property-js>

Custom properties can also be read in JavaScript using ``` getPropertyValue()```, as shown in @primary-color-custom-property-js-read. This makes it possible to react to dynamically changed values and use them in application logic.

#figure(
  align(left,
    ```js
    const root          = document.documentElement;
    const contrastColor = getComputedStyle(root).getPropertyValue('--contrast-color');
    ```
  ),
  caption: [Reading a CSS custom property in JavaScript using ``` getPropertyValue()```.],
) <primary-color-custom-property-js-read>

=== Global State Management

CSS custom properties are not limited to storing design values such as colors. They can also be used to manage application state. Because custom properties can be read and modified in both CSS and JavaScript, they provide a convenient way to store configuration values that directly influence the user interface.

For example, a user may not have enabled reduced motion at the operating system or browser level, but may choose to disable animations through a website-specific setting. This preference can be stored in a custom property such as ``` --prefers-reduced-motion: true```. The ``` @container``` at-rule can then react to this value and apply different styles at runtime, as shown in @at-container-reduced-motion. @at-container

#figure(
  align(left,
    ```css
    :root {
      --prefers-reduced-motion: false;
    }

    @container style(--prefers-reduced-motion: true) {
        .animated-contents {
            animation: none !important;
        }
    }
    ```
  ),
  caption: [Using the CSS ``` @container``` at-rule to disable animations based on a custom property.],
) <at-container-reduced-motion>

Another approach is to use a CSS attribute selector to override custom properties when a different color theme is selected. For example, the operating system and browser may indicate a preference for a light theme, while the user explicitly selects a dark theme on the website. In this case, a custom property such as ``` --prefers-dark-theme: true``` can be used to switch the application's color palette, as demonstrated in @attribute-selector-dark-color-theme. @attribute-selector

#figure(
  align(left,
    ```css
    :root {
      --prefers-dark-theme: false;

      --text-color:     #222222;
      --bg-color:       #fcfcfc;
      --border-color:   #eeeeee;
      --primary-accent: #0056b3;
    }

    :root[style*="--prefers-dark-theme: true"] {
      --text-color:     #ededed;
      --bg-color:       #212121;
      --border-color:   #232323;
      --primary-accent: #6Db3f4;
    }

    ```
  ),
  caption: [Using a CSS attribute selector to switch to a dark color theme based on a custom property.],
) <attribute-selector-dark-color-theme>

=== Custom Property Toggle

In modern CSS, developers often face the challenge of managing repetitive declarations, especially when implementing light and dark themes. Whether the switch is handled through classes or through ``` @media (prefers-color-scheme: dark)```, the same property names typically need to be declared multiple times with different values. A lesser-known detail in the CSS specification makes it possible to implement this kind of state management more elegantly by using custom properties as toggle values.

According to the CSS specification, a custom property must contain at least one token to be considered valid. A single whitespace character satisfies this requirement and can therefore be used to simulate boolean-like values, as shown in @whitespace-property-value. @custom-property-declaration-value

#figure(
  align(left,
    ```css
    :root {
    	--ON: ;
    	--OFF: initial;
    }
    ```
  ),
  caption: [Both ``` ' '``` and ``` initial``` are valid values for custom properties.],
) <whitespace-property-value>

In traditional theming setups, each variable must be defined separately for both the light and dark theme. By using the pseudo-boolean values introduced in @whitespace-property-value, the theme state can be stored in a single custom property, as demonstrated in @toggle-custom-property.

#figure(
  align(left,
    ```css
    :root {
      --is-light-theme: var(--ON);
    }

    @media (prefers-color-scheme: dark) {
      :root {
        --is-light-theme: var(--OFF);
      }
    }
    ```
  ),
  caption: [Assigning either ``` ' '``` or ``` initial``` depending on the active theme creates the basis for the toggle logic.],
) <toggle-custom-property>

When ``` --is-light-theme``` is used as a prefix in another custom property declaration, the resulting declaration is either valid or invalid depending on its value. If the prefix expands to a whitespace character, the declaration remains valid. If it expands to ``` initial```, the declaration becomes invalid. In that case, the fallback value provided to ``` var()``` is used automatically, as illustrated in @var-fallback-property.

#figure(
  align(left,
    ```css
    :root {
      --color-text--light: var(--is-light-theme) black;
      --color-text--dark: white;

      --color-background--light: var(--is-light-theme) white;
      --color-background--dark: black;

      --color-text: var(--color-text--light,
                    var(--color-text--dark));
      --color-background: var(--color-background--light,
                          var(--color-background--dark));
    }
    ```
  ),
  caption: [When a custom property becomes invalid, ``` var()``` automatically uses the fallback value.],
) <var-fallback-property>

Multiple fallback values based on different toggle properties can be chained using the CSS ``` var()``` function. This enables centralized state management, where the custom properties used throughout the entire style sheet are controlled from a single location. @custom-property-theme-switch @var-function

An example of this theme toggle is available in the project's repository: #link("https://github.com/Flaverus/P8_sandbox/tree/main/examples/theme-switch")

#pagebreak()
== CSS Functions

CSS provides a wide range of built-in functions that simplify common styling tasks. Some of these functions are particularly useful for accessibility. One notable example is ``` contrast-color()```, which became broadly available during the implementation of this project in April 2026 and is supported by current browser versions. The function returns either black or white, depending on which of the two provides the higher contrast against the color passed as its argument. @contrast-color-example shows this approach in the context of a ``` button``` element. @contrast-color

#figure(
  align(left,
    ```css
    button {
      background-color: var(--button-color);
      color: contrast-color(var(--button-color));
    }
    ```
  ),
  caption: [Setting the text color of a button to black or white based on the background color.],
) <contrast-color-example>

Using either black or white for text is a reliable way to ensure strong contrast. Depending on the background color, however, the result may appear visually harsh and less pleasant to read. Another recently introduced CSS function is ``` light-dark()```, which accepts two colors or images. The first value is used when a light color scheme is active, while the second value is used for a dark color scheme. @light-dark-example demonstrates this approach using custom properties. @light-dark

#figure(
  align(left,
    ```css
    body {
      color: light-dark(var(--color-text--light),
                        var(--color-text--dark));
      background-color: light-dark(var(--color-background--light),
                                   var(--color-background--dark));
    }
    ```
  ),
  caption: [Defining text and background colors based on the active color theme using custom properties.],
) <light-dark-example>

=== CSS Custom Functions

Although the growing set of built-in CSS functions covers many use cases, some scenarios still require functionality that cannot be expressed with the currently available primitives. In such cases, developers may need to combine multiple functions or implement custom logic. This is where the experimental ``` @function``` at-rule becomes relevant.

This feature is conceptually similar to CSS custom properties, as custom functions also use names that begin with ``` --```. A function is declared using the ``` @function``` keyword, followed by a custom name and an optional list of parameters. Both the function name and its parameters start with ``` --``` and are followed by case-sensitive identifiers defined by the developer. Inside the function body, the expression assigned to ``` result:``` is evaluated and returned, as shown in @at-function-example. @at-function

#figure(
  align(left,
    ```css
    @function --color-contrast(--color <color>) returns <color> {
      result: oklch(from var(--color) calc((0.5 - l) * infinity) 0 0);
    }
    ```
  ),
  caption: [A custom function that provides behavior similar to ``` contrast-color()``` and was created before that function became widely available.],
) <at-function-example>

As with CSS custom properties, CSS data types such as ``` <color>```, ``` <number>```, and ``` <string>``` can be specified for both function parameters and the return value.

#pagebreak()
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
      animation: 0.4s ease-in both move-out;
    }

    ::view-transition-new(root) {
      animation: 0.4s ease-in both move-in;
    }
    ```
  ),
  caption: [A custom page transition that swipes the previous view out to the left while moving the new view in from the right.],
) <view-transition-example>

#pagebreak()
== Color Spaces

There are many different models for describing the colors perceptible to the human eye. Each model has its own strengths and weaknesses and is used in different contexts, ranging from print and photography to digital displays.

For many years, CSS relied primarily on the RGB color space, which limited how colors could be described and manipulated. To update features faster, the W3C now evolves CSS through independent modules rather than giant versions. Under this system, the CSS Color Module Level 4 specification acts as a direct software update to the three previously released levels, introducing support for additional color spaces and more advanced color functions to significantly expand the possibilities for working with color in CSS. Development in this area continues, and the W3C is currently working on the CSS Color Module Level 5 specification.

=== RGB

The RGB color model represents colors by combining different intensities of the primary colors ``` red```, ``` green```, and ``` blue```. An optional alpha channel can be added to define the opacity of the resulting color.

RGB has been supported in CSS since its early days and can be expressed using the ``` rgb()``` function or hexadecimal notation. For example, the color shown in @rgb-color-example can also be written as ``` #2d1fb180```. @CSS-colors

#figure(
  kind: raw,
  align(left,
    color-snippet(
      ```css
      rgb(45 31 177 / 0.5);
      ```,
      rgb(45, 31, 177, 50%)
    ),
  ),
  caption: [Using ``` rgb()``` to define a color from the Kolibri palette with 50% opacity.],
) <rgb-color-example>

=== HSL

CSS Color Module Level 3 introduced the HSL color model to CSS. HSL describes colors using three components: ``` hue```, ``` saturation```, and ``` lightness```, as illustrated in @hsl-color-example. The hue is represented as an angle on the color wheel, while saturation and lightness define the intensity and brightness of the color. As with RGB, an optional alpha channel can be added to control opacity.

HSL makes it easier to create variations of a color because saturation and lightness can be adjusted directly without recalculating individual RGB values. This is particularly useful when generating lighter or darker shades of the same base color. @CSS-colors

#figure(
  kind: raw,
  align(left,
    color-snippet(
      ```css
      hsl(256 82 55 / 0.6);
      ```,
      rgb(95, 46, 234, 60%)
    ),
  ),
  caption: [Using ``` hsl()``` to define a color from the Kolibri palette with 60% opacity.],
) <hsl-color-example>

=== CIELAB Colors

Perceptual color spaces such as Oklab and OkLCH make it possible to define colors in a way that more closely matches human vision. They also provide access to a wider range of colors than those that can be represented in the traditional sRGB color space.

The ``` oklab()``` function describes a color using three components: ``` lightness```, the ``` a``` axis representing red-green variation, and the ``` b``` axis representing yellow-blue variation. The related ``` oklch()``` function uses ``` lightness```, ``` chroma```, and ``` hue``` instead. Both functions support an optional alpha channel to control opacity. An exemplary usage of both functions can be observed in @ok-color-example.

These color models are widely regarded as the current state of the art for working with color in CSS because they produce more perceptually uniform results. In practice, this means that adjusting lightness or chroma leads to more predictable visual changes than with older color models. @CSS-colors

#figure(
  kind: raw,
  align(left,
    color-snippet(```css
      oklab(0.638 0.176 -0.279 / 0.7);
      oklch(0.718 0.255 301.5 / 0.7);
      ```,
      rgb(190, 88, 253, 70%)
    ),
  ),
  caption: [Using ``` oklab()``` and ``` oklch()``` to define a color from the Kolibri palette with 70% opacity.],
) <ok-color-example>

=== HWB

The ``` hwb()``` color function was introduced alongside the newer CSS color features. It describes colors using three components within the RGB color space: ``` hue```, ``` whiteness```, and ``` blackness```. In practice, it offers an alternative to ``` hsl()``` that many developers find more intuitive when adjusting tints and shades. An example is shown in @hwb-color-example. @CSS-colors

#figure(
  kind: raw,
  align(left,
    color-snippet(```css
      hwb(325 18 0 / 0.3);
      ```,
      rgb(254, 46, 168, 30%)
    ),
  ),
  caption: [Using ``` hwb()``` to define a color from the Kolibri palette with 30% opacity.],
) <hwb-color-example>

#pagebreak()
== Contrast Perception

Contrast is essential for distinguishing elements and understanding their relationships. Differences in brightness, size, texture, and shape all contribute to visual contrast. On the web, variations in lightness are the primary means of ensuring text readability and clearly separating interface elements.

The following section introduces the contrast requirements defined in WCAG 2.x and provides an overview of the emerging approach proposed for WCAG 3.0.

=== Relative Luminance

The contrast requirements in WCAG 2.x are based on the relative luminance of text and its background, independent of hue. This approach assumes that hue and saturation have little influence on reading performance, even for users with color vision deficiencies. Since the inability to distinguish certain colors does not usually affect the perception of light and dark, color itself is not treated as a primary factor in the contrast calculation.

In practice, the perceived contrast may differ from the theoretical value. Smaller or thinner fonts can appear noticeably lighter than the color specified in CSS due to anti-aliasing and font rendering. As a result, text may appear to have lower contrast than the calculated ratio suggests.

WCAG 2.x requires a minimum contrast ratio of 4.5:1 for normal text to meet Level AA. Large text must reach at least 3:1. For Level AAA, the minimum contrast ratio increases to 7:1. These thresholds are based in part on recommendations from ISO 9241-3 and are intended to compensate for reduced contrast sensitivity in users with moderate visual impairments. Users with more severe vision loss typically rely on assistive technologies such as screen magnifiers or screen readers.

Color vision deficiencies vary significantly, making it difficult to define universally effective color combinations based solely on hue. This is one of the main reasons why WCAG evaluates contrast primarily through relative luminance.

One notable exception is ``` protanopia```, in which red tones may appear significantly darker than expected. As a result, red text on dark backgrounds can provide much less contrast than the calculated ratio suggests and should generally be avoided. @WCAG-1.4.3

The formula shown in @relative-luminanc-formula is used by WCAG 2.x to calculate relative luminance, which serves as the basis for determining contrast ratios. @relative_luminanc

#figure(
  box(
    inset: 12pt,
    fill: rgb("#f8fafc"),
    radius: 6pt,
    width: 100%,
    stroke: 0.5pt + rgb("#cbd5e1"),
  {
    [
      $ L = 0.2126 dot R + 0.7152 dot G + 0.0722 dot B $
      #v(5pt)
      $ "Where " C = cases(
        C_("sRGB") / 12.92 & "if" C_("sRGB") <= 0.03928,
        ((C_("sRGB") + 0.055) / 1.055)^2.4 & "otherwise"
      ) $
    ]

    line(length: 100%, stroke: 0.5pt + gray)

    set align(left)
    [*Example:* Dodger Blue `rgb(30, 144, 255)`]

    grid(
      columns: (1fr, 1fr),
      gutter: 15pt,
      [
        *1. Normalize ($\/255$)* \
        $R_("sRGB") = 30/255 = 0.1176$ \
        $G_("sRGB") = 144/255 = 0.5647$ \
        $B_("sRGB") = 255/255 = 1.0000$
      ],
      [
        *2. Linearize* \
        $R = 0.0123$ \
        $G = 0.2747$ \
        $B = 1.0000$
      ]
    )

    v(5pt)
    [*3. Calculate Luminance ($L$)*]
    $ L = (0.2126 dot 0.0123) + (0.7152 dot 0.2747) + (0.0722 dot 1.0000) = bold(0.2712) $

    line(length: 100%, stroke: 0.5pt + gray)

    [*Calculate Contrast Ratio*]
    $ "Ratio" = ("L1" + 0.05)/("L2" + 0.05) $
  }),
  caption: [Step-by-step calculation of relative luminance based on the W3C sRGB formula. @relative_luminanc],
) <relative-luminanc-formula>

=== Perceptual Color Models

The contrast model used in WCAG 2.x is based on relative luminance. In the future, it is expected to be replaced by the Accessible Perceptual Contrast Algorithm (APCA), which forms part of the ongoing WCAG 3.0 work. Advances in display technology, modern web design, and vision science have shown that the approach introduced nearly two decades ago in WCAG 2.x no longer reflects how contrast is perceived in practice.

WCAG 2.x follows a binary model in which a contrast ratio either passes or fails. APCA takes a different approach by accounting for the non-linear nature of human perception and by evaluating contrast in the context in which the colors are used.

Readability depends on more than the luminance difference between two colors. Font size, font weight, stroke thickness, and surrounding context all influence how contrast is perceived. High light-dark contrast generally improves readability, but smaller and thinner text requires a greater difference in lightness to remain legible, as illustrated in @apca-curve.

#figure(
  box(
    inset: 12pt,
    radius: 6pt,
    clip: true,
    stroke: 0.5pt + rgb("#cbd5e1"),
  {
    image("../ressources/apca_curve.png", width: 80%)
  }),
  caption: [This chart illustrates the spatial dependence of human contrast sensitivity using text samples. @APCA],
) <apca-curve>

Non-text elements such as icons typically require less contrast than body text. More generally, the appropriate contrast between two colors depends on the specific use case, including the size, thickness, and purpose of the element.

The contrast formula used in WCAG 2.x has been criticized for many years. Case studies comparing white and black text on colored backgrounds have shown that combinations classified as inaccessible under WCAG 2.x were sometimes perceived as more readable by participants with color vision deficiencies. @white-on-orange-case-study

APCA introduces a new metric called lightness contrast, expressed as $L^c$. Instead of assigning a universal pass-or-fail threshold, it estimates readability based on the perceptual relationship between foreground and background colors within their actual visual context. @APCA

#pagebreak()
== Canvas

The HTML ``` <canvas>``` element is used to draw graphics and animations directly within a web page. By default, the element has no visual representation of its own and must be rendered through JavaScript using either the ``` Canvas API``` or the ``` WebGL API```.

The ``` Canvas API``` is primarily designed for two-dimensional graphics and is commonly used for tasks such as game rendering, data visualization, image manipulation, and real-time video processing. The ``` WebGL API``` extends these capabilities by providing hardware-accelerated rendering for both two-dimensional and three-dimensional graphics.

In addition to drawing content, the canvas also allows pixel data to be read and analyzed. The ``` ImageData``` interface provides access to the underlying RGBA values of a rendered image. @canvas-rgba-extraction demonstrates how the color values of a selected area can be extracted in JavaScript. @canvas-element @canvas-api @image-data

#figure(
  align(left,
    ```js
    const canvas = document.createElement('canvas');
    const ctx    = canvas.getContext('2d');

    ctx.fillStyle = 'oklab(0.638 0.176 -0.279)';
    ctx.fillRect(0, 0, 100, 100);

    const red   = ctx.getImageData(10, 10, 10, 10).data[0];
    const green = ctx.getImageData(10, 10, 10, 10).data[1];
    const blue  = ctx.getImageData(10, 10, 10, 10).data[2];
    const alpha = ctx.getImageData(10, 10, 10, 10).data[3];

    ```
  ),
  caption: [Creating a purple 100 × 100 pixel square and extracting the RGBA values from a 10 × 10 pixel region starting at coordinates x = 10 and y = 10.],
) <canvas-rgba-extraction>

#pagebreak()
== Ishihara

The Ishihara color test, named after the Japanese ophthalmologist Shinobu Ishihara, was developed in 1917 to detect red-green color vision deficiencies. The test consists of a series of circular plates composed of pseudo-isochromatic dots. These dots vary in size and color and are arranged in patterns that appear distinct to individuals with typical color vision, while blending together for people with certain forms of color blindness. @ishihara

An example of such a plate is shown in @ishihara-example01. It uses orange and teal tones and is designed to remain visible regardless of the viewer's color perception. Plates of this kind are commonly used as introductory demonstration images at the beginning of an Ishihara test.

=== Functional Application in Contrast Testing

Although originally developed as a diagnostic tool, the underlying principle of Ishihara plates also provides a useful framework for evaluating color contrast in interface design.

By placing many small dots of different colors next to each other, the method forces the visual system to rely primarily on chromatic contrast to identify a pattern. In a custom accessibility tool, if the foreground and background colors visually blend together within such a plate, this indicates that the chosen color combination may not provide sufficient perceptual contrast.

Custom plates can be generated using a specific brand palette to verify that key colors remain distinguishable not only for users with typical color vision, but also for users with conditions such as ``` protanopia``` or ``` deuteranopia```.

#figure(
  box(
    inset: 12pt,
    radius: 6pt,
    stroke: 0.5pt + rgb("#cbd5e1"),
  {
    image("../ressources/Ishihara-example01.png", width: 40%)
  }),
  caption: [A high-contrast demonstration plate designed to remain legible across all common vision types.],
) <ishihara-example01>

#pagebreak()