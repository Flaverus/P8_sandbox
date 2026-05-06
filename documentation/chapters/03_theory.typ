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

== CSS Media Queries

CSS Media Queries allow developer to apply different styles based on characteristics of a device or environment displaying a web page. This is often used to create a responsive web page that uses different stylings, based on screen width.

@media-synthax-example below describes the media query synthax according to W3C.

#figure(
  align(left,
    ```css
    @media <media-query-list> {
      <rule-list>
    }
    ```
  ),
  caption: [Synthax of the media query where ``` <media-query-list>``` contains ``` <media-type>```s, ``` <media-feature>```s as well as logical operators.],
) <media-synthax-example>



For web development the ``` screen``` media-type is mainly of interest, but it is also possible to set it to ``` print``` for targeting printers. The default value is ``` all```, representing both independent options and is suitable for all devices.

Media-feature is where it gets interesting as there are currently over 40 options available to listen and react to. For example, both ``` max-width``` and ``` max-height```, as well as their opposites ``` min-width``` and ``` min-height```, are widely used to create responsive web sites with different appearances optimized for different devices. @screen-width-example showcases an example using ``` screen``` and ``` max-width```. Some of these features consider aspects of accessibility and user preferences which make them essential to create an accessible web page considering individual needs of different users, but they are not as widely used yet as they should. The following media-feature values should be considered when building web applications that should include everyone. @media_queries

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
  caption: [An example styling the background color for mobile devices with media-type ``` screen``` and media-feature ``` max-width```.],
) <screen-width-example>

=== Reduced Motion

The ``` prefers-reduced-motion``` media-feature indicated if a user has enabled a setting on their device to minimize the amount of non-essential motion shown to them. If the value is set to ``` reduced``` animations and transitions should be reduced to the bare minimum.

A value set to ``` no-preference``` indicated that the user has no preference on reduced motions, allowing all kinds of animations and movement. @reduced-motion

=== Contrast

With ``` prefers-contrast``` the user can specify if he requests content to be presented with a lower or higher contrast. The value ``` no-preference``` indicates that no setting regarding contrast preference was configured by the user.

If the value is set to ``` more``` a higher level of contrast is requested by the user whilst a value of ``` less``` indicated that the opposite, so a lower contrast, is preferred by the user.

Additionally, ``` custom``` can be set as a value as well, meaning the user prefers a specific set of colors. The color palette is typically specified within the media feature ``` forced-colors``` explained in the following section. @contrast

=== Forced Colors

``` forced-colors``` detects, if a user agent has a forced colors mode enabled such as Windows High Contrast. This media-feature has either the value ``` active``` if such a mode is enabled or ``` none``` if not.

When activated, this overwrites and restricts colors defined in the style sheet. Color values are not affected by styles defined in CSS but instead forced by the browser at paint time. The colors enforced depend on the context of an element. Additionally, backplates are drawn behind text to ensure legibility to preserve contrast for text placed on top of images.

Developers are not encouraged to use this media query to create a separate design for users with this feature enabled but to make small tweaks to improve usability if a certain part of a page would not work well in the forced colors context such as replacing box-shadow stylings with a border to not lose the contrast of a button that is only elevated from the background with a box-shadow. @forced-colors

=== Reduced Transparency

When a user has enabled a setting to reduce the transparent or translucent layer effects the ``` prefers-reduced-transparency``` media-feature will be set to ``` reduced``` while a value of ``` no-preference``` indicates default behavior is expected by the user. This can help improve contrast and readability for some users.

This feature is restricted available and not yet fully supported by Firefox and Safari. @reduced-transparency

=== Color Scheme

A feature more broadly used compared to the others introduced in this chapter is the ``` prefers-color-scheme```. It indicates if the user requests a light or dark color theme set through the operating system or a user agent setting. Possible values are ``` light``` for a light color theme and ``` dark``` for a dark color theme. @color-scheme

=== Inverted Colors

Using inverted colors can have unpleasant side effects such as shadows turning into highlights, reducing the readability of the content. Developers can react to this preference and ensure the pages integrity with this media-feature. This feature is only supported by Safari so far. @inverted-colors

=== Accessing Media Features through JavaScript

The ``` window``` interface provides the ``` matchMedia()``` method, returning a ``` MediaQueryList``` object to check if the ``` document``` matches a media query string as seen below in @dark-color-scheme-example for the ``` prefers-color-scheme``` query.


