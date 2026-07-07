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

= Guiding Developers During Construction

The following section discusses aspects to consider while building a web application and introduces tools that support developers throughout the development process. These tools make it easier to address contrast concerns early, resulting in more accessible websites.

A custom CSS contrast color function is presented that extends the functionality currently available in CSS. Additionally, an interactive Ishihara plate is introduced to evaluate the color compatibility of a design while also allowing its colors to be inspected under simulated color blindness conditions. The section further covers practical CSS and JavaScript concepts, demonstrating how developers can respond to user preferences and implement adaptive behavior using CSS custom properties.

== Color Models

There are many different models for describing the colors perceptible to the human eye. Each model has its own strengths and weaknesses and is used in different contexts, ranging from print and photography to digital displays.

For many years, CSS relied primarily on the RGB color model, which limited how colors could be described and manipulated. To update features faster, the W3C now evolves CSS through independent modules rather than giant versions. Under this system, the CSS Color Module Level 4 specification acts as a direct software update to the three previously released levels, introducing support for additional color models and more advanced color functions to significantly expand the possibilities for working with color in CSS. Development in this area continues, and the W3C is currently working on the CSS Color Module Level 5 specification.

#pagebreak()
=== RGB

The RGB color model represents colors by combining different intensities of the primary colors ``` red```, ``` green```, and ``` blue```. An optional alpha channel can be added to define the opacity of the resulting color. The geometric relationship of these three primary channels is mapped as a three-dimensional cube, as shown in @rgb-model-image.

RGB has been supported in CSS since its early days and can be expressed using the ``` rgb()``` function or hexadecimal notation. For example, the color shown in @rgb-color-example can also be written as ``` #2d1fb180```. @CSS-colors

This color model is widely used because it has been established for a long time and its syntax is relatively intuitive, making it possible to roughly predict the resulting color. A drawback of this model is that adjusting the lightness or darkness of a color without changing its hue is nearly impossible by simply modifying its parameters. This makes it difficult to create different shades of the same color in a predictable and manageable way.

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

#figure(
  box(
    radius: 6pt,
    clip: true,
    stroke: 0.5pt + rgb("#cbd5e1"),
  {
    image("../ressources/RGB_model.png", width: 40%)
  }),
  caption: [A visual representation of the RGB model with its \ dimention showcasing how color values are defined. @RGB_model],
) <rgb-model-image>

#pagebreak()
=== HSL

CSS Color Module Level 3 introduced the HSL color model to CSS. HSL describes colors using three components: ``` hue```, ``` saturation```, and ``` lightness```, as illustrated in @hsl-color-example and visually mapped onto the cylindrical coordinate system in @hsl-model-image. The hue is represented as an angle on the color wheel, while saturation and lightness define the intensity and brightness of the color. As with RGB, an optional alpha channel can be added to control opacity.

HSL makes it easier to create variations of a color because saturation and lightness can be adjusted directly without recalculating individual RGB values. This is particularly useful when generating lighter or darker shades while preserving the visual identity of the base color as much as possible. @CSS-colors

Although HSL is not as widely used as RGB, it is still commonly used in practice. It is particularly well suited for creating interactive states such as hover effects, as the lightness or saturation of a color can be adjusted independently while largely preserving its hue. Once the distribution of colors around the hue wheel is understood, the resulting colors are also relatively predictable.

#figure(
  kind: raw,
  align(left,
    color-snippet(
      ```css
      hsl(256deg 82% 55% / 60%);
      ```,
      rgb(95, 46, 234, 60%)
    ),
  ),
  caption: [Using ``` hsl()``` to define a color from the Kolibri palette with 60% opacity.],
) <hsl-color-example>

#figure(
  box(
    radius: 6pt,
    clip: true,
    stroke: 0.5pt + rgb("#cbd5e1"),
  {
    image("../ressources/HSL_model.png", width: 50%)
  }),
  caption: [A visual representation of the HSL cylindrical model with \ its dimensions showcasing how color values are defined. @HSL_model],
) <hsl-model-image>

#pagebreak()
=== CIELAB Colors

