= Abstract

This project explores native CSS and JavaScript features related to accessibility concerns, discusses the theory behind contrast perception in WCAG 2.x, and introduces the new perceptual approach proposed in the current WCAG 3.0 working draft. In addition, it examines patterns and techniques such as global state management with CSS custom properties, CSS attribute selectors, and experimental at-rules that can be used to create more individualized and accessible user experiences.

The accompanying repository contains interactive example pages and code snippets for all implementations discussed in this documentation and additional experiments. These examples allow the presented functionality to be explored in a practical and interactive way. The repository also includes this documentation both as Typst source code and as a rendered PDF: #link("https://github.com/Flaverus/P8_sandbox/tree/main")

The three main tools developed during this project are:

- A user-centric Preferences Widget that enables persistent website-specific accessibility settings beyond native operating system restrictions.
- A Custom Contrast Color Function based on the OkLCH color space that softens harsh contrast through perceptual color mixing.
- An Interactive Ishihara Plate generator designed as a developer tool for evaluating color combinations and simulating color vision deficiencies such as ``` Protanopia```, ``` Deuteranopia```, and ``` Tritanopia```.

This project demonstrates that modern web standards already provide the foundation for highly personalized and perceptually aware accessibility solutions without requiring large external frameworks or overly complex configurations.

= Acknowledgement

#pagebreak()