#figure(
  align(left,
    ```js
    const isDarkTheme = window.matchMedia("(prefers-color-scheme: dark)").matches;
    ```
  ),
  caption: [Checking if the user's system settings prefere a dark color scheme.],
) <dark-color-scheme-example>




This enables developers to not only react to preferences within CSS but also consider the users wishes within business logic and web page specific features. @match-media

=== Changes in the World of Media Queries

Continuous development and improvement take place in the world of CSS media queries but there is currently one big visual accessibility concern that is not considered yet. Different types of colorblindness and other visual impairments in regards of color perception fall short. There is an open issue in the W3Cs csswg-drafts repository proposing an additional ``` media-feature``` called ``` color-vision-adjustment``` that intends to cover that area to enhance web accessibility for users with color vision deficiencies.

This proposal intends to cover various specific types of colorblindness such as ``` protanopia``` (red deficiency), ``` deuteranopia``` (red-green deficiency), ``` tritanopia``` (blue-yellow deficiency) or ``` achromatopsia``` (near total color blindness - grayscale) that were covered in the previous P7 project with bookmarklets simulating these visual impairments.

Having such a ``` media-feature``` would increase the awareness as well as the possibilities to directly react to the needs of users affected which such impairments. @color_blindness_media_qiery

=== Deprecated Features

There were media types considering accessibility needs like ``` embossed```, ``` aural``` and ``` braille```, but they got deprecated, assuming distinctions between device types will become more blurred in the future and due to media-type referring to device categories rather than the media they support. @css3_qa @at_media

=== Security Concerns

Data accessible with media queries can be abused to construct a fingerprint, helping to identify and track a device. To prevent this, browsers may fudge returned values in some manners. Some Browsers also provide the possibility to prevent this abuse in the browser settings, such as "Resist Fingerprinting" in Firefox resulting in many media queries only reporting default values rather than device specific settings. @at_media

#pagebreak()
== CSS Custom Properties

CSS custom properties, also referred to as CSS variables, are entities representing values. These properties can be used throughout the document, evaluating into the same values, depending on the scope it is defined, everywhere they are used. This helps developers to keep an overview and reduces complexity. Such a property is typically set by the custom property syntax, being two dashes ``` --```, followed by a name, joined with single dashes. To access a custom property the CSS ``` var()``` function must be used. @primary-color-custom-property shows an example of custom properties being used to define a ``` --primary-color``` that then can be used on the whole website and is easy exchangeable in one central part to implement different color palates such as a light and dark theme, based on the users preference. @custom-properties