The Oklab color space and its related Oklch color model make it possible to define colors in a way that more closely matches human vision. They also provide access to a wider range of colors than those that can be represented in the traditional sRGB color space.

The ``` oklab()``` function describes a color using three components: ``` lightness```, the ``` a``` axis representing red-green variation, and the ``` b``` axis representing yellow-blue variation. The related ``` oklch()``` function uses ``` lightness```, ``` chroma```, and ``` hue``` instead. Both functions support an optional alpha channel to control opacity. An exemplary usage of both functions can be observed in @ok-color-example. While Oklab and Oklch utilize optimized mathematical models for modern screens, they are based on perceptual axes shown in @cielab-model-image, where lightness forms the vertical axis while the color components extend orthogonally from it.

Although this color model is relatively new and not yet widely used, it is regarded as the current state of the art for working with color in CSS because it produces more perceptually uniform results. In practice, this means that adjusting lightness or chroma leads to visual changes that preserve the original base color as accurately as possible compared to older color models. However, its syntax is less intuitive, making it difficult to roughly predict the resulting color without additional knowledge. @CSS-colors

#figure(
  kind: raw,
  align(left,
    color-snippet(```css
      oklab(63.8% 0.176 -0.279 / 0.7);
      oklch(71.8% 0.255 301.5 / 0.7);
      ```,
      rgb(190, 88, 253, 70%)
    ),
  ),
  caption: [Using ``` oklab()``` and ``` oklch()``` to define a \ color from the Kolibri palette with 70% opacity.],
) <ok-color-example>

#figure(
  box(
    radius: 6pt,
    clip: true,
    stroke: 0.5pt + rgb("#cbd5e1"),
  {
    image("../ressources/CIELAB_model.png", width: 75%)
  }),
  caption: [A visual representation of the CIELAB/CIELCH coordinate \ dimensions, mapping perceptual lightness ($L$), chromatic axes ($a, b$), \ chroma ($C$), and hue ($H$). @CIELAB_model_a @CIELAB_model_b],
) <cielab-model-image>

#pagebreak()
=== HWB

The ``` hwb()``` color function was introduced alongside newer CSS color features. It describes colors using three components within the RGB color space: ``` hue```, ``` whiteness```, and ``` blackness```. In practice, it provides an alternative to ``` hsl()``` that can be considered more intuitive when adjusting tints and shades. An example is shown in @hwb-color-example, while @hwb-model-image illustrates how these coordinates are mapped relative to the peripheral hue wheel. @CSS-colors

This color model is not widely used and was designed to provide a simpler and more intuitive approach compared to RGB or HSL. Its simplicity comes from the idea of defining a base color and adding white and/or black to create different shades without changing the underlying hue.

#figure(
  kind: raw,
  align(left,
    color-snippet(```css
      hwb(325deg 18% 0% / 30%);
      ```,
      rgb(254, 46, 168, 30%)
    ),
  ),
  caption: [Using ``` hwb()``` to define a color from the Kolibri palette with 30% opacity.],
) <hwb-color-example>

#figure(
  box(
    //inset: 12pt,
    radius: 6pt,
    clip: true,
    stroke: 0.5pt + rgb("#cbd5e1"),
  {
    image("../ressources/HWB_model.png", width: 50%)
  }),
  caption: [A visual representation of the HWB color space structured as a triangle-wheel picker, showcasing how hue, whiteness, and blackness interact. @HWB_model],
) <hwb-model-image>

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
  caption: [Setting the text color of a button to black \ or white based on the background color.],
) <contrast-color-example>

Using either black or white for text is a reliable way to ensure strong contrast. Depending on the background color, however, the result may appear visually harsh and less pleasant to read. Another CSS function is ``` light-dark()```, which accepts two color values or images. The first value is used when a light color scheme is active, while the second value is applied when a dark color scheme is active. The active mode is determined by the ``` color-scheme``` CSS property, which indicates the color system an element should render. User agents use this property to adapt elements such as scrollbars, form controls, and the canvas surface to match the preferred scheme. @light-dark-example demonstrates this approach using custom properties. @light-dark

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
  caption: [Defining text and background colors based on the \ active color theme using custom properties.],
) <light-dark-example>

