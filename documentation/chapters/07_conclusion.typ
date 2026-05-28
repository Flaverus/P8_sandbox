= Conclusions

Improving accessibility and usability for a diverse group of users does not necessarily require large or complex solutions. This project demonstrates that existing web standards can already be extended with relatively little implementation effort to provide a more user-centric and customizable experience for how web content is presented.

The Preferences Widget in particular shows how native browser capabilities and CSS custom properties can be combined to create flexible accessibility configurations on a website-specific level. At the same time, this approach introduces an important challenge. The more configuration options become available, the more visual combinations and states must be considered, implemented, and tested. Combining multiple accessibility preferences quickly results in a large number of possible variations. This complexity represents the biggest limitation of such an approach and makes it difficult to realistically cover every possible combination. In practice, implementations therefore need to focus on the settings that provide the greatest benefit for the broadest group of users.

== Limitations

The scope of this project was limited and therefore no large-scale user testing was conducted to quantitatively validate the assumptions and implementations presented throughout this documentation. In addition, perceived contrast remains partially subjective. While contrast calculations and perceptual models can improve accessibility for many users, no universal solution exists that guarantees optimal readability and visual comfort for everyone.

APCA represents a significant improvement over the current relative luminance approach used in WCAG 2.x because it considers perceptual aspects such as text size, font weight, and surrounding context. However, the underlying theory and calculations are considerably more complex than the current WCAG 2.x model. Furthermore, APCA is still under active development and has not yet been finalized or officially established as a web standard. As a result, it is still too early to draw definitive conclusions regarding its long-term adoption and practical impact.

== Future Work

In its current form, the Preferences Widget cannot yet be integrated directly into the Kolibri Web UI toolkit. Although this was not an official part of the project scope, the widget will undergo additional user testing to evaluate its usability and effectiveness before being further refined into a draft proposal for integration into Kolibri.

The example application for the custom contrast color function could also be extended with APCA support in the future. This would make it possible to evaluate not only WCAG 2.x contrast requirements but also the future WCAG 3.0 perceptual contrast model once the specification becomes finalized and publicly established.

Another valuable next step would be conducting a survey focused on identifying the most important accessibility customization needs users expect from modern websites. Such research could help determine which configuration options provide the greatest practical value for the initial implementation of the Preferences Widget and which accessibility preferences are most relevant in everyday web usage.

#pagebreak()