#figure(
  align(left,
    ```css
    :root {
      --primary-color: #204CCF;
      --primary-color-contrast: #FFFFFF;
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
  caption: [Defining a primary color custom propperty that can be used throughout the website.],
) <primary-color-custom-property>

It is possible to be more precise when defining a custom property by using the ``` @property``` at-rule, allowing to define the value type with ``` syntax```, if the property inherits by default with ``` inherits``` and an initial value with ``` initial-value```. There is a wide range of values possible for ``` syntax``` such as ``` <color>```, ``` <number>``` and ``` <url>``` to name a few. @primary-color-custom-property-at-rule shows how the ``` ---primary-color``` example from before is achieved with this at-rule. @at-property @at-property-syntax

#figure(
  align(left,
    ```css
    @property --primary-color {
      syntax: "<color>";
      inherits: false;
      initial-value: #204CCF;
    }
    ```
  ),
  caption: [Defining a primary color custom propperty using the ``` @property``` rule to be more precise.],
) <primary-color-custom-property-at-rule>

As displayed in @primary-color-custom-property-js below, both variations are also definable with JavaScript using ``` registerPropperty()``` or ``` setProperty()```. @register-property @set-property

#figure(
  align(left,
    ```js
    window.CSS.registerProperty({
      name: '--primary-color',
      syntax: '<color>',
      inherits: false,
      initialValue: '#204CCF ',
    });

    const root = document.documentElement;
    root.style.setProperty('--primary-color-contrast', '#FFFFFF');

    ```
  ),
  caption: [Using both ``` registerProperty()``` and ``` setProperty()``` in JavaScript to create CSS custom properties.],
) <primary-color-custom-property-js>

=== Global State Management

The CSS custom property can not only be used to store values such as colors to be applied to properties but also for state management. As the values can be altered and accessed both within CSS, as well as in JavaScript, it lends itself to store configuration data, based on which the user interface adapts.

When a user has not enabled a reduced motion setting in his OS or browser yet deactivates it with some website specific settings, it is possible to store that preference within a custom property, such as ``` --prefers-reduced-motion: true``` and act on that with the ``` @container``` at-rule to apply different styling at runtime similar to @at-container-reduced-motion. @at-container

#figure(
  align(left,
    ```css
    :root {
      --prefers-reduced-motion: false;
    }

    @container style(--prefers-reduced-motion: true) {
        .animated-content {
            animation: none !important;
        }
    }
    ```
  ),
  caption: [CSS ``` @container``` at-rule used to react to custom properties turning off animations based on user preferences.],
) <at-container-reduced-motion>

Another possibility would be to use the CSS attribute selector to overwrite other custom properties if another color theme is needed. When the users OS and browser settings suggest he wants a light color theme but he configures it differently on the website itself a custom property such as ``` --prefers-dark-theme: true``` could be set to change the applications color palette as shown in @attribute-selector-dark-color-theme. @attribute-selector

#figure(
  align(left,
    ```css
    :root {
      --prefers-dark-theme: false;

        --text-color: #222222;
        --bg-color: #FCFCFC;
        --border-color: #EEEEEE;
        --primary-accent: #0056B3;
    }

    :root[style*="--prefers-dark-theme: true"] {
        --text-color: #EDEDED;
        --bg-color: #212121;
        --border-color: #232323;
        --primary-accent: #6DB3F4;
    }

    ```
  ),
  caption: [CSS attribute selector used to react to custom properties switching to a dark color theme based on user preferences.],
) <attribute-selector-dark-color-theme>

=== Custom Propperty Toggle

In the landscape of modern CSS, developers often face the challenge of managing repetitive declarations, particularly when implementing light and dark themes. Whether using traditional class-based switching or standard ``` @media (prefers-color-scheme: dark)``` blocks, the logic frequently requires duplicating property keys to override their values. A tiny footnote in the CSS specifications allows for a more elegant approach to state management using custom property to toggle values.

According to CSS specifications, a custom property must represent at least one token to be valid. This token can be a simple whitespace, allowing for exploitation to create ``` boolean``` values as shown in @whitespace-property-value. @custom-propperty-declaration-value

#figure(
  align(left,
    ```css
    :root {
    	--true: ;
    	--false: initial;
    }
    ```
  ),
  caption: [Both ``` ' '``` and ``` initial``` are valid values for custom properties.],
) <whitespace-property-value>

Traditional theming setups require to define variables twice for both the light- as well as the dark-theme. Taking advantage of the pseudo ``` boolean``` values from @whitespace-property-value the toggle logic can be put into a single custom property, demonstrated in @toggle-custom-property.

#figure(
  align(left,
    ```css
    :root {
      --is-light-theme: var(--true);
    }

    @media (prefers-color-scheme: dark) {
      :root {
        --is-light-theme: var(--false);
      }
    }
    ```
  ),
  caption: [Assigning either ``` ' '``` or ``` initial``` debending on the chosen theme allows to create the base for the toggle logic.],
) <toggle-custom-property>

Setting the ``` --is-light-theme``` property as prefix when declairing a custom property results either in a valid declaration, if a whitespace is set as prefix, or an invalid declaration, if ``` initial``` is set as the prefix value. Using ``` var()``` with a fallback value is now automatically assigning either the light-theme or dark-theme color, depending on the validity of the light-theme custom properties displayed in @var-fallback-property.

#figure(
  align(left,
    ```css
    :root {
      --color-text--light: var(--is-light-theme) black;
      --color-text--dark: white;

      --color-background--light: var(--is-light-theme) white;
      --color-background--dark: black;

      --color-text: var(--color-text--light, var(--color-text--dark));
      --color-background: var(--color-background--light, var(--color-background--dark));
    }
    ```
  ),
  caption: [Prepending ``` initial``` when setting the value of a custom property results in ``` var()``` taking the fallback argument.],
) <var-fallback-property>

Multiple fallback values, based on different toggle properties, representing different stylings, could be chained with the ``` var()``` CSS function. This allows for a central state management, assigning custom properties used throughout the whole setup in one single place. @custom-propperty-theme-switch @var-function

#pagebreak()
== CSS Functions

There are many native CSS functions available that make a developer's life easier. Some of these functions might be useful when it comes to accessibility such as the ``` contrast-color()``` function that became newly available during the implementation of this project in April 2026 and works across the latest devices and browser versions. This function returns either white or black, depending on which of these two colors has a higher contrast to the color passed to the function as parameter. An example with a ``` button``` styling can be seen in @contrast-color-example. @contrast-color

#figure(
  align(left,
    ```css
    button {
      background-color: var(--button-color);
      color: contrast-color(var(--button-color));
    }
    ```
  ),
  caption: [Setting the text color of a button black or white, depending on the background color],
) <contrast-color-example>

Having either black or white as font color on a background is a very safe approach but might, depending on the background, feel too harsh, making the reading experience less pleasant. Another relatively fresh available CSS function is the ``` light-dark()```, allowing developers to provide two colors or images. Depending on the active color scheme the first value is returned for the light theme and the second value for the dark theme. In @light-dark-example this approach ids shown using custom properties. @light-dark

#figure(
  align(left,
    ```css
    body {
      color: light-dark(var(--color-text--light), var(--color-text--dark));
      background-color: light-dark(var(--color-background--light), var(--color-background--dark));
    }
    ```
  ),
  caption: [Defining the text and background color depending on the selected theme with custom properties.],
) <light-dark-example>

=== CSS Custom Functions

Whilst the wide range of available functions in CSS covers a lot of use cases there might be scenarios that do not fit these provided possibilities and need combination of functions or even completely different functionalities. This is where the currently still as experimental flagged ``` @function``` at-rule comes into play. This feature has a similar look and feel to the CSS custom properties, also starting with a leading ``` --``` in their name. To declare such a function the ``` @function```keyword is needed, followed by a custom name and some optional parameters. Both parameters and function name start with ``` ---```, followed by a case-sensitive identifier defined by the user. Finaly a value defined with ``` result:``` is evaluated and the result returned as seen in @at-function-example. @at-function

#figure(
  align(left,
    ```css
    @function --color-contrast(--color <color>) returns <color> {
        result: oklch(from var(--color) calc((0.5 - l) * infinity) 0 0);
    }
    ```
  ),
  caption: [A custom function that serves the same purpose as ``` contrast-color()``` but was creates before this feature was widely available.],
) <at-function-example>

[[ADDING IF, ELSE, types (synthax in properties)]]

#pagebreak()
== Color Spaces

=== RGB

Red, green and blue (and alpha chanel)

#figure(
  align(left,
    color-snippet(
      ```css
      rgb(45 31 177 / 0.5);
      ```,
      rgb(45, 31, 177, 50%)
    ),
  ),
  caption: [An example showing how to use ``` rgb()``` with a color from the Kolibri palette],
) <rgb-color-example>

=== HSL

Hue, saturation and light (Also in RGB color space)

#figure(
  align(left,
    color-snippet(
      ```css
      hsl(256 82 55 / 0.6);
      ```,
      rgb(95, 46, 234, 60%)
    ),
  ),
  caption: [How to use ``` hsl()``` to configure another color from the Kolibri palette],
) <hsl-color-example>


=== Oklab

oklab() (lightness, red/green-ness, yellow/blue-ness) and oklch() (lightness, chroma, hue)

#figure(
  align(left,
    color-snippet(```css
      oklab(0.638, 0.176, -0.279 / 0.7);
      oklch(0.718 0.255 301.5 / 0.7);
      ```,
      rgb(190, 88, 253, 70%)
    ),
  ),
  caption: [Showcasing ``` oklab()``` and ``` oklch()``` with yet another color from the Kolibri palette],
) <ok-color-example>

=== HWB

Hue, whiteness and blackness

#figure(
  align(left,
    color-snippet(```css
      hwb(325 18 0 / 0.3);
      ```,
      rgb(254, 46, 168, 30%)
    ),
  ),
  caption: [Using ``` hwb()``` to recreate a different color shade from the Kolibri palette],
) <hwb-color-example>

@CSS-colors

#pagebreak()
== Contrast perception

[TODO] Some introducing summary on contrast.

=== Relative Luminance

The current WCAG 2.x standard bases contrast requirements on relative luminance between text and its background, independent of hue. This assumes that for individuals with color vision deficiencies, hue and saturation have minimal or no effect regarding legibility as assessed by reading performance. Since the inability to distinguish specific colors does not typically impair light-dark perception, color itself is not considered a primary factor in these calculations. Far more important is that smaller and thinner fonts may be rendered by user agents with a much fainter appearance than the color defined in the CSS, leading to a perceived contrast that is notably lower than the theoretical ratio.

The WCAG guideline requires at least a contrast ratio of 3:1 to satisfy the corelating requirement for level AA. This is based in the recommendation from ISO-9241-3. To achieve level AAA certification the minimum ratio is set to 7:1. This ratio was chosen because it compensated for the loss in contrast sensitivity experienced by users with approximately 20/80 vision (This means that someone needs to be 20 feet away to see what a person with normal vision can see from 80 feet away). People with more than this degree of vision loss usually use assistive technologies.

Color deficiencies are so diverse that it is impossible to generalize effective color pairs for contrast based on quantitative data. This is why contrast independent of color perception is so important.

A notable exception is protanopia where red color tones are perceived as dark grey, resulting in a bad contrast on darker colors and black. This is why it is recommended to generally not use red on black. @WCAG-1.4.3

The formula depicted in @relative-luminanc-formula is used in the WCAG 2.x specification to calculate the relative luminance used for further calculations such as color contrast. @relative_luminanc

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

The WCAG 2.x contrast guidelines that are based on relative luminance are being replaced in the future with the WCAG 3.0 guidelines that use the Accessible Perceptual Contrast Algorithm (APCA). Massive changes in display technology, web content and CSS functionality led to the approach that was defined nearly 2 decades ago for WCAG 2.x to be outdated and in need for replacement based on advances in vision science since 2005.

The current approach follows a binary nature where the criteria either passes or fails as a whole. It is important to understand the non-linear aspects of perception and using a model that takes these aspects in account.

All perception is context sensitive and when it comes to readability contrast font weight and line thickness are principal factors that must be taken into account when looking at luminance contrast.

The color contrast regarding hue, chroma or saturation is less relevant for readability, but high light/dark contrast ensures the best readability. Smaller and thinner visual characteristics lower the perceived contrast, requiring for the light/darkness difference to increase as showcased in @apca-curve.

#figure(
  box(
    inset: 12pt,
    radius: 6pt,
    stroke: 0.5pt + rgb("#cbd5e1"),
  {
    image("../ressources/apca_curve.png", width: 80%)
  }),
  caption: [This chart demonstrates with the usage of text samples the spatial dependance of human contrast sensitivity. @APCA],
) <apca-curve>

Nontextual objects like an icon require a lower lightness contrast compared to text and the contrast requirement of two colors is dependent of the use case, size, thickness and so on. The math behind WCAG 2.x contrast for accessibility has problems that have been known for a long time and are criticized widely. Case studies that compare contrast between white and black text on a colored background found that the variant that was deemed as inaccessible by the guidelines were perceived as more readable by the majority of contestants with color vision deficiencies. @white-on-orange-case-study

APCA is a new approach for calculating and predicting readability contrast related to color appearance on self-illuminated RGB computer displays introducing the lightness contrast ($L^c$) value. This new approach considers the context in which two colors are used rather than passing or failing regardless of the use case. @APCA

#pagebreak()
== Ishihara

The Ishihara color test, named after Japanese ophthalmologist Shinobu Ishihara, was originally designed in 1917 to identify red-green color vision deficiencies. The test utilizes a series of circular plates covered in pseudo-isochromatic dots, randomly sized circles of varying colors that appear identical to those with color blindness but distinct to those with standard vision. @ishihara

An example of such a plate can be seen in @ishihara-example01 that uses a orange and teal color plate which should be visible independent of the viewers vision types. This color combination was typically used as demonstratin plate at the beginning of a ishihara test.

=== Functional Application in Contrast Testing

While traditionally a diagnostic tool for the human eye, the mechanics of these plates offer a rigorous framework for testing visual hierarchy and contrast in design.

By packing dots of different colors together, the Ishihara method forces the eye to rely on "chromatic contrast" to find a pattern. In a custom application, if a design’s foreground and background colors "bleed" together on a dotted plate, it proves the colors lack the necessary luminance contrast to be accessible.

Custom plates can be generated using specific color palettes to ensure that a brand's primary colors are distinguishable not just to standard viewers, but across the spectrum of for example Protanopia or Deuteranopia.

#figure(
  box(
    inset: 12pt,
    radius: 6pt,
    stroke: 0.5pt + rgb("#cbd5e1"),
  {
    image("../ressources/Ishihara-example01.png", width: 50%)
  }),
  caption: [This plate displays a high-contrast figure designed to remain legible across all vision types, serving as the universal baseline for the Ishihara color test.],
) <ishihara-example01>

#pagebreak()