=== CSS Custom Functions

Although the growing set of built-in CSS functions covers many use cases, some scenarios, such as calculating ``` rem``` from a pixel value, still require functionality that cannot be expressed with the currently available primitives. In such cases, developers may need to combine multiple functions or implement custom logic. This is where the experimental ``` @function``` at-rule becomes relevant.

This feature is conceptually similar to CSS custom properties, as custom functions also use names that begin with a dashed-ident ``` --```. A function is declared using the ``` @function``` keyword, followed by a custom name and an optional list of parameters. Both the function name and its parameters start with ``` --``` and are followed by case-sensitive identifiers defined by the developer. Inside the function body, the expression assigned to ``` result:``` is evaluated and returned, as shown in @at-function-example. @at-function

#figure(
  align(left,
    ```css
    @function --color-contrast(--color <color>) returns <color> {
      result: oklch(from var(--color) calc(((l * -1) + 0.5) * infinity) 0 0);
    }
    ```
  ),
  caption: [A custom function that provides behavior similar to ``` contrast-color()``` \ and was created before that function became widely available.],
) <at-function-example>

As with CSS custom properties, CSS data types such as ``` <color>```, ``` <number>```, and ``` <string>``` can be specified for both function parameters and the return value.

#pagebreak()
== Canvas

The HTML ``` <canvas>``` element is used to draw graphics and animations directly within a web page. By default, the element has no visual representation of its own and must be rendered through JavaScript using either the ``` Canvas API``` or the ``` WebGL API```. @canvas-element

The ``` Canvas API``` is primarily designed for two-dimensional graphics and is commonly used for tasks such as game rendering, data visualization, image manipulation, and real-time video processing. The ``` WebGL API``` extends these capabilities by providing hardware-accelerated rendering for both two-dimensional and three-dimensional graphics. @canvas-api

In addition to drawing content, the canvas allows pixel data to be read and analyzed. The ``` ImageData``` interface provides access to the underlying RGBA values of a rendered image. @canvas-rgba-extraction demonstrates how the color values of a selected area can be extracted in JavaScript. This is especially useful when converting colors between different CSS color spaces, where manual conversion can introduce inaccuracies. For example, converting an Oklch color into an RGB value requires mapping between different color spaces, which can result in imprecise values that affect further calculations. Using the ``` canvas``` element allows these inaccurate conversions to be avoided by extracting the actual rendered pixel values directly. @image-data

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
== Contrast Color Function

The previously introduced ``` contrast-color()``` function returns either black or white for a given color, depending on which provides the greater lightness contrast. While this approach is effective, pure black and white can appear visually harsh, especially when used for larger blocks of text.

To address this limitation, an enhanced version of ``` contrast-color()``` was developed during this project and is shown in @custom-color-contrast-function. The custom function accepts a required parameter of type ``` <color>``` and an optional ``` <percentage>``` parameter named ``` --intensity```.

In the first step, the function determines whether black or white provides the better contrast by evaluating the lightness component of the input color in the Oklch color space. This is achieved by multiplying the lightness value with ``` -1``` and adding ``` 0.5``` afterwards, resulting in either a positive or negative value. The result is then multiplied by the constant ``` infinity```. Due to the way ``` oklch()``` handles lightness values, this effectively collapses the result to either 0 or 1, depending on whether the original color is darker or lighter than 50%. If the lightness value is greater than 50%, black is selected. Otherwise, white is used.

In the second step, the selected contrast color is passed to the ``` color-mix()``` function. The optional ``` --intensity``` parameter controls how much of the original color is mixed back into the result. This produces a softer contrast color that retains some of the visual characteristics of the source color.

To further reduce extreme contrast, the lightness of the selected black or white is adjusted using the ``` clamp()``` function. This ensures that light colors do not exceed a lightness of 97.5% and dark colors do not fall below 15%. As a result, the generated contrast color remains readable while appearing less visually aggressive. The selected bounds represent pragmatic perceptual limits intended to preserve strong readability while reducing the visual harshness associated with maximum contrast combinations.

