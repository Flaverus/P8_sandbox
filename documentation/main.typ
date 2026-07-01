// Use LaTeX style font
#set text(font: "New Computer Modern", size: 12pt)
// Heading hierarchy with decimal
#set heading(numbering: "1.1.")

// Page Layout
#set page(
  paper: "a4",
  margin: (x: 2.5cm, y: 3cm),
)

#show link: underline

// Code Styling
#show raw: set text(font: "Roboto Mono", size: 10pt)

// Inline Code (using box instead of highlight for better padding control)
#show raw.where(block: false): it => box(
  fill: rgb("#f8fafc"),
  stroke: 0.5pt + rgb("#cbd5e1"),
  radius: 2pt,
  inset: (x: 2pt),
  outset: (y: 2pt),
  text(size: 10pt, weight: "medium", font: "Roboto Mono", it)
)

// Block Code
#show raw.where(block: true): it => {
  block(
    fill: rgb("#f8fafc"),
    inset: 12pt,
    radius: 6pt,
    width: 100%,
    stroke: 0.5pt + rgb("#cbd5e1"),
    it,
  )
}

// Figure
#show figure.caption: emph
#show figure: set block(above: 28pt, below: 28pt)

// --- Cover Page ---
#align(center)[
  #grid(
    columns: (1fr),
    gutter: 1em,
    [#text(size: 14pt, weight: "bold")[University of Applied Sciences and Arts \ Northwestern Switzerland]],
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
#include "chapters/04_methodology.typ"
#include "chapters/05_results.typ"
#include "chapters/06_discussion.typ"
#include "chapters/07_conclusion.typ"


// --- Appendix ---
// Bibliography usually isn't numbered
#set heading(numbering: none)
#bibliography("references.bib", style: "ieee", title: "Bibliography")

#pagebreak()
= List of Figures
#outline(
  title: none,
  target: figure.where(kind: image),
)

#pagebreak()
= List of Listings
#outline(
  title: none,
  target: figure.where(kind: raw),
)

#pagebreak()
= List of Aids

== Artificial Intelligence and Language Models

#v(2em)

*Tool: ChatGPT (OpenAI), Version GPT-5.5.*

*Type of Usage*: Used for linguistic refinement of drafts and improvement of readability and text flow.

*Extent*: Specific sections of the documentation were refined using the tool to improve wording, transitions, and overall readability. The original content, technical facts, code, and project structure remained author-created and were manually verified for accuracy.

#v(2em)

*Tool: Gemini (Google), Version 3 Flash.*

*Type of Usage*: Used for linguistic refinement of drafts and formating mathematical formulas (Relative Luminance).

*Extent*: Specific paragraphs regarding WCAG luminance calculations were refined using the tool. All technical facts and code were manually verified for accuracy.

#v(2em)

*Tool: Gemini (Google), Version 3 Flash.*

*Type of Usage*: Used for graphic editing and uniform styling of figures.

*Extent*: The backgrounds of the three-dimensional color model illustrations were mechanically modified to a uniform white color for visual consistency. The original geometric structures, annotations, and colors remained completely unaltered.

#pagebreak()
= MSE-Declaration of Originality

The project reports (P7 and P8) and the master's thesis (P9) must be accompanied by the following declaration of originality and signed:

I hereby declare that any individual work submitted for assessment is entirely the product of my own effort:

- That I have correctly cited all text passages that do not originate from me, in accordance with standard academic citation rules (e.g., APA or IEEE), and that I have clearly mentioned all sources used;
- That I have declared in footnotes or in an "List of Aids" all aids used (AI assistance systems such as chatbots [e.g., ChatGPT], translation [e.g., DeepL], paraphrasing [e.g., QuillBot]) or programming applications [e.g., GitHub Copilot] and indicated their use at the corresponding text passages;
- That I have acquired all intangible rights to any materials I may have used, such as images or graphics, or that these materials were created by me;
- That the topic, the thesis, or parts of it have not been used in an assessment of another module, unless this has been expressly agreed with the lecturer in advance and is stated as such;
- That I am aware that my work may be checked for plagiarism and for third-party authorship of human or technical origin (artificial intelligence);
- That I am aware that the University of Applied Sciences and Arts Northwestern Switzerland FHNW will pursue a violation of this declaration of authenticity and that disciplinary consequences (reprimand or expulsion from the study program) may result from this.

#v(2cm)

#grid(
  columns: (1fr, 1fr),
  gutter: 2cm,
  [
    Windisch, #box(width: 60%, line(length: 100%, stroke: 0.5pt + gray)) \
    #text(size: 9pt, fill: gray)[Location / Date]
  ],
  [
    Florian Schnidrig \
    #text(size: 9pt, fill: gray)[First Name / Surname]
  ]
)

#v(1.5cm)

#grid(
  columns: (1fr, 1fr),
  gutter: 2cm,
  [],
  [
    #line(length: 100%, stroke: 0.5pt + gray)
    #text(size: 9pt, fill: gray)[Signature]
  ]
)