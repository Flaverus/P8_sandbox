// Use LaTeX style font
#set text(font: "New Computer Modern", size: 12pt)
// Heading hierarchy with decimal
#set heading(numbering: "1.1.")

// Page Layout
#set page(
  paper: "a4",
  margin: (x: 2.5cm, y: 3cm),
)

// --- Cover Page ---
#align(center)[
  #grid(
    columns: (1fr),
    gutter: 1em,
    [#text(size: 14pt, weight: "bold")[University of Applied Sciences and Arts Northwestern Switzerland]],
    [#text(size: 12pt)[School of Computer Science]],
    [#text(size: 12pt)[Institute for Mobile and Distributed Systems (IMVS)]]
  )

  #v(4cm)

  #text(size: 14pt, weight: "semibold")[Master of Science in Engineering (MSE)]
  #v(0.5cm)
  #text(size: 16pt, weight: "bold")[Project P8]

  #v(1.5cm)

  #line(length: 100%)
  #v(0.5cm)
  #text(size: 22pt, weight: "bold")[
    Enhancing Web Accessibility Standards
  ]
  #v(0.2cm)
  #text(size: 16pt, style: "italic", fill: gray.darken(50%))[
    Implementation of User-Centric Customization Interfaces and CSS-based Contrast Optimization
  ]
  #v(0.5cm)
  #line(length: 100%)

  #v(3cm)

  #grid(
    columns: (150pt, 1fr),
    row-gutter: 1.5em,
    align: (left, left),
    [*Author:*], [#text(weight: "bold")[Florian Schnidrig]],
    [*Advisor:*], [Prof. Dierk König],
    [*Profile:*], [Computer Science],
    [*Date:*], [Summer 2026 (TBD)]
  )
]
#pagebreak()

// Start Page Numbering after Coverpage (Roman numbering for Table of Contents)
#set page(numbering: "i")
#counter(page).update(1)

// --- Table of Contents ---
#outline(indent: auto)

// Regular arabic Numbering for the main contents
#pagebreak()
#set page(numbering: "1")
#counter(page).update(1)

// --- Chapters ---
#include "chapters/01_abstract.typ"
#include "chapters/02_introduction.typ"
#include "chapters/03_theory.typ"
#include "chapters/04_results.typ"
#include "chapters/05_discussion.typ"
#include "chapters/06_conclusion.typ"


// --- Appendix ---
// Bibliography usually isn't numbered
#set heading(numbering: none)
#bibliography("references.bib", style: "ieee", title: "Bibliography")

#pagebreak()
#outline(
  title: "List of Figures",
  target: figure.where(kind: image),
)