#figure(
  align(left,
    ```css
    @function --color-contrast(
      --color <color>,
      --intensity <percentage>: 0%
    ) returns <color> {
      --black-or-white: oklch(
        from var(--color) calc(((l * -1) + 0.5) * infinity) 0 0
      );

      result: color-mix(
        in oklch,
        oklch(from var(--black-or-white) clamp(0.15, l, 0.975) c h),
        var(--color) var(--intensity)
      );
    }
    ```
  ),
  caption: [A custom contrast function that softens pure black and \ white and optionally mixes in a portion of the original color.],
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
  caption: [A screenshot of the configuration interface \ for the custom contrast color function.],
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
  caption: [Extracting the ``` RGBA``` values of any CSS \ color using the HTML ``` <canvas>``` element.],
) <canvas-for-color-extraction>

The implementation of the custom contrast color function is available in the project's repository. @p8-contrast-color

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
  caption: [A high-contrast demonstration plate designed to \ remain legible across all common vision types.],
) <ishihara-example01>

== Interactive Ishihara Plate

The interactive Ishihara plate created during this project is not intended to directly enhance a website through integration into a production environment. Instead, it serves as a developer tool for visually evaluating color contrast in situations where shape, placement, or additional visual cues do not influence recognition. The focus lies entirely on the perception of color itself.

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
  caption: [A screenshot of the interactive Ishihara plate \ configured with colors from the Kolibri palette.],
) <interactive-ishihara-plate>

In addition to freely configurable colors, the application also includes predefined color combinations designed to simulate scenarios that are difficult or impossible to distinguish for people with specific forms of color vision deficiency such as ``` Protanopia```, ``` Deuteranopia```, and ``` Tritanopia```. These presets make it possible to evaluate whether certain color combinations remain distinguishable under different forms of impaired color perception.

Although these configurations are inspired by the original Ishihara test plates, the application is not intended to serve as a medically accurate diagnostic tool. Instead, it should be considered a visual indicator that may suggest the need for further professional examination.

An example of these comparison modes can be seen in @ishihara-plate-comparisement. The left side displays a plate configured with colors that are difficult to distinguish for users with ``` Deuteranopia```. The right side shows the same plate with a ``` Deuteranopia``` simulation filter applied, illustrating how the color combination may appear to affected users. The simulation filters are based on the bookmarklet filters developed during the previous P7 project.

A more detailed discussion of these bookmarklets is available in the corresponding chapter of the previous P7 project. @p7-debugging

#figure(
  box(
    inset: 0pt,
    radius: 6pt,
    clip: true,
    stroke: 0.5pt + rgb("#cbd5e1"),
  {
    image("../ressources/ishihara-comparisement.png", width: 80%)
  }),
  caption: [A comparison between a plate configured for ``` Deuteranopia``` on the left \ and the same plate viewed through a ``` Deuteranopia``` simulation filter on the right.],
) <ishihara-plate-comparisement>

The implementation of the interactive Ishihara plate is available in the project's repository. @p8-ishihara

#pagebreak()
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
  caption: [Syntax of a media query, where ``` <media-query-list>``` contains \ ``` <media-type>``` values, ``` <media-feature>``` values, and logical operators.],
) <media-synthax-example>

In web development, the ``` screen``` media type is the most commonly used, but media queries can also target printers by using ``` print```. If no media type is specified, the default value is ``` all```, which applies the styles to all devices.

Media features are where media queries become particularly powerful, as more than 40 features are currently available. They allow styles to respond to specific characteristics of the user's environment. Common examples include ``` max-width``` and ``` max-height```, as well as their counterparts ``` min-width``` and ``` min-height```. These features are widely used to create responsive websites with layouts optimized for different screen sizes.

@screen-width-example demonstrates a media query that uses the ``` screen``` media type together with the ``` max-width``` media feature.

Some media features take accessibility needs and user preferences into account. They make it possible to adapt the presentation of a website to individual requirements. Despite their importance, they are still used less frequently than they should be. The following media features are particularly relevant when building web applications that aim to be accessible to a broader audience. @media_queries

