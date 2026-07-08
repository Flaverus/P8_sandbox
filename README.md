# Enhancing Web Accessibility Standards
### Implementation of User-Centric Customization Interfaces and CSS-based Contrast Optimization

---

## Project Overview
This repository contains the source code, interactive examples, and full documentation for **P8** (Preparation Project for Master Thesis), developed as part of the **MSE (Master of Science in Engineering)** program at the **University of Applied Sciences and Arts Northwestern Switzerland (FHNW)**, School of Computer Science, Institute for Mobile and Distributed Systems (IMVS).

* **Advisor:** [Prof. Dierk König](https://www.fhnw.ch/de/informatik/ueber-uns/portrait-organisation/personen/dierk-koenig)
* **Documentation (PDF):** [`documentation/main.pdf`](https://github.com/Flaverus/P8_sandbox/blob/main/documentation/main.pdf)

---
## Abstract
This project explores native CSS and JavaScript features to advance digital inclusion. It begins by focusing on Auditing Existing Applications, examining WCAG 2.x relative luminance and the perceptual contrast principles introduced by WCAG 3.0. Building on this foundation, a color contrast checker, a Developer Widget for simulating visual impairments, and an interactive Ishihara plate are introduced to support the evaluation of existing interfaces.

The focus then shifts to Guiding Developers During Construction by presenting practical CSS and JavaScript concepts alongside a custom contrast color function that dynamically softens harsh color combinations.

Finally, the project concludes with Empowering Users to Refine Their Experience, shifting control directly to users through a Preferences Widget that enables persistent, website-specific accessibility configurations.

---
## Repository Structure & Quick Links

* **[`index.html`](index.html):** The [Overview Page](https://github.com/Flaverus/P8_sandbox/blob/main/index.html) that links all individual example pages and experiments together.
* **[`examples/`](examples/):** Interactive implementation sandboxes including:
  * `contrast-checker/` — Contrast checker for two given colors.
  * `contrast-color/` — CSS function to calculate contrast colors.
  * `ishihara/` — Interactive Ishihara plate CVD simulator.
  * `widget/` — Accessibility preferences widget.
  * `developer-widget/` — Widget to simulate CVD on a whole webpage.
  * `theme-switch/` — Theme switch example based on braking CSS custom properties intentionally.
  * `drag-and-drop/` — Keyboard accessible drag and drop idea.
* **[`documentation/`](documentation/):** Full documentation containing theoretical background and implementation. Available as [Typst source files](documentation/) and rendered [PDF output](documentation/main.pdf).

---
## Getting Started
To view the examples locally, simply clone the repository and open `index.html` in any modern web browser.
