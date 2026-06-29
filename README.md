# Enhancing Web Accessibility Standards
### Implementation of User-Centric Customization Interfaces and CSS-based Contrast Optimization

---

## Project Overview
This repository contains the source code, interactive examples, and full documentation for **P8** (Preparation Project for Master Thesis), developed as part of the **MSE (Master of Science in Engineering)** program at the **University of Applied Sciences and Arts Northwestern Switzerland (FHNW)**, School of Computer Science, Institute for Mobile and Distributed Systems (IMVS).

* **Advisor:** [Prof. Dierk König](https://www.fhnw.ch/de/informatik/ueber-uns/portrait-organisation/personen/dierk-koenig)
* **Documentation (PDF):** [`documentation/main.pdf`](https://github.com/Flaverus/P8_sandbox/blob/main/documentation/main.pdf)

---
## Abstract
This project explores native CSS and JavaScript features related to accessibility concerns, discusses the theory behind contrast perception in WCAG 2.x, and introduces the new perceptual approach proposed in the current WCAG 3.0 working draft. In addition, it examines patterns and techniques such as global state management with CSS custom properties, CSS attribute selectors, and experimental at-rules that can be used to create more individualized and accessible user experiences.

The accompanying repository contains interactive example pages and code snippets for all implementations discussed in this documentation and additional experiments. This project demonstrates that modern web standards already provide the foundation for highly personalized and perceptually aware accessibility solutions without requiring large external frameworks or overly complex configurations.

---
## Repository Structure & Quick Links

* **[`index.html`](index.html):** The [Overview Page](https://github.com/Flaverus/P8_sandbox/blob/main/index.html) that links all individual example pages and experiments together.
* **[`examples/`](examples/):** Interactive implementation sandboxes including:
  * `contrast-color/` — CSS function to calculate contrast colors.
  * `ishihara/` — Interactive Ishihara plate CVD simulator.
  * `widget/` — Accessibility preference widgets.
  * `theme-switch/` — Theme switch example based on braking CSS custom properties intentionally.
  * `drag-and-drop/` — Keyboard accessible drag and drop idea.
* **[`documentation/`](documentation/):** Full documentation containing theoretical background and implementation. Available as [Typst source files](documentation/) and rendered [PDF output](documentation/main.pdf).

---
## Getting Started
To view the examples locally, simply clone the repository and open `index.html` in any modern web browser.