#figure(
  align(left,
    ```css
    .container {
      display: grid;
      grid-template-columns: 1fr 1fr 1fr;
    }

    @media screen and (max-width: 768px) {
      .container {
        grid-template-columns: 1fr 1fr;
      }
    }
    ```
  ),
  caption: [Example of a media query that changes the ``` .container``` element layout from 3 columns to 2 columns on smaller screens, such as a vertical tablet \ screen, using the ``` screen``` media type and the ``` max-width``` media feature.],
) <screen-width-example>

=== Reduced Motion

The ``` prefers-reduced-motion``` media feature indicates whether a user has enabled a system setting that reduces non-essential motion. If the value is set to ``` reduce```, animations and transitions should be limited to the bare minimum.

A value of ``` no-preference``` indicates that the user has not expressed a preference for reduced motion, allowing animations and transitions to be displayed without restriction. @reduced-motion

=== Contrast

The ``` prefers-contrast``` media feature allows users to indicate whether they prefer content to be presented with higher or lower contrast. A value of ``` no-preference``` indicates that the user has not configured a contrast preference.

If the value is set to ``` more```, the user requests a higher level of contrast. Conversely, a value of ``` less``` indicates that a lower contrast is preferred.

The value ``` custom``` indicates that the user prefers a specific set of colors. This color palette is typically defined through the ``` forced-colors``` media feature, which is explained in the following section. @contrast

=== Forced Colors

The ``` forced-colors``` media feature detects whether the user agent has enabled a forced color mode, such as a Contrast Theme available in the Windows accessibility settings. This media feature has the value ``` active``` when such a mode is enabled and ``` none``` when it is not.

When forced colors mode is active, many color values defined in the style sheet are overridden by the browser during the painting process. The exact colors applied depend on the semantic role of each element. In addition, browsers may draw backplates behind text to preserve legibility and maintain sufficient contrast when text appears on top of images or patterned backgrounds.

Developers are generally not encouraged to create a separate design specifically for users who enable forced colors mode. Instead, this media query should be used to make targeted adjustments when certain components do not work well in this context. For example, a button that relies solely on ``` box-shadow``` to stand out from the background may lose its visual distinction. In such cases, replacing the shadow with a visible border can provide a more robust solution. @forced-colors

=== Reduced Transparency

The ``` prefers-reduced-transparency``` media feature indicates whether a user has enabled a system setting to reduce transparent or translucent visual effects. If the value is set to ``` reduce```, transparency effects such as blurred overlays or frosted glass backgrounds should be minimized or removed. A value of ``` no-preference``` indicates that the user has not expressed a preference and that the default design can be used.

Reducing transparency can improve contrast and readability, particularly for users who find translucent interface elements distracting or difficult to perceive.

Support for this media feature is currently limited and it is not yet fully supported by Firefox and Safari as of July 2026. @reduced-transparency

=== Color Scheme

A more widely adopted media feature is ``` prefers-color-scheme```. It indicates whether the user prefers a light or dark color theme configured through the operating system or the user agent. The value ``` light``` represents a light color theme, while ``` dark``` represents a dark color theme. @color-scheme

=== Inverted Colors

The ``` inverted-colors``` media feature detects whether the user agent is displaying content with inverted colors. Color inversion can introduce visual side effects, such as shadows appearing as highlights, which may reduce the readability of the content. By responding to this media feature, developers can make targeted adjustments to preserve the visual integrity of the page.

Support for this media feature is currently limited and, at the time of writing, it is only supported by Safari. @inverted-colors

=== Accessing Media Features through JavaScript

The ``` window``` interface provides the ``` matchMedia()``` function, which returns a ``` MediaQueryList``` object. This object can be used to determine whether the current ``` document``` matches a given media query string. @dark-color-scheme-example demonstrates this approach using the ``` prefers-color-scheme``` media feature.

#figure(
  align(left,
    ```js
    const isDarkTheme = window.matchMedia(
                          '(prefers-color-scheme: dark)'
                        ).matches;
    ```
  ),
  caption: [Checking whether the user's system settings prefer a dark color scheme.],
) <dark-color-scheme-example>

This allows developers to respond to user preferences not only in CSS, but also within JavaScript logic and application-specific features. @match-media

=== Changes in the World of Media Queries

