# Montage

> **PROPRIETARY & CONFIDENTIAL**
> 
> © 2026 Zunaira Mughal. All rights reserved. Unauthorized cloning, distribution, or usage of this repository is strictly prohibited.

**Financial discipline, refined.**

Montage is a personal finance management application built with Flutter. It helps users track income and expenses, visualize spending patterns, attach receipts to transactions, and manage their financial goals — all wrapped in a polished, dark-themed glassmorphic interface.

---

## Features

### Transaction Management
- **Intelligent Expression Pad**: Native keypad with real-time mathematical expression evaluation for rapid entry.
- **Swipe-to-Action**: Intuitive swipe gestures (Delete/Edit) on both Home and History lists for a fluid, native experience.
- **Batch Selection**: Effortlessly select multiple transactions for bulk actions (Delete/Export) without workflow interruption.
- **Soft Delete & History**: A robust "safety-net" system allowing users to manage deleted records and restore them with a single tap.
- **Category CRUD**: Full Create, Read, Update, and Delete support for user-defined categories with curated iconography.
- **Predictive Category Fallback**: Intelligently updates transaction references when custom categories are modified or removed.
- **Selective Data Exporting**: Generate beautifully formatted PDF or CSV reports for specific intervals or selected transactions.
- **Smart Dictation**: Multi-lingual speech-to-text (English & Urdu) for transaction titles and custom category creation.
- **Media Attachments**: Capture and attach receipts via camera/gallery with high-res zooming and native gallery persistence.

### Dashboard & Analytics
- **AI-Powered Insights**: Personalized financial mentoring using Google Generative AI to analyze spending patterns.
- **Glassmorphic Financial Hub**: Real-time balance summaries and recent activities wrapped in a premium dark-mode aesthetic.
- **Interactive Data Visualization**: Dynamic pie charts and trend bars for deep-dive category breakdowns and weekly comparisons.
- **Skeleton Loading Architecture**: Flicker-free placeholder animations for smooth initial data fetches.

### Security & UX
- **Per-User Isolation**: Independent data storage boxes and Firebase record isolation for complete privacy.
- **Haptic Ecosystem**: Tactile physical feedback for keypad entry, tab transitions, and primary destructive actions.
- **Network Resilience**: Comprehensive image caching using `CachedNetworkImage` for high-performance offline visuals.
- **Interactive Navigation**: Intelligent back-button routing and animated page transitions with sleek line indicators.

---

## Tech Stack

| Layer              | Technology                                                                 |
|--------------------|---------------------------------------------------------------------------|
| Framework          | [Flutter](https://flutter.dev/) (Dart 3+)                                 |
| State Management   | [Provider](https://pub.dev/packages/provider) (MVVM Pattern)              |
| Local Storage      | [Hive](https://pub.dev/packages/hive) (NoSQL)                             |
| Cloud Services     | [Firebase](https://firebase.google.com/) (Auth, Firestore, Storage)       |
| AI Engine          | [Google Generative AI](https://pub.dev/packages/google_generative_ai)     |
| Charts             | [FL Chart](https://pub.dev/packages/fl_chart)                             |
| Routing            | [GoRouter](https://pub.dev/packages/go_router)                            |
| Network Images     | [Cached Network Image](https://pub.dev/packages/cached_network_image)     |
| Haptics            | [Haptic Helper](https://pub.dev/packages/services) (Native Feedback)      |
| Speech Recognition | [Speech to Text](https://pub.dev/packages/speech_to_text) (Urdu/English)   |
| Animations         | [Flutter Animate](https://pub.dev/packages/flutter_animate)               |

---

## Project Structure

```
lib/
├── config/              # Centralized GoRouter and app-wide configurations
├── core/
│   ├── constants/       # Design tokens (Colors, Shadows, Asset keys)
│   ├── themes/          # Glassmorphic system, Typography (Nunito), extensions
│   ├── interfaces/      # Abstract contracts for Repositories and Services
│   └── utils/           # Business helpers (Haptics, UI mappings, Validators)
├── models/              # Type-safe Hive data models and adapters
├── providers/           # Shared state management (Auth, Settings, Categories)
├── repositories/        # Data access layer (Hive + Firestore synchronization)
├── screens/             # Declarative UI views (Home, Analytics, History, etc.)
├── services/            # Low-level infrastructure (AI, Database, Sync)
├── viewmodels/          # Presentation logic and UI state machines
└── widgets/             # Reusable UI components (Shared, Transaction, Analytics)
```

---

---

*Built by Zunaira Mughal*
