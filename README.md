# 🌟  E-Commerce Flutter App

[![License](https://img.shields.io/badge/license-MIT-007ec6.svg)](./LICENSE)
[![Flutter](https://img.shields.io/badge/Flutter-%5E3.0-blue?logo=flutter)](https://flutter.dev)
[![Issues](https://img.shields.io/github/issues/Tanvir284/E-Commerce-app)](https://github.com/Tanvir284/E-Commerce-app/issues)
[![Open in Gitpod](https://img.shields.io/badge/Open%20in-Gitpod-04BE2A?logo=gitpod)](https://gitpod.io/#https://github.com/Tanvir284/E-Commerce-app)



Table of contents
- Features
- Demo
- Quick start
- Development
- Project structure
- Contributing
- Roadmap
- License

----

Why this project?

This is a minimal modern e-commerce Flutter app focused on Phase 1 recruiter-facing features and local persistence (wishlist and cart). It’s designed to be simple to run, easy to extend, and pleasant to explore.

Features (Phase 1)
- ⭐ Wishlist with local persistence (shared_preferences)
- 🛒 Persistent cart (saved locally)
- 🖼️ Product image carousel on product details
- 💖 Wishlist screen and wishlist toggle from product cards

Demo

<center>

![Demo GIF](https://raw.githubusercontent.com/Tanvir284/E-Commerce-app/main/.github/demo.gif)

</center>

If the demo GIF does not load, run locally or open the repo in Gitpod (click the badge at the top) to see the app running instantly in a cloud workspace.

Quick start

1. flutter pub get
2. flutter run

Optional: Run instantly in the cloud

- Click the "Open in Gitpod" badge above (or visit: https://gitpod.io/#https://github.com/Tanvir284/E-Commerce-app) to launch a ready-to-code environment. Gitpod will install Flutter and dependencies so you can run the app in a browser-based IDE.

Development

- Flutter SDK (stable channel) recommended
- Uses shared_preferences for local persistence

Environment

- Flutter: see flutter.dev for installation
- Device/emulator or Gitpod

Project structure (short)
- lib/
  - main.dart — app entry
  - models/ — data models (product, cart, wishlist)
  - screens/ — UI screens (home, product details, wishlist)
  - widgets/ — reusable UI components (product card, carousel)
- assets/ — images and demo GIFs

Contributing

Contributions, issues, and feature requests are welcome. Please open an issue first for significant changes. For small fixes, open a PR and reference the issue.

Guidelines
- Keep changes focused and documented
- Add or update tests where appropriate
- Follow existing code style (Dart/Flutter conventions)

Roadmap (Phase 2 planned)
- Firestore synchronization for wishlist and cart
- Social sign-ins (Google, Facebook)
- Improved product search, filtering, and categories
- Add screenshots and a detailed setup guide for Firebase

License

MIT — add a LICENSE file at the repo root if you want the MIT badge to link correctly.

Contact

Maintainer: @Tanvir284

----

Notes
- If you want, I can add actual screenshots and a demo GIF into .github/, add GitHub Actions to generate the demo automatically, or prepare a short Firebase setup guide for Phase 2. I can push those updates next.