CSS media queries continue to evolve, but one important aspect of visual accessibility is still not addressed. Different forms of color blindness and other impairments that affect color perception are not yet covered by an official media feature.

An open issue in the W3C's ``` csswg-drafts``` repository proposes a new media feature called ``` color-vision-adjustment```. Its goal is to improve web accessibility by allowing developers to respond directly to the needs of users with color vision deficiencies.

The proposal includes support for several specific conditions, including protanopia (red deficiency), deuteranopia (red-green deficiency), tritanopia (blue-yellow deficiency), and achromatopsia (near-total color blindness, resulting in grayscale vision). These impairments were previously investigated in the P7 project through browser bookmarklets designed to simulate the corresponding visual deficiencies.

Further details regarding the implementation and theoretical background of these simulations can be found in the P7 project documentation. @p7

A media feature of this kind would increase awareness of color vision deficiencies and provide developers with a standardized way to react to the specific requirements of affected users. @color_blindness_media_qiery

=== Deprecated Features

Earlier versions of CSS included media types such as ``` embossed```, ``` aural```, and ``` braille```, which were intended to address specific accessibility needs. These media types were later deprecated because the distinction between device categories was expected to become less meaningful over time. In addition, media types describe classes of devices rather than the actual capabilities they support. @css3_qa

=== Security Concerns

Information exposed through media queries can be used to build a browser fingerprint, which may allow a device to be identified and tracked across websites. To reduce this risk, browsers may deliberately modify or generalize certain reported values.

Some browsers also provide settings that further limit this information. For example, Firefox offers the "Resist Fingerprinting" option, which causes many media queries to return standardized values instead of device-specific settings. @at_media

#pagebreak()
== CSS Custom Properties

CSS custom properties are user-defined values that can be reused throughout a style sheet where the style defining them is applied. This centralized approach makes styles significantly easier to maintain and reduces code duplication.

A custom property is defined using a ``` <dashed-ident>```, which consists of two dashes ``` --``` followed by a descriptive identifier. Its value can then be accessed using the CSS ``` var()``` function. @primary-color-custom-property demonstrates how the custom property ``` --primary-color``` can be defined once and reused throughout a style sheet. This approach is particularly useful when implementing multiple themes, such as light and dark modes, because colors can be updated from a single central location.

