= Auditing Existing Applications

The first part focuses on existing web applications. It introduces key concepts of contrast perception, current standards, and their evolution.

Based on this, tools created during this project are introduced. A color contrast checker is provided, enabling the calculation of WCAG 2.x-based contrast ratios between two colors using relative luminance. A Developer Widget is provided which simulates different vision impairments, allowing websites to be inspected under simulated conditions to evaluate their current accessibility state with respect to contrast and identify potential weaknesses. Additionally, an interactive Ishihara plate is introduced to evaluate the color compatibility of a design while allowing its colors to be inspected under simulated color blindness conditions.

== Setup and Exploratory Prototyping

The starting point of this project included the creation of an isolated environment, referred to as the Sandbox project, for rapid prototyping and experimentation. This environment allowed different implementation approaches to be tested incrementally while individual project parts evolved over time.

Testing CSS and JavaScript compatibility in practice proved especially important, as documentation alone often did not fully reflect actual browser behavior. Experimentation and exploratory iteration became a central part of the ideation process before more concrete concepts gradually emerged and were refined into the implementations presented throughout this documentation.

Many examples initially started as simple or partially hacky drafts before being iteratively improved into more stable and reusable solutions.

== Mathematical Foundation

To understand the current WCAG 2.x contrast standard, this work analyzes the W3C documentation regarding relative luminance and RGB color calculations. This defines the mathematical relationships between RGB values, luminance calculation, and contrast ratios.

This understanding allows the algorithmic approach from the specification to be formalized into a clear mathematical representation. This formulation enables the implementation of the contrast ratio indicator used within the custom contrast color function application.

This analysis also motivated research into the upcoming WCAG 3.0 contrast model. The WCAG 2.x documentation itself acknowledges limitations in its current formula, including simplifications, rounding inaccuracies, and perceptual shortcomings. While the APCA model was identified as a promising future replacement, it was not integrated into the practical implementation of this project because it remains under active development in draft status.

#pagebreak()
== Contrast Perception

Contrast is essential for distinguishing elements and understanding their relationships. Differences in brightness, size, sharpness, and shape all contribute to visual contrast. On the web, variations in lightness are the primary means of ensuring text readability and clearly separating interface elements.

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
  caption: [Step-by-step calculation of relative luminance \ based on the W3C sRGB formula. @relative_luminanc],
) <relative-luminanc-formula>

#pagebreak()
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
  caption: [This chart illustrates the spatial dependence of \ human contrast sensitivity using text samples. @APCA],
) <apca-curve>

Non-text elements such as icons typically require less contrast than body text. More generally, the appropriate contrast between two colors depends on the specific use case, including the size, thickness, and purpose of the element.

The contrast formula used in WCAG 2.x has been criticized for many years. Case studies comparing white and black text on colored backgrounds have shown that combinations classified as inaccessible under WCAG 2.x were sometimes perceived as more readable by participants with color vision deficiencies. @white-on-orange-case-study

APCA introduces a new metric called lightness contrast, expressed as $L^c$. Instead of assigning a universal pass-or-fail threshold, it estimates readability based on the perceptual relationship between foreground and background colors within their actual visual context. @APCA

#pagebreak()
== Color Contrast Checker

The WCAG contrast ratio requirements are precisely defined but cannot be reliably estimated by visually comparing two colors. Therefore, additional tools are required to verify whether these requirements are fulfilled for a given color pair. This is where the Color Contrast Checker, shown in @contrast-checker, comes into play. This tool allows the selection of two colors and calculates the contrast ratio to verify whether a color combination is suitable for use in a web application or if alternative colors are required to ensure sufficient contrast.

#figure(
  box(
    inset: 12pt,
    radius: 6pt,
    clip: true,
    stroke: 0.5pt + rgb("#cbd5e1"),
  {
    image("../ressources/contrast-checker.png", width: 100%)
  }),
  caption: [A screenshot of the color contrast checker that \ calculates the ratio of two selected colors.],
) <contrast-checker>

The implementation of the color contrast checker is available in the project’s repository. @p8-color-contrast-checker

#pagebreak()
== Developer Widget

While having a design with colors coordinated with each other is important, it is also essential to consider the system as a whole. All individual elements incorporated into a webpage must harmonize with each other in a consistent visual structure. The Developer Widget shown in @developer-widget is intended to visually evaluate how a website behaves under different vision impairments. In its current state, this widget allows simulation of common color blindness types in combination with blurred vision, and can be extended to a wider range of accessibility conditions if required.

#figure(
  box(
    inset: 0pt,
    radius: 6pt,
    clip: true,
    stroke: 0.5pt + rgb("#cbd5e1"),
  {
    image("../ressources/developer-widget.png", width: 100%)
  }),
  caption: [A screenshot of the developer widget where a website is inspected simulating Protanopia combined with intense blurry vision.],
) <developer-widget>

The widget itself is a simplified version of the Preferences Widget introduced in a later chapter. Implementation details are discussed in more depth later, as this widget shares the same underlying mechanism but operates with a reduced feature set. It applies filter configurations by adding classes to the document body, based on bookmarklets developed in the previous P7 iteration. @p7-debugging

While the simplified Developer Widget modifies the document state through direct class mapping, the more advanced architecture of the full Preferences Widget, detailed in @preferences-widget-section, manages these settings globally by dynamically binding values to CSS custom properties on the root element.

The implementation of the Developer Widget, alongside an example page containing various content types, is available in the project’s repository. @p8-developer-widget

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

=== Interactive Ishihara Plate

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
