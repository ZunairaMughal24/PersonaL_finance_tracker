# FinFlow — Personal Finance Tracker

**FinFlow** is a premium, AI-powered personal finance management application designed to give you complete control over your financial life. Built with Flutter, it combines a sleek, modern UI with powerful tracking and intelligent insights.

## ✨ Features

- **Intuitive Dashboard**: At-a-glance view of your total balance, monthly income, and expenses.
- **Smart Transactions**: Detailed transaction logging with category management and custom notes.
- **AI Financial Mentor**: No-nonsense financial advice and analysis powered by AI to help you save more and spend smarter.
- **Visual Analytics**: Interactive charts and trends to visualize your spending habits over time.
- **Premium UI/UX**: Dark mode by default, featuring glassmorphism effects, smooth animations, and high-quality typography.
- **Secure Storage**: Your data stays on your device using Hive's lightning-fast local storage.
- **Haptic Feedback**: Contextual haptics for critical actions and warnings.

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (v3.0.0 or higher)
- Dart SDK (v3.0.0 or higher)
- An iOS/Android Emulator or physical device

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/yourusername/finflow.git
   ```

2. **Navigate to the project directory:**
   ```bash
   cd finflow
   ```

3. **Install dependencies:**
   ```bash
   flutter pub get
   ```

4. **Run the app:**
   ```bash
   flutter run
   ```

## 🏗️ Technical Architecture

This project follows a clean, modular architecture:
- **Providers**: State management for user settings, transactions, and theme.
- **Services**: Abstracted logic for database (Hive), AI integration (Google Generative AI), and financial calculations.
- **Core**: Centralized constants, theme data, and utility functions.
- **Widgets**: Reusable, atomic UI components designed for high performance.

## 🛠️ Tech Stack

- **Framework**: [Flutter](https://flutter.dev)
- **State Management**: [Provider](https://pub.dev/packages/provider)
- **Database**: [Hive](https://pub.dev/packages/hive)
- **Navigation**: [GoRouter](https://pub.dev/packages/go_router)
- **AI Engine**: [Google Generative AI](https://pub.dev/packages/google_generative_ai)
- **Fonts**: [Google Fonts (Inter, Outfit)](https://pub.dev/packages/google_fonts)

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