#figure(
  align(left,
    ```css
    body {
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
  caption: [Defining a primary color custom property \ that can be reused throughout the website.],
) <primary-color-custom-property>

The ``` @property``` at-rule allows custom properties to be defined more precisely. It makes it possible to specify expected syntax definition using ``` syntax```, whether the property's value is inherited by child elements using ``` inherits```, and an initial value using ``` initial-value```. Possible syntax definitions include data type names such as ``` <color>```, ``` <number>```, and ``` <url>```. @at-property-syntax @primary-color-custom-property-at-rule shows how the previous ``` --primary-color``` example can be expressed using this at-rule. @at-property

#figure(
  align(left,
    ```css
    @property --primary-color {
      syntax: '<color>';
      inherits: true;
      initial-value: limegreen;
    }

    body {
      --primary-color: #204ccf;
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
      inherits: true,
      initialValue: 'limegreen',
    });

    document.body.style.setProperty('--primary-color-contrast', '#ffffff');
    ```
  ),
  caption: [Using ``` registerProperty()``` and ``` setProperty()``` \ in JavaScript to define CSS custom properties.],
) <primary-color-custom-property-js>

Custom properties can also be read in JavaScript using ``` getPropertyValue()```, as shown in @primary-color-custom-property-js-read. This makes it possible to react to dynamically changed values and use them in application logic.

#figure(
  align(left,
    ```js
    const body          = document.body;
    const primaryColor  = getComputedStyle(body).getPropertyValue(
                            '--primary-color'
                          );
    ```
  ),
  caption: [Reading a CSS custom property in JavaScript using ``` getPropertyValue()```.],
) <primary-color-custom-property-js-read>

#pagebreak()
=== Global State Management

CSS custom properties are not limited to storing design values such as colors. They can also be used to manage application state. Because custom properties can be read and modified in both CSS and JavaScript, they provide a convenient way to store configuration values that directly influence the user interface.

For example, a user may not have enabled reduced motion at the operating system level, such as the Reduced Motion setting in the Accessibility settings on macOS, but may choose to disable animations through an application-level preference. This choice can be stored in a custom property such as ``` --prefers-reduced-motion: true```. The ``` @container``` at-rule can then react to this value and apply different styles at runtime, as shown in @at-container-reduced-motion. @at-container

#figure(
  align(left,
    ```css
    :root {
      --prefers-reduced-motion: false;
    }

    @container style(--prefers-reduced-motion: true) {
        .animated {
            animation: none;
        }
    }
    ```
  ),
  caption: [Using the CSS ``` @container``` at-rule to \ disable animations based on a custom property.],
) <at-container-reduced-motion>

It is also possible to override custom properties when a different color theme is selected with the ``` @container``` at-rule. For example, the operating system and browser may indicate a preference for a light theme, while the user explicitly selects a dark theme on the website. In this case, a custom property such as ``` --prefers-dark-theme: true``` can be used to switch the application's color palette, as demonstrated in @at-container-dark-color-theme.

#figure(
  align(left,
    ```css
    :root {
      --prefers-dark-theme: false;
    }

    body {
      --text-color:     #222222;
      --bg-color:       #fcfcfc;
      --border-color:   #eeeeee;
      --primary-accent: #0056b3;
    }

    @container style(--prefers-dark-theme: true) {
      body {
        --text-color:     #ededed;
        --bg-color:       #212121;
        --border-color:   #232323;
        --primary-accent: #6Db3f4;
      }
    }

    ```
  ),
  caption: [Using the ``` @container``` at-rule to switch to a \ dark color theme based on a custom property.],
) <at-container-dark-color-theme>

#pagebreak()
=== Custom Property Toggle

In modern CSS, developers often face the challenge of managing repetitive declarations, especially when implementing light and dark themes. Whether the switch is handled through classes or through ``` @media (prefers-color-scheme: dark)```, the same property names typically need to be declared multiple times with different values. A lesser-known detail in the CSS specification makes it possible to implement this kind of state management more elegantly by using custom properties as toggle values.

According to the CSS specification, a custom property must contain at least one token to be considered valid. A single whitespace character satisfies this requirement and can therefore be used to simulate boolean-like values, as shown in @whitespace-property-value. @custom-property-declaration-value

#figure(
  align(left,
    ```css
    body {
    	--ON: ;
    	--OFF: initial;
    }
    ```
  ),
  caption: [Both ``` ' '``` and ``` initial``` are valid values for custom properties.],
) <whitespace-property-value>

In traditional theming setups, each variable must be defined separately for both the light and dark theme. By using the toggle values introduced in @whitespace-property-value, the theme state can be stored in a single custom property, as demonstrated in @toggle-custom-property.

#figure(
  align(left,
    ```css
    body {
      --is-light-theme: var(--ON);
    }

    @media (prefers-color-scheme: dark) {
      body {
        --is-light-theme: var(--OFF);
      }
    }
    ```
  ),
  caption: [Assigning either ``` ' '``` or ``` initial``` depending on \ the active theme creates the basis for the toggle logic.],
) <toggle-custom-property>

When ``` --is-light-theme``` is used as a prefix in another custom property declaration, the resulting declaration is either valid or invalid depending on its value. If the prefix expands to a whitespace character, the declaration remains valid. If it expands to ``` initial```, the declaration becomes invalid. To handle this, the ``` var()``` function accepts a fallback value as a second argument, which is automatically applied if the referenced custom property resolves to a guaranteed-invalid value like ``` initial```. @var-fallback-property illustrates how this mechanism is utilized. @guaranteed-invalid-value

#figure(
  align(left,
    ```css
    body {
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
  caption: [When a custom property becomes invalid, \ ``` var()``` automatically uses the fallback value.],
) <var-fallback-property>

Multiple fallback values based on different toggle properties can be chained using the CSS ``` var()``` function. @var-function This enables centralized state management, where the custom properties used throughout the entire style sheet are controlled from a single location. @custom-property-theme-switch

An example of this theme toggle is available in the project's repository. @p8-theme-switch

#pagebreak()