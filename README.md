# Modern E-Commerce Flutter App — Phase 1

A minimal, modern e-commerce Flutter application implementing Phase 1 recruiter-facing features and local persistence for wishlist and cart state.

Key features (Phase 1)
- Wishlist with local persistence (shared_preferences)
- Persistent cart (saved locally)
- Product image carousel on product details
- Wishlist screen and wishlist toggle from product cards

Tech stack
- Flutter
- Dart
- shared_preferences for local persistence

Requirements
- Flutter SDK (stable channel)
- A device or emulator to run the app

Quick start
1. flutter pub get
2. flutter run

Optional: Firebase (Phase 2)
- The app currently works fully with local persistence and does not require Firebase.
- In Phase 2 I plan to add Firestore sync and social sign-ins (Google, Facebook) — Firebase configuration will be documented then.

Contributing
- PRs, issues, and suggestions are welcome. Please open an issue to discuss larger changes before submitting a PR.

Future work (Phase 2)
- Firestore synchronization for wishlist and cart
- Social sign-ins (Google, Facebook)
- Improved product search and filtering

License
- MIT License (add LICENSE file if desired)
