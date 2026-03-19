# MONTAGE — Premium Personal Finance Tracker

MONTAGE is a sophisticated, glassmorphic personal finance management application built with Flutter. It combines a premium dark-themed UI with powerful tracking features and real-time data synchronization to provide a seamless financial management experience.

## ✨ Features

- **Premium Glassmorphic UI**: High-end dark mode interface with subtle blurs, gradients, and micro-animations.
- **Real-Time Profile Sync**: Immediate synchronization of user profile data (name, email, photo) across all screens.
- **Smart Analytics**: 
  - **Spending Categories**: Interactive pie chart breakdown of your expenses.
  - **Financial Trends**: Weekly income vs. expense bar charts and daily breakdown lists.
- **Secure Authentication**: Built-in sign-in and sign-up flows powered by Firebase.
- **Data Isolation**: Multi-account support with separate storage boxes for each user ensuring data privacy.
- **Advanced Transaction Editing**: Quick edit dialogs with category pre-filling and custom category support.
- **Multi-Currency Support**: Flexible currency settings for international use.

## 🛠️ Tech Stack

- **Framework**: [Flutter](https://flutter.dev/)
- **State Management**: [Provider](https://pub.dev/packages/provider)
- **Local Database**: [Hive](https://pub.dev/packages/hive) (for high-performance local storage)
- **Backend**: [Firebase Auth](https://firebase.google.com/docs/auth)
- **Charts**: [FL Chart](https://pub.dev/packages/fl_chart)
- **Typography**: [Google Fonts (Nunito)](https://fonts.google.com/specimen/Nunito)

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (Latest Stable)
- Android Studio or VS Code
- Firebase Project (Configured for Flutter)

### Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/ZunairaMughal24/PersonaL_finance_tracker.git
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**:
   Follow the [FlutterFire](https://firebase.google.com/docs/flutter/setup) guide to set up your `firebase_options.dart`.

4. **Run the app**:
   ```bash
   flutter run
   ```

## 📂 Project Structure

- `lib/core`: Global constants, theme data (consolidated in `themes/`), and utility classes.
- `lib/models`: Hive-compatible data models.
- `lib/providers`: State management logic for transactions, auth, and user settings.
- `lib/screens`: Primary application views (Home, Analytics, Settings, Auth).
- `lib/widgets`: Reusable UI components from specialized chart widgets to glassmorphic containers.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---
*Built with ❤️ by Zunaira Mughal*
