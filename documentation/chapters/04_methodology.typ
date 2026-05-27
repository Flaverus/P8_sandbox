= Methodology

== Research and Ideation

This project initially started in a different direction by exploring how accessibility can be tested in an automated manner. During this research phase, a wide range of accessibility testing tools was examined, including both free and commercial solutions. One particularly influential source was the blog of Karl Groves, which states that only around 30–40% of accessibility issues can be reliably detected through automated testing @karl-groves. Although the original article was published in 2012, it received updates in late 2025. While automated accessibility testing has improved since the article was first written, the research process gradually shifted the focus of this project into another direction.

During this phase, additional ideas emerged regarding accessibility support beyond testing itself. Instead of focusing exclusively on automated evaluation, the project evolved toward exploring ways to enhance browser standards and provide additional accessibility aids directly within web applications. Since accessibility testing is already heavily researched and commercially established, this alternative direction appeared more valuable and interesting for further exploration.

After redefining the project goals, an exploratory prototyping approach was chosen to rapidly test and refine ideas over time. Existing standards, emerging browser capabilities, and newly introduced CSS and JavaScript features were researched to build a broad overview of current possibilities.

Browser support and compatibility were considered throughout the process to better understand both practical limitations and future opportunities. Experimental features and unconventional approaches were intentionally included where appropriate to avoid building solutions solely around already outdated technologies and standards.

== Prototyping

The first practical step was creating an isolated environment, referred to as the Sandbox project, for rapid prototyping and experimentation. This environment allowed different implementation approaches to be tested incrementally while evolving the individual project parts over time.

Testing CSS and JavaScript compatibility directly in practice proved especially important, as documentation alone often did not fully reflect actual browser behavior. Experimentation and playful exploration became a major part of the ideation process before more concrete concepts gradually emerged and were refined into the implementations presented throughout this documentation.

Many examples initially started as simple or partially hacky drafts before being iteratively improved into more stable and reusable solutions.

== Mathematical Foundation

To develop a deeper understanding of the current WCAG 2.x contrast standard, the W3C documentation regarding relative luminance and RGB color calculations was studied extensively. This research helped clarify the mathematical relationship between RGB color values, luminance calculation, and contrast ratios.

The resulting understanding made it possible to formalize the algorithmic approach described in the specification into a clearer mathematical representation. This later enabled the implementation of a contrast ratio indicator that was used within the custom contrast color function example application.

This process also motivated further research into the future WCAG 3.0 contrast model. The WCAG 2.x documentation itself acknowledges known limitations in the current contrast formula, including simplifications, rounding inaccuracies, and shortcomings regarding human visual perception. During this research, the APCA model was identified as a promising future replacement. However, because APCA is still under active development and currently remains in draft status, it was not integrated further into the practical implementations of this project.

== Validation and Verification

The Preferences Widget underwent smaller-scale user testing to gather feedback from real users and refine the interface for future integration into Kolibri. The tests were intentionally kept simple to allow participation from users with different backgrounds and experience levels. The primary focus was usability, keyboard accessibility, intuitiveness, and the overall visual experience.

The different example applications and prototype pages were additionally validated using automated accessibility testing tools such as the axe DevTools browser extension and Google Lighthouse. These automated checks were supplemented with manual keyboard accessibility testing to verify practical usability beyond purely automated evaluation.

#pagebreak()