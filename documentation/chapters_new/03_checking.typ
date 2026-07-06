= Checking Existing Applications

The first part sets it's focus on existing webapplications. It introduces important concepts regarding contrast perception, what the current standard is and in what direction it is currentli evolving. Based on this tools are introducted which were created during this project, allowing to calculate the WCAG 2.x based contrast ratio of two colors regarding relative luminance. Additionally a Developer Widget, allowing to simulate different vision impairments, allowing to inspect websides with these simulations to check the current state of a website regarding contrast and enabling to improve on detected issues or weaknesses.

== Prototyping

The first practical step was creating an isolated environment, referred to as the Sandbox project, for rapid prototyping and experimentation. This environment allowed different implementation approaches to be tested incrementally while evolving the individual project parts over time.

Testing CSS and JavaScript compatibility directly in practice proved especially important, as documentation alone often did not fully reflect actual browser behavior. Experimentation and playful exploration became a major part of the ideation process before more concrete concepts gradually emerged and were refined into the implementations presented throughout this documentation.

Many examples initially started as simple or partially hacky drafts before being iteratively improved into more stable and reusable solutions.

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

== Checking Color Contrasts

The WCAG contrast ratio requirements are precisely defined but they can not be guessed by simply looking at two colors. Therfore addisional tools are needed to check if the requirements are fulfilled wor two colors. This is where the Color Contrast Checker, shown in @contrast-checker, comes into play. This tool allows to select two colors and calculates the contrast ratio so verify if a color combination can be considered when building a webapplication or if alternative colors should be taken to provide sufficient contrast.

#figure(
  box(
    inset: 12pt,
    radius: 6pt,
    clip: true,
    stroke: 0.5pt + rgb("#cbd5e1"),
  {
    image("../ressources/contrast-checker.png", width: 100%)
  }),
  caption: [A screenshot of the color contrast checker that calculates the ratio of two selected colors.],
) <contrast-checker>

The implementation of the color contrast checker is available in the project’s repository. @p8-color-contrast-checker

== Developer Widget

Whilst having a design that has colors coordinated with each other is important, it is also important to consider the whole picture. It is important that all individual elements incorporatet into a webpage harmonize with each other. The Developer Widget shown in @developer-widget is intended to visually check how a website as a whole looks with certain vision impairments. This widget in its current state allows to simulate common color blindeness types in combination with blurry vision but can be extended to any degree needed.

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

The widget itself is a simplified version of the Preferences Widget that is introduced in the chapter afterwasrds. The implementation details are discussed later in more detail as this widget is the same but reduced in its features and functionality. It is simply adding classes to the body which apply different filters which are based on the bookmarklets developed in the previous P7. @p7-debugging

The implementation of the developer widget, alongside an example page with varoius contents, is available in the project’s repository. @p8-developer-widget

#pagebreak()