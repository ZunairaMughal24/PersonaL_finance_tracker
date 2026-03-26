# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.3.0] - 2026-03-26

### Added
- **Safe Auth Flow**: Implemented a professional, data-ready polling system in the splash screen to ensure user data is 100% loaded before the dashboard appears, eliminating all uninitialized state flickering.
- **Custom Category Voice Input**: Integrated multilingual (English & Urdu) speech-to-text into the custom category dialog.
- **Reusable Animation Library**: Extracted the green pulsing microphone indicator into a standalone `PulseEffect` widget for consistent feedback across the app.

### Improved
- **Robustness**: Added a 1.5-second "double-check" delay during auth initialization to perfectly handle slow Firebase session restorations.
- **Layout Stability**: Fixed keyboard-related overflow crashes in the custom category dialog by adding responsive scrolling support.

## [1.2.2] - 2026-03-26

### Added
- **Professional App Icon**: Updated the application identity with a new, sleek line-chart icon for a more financial-grade look.

### Improved
- **Smart Dictation UI**: Refined the speech-to-text interface to a minimalist, badge-free look with a green pulsing indicator.
- **NDK Build Stability**: Verified and ensured project compatibility with standard Android NDK versions for smoother compilation.

## [1.2.1] - 2026-03-26

### Added
- **Personal Information Screen**: Dedicated screen for viewing and editing user profile details with read-only email display.
- **Data-Ready Splash**: Splash screen now holds until all user data is loaded, eliminating the flash of uninitialized state.
- **Speech-to-Text Integration**: Multilingual (English & Urdu) voice typing for transaction notes and titles with a minimalist, green-pulse UI.

### Improved
- **Profile Edit Menu**: Dynamic "Add Photo" / "Change Photo" text based on photo state; "Remove Photo" hidden when no photo exists.
- **Email Overflow**: Long email addresses now truncate cleanly with ellipsis in the profile card.

## [1.2.0] - 2026-03-26

### Added
- **Transaction Media Attachments**: Enabled attaching high-resolution images/snapshots to financial records for better tracking.
- **Native Gallery Integration**: Implemented a robust image download system using the `gal` package for direct persistence to the device's photo gallery.
- **Premium Action Sheets**: Refactored transaction management into unified, glass-morphic bottom sheets, exactly mirroring the high-end profile menu aesthetic.

### Improved
- **Architectural Logic Separation**: Decoupled business logic from UI views in `ImageViewScreen` and `TransactionActionSheet` using dedicated ViewModels.
- **Navigation Intelligence**: Implemented a "Pop-to-Home" navigation pattern, ensuring the back button always returns to the primary dashboard for a more intuitive flow.
- **UI Consistency**: Refined the custom keypad and transaction list items with enhanced visual states and standardized iconography.

### Fixed
- **Sheet Layout Overflows**: Corrected layout constraints in action sheets to ensure perfect rendering across all devices, including those with notches.
- **State Management Synchronization**: Fixed intermittent lag in image badge refreshing on the transaction dashboard.

## [1.1.0] - 2026-03-20

### Added
- **First-Name Handle**: Implemented intelligent name extraction in `HomeHeader` to handle long usernames gracefully and prevent layout overflow.
- **Custom Category Pre-filling**: Added support for pre-filling the category name when editing transactions, improving the UX for custom labels.
- **Consolidated Theme System**: Unified the theme architecture into a single `lib/core/themes/` directory for better maintainability.

### Improved
- **Real-Time Profile Sync**: Resolved a critical delay issue in `UserSettingsProvider`. Changes made in theSettings screen now reflect instantly on the Home screen without requiring a manual refresh.
- **Data Isolation Fixes**: Enhanced the `DatabaseService` to ensure clean state transitions when signing out and switching between different Firebase accounts.
- **Gradle Stability**: Upgraded Android Gradle Plugin (AGP) to 8.9.1 for modern build support and improved build performance.

### Fixed
- **Home UI Regression**: Restored the `HomeHeader` layout to its clean, intended design (Name + Greeting only).
- **Redundant Components**: Removed unused theme files and legacy analytics widgets (`analytics_breakdown.dart`) to keep the codebase lean.
- **Background Sizing**: Fixed sizing logic in `AppBackground` to ensure full-screen coverage on both small and large devices.

## [1.0.0] - 2026-02-27

### Added
- **AI Financial Mentor**: Integrated Google Generative AI for personalized spending insights.
- **Haptic Feedback**: Added physical feedback for negative balance warnings and transaction actions.
- **Interactive Analytics**: Added FL Chart integration for spending trends.
- **Secure Authentication**: Implemented Firebase Auth sign-in and sign-up flows.
- **Custom Theme**: Created a premium glassmorphic dark theme.

### Changed
- **Refactored Architecture**: Moved business logic from UI screens to dedicated Providers.
- **Enhanced Profile Management**: Implemented inline name editing and professional photo picking.
- **UI Optimization**: Improved `InfoBox` responsiveness to handle large numerical amounts gracefully.

### Fixed
- **DatePicker Typo**: Renamed `CustomeDatePicker` to `CustomDatePicker` and synchronized all references.
- **Overflow Issues**: Resolved UI clipping in the balance card and info tiles.

---
*Initial Release*
