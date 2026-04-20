# Montage

**Financial discipline, refined.**

Montage is a personal finance management application built with Flutter. It helps users track income and expenses, visualize spending patterns, attach receipts to transactions, and manage their financial goals — all wrapped in a polished, dark-themed glassmorphic interface.

---

## Features

### Transaction Management
- Choose from predefined categories or create and manage **custom ones**.
- **Category CRUD**: Full Create, Read, Update, and Delete support for user-defined categories.
- **Icon Customization**: Select from a curated list of icons for personalized category tracking.
- **Cloud Sync**: Automatic background synchronization between local Hive storage and Firebase Firestore.
- **Predictive Selection**: Intelligently updates transaction category references when custom categories are edited or deleted (auto-fallback to 'Other').
- Toggle between income and expense views with optimized **swipe gestures**.
- **Smart Dictation**: Multi-lingual speech-to-text (English & Urdu) for transaction notes, titles, and **custom category creation**.
- Attach photos (camera or gallery) as receipts or proof of purchase.
- View attached images in a full-screen viewer with pinch-to-zoom.
- Save attached images directly to the device gallery.

### Dashboard
- At-a-glance balance summary showing total income, total expenses, and net balance.
- Recent transactions list with category icons and amount formatting.
- AI-powered spending insights card using Google Generative AI.
- Greeting header with the user's first name and profile photo.
- **Skeleton Loading States**: Smooth, flicker-free placeholder animations during initial network fetches or database loads.

### Analytics
- **Category Breakdown**: Interactive pie chart showing expense distribution by category.
- **Weekly Trends**: Bar chart comparing income vs. expenses over the past week.
- **Daily Breakdown**: Itemized daily spending list for the selected period.

### Profile & Settings
- Edit display name inline with instant sync across all screens.
- Change or remove profile photo via the device camera or gallery.
- Toggle notification preferences.
- Switch between supported currencies (PKR, USD, EUR, GBP, etc.).
- **Financial Exports**: Generate and download beautifully formatted PDF reports and CSV spreadsheets of all your transaction history.
- **logout Confirmation Flows**: Professional, glassmorphic confirmation sheets for critical actions like signing out.
- Sign out with full session cleanup and confirmation.

### Authentication
- Email/password sign-in and sign-up powered by Firebase Authentication.
- **Reliable Error Handling**: Real-time, field-level validation with custom error mapping for authenticating Firebase responses into human-readable messages.
- **Independent Form State**: Separate data persistence for Sign In and Sign Up screens, allowing users to switch between authentication modes without losing their typed progress.
- Onboarding screen for first-time users.
- Per-user data isolation — each account has its own private Hive storage box.

### Navigation & UX
- Bottom navigation with four tabs: Home, Analytics, Activity, and Settings.
- Intelligent back-button handling: pressing back from any tab returns to Home first.
- Consistent bottom-sheet interactions for all secondary actions (transaction details, editing, media picking, profile options).
- **Data-Ready Startup**: A "Bulletproof" splash screen that polls for both authentication status and database readiness, ensuring a flicker-free transition once the home screen appears.
- Haptic feedback on key interactions.
- **Interactive Animations**: Smooth page transitions, micro-animations, and animated line indicators for enhanced navigation feedback.
- **Stable UI Engineering**: Fixed-height input validation area prevents screen layout shifts or "jumping" when errors are displayed.
- **Iconography**: Unified, professional iconography powered by **Font Awesome**.

---

## Tech Stack

| Layer              | Technology                                                                 |
|--------------------|---------------------------------------------------------------------------|
| Framework          | [Flutter](https://flutter.dev/) (Dart)                                    |
| State Management   | [Provider](https://pub.dev/packages/provider)                             |
| Local Storage      | [Hive](https://pub.dev/packages/hive)                                     |
| Cloud Database    | [Cloud Firestore](https://firebase.google.com/docs/firestore)             |
| Authentication     | [Firebase Auth](https://firebase.google.com/docs/auth)                    |
| AI Insights        | [Google Generative AI](https://pub.dev/packages/google_generative_ai)     |
| Charts             | [FL Chart](https://pub.dev/packages/fl_chart)                             |
| Routing            | [GoRouter](https://pub.dev/packages/go_router)                            |
| Image Handling     | [image_picker](https://pub.dev/packages/image_picker), [gal](https://pub.dev/packages/gal) |
| Typography         | [Google Fonts](https://pub.dev/packages/google_fonts) (Nunito)            |
| Speech Recognition | [speech_to_text](https://pub.dev/packages/speech_to_text)                 |
| Animations         | [flutter_animate](https://pub.dev/packages/flutter_animate)               |
| SVG Rendering      | [flutter_svg](https://pub.dev/packages/flutter_svg)                       |
| Icons              | [font_awesome_flutter](https://pub.dev/packages/font_awesome_flutter)     |

---

## Project Structure

```
lib/
├── config/              # App router configuration
├── core/
│   ├── constants/       # Colors, image asset paths
│   ├── themes/          # App theme, text styles, extensions
│   └── utils/           # Formatters, validators, category utils, animation helpers
├── models/              # Hive data models (Transaction, SpendingSummary, Trends)
├── providers/           # State management (Auth, Transactions, UserSettings)
├── screens/             # All app screens (12 total)
├── services/            # Business logic (Auth, Database, Finance, AI)
├── viewmodels/          # Presentation logic (TransactionForm, ImageView)
└── widgets/             # Reusable UI components (25+)
    ├── analytics/       # Chart widgets
    └── transaction/     # Transaction-specific sheets and list items
```

---

## Getting Started

### Prerequisites
- Flutter SDK (stable channel, Dart ≥ 3.8.1)
- Android Studio or VS Code
- A configured Firebase project

### Setup

```bash
# Clone the repository
git clone https://github.com/ZunairaMughal24/PersonaL_finance_tracker.git

# Install dependencies
flutter pub get

# Generate Hive adapters
dart run build_runner build --delete-conflicting-outputs

# Run the app
flutter run
```

### Firebase Configuration
Place your `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) in the appropriate platform directories. Refer to the [FlutterFire setup guide](https://firebase.google.com/docs/flutter/setup) for details.

---

## Design Philosophy

Montage follows a **refined 3D container aesthetic** with subtle shadows, frosted glass effects, and elegant border treatments. Moving beyond traditional Neumorphism, the app now utilizes a custom `AppContainer` system that provides depth and hierarchy through soft, layered shadows and curated gradients. 

All interactive surfaces share a unified visual language — from the professional Font Awesome iconography to the animated line indicators. Business logic is strictly separated from UI, ensuring that screens remain thin while delegating complex state management to Providers, ViewModels, and Services.

---

## License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.

---

*Built by Zunaira Mughal*
