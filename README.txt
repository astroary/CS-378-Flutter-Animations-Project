# 📱 Flutter Animation Showcase

A Flutter project demonstrating the implementation of both Implicit and Explicit animations. This project explores the distinction between animations that require a controller for complex logic versus those that are handled automatically by the framework.

## 🎞️ Animation Details

I have implemented 6 distinct animations, each contained in its own dedicated file with headers explaining the logic used to categorize them based on course standards.

### 🔄 Explicit Animations (Continuous)
These animations utilize an `AnimationController` to loop indefinitely:
* **Bouncing UCL Ball**: Uses a bounce curve and controller to simulate continuous motion.
* **Barca Logo Flip**: Rotates 180° along the Y-axis to create a mirroring effect that repeats forever.
* **360° Text Rotation**: A continuous circular rotation of text elements.

### ⚡ Implicit Animations (Triggered)
These animations are built using Flutter’s `Animated` widgets and trigger based on state changes:
* **Enlarging/Shrinking Image**: Scales the image size up or down based on user interaction.
* **Multi-Color Background**: A smooth transition between different background colors.
* **Moving Ramen Icon**: An icon that moves between corners of a square container sequentially.

## 🛠️ Technical Implementation
* **Implicit Logic**: Determined by animations that stop once they reach their target value and are managed by the widget's internal state.
* **Explicit Logic**: Determined by animations that require manual control (like looping forever) using `addListener` or `AnimationStatus`.

## 👥 Author
* **Aryansingh Chauhan** (astroary)

---
**Course:** CS 378, Fall 2024  
**Instructor:** Prof. Ugo Buy
** University of Illinois